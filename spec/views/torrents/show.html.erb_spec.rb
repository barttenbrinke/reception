require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/torrents/show.html.erb" do
  include TorrentsHelper
  before(:each) do
    assigns[:torrent] = @torrent = stub_model(Torrent,
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
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ series/)
    response.should have_text(/value\ for\ season/)
    response.should have_text(/value\ for\ episode/)
    response.should have_text(/value\ for\ description/)
    response.should have_text(/value\ for\ torrent_url/)
    response.should have_text(/value\ for\ torrent_data/)
    response.should have_text(/value\ for\ imdb_url/)
    response.should have_text(/false/)
    response.should have_text(/false/)
    response.should have_text(/1\.5/)
    response.should have_text(/1/)
    response.should have_text(/1/)
  end
end

