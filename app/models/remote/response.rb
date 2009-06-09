class Remote::Response
  
  attr_accessor :data
  
  # Initialize Response using either a setting object or by finding one.
  # <tt>data</tt> Response object. Will be parsed using JSON.parse
  def initialize(response_data)
    begin
      self.data    = JSON.parse(response_data)
    rescue JSON::ParserError
      self.data    = {}
    end
    
    y self.data if Object::DEBUG_RPC_MESSAGES == true
  end
  
  # Check if the response was sucessful
  def success?
    return self.data && self.data["result"] && self.data["result"] == "success"
  end

  # Check if the response threw an exception
  def failed_to_connect?
    return self.data && self.data["result"] && self.data["result"] == "failed_to_connect"
  end
  
  # Get all torrents in the response (if any)
  def torrents
    if self.data["arguments"] && self.data["arguments"]["torrents"]
      return self.data["arguments"]["torrents"]
    end
    
    return []
  end
  
  # If a torrent is added, the new data is placed in torrent-added
  def torrent_added
    return self.data["arguments"]["torrent-added"]
  end
  
  # Get torrent information from a specific torrent from the response
  # If the id is nill, and response contains a single torrent, that torrent is returned
  # <tt>id</tt> Optional id.
  def torrent(id = nil)
    torrent_array = self.torrents
    
    if id.nil?
      return {} if torrent_array.length == 0 || torrent_array.length > 1
      return torrent_array.first
    else
      torrent_array.each do |torrent_hash|
        return torrent_hash if torrent_hash["id"].to_i == id.to_i
      end
    end
    
    return {}
  end

end