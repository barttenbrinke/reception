require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/torrents/edit.html.erb" do
  include TorrentsHelper
  
  before(:each) do
    assigns[:torrent] = @torrent = stub_model(Torrent,
      :new_record? => false,
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

  it "renders the edit torrent form" do
    render
    
    response.should have_tag("form[action=#{torrent_path(@torrent)}][method=post]") do
      with_tag('input#torrent_name[name=?]', "torrent[name]")
      with_tag('input#torrent_series[name=?]', "torrent[series]")
      with_tag('input#torrent_season[name=?]', "torrent[season]")
      with_tag('input#torrent_episode[name=?]', "torrent[episode]")
      with_tag('input#torrent_description[name=?]', "torrent[description]")
      with_tag('input#torrent_torrent_url[name=?]', "torrent[torrent_url]")
      with_tag('input#torrent_torrent_data[name=?]', "torrent[torrent_data]")
      with_tag('input#torrent_imdb_url[name=?]', "torrent[imdb_url]")
      with_tag('input#torrent_download[name=?]', "torrent[download]")
      with_tag('input#torrent_completed[name=?]', "torrent[completed]")
      with_tag('input#torrent_ratio[name=?]', "torrent[ratio]")
      with_tag('input#torrent_uplimit[name=?]', "torrent[uplimit]")
      with_tag('input#torrent_downlimit[name=?]', "torrent[downlimit]")
    end
  end
end


