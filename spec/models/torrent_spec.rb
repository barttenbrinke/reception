require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Torrent do
  before(:each) do
    @torrent = Torrent.new
    @torrent.name = "Test"
    @torrent.description = "Test example"
    @path    = File.join(RAILS_ROOT, "spec", "fixtures", "test_data.torrent")
  end

  it "should have a state" do
    @torrent.fetch_state.should eql(:to_download)
  end
  
  it "should be able to set a state" do
    @torrent.set_state(:completed)
    @torrent.fetch_state.should eql(:completed)
  end
  
  it "should include_keyword" do
    @torrent.include_keyword?('test').should be_true
    @torrent.include_keyword?('Example').should be_true
    @torrent.include_keyword?('beer').should be_false
  end
  
  it "should fetch torrent data" do
    @torrent.torrent_data.should be_nil
    @torrent.fetch_torrent_data(@path)
    @torrent.torrent_data.should_not be_nil
    @torrent.fetch_state.should eql(:to_download)
  end

  it "should fetch mark broken torrents as broken" do
    @torrent.fetch_torrent_data('')
    @torrent.fetch_state.should eql(:broken)
  end

  it "should store torrent data as base64" do
    @torrent.fetch_torrent_data(@path)
    @torrent.fetch_state.should eql(:to_download)
    @torrent.torrent_data.should eql(Base64.encode64(open(@path).read))
  end
  
  it "should find the active torrents in the database" do
    @torrent.save!
    Torrent.active.all.first.should eql(@torrent)

    @torrent.set_state(:to_download)
    @torrent.save!
    Torrent.active.all.first.should eql(@torrent)

    @torrent.set_state(:downloading)
    @torrent.save!
    Torrent.active.all.first.should eql(@torrent)

    @torrent.set_state(:paused)
    @torrent.save!
    Torrent.active.all.first.should eql(@torrent)

    @torrent.set_state(:seeding)
    @torrent.save!
    Torrent.active.all.first.should eql(@torrent)

    @torrent.set_state(:completed)
    @torrent.save!
    Torrent.active.all.should eql([])
    
    @torrent.set_state(:broken)
    @torrent.save!
    Torrent.active.all.should eql([])

    @torrent.set_state(:skipped)
    @torrent.save!
    Torrent.active.all.should eql([])
  end
end


describe Torrent, "when checking if a torrent if fully downloaded" do
  before(:each) do
    @torrent = Torrent.new
    @torrent.name = "Test"
    @torrent.description = "Test example"
    @torrent.transmission_upload_ratio = 2.00
    @torrent.created_at = Time.now

    @torrent.transmission_status = 8
    @torrent.transmission_total_size = 100
    @torrent.transmission_downloaded_size = 100
  end

  it "should be fully downloaded if status and size are ok" do
    @torrent.should be_fully_downloaded
  end

  it "should not be fully downloaded is status != 8" do
    @torrent.transmission_status = 1
    @torrent.should_not be_fully_downloaded
  end

  it "should not be fully downloaded is downloaded size != total_size" do
    @torrent.transmission_total_size = 10
    @torrent.should_not be_fully_downloaded
  end
  
  it "should stop seeding if fully downloaded and ratio > 2" do
    @torrent.stop_seeding?.should be_true
  end

  it "should not stop seeding if not fully downloaded and ratio < 4" do
    @torrent.transmission_total_size = 10
    @torrent.stop_seeding?.should be_false
  end

  it "should not stop seeding if fully downloaded and ratio < 4" do
    @torrent.stop_seeding?(4.00).should be_false
  end

  it "should stop seeding if fully downloaded and older then a week" do
    @torrent.created_at = Time.now - 14.days
    @torrent.stop_seeding?(4.00, 7.days).should be_true
  end

end