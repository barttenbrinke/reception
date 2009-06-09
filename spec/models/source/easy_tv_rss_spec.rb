require File.dirname(__FILE__) + '/../../spec_helper'

describe Source::EasyTvRss do
  before(:each) do
    @path    = File.join(RAILS_ROOT, "spec", "fixtures", "source", "easy_tv_rss.rss")

    @source = Source.new
    @source.source_type = 'EasyTvRss'
    @source.url = @path
  end
  
  it "should fetch data from an rss feed" do
    rss_data = @source.fetch_rss_feed(@source.url)
    rss_data.length.should eql(30)
    rss_data.first.name.should eql("Jay Leno - Kevin Bacon 2009-05-15 [HDTV - XOXO]")
  end
  
  it "should generate a torrent from an rss feed items" do
    item = mock_model(Object)
    item.stub!(:link).and_return('http://example.com')
    item.stub!(:title).and_return('Example')
    item.stub!(:description).and_return('Example RSS Feed item')
    
    torrent = @source.new_torrent_from_rss_item(item)
    torrent.torrent_url.should eql('http://example.com')
    torrent.name.should eql('Example')
    torrent.description.should eql('Example RSS Feed item')
  end
  
end