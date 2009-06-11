class Remote
  
  attr_accessor :setting
  attr_accessor :connected_cache
  
  # Initialize remote using either a setting object or by finding one.
  # <tt>setting</tt> Optional setting object, defaults to Setting.find_or_create
  def initialize(setting = Setting.find_or_create)
    self.setting    = setting
  end
  
  # Push settings to torrent client
  # <tt><tt>setting</tt> Optional setting object, defaults to self.setting
  def push_settings(setting_object = self.setting)
    return unless connected?
    session_uplimit(setting_object.session_uplimit)
    session_downlimit(setting_object.session_downlimit)
    return true
  end

  # Set the maximum upload speed for the entire daemon
  # <tt>limit</tt> Maximum speed in kilobytes. nil = no limit
  def session_uplimit(limit = nil)
    args = generate_speed_args("speed-limit-up-enabled", "speed-limit-up", limit)
    remote_request("session-set", args)
  end

  # Set the maximum download speed for the entire daemon
  # <tt>limit</tt> Maximum speed in kilobytes. nil = no limit
  def session_downlimit(limit = nil)
    args = generate_speed_args("speed-limit-down-enabled", "speed-limit-down", limit)
    remote_request("session-set", args)
  end

  # Set the maximum upload speed for an array of torrents
  # <tt>ids</tt> Array of ids
  # <tt>limit</tt> Maximum speed in kilobytes. nil = no limit
  def uplimit(ids, limit = nil)
    args = generate_speed_args("speed-limit-up-enabled", "speed-limit-up", limit, {:ids => get_ids(ids)})
    remote_request("torrent-set", args)
  end

  # Set the maximum download speed for an array of torrents
  # <tt>ids</tt> Array of ids
  # <tt>limit</tt> Maximum speed in kilobytes. nil = no limit
  def downlimit(ids, limit = nil)
    args = generate_speed_args("speed-limit-down-enabled", "speed-limit-down", limit, {:ids => get_ids(ids)})
    remote_request("torrent-set", args)
  end
  
  # Generate json instructions for speed changes on session or torrent level
  # <tt>limit</tt> Speed in KB
  # <tt>enabled_string</tt> Example: "speed-limit-down-enabled" 
  # <tt>limit_string</tt> Example: "speed-limit-down" 
  # Options
  # Any options passed are retuned in the args
  def generate_speed_args(enabled_string, limit_string, limit, options = {})
    if limit.to_i > 0
      args = { enabled_string => 1, limit_string => limit.to_i }
    else
      args = { enabled_string => 0 }
    end
    
    return args.merge!(options)
  end

  def get_ids(id_str = nil)
    return id_str.split(",").map! { |x| x.to_i } if id_str.is_a?(String)

    return [id_str] if id_str.is_a?(Integer)
    return id_str
  end
  
  # Check if there are any new torrents in the daemon of which we don't know
  # <tt>save</tt> Save the new torrents
  # Returns array of new torrents
  def import_torrents_from_daemon_and_update_existing(save = true)
    return unless connected?

    new_torrents = []
    
    return unless connected?
    response = get_torrent_info
    
    return unless response.success?
    
    response.torrents.each do |th|
      new_torrent = Torrent.find_by_name(th["name"]) || 
                    Torrent.find_by_transmission_name(th["name"]) || 
                    Torrent.find_by_transmission_hash_string(th["hashString"]) ||
                    Torrent.new
      new_torrent.update_from_transmission(th)
      new_torrent.save if save && new_torrent.valid?
      new_torrents << new_torrent
    end
    
    return new_torrents
  end
  
  # Push all Torrents in the database to the transmission daemon and pull the new ones ine
  # <tt>sync_torrents</tt> The torrents to synchronize with transmission defaults to Torrent.active.all
  def push_new_torrents_to_daemon(sync_torrents = Torrent.active.all)
    return unless connected?
    
    sync_torrents.each do |torrent|
      if torrent.fetch_state == :to_download && torrent.transmission_id.nil?
        add_torrent(torrent)
        torrent.save!
      end
    end
  end
  
  # Stop completed torrents
  # <tt>active_torrents</tt> Defaults to Torrent.active.all
  def cleanup_completed_torrents(active_torrents = Torrent.active.all)
    active_torrents.each do |active_torrent|
      if active_torrent.stop_seeding?(self.setting.ratio)
        if remove_torrent(active_torrent)
          active_torrent.set_state(:completed)
          active_torrent.save!
        end
      end
    end
  end
  
  # Update everything in the correct order:
  # * Push new settings
  # * Find torrents in transmission daemon
  # * Gets all enabled sources to fetch new torrents (if available)
  # * Synchronize new torrents with the transmission daemon
  # * Cleanup all completed torrents
  # Options
  # <tt>:skip_sources</tt> Skip updating from the sources
  def update(options = {})
    if connected?
      push_settings
      import_torrents_from_daemon_and_update_existing
      
      unless options[:skip_sources]
        Source.enabled.each do |source|
          source.fetch_new_torrents
        end
      end

      push_new_torrents_to_daemon
      cleanup_completed_torrents
    end
  end
  
  # Add a torrent to transmission daemon
  # <tt>torrent</tt> Torrent object
  # Returns true if successfull, false otherwise
  # Results get stored in the torrent through update from transmission
  def add_torrent(torrent)
    return false unless torrent.torrent_data

    response = remote_request("torrent-add", {:metainfo => torrent.torrent_data})
    
    if response.success? 
      torrent.update_from_transmission(response.torrent_added)
      torrent.save
      return true
    end

    return false
  end
  
  # Remove a torret from transmission daemon
  def remove_torrent(torrent)
    remote_request("torrent-remove", {:ids => [torrent.transmission_id]}).success? 
  end
  
  # Start a torrent
  def start_torrent(torrent)
    remote_request("torrent-start", {:ids => [torrent.transmission_id]}).success? 
  end

  # Stop a torrent
  def stop_torrent(torrent)
    remote_request("torrent-stop", {:ids => [torrent.transmission_id]}).success? 
  end
  
  # Remove a torrent from transmission if it is running, disable or enable otherwise
  # <tt>torrent</tt> The torrent to toggle
  def update_state(torrent, new_state_string)
    new_state = new_state_string.to_sym
    
    return false if new_state.blank?
    
    if new_state == :downloading || new_state == :seeding
      add_torrent(torrent)
      start_torrent(torrent)
    elsif new_state == :paused
      stop_torrent(torrent)
    elsif new_state == :completed
      if torrent.fully_downloaded?
        stop_torrent(torrent)
        remove_torrent(torrent)
        torrent.set_state(:completed)
        torrent.save
      end
    end
    
    push_new_torrents_to_daemon([torrent])

    return true
  end

  
  # Get information of all or a specific test of torrents
  # <tt>ids</tt> Optional ids to get specific information of a torrent
  def get_torrent_info(ids = nil)
    args =  { :fields => [ :id, :name, :size, :rateDownload, :rateUpload, :uploadLimitMode, :downloadLimit, \
                          :downloadLimitMode, :uploadLimit, :haveValid, :uploadRatio, :uploadedEver, \
                          :downloadedEver, :status, :totalSize, :sizeWhenDone, :hashString] }
    args.store(:ids, get_ids(ids)) if ids
    
    return remote_request("torrent-get", args)
  end
  
  # Get session info
  def session_info
    remote_request("session-get", {})
  end
  
  # Check if we are connected to the transmission-daemon
  def connected?
    self.connected_cache ||= session_info.success?
  end
  
  # Send a request to the transmission-daemon
  # <tt>method</tt> Method to send
  # <tt>args</tt> The arguments to send
  # Returns a Response class if successful. Nil otherwise
  def remote_request(method, args = {})
    Remote::Request.new(method, args).send(self.setting)
  end
end