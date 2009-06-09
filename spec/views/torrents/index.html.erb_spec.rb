require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/torrents/index.html.erb" do
  include TorrentsHelper
  
  before(:each) do
    assigns[:torrents] = [
      stub_model(Torrent,
        :name => "value for name",
        :series => "value for series",
        :season => "value for season",
        :episode => "value for episode",
        :description => "value for description",
        :torrent_url => "value for torrent_url",
        :torrent_data => "value for torrent_data",
        :imdb_url => "value for imdb_url",
        :download => false,
        :completed => false,
        :ratio => 1.5,
        :uplimit => 1,
        :downlimit => 1
      ),
      stub_model(Torrent,
        :name => "value for name",
        :series => "value for series",
        :season => "value for season",
        :episode => "value for episode",
        :description => "value for description",
        :torrent_url => "value for torrent_url",
        :torrent_data => "value for torrent_data",
        :imdb_url => "value for imdb_url",
        :download => false,
        :completed => false,
        :ratio => 1.5,
        :uplimit => 1,
        :downlimit => 1
      )
    ]
  end

  it "renders a list of torrents" do
    render
    response.should have_tag("tr>td", "value for name".to_s, 2)
    response.should have_tag("tr>td", "value for series".to_s, 2)
    response.should have_tag("tr>td", "value for season".to_s, 2)
    response.should have_tag("tr>td", "value for episode".to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
    response.should have_tag("tr>td", "value for torrent_url".to_s, 2)
    response.should have_tag("tr>td", "value for torrent_data".to_s, 2)
    response.should have_tag("tr>td", "value for imdb_url".to_s, 2)
    response.should have_tag("tr>td", false.to_s, 2)
    response.should have_tag("tr>td", false.to_s, 2)
    response.should have_tag("tr>td", 1.5.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", 1.to_s, 2)
  end
end

