require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Source, "when including a module" do
  before(:each) do
    @source = Source.new
    @source.source_type = "mock"
  end

  it "should include module on creation" do
    @source.source_type.should eql("mock")
    @source.should be_mock
  end

  it "should include module on load" do
    @source.save!
    new_source = Source.find(:first)
    new_source.should be_mock
  end
end

describe Source, "when creating torrents" do
  before(:each) do
    @source = Source.new
    @source.source_type = "easy_tv_rss"
    @source.url = File.join(RAILS_ROOT, "spec", "fixtures", "source", "easy_tv_rss.rss")
    @source.save!
  end

  it "should create new torrents if no filters are defined" do
    torrents = @source.fetch_new_torrents(false)
    torrents.length.should eql(30)
  end

  it "should filter out doubles" do
    torrents = @source.fetch_new_torrents(false)
    torrents.first.save!
    
    torrents = @source.fetch_new_torrents(false)
    torrents.length.should eql(29)
  end

  it "should filter with positive filters" do
    filter = @source.filters.new
    filter.positive = true
    filter.keyword = 'Jay Leno'
    filter.save!
    
    torrents = @source.fetch_new_torrents(false)
    torrents.length.should eql(1)    
  end

  it "should filter with negative filters" do
    filter = @source.filters.new
    filter.positive = false
    filter.keyword = 'Jay Leno'
    filter.save!
    
    torrents = @source.fetch_new_torrents(false)
    torrents.length.should eql(29)
  end    

  it "should filter with multiple filters" do
    filter = @source.filters.new
    filter.positive = true
    filter.keyword = 'CSI'
    filter.save!

    filter = @source.filters.new
    filter.positive = false
    filter.keyword = 'New York'
    filter.save!
    
    torrents = @source.fetch_new_torrents(false)
    torrents.length.should eql(2)
  end
    
end