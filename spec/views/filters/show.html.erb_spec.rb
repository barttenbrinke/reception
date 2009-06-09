require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/filters/show.html.erb" do
  include FiltersHelper
  before(:each) do
    assigns[:filter] = @filter = stub_model(Filter,
      :source_id => 1,
      :keyword => "value for keyword",
      :positive => false
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/1/)
    response.should have_text(/value\ for\ keyword/)
    response.should have_text(/false/)
  end
end

