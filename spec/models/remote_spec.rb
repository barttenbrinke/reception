require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../transmission_response_helper')

describe Remote, "when generating speed arguments" do
  before(:each) do
    @remote = Remote.new
  end

  it "should handle pased attributes correctly" do
    new_args = @remote.generate_speed_args("speed-limit-up-enabled", "speed-limit-up", 'new_speed', "ids" => [1,2,3])
    new_args["speed-limit-up-enabled"].should eql(0)
    new_args["ids"].should eql([1,2,3])

    new_args = @remote.generate_speed_args("speed-limit-up-enabled", "speed-limit-up", 100, "ids" => [1,2,3])
    new_args["speed-limit-up-enabled"].should eql(1)
    new_args["speed-limit-up"].should eql(100)
    new_args["ids"].should eql([1,2,3])
  end
  
end


describe Remote, "when adding torrents" do
  before(:each) do
    @torrent = Torrent.new
    @torrent.name = "Test"
    @torrent.description = "Test example"
    @path    = File.join(RAILS_ROOT, "spec", "fixtures", "test_data.torrent")
    @torrent.torrent_data = Base64.encode64(open(@path).read)
    @torrent.save!

    @remote = Remote.new
    @trh = TransmissionResponseHelper    
  end

  it "should add torrents to a daemon" do
    @remote.stub!(:remote_request).and_return(@trh.successfull_torrent_add)
    @remote.add_torrent(@torrent).should_not be_nil
    
    @torrent.reload
    @torrent.fetch_state.should eql(:downloading)
  end

  it "should not change state when connection is broken" do
    @remote.stub!(:remote_request).and_return(@trh.failed_to_connect)
    @remote.add_torrent(@torrent).should_not be_nil
    
    @torrent.reload
    @torrent.fetch_state.should eql(:to_download)
  end

  it "should not change state when daemon cannot handle the request" do
    @remote.stub!(:remote_request).and_return(@trh.broken)
    @remote.add_torrent(@torrent).should be_false
    
    @torrent.reload
    @torrent.fetch_state.should eql(:to_download)
  end
end


describe Remote, "when cleaning up completed torrents" do
  before(:each) do
    @torrent = Torrent.new
    @torrent.name = "Test"
    @torrent.description = "Test example"
    @torrent.set_state(:seeding)
    
    @torrent.save!

    @remote = Remote.new
    @trh = TransmissionResponseHelper    
  end

  it "should successfully clean up remote torrents" do
    @remote.stub!(:remote_request).and_return(@trh.success)
    @torrent.stub!(:stop_seeding?).and_return(true)
    
    @remote.cleanup_completed_torrents([@torrent])
    
    @torrent.reload
    @torrent.fetch_state.should eql(:completed)    
  end

  it "should not clean up remote torrents if no connection to daemon" do
    @remote.stub!(:remote_request).and_return(@trh.failed_to_connect)
    @torrent.stub!(:stop_seeding?).and_return(true)
    
    @remote.cleanup_completed_torrents([@torrent])
    
    @torrent.reload
    @torrent.fetch_state.should eql(:seeding)    
  end

end
