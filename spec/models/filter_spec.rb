require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Filter do
  before(:each) do
    @source = Source.new
    @source.source_type = "mock"
    @source.save!
    
    @torrent1 = Torrent.new
    @torrent1.name = "CSI New York"

    @torrent2 = Torrent.new
    @torrent2.name = "CSI Miami"

    @torrent3 = Torrent.new
    @torrent3.name = "CSI Terschelling Telesync"
    
    @torrents = [@torrent1, @torrent2, @torrent3]

    @p_filter1 = Filter.new
    @p_filter1.positive = true
    @p_filter1.keyword = 'Miami'

    @p_filter2 = Filter.new
    @p_filter2.positive = true
    @p_filter2.keyword = 'New'

    @p_filter_chain = [@p_filter1, @p_filter2]

    @n_filter1 = Filter.new
    @n_filter1.positive = false
    @n_filter1.keyword = 'Telesync'

    @n_filter_chain = [@n_filter1]
  end

  it "should except everything if the filter chain is empty" do
    Filter.allowed?([], @torrent1).should be_true
    Filter.allowed?([], @torrent2).should be_true
    Filter.allowed?([], @torrent3).should be_true
  end

  it "should filter postives with or" do
    Filter.allowed?(@p_filter_chain, @torrent1).should be_true
    Filter.allowed?(@p_filter_chain, @torrent2).should be_true
    Filter.allowed?(@p_filter_chain, @torrent3).should be_false
  end

  it "should filter negatives with or" do
    Filter.allowed?(@n_filter_chain, @torrent1).should be_true
    Filter.allowed?(@n_filter_chain, @torrent2).should be_true
    Filter.allowed?(@n_filter_chain, @torrent3).should be_false
  end

  it "should filter (postive or postive) and (negative or negative)" do
    @p_filter2 = Filter.new
    @p_filter2.positive = true
    @p_filter2.keyword = 'CSI'
        
    @filter_chain = @n_filter_chain + [@p_filter2]

    Filter.allowed?(@filter_chain, @torrent1).should be_true
    Filter.allowed?(@filter_chain, @torrent2).should be_true
    Filter.allowed?(@filter_chain, @torrent3).should be_false  
  end
  
end
