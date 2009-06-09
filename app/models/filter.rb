class Filter < ActiveRecord::Base
  belongs_to :source

  validates_presence_of :source_id
  validates_presence_of :keyword
  
  named_scope :positive, :conditions => ['positive = ?', true ]
  named_scope :negative, :conditions => ['positive = ?', false ]

  # Is this a negative filter?
  def negative
    return !positive
  end
  
  # Filter using all positive and negative filters
  # Returns true if filters accept the torrent, false otherwise
  # <tt>filters</tt> filter array
  # <tt>torrent</tt> The torrent to filter
  def self.allowed?(filters, torrent)
    keep = false

    p_filters = filters.select{|x| x.positive}
    n_filters = filters.select{|x| x.negative}

    keep = true if p_filters.length == 0
    
    p_filters.each do |p_filter|
      keep = true if torrent.include_keyword?(p_filter.keyword)
    end
    
    n_filters.each do |n_filter|
      keep = false if torrent.include_keyword?(n_filter.keyword)
    end
    
    return keep
  end
  
  # To string function
  # Returns KEYWORD if postive or ¬KEYWORD if negative
  # <tt>display_nack</tt> Hides the negation(¬) if false. Defaults to true
  def to_s(display_nack = true)
    return keyword if positive || (negative && !display_nack)
    
    return '¬' + keyword
  end
end
