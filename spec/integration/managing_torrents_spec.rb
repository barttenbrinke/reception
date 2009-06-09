require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Managing Torrents" do
  before(:each) do
    @valid_attributes = {
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
    }
  end

  describe "viewing index" do
    it "lists all Torrents" do
      torrent = Torrent.create!(@valid_attributes)
      visit torrents_path
      response.should have_selector("a", :href => torrent_path(torrent))
    end
  end
end
