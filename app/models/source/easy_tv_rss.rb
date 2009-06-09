# Source Rss
class Source

  # http://tvrss.net/feed/eztv/
  module EasyTvRss
    # Get all torrent files frm the given source
    # Returns an array of torrent objects
    def get_torrents(options = {})
      return fetch_rss_feed
    end
    
    # Fetch the rss data from the given RSS feed
    # <tt>feed_url</tt> Defaults to self.url
    def fetch_rss_feed(feed_url = self.url)
      torrents = []
      
      open(feed_url) do |rss|
        result = RSS::Parser.parse(rss.read, false)
        
        if result
          result.items.each do |item|
            torrents << new_torrent_from_rss_item(item)
          end
        end
      end
      
      return torrents
    end
    
    
    # Create a torrent from an rss item
    # <tt>item</tt> Data hash 
    def new_torrent_from_rss_item(item)
      torrent               = Torrent.new
      torrent.torrent_url   = item.link
      torrent.name          = item.title
      torrent.description   = item.description
      torrent.source_id     = self.id
      
      return torrent
    end
  
  end
end