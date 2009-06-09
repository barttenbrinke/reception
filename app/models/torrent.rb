class Torrent < ActiveRecord::Base
  
  STATES = [:to_download, :downloading, :paused, :seeding, :completed, :broken, :skipped]
  
  #validates_uniqueness_of :transmission_hash, :if :transmission_hash
  validates_presence_of :name
  belongs_to :source
  
  named_scope :active, :conditions => ['state IN (?)', [0,1,2,3] ]
  named_scope :active_not_seeding, :conditions => ['state IN (?)', [0,1] ]
  
  named_scope :paused, :conditions => ['state = ?', 2]
  named_scope :completed, :conditions => ['state IN (?)', [3,4] ]
  named_scope :broken, :conditions => ['state IN (?)', [5,6] ]
  
  named_scope :not_self, lambda { |id| { :conditions => ['id != ?', id] } }
  
  # Check if this torrent allready exists in the database
  def double?
    if self.id
      return true if self.torrent_url && Torrent.not_self(self.id).find_by_torrent_url(self.torrent_url)
      return true if self.transmission_hash_string && Torrent.not_self(self.id).find_by_transmission_hash_string(self.transmission_hash_string)
      return true if self.name && Torrent.not_self(self.id).find_by_name(self.name)
    else
      return true if self.torrent_url && Torrent.find_by_torrent_url(self.torrent_url)
      return true if self.transmission_hash_string && Torrent.find_by_transmission_hash_string(self.transmission_hash_string)
      return true if self.name && Torrent.find_by_name(self.name)    
    end
    
    
    return false
  end
  
  # Fetch torrent data
  # <tt>the_torrent_urll</tt> Optional. defaults to self.torrent_url
  def fetch_torrent_data(the_torrent_url = self.torrent_url)
    if the_torrent_url && torrent_data.nil?
      begin
        torrent_item = open(the_torrent_url)
        self.torrent_data = Base64.encode64(torrent_item.read())
        torrent_item.close
        self.set_state(:to_download)
        return true
      rescue
        self.set_state(:broken)      
      end
    end
    
    return false
  end
  
  # Check if the torrent includes a keyword
  # <tt>keyword</tt> The keyword to look for
  def include_keyword?(keyword)
    return true if self.name && self.name.downcase.include?(keyword.downcase)
    return true if self.description && self.description.downcase.include?(keyword.downcase)
    
    return false
  end
  
  # Get the state of the torrent
  def fetch_state
    return Torrent::STATES[self.state] if self.state
    
    return nil
  end
  
  # Set the state of the torrent
  # <tt>new_state</tt> symbol from Torrent::STATES
  def set_state(new_state)
    Torrent::STATES.each_with_index do |allowed_state, index|
      if allowed_state == new_state
        self.state = index
      end
    end
  end
  
  # Update torrent from transmission hash
  # <tt>data_hash</tt> Data hash from transmission
  def update_from_transmission(data_hash = {})
    return if data_hash.nil? || data_hash.empty?
    
    # Handle state change after torrent-added
    self.set_state(:downloading)      if self.fetch_state == :to_download && self.transmission_id.nil? && data_hash["id"].to_i
    
    self.name                         ||= data_hash["name"].to_s
    self.transmission_downloaded_size = data_hash["haveValid"].to_i
    self.transmission_total_size      = data_hash["totalSize"].to_i
    self.ratio                        = data_hash["uploadRatio"].to_f
    self.transmission_status          = data_hash["status"].to_i
    self.transmission_name            = data_hash["name"]
    self.transmission_id              = data_hash["id"].to_i
    self.transmission_hash_string     = data_hash["hashString"]
    
    self.set_state(:seeding)          if self.fully_downloaded?
    self.set_state(:downloading)      if self.state.nil? || self.transmission_status == 4
    self.set_state(:paused)           if self.transmission_status == 16
  end
  
  # Check if we are fully downloaded
  def fully_downloaded?
    self.transmission_status == 8 && self.transmission_total_size == self.transmission_downloaded_size
  end
  
  def download_percentage
    return 0 if self.transmission_downloaded_size.nil? || self.transmission_total_size.nil?
    return 0 if self.transmission_downloaded_size.to_i == 0 || self.transmission_total_size.to_i == 0
    return 100 if self.fully_downloaded?
    return ((self.transmission_downloaded_size.to_f / self.transmission_total_size.to_f) * 100).to_i
  end

  # Stop seeding?
  # Returns true if we should
  # <tt>ratio</tt>The ratio after which to stop seeding
  # <tt>max_seeding_time</tt> Stop afer x days eventhough ratio 
  def stop_seeding?(ratio = 2.00, max_seeding_time = 7.days)
    if self.fully_downloaded?
      
      if (self.transmission_upload_ratio.to_f >= ratio) || (Time.now >= (self.created_at + max_seeding_time))
        return true
      end
    end
    
    return false
  end
  
  # Returns name of torrent
  def to_s
    name
  end
  
end
