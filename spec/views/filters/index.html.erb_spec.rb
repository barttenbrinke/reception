require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/filters/index.html.erb" do
  include FiltersHelper
  
  before(:each) do
    assigns[:filters] = [
      stub_model(Filter,
        :source_id => 1,
        :keyword => "value for keyword",
        :positive => false
      ),
      stub_model(Filter,
        :source_id => 1,
        :keyword => "value for keyword",
        :positive => false
      )
    ]
  end

  it "renders a list of filters" do
    render
    response.should have_tag("tr>td", 1.to_s, 2)
    response.should have_tag("tr>td", "value for keyword".to_s, 2)
    response.should have_tag("tr>td", false.to_s, 2)
  end
end

