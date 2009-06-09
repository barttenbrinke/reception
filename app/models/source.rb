class Source < ActiveRecord::Base
  AVAILABLE_SOURCE_TYPES = [ 'Scraper', 'EasyTvRss']
  
  validates_presence_of :source_type
  has_many :filters
  has_many :torrents

  named_scope :enabled, :conditions => ['enabled = ?', true ]
  
  # Type to load module after initialize.
  def after_initialize
    load_module
  end
  
  # Hook for the modules if needed.
  def self.modules_available
    AVAILABLE_SOURCE_TYPES
  end
  
  def self.collection_select
    options = []
    
    Source.modules_available.each do |m|
      options << {:id => m, :name => m}
    end
    
    return options
  end
    
  # Override for source type so that setting the value will also load the module.
  # <tt>value</tt> The module name to load.
  def source_type=(value)
    super(value)
    load_module
  end
  
  # Dynamicly load the requested module.
  # <tt>module_name</tt> String of the source module to load.
  def load_module(module_name = self.source_type)
    self.extend("Source::#{module_name.to_s.camelize}".constantize) if module_name
  end
  
  # Get all new torrents from this source.
  # Sources get passed trough all the filters defined for this source.
  # Returns an array of torrent objects.
  # <tt>save</tt> Save the created torrents defaults to false.
  def fetch_new_torrents(save = true)
    new_torrents = []

    self.get_torrents.each do |new_torrent|
      if !new_torrent.double? && allowed_by_filters?(new_torrent)
        new_torrents << new_torrent
      end
    end
    
    # Fetch torrent data
    if save
      new_torrents.each do |torrent|
        torrent.fetch_torrent_data
        torrent.save!
      end
    end
    
    return new_torrents
  end
  
  # Get all torrent files frm the given source.
  # Returns an array of torrent objects.
  def get_torrents(options = {})
    return []
  end
  
  # Check if the torrent is allowed by our filter chain
  # <tt>torrent</tt> Torent item
  # <tt>filter_chain</tt> Defaults to self.filters
  def allowed_by_filters?(torrent, filter_chain = self.filters)
    return Filter.allowed?(filter_chain, torrent)
  end
  
  # To string function, returns name
  def to_s
    name
  end
  
  # Get all torrents and see what is kept by the filters
  # Returns hash containing torrents, with the keys :accepted and :rejected
  def test_filters
    accepted = []
    rejected = []
    self.get_torrents.each do |new_torrent|
      if allowed_by_filters?(new_torrent)
        accepted << new_torrent
      else
        rejected << new_torrent
      end
    end
    
    return {:accepted => accepted, :rejected => rejected}
  end
  
end
