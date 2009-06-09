# Mock source class
class Source
  
  module Mock

    # Get all torrent files frm the given source
    # Returns an array of torrent objects
    # Options
    # *<tt>:return_torrents</tt> The torrents she mock should return
    def get_torrents(options = {})
      return options[:return_torrents]
    end
    
    def mock?
      return true
    end
  
  end

end