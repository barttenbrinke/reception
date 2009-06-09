# Source Scraper
# http://thepiratebay.org/search/dvdrip/0/7/200
# http://thepiratebay.org/search/axxo/0/7/200
# http://thepiratebay.org/search/r5/0/7/200
# http://thepiratebay.org/user/eztv/
# http://thepiratebay.org/top/201
class Source

  module Scraper
    # Get all torrent files frm the given source
    # Returns an array of torrent objects
    def get_torrents(options = {})
      torrents = []

      doc = Hpricot(open(self.url))

      (doc/"a").collect{|x| x["href"]}.select{|x| x.include?('.torrent')}.each do |torrent_link|
        torrents << new_torrent_from_link(torrent_link)
      end
      
      return torrents
    end
    
    # Return net torrent from link
    def new_torrent_from_link(torrent_link)
      torrent               = Torrent.new
      torrent.torrent_url   = torrent_link.gsub('[', '%5B').gsub(']', '%5D')
      torrent.name          = torrent_link.split('/').last.gsub('.torrent', '').gsub(/\.\d+\.TPB/, '').gsub('.', ' ')
      torrent.transmission_name = torrent_link.split('/').last.gsub('.torrent', '').gsub(/\.\d+\.TPB/, '')
      return torrent
    end
  end
end