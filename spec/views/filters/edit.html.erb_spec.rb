require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/filters/edit.html.erb" do
  include FiltersHelper
  
  before(:each) do
    assigns[:filter] = @filter = stub_model(Filter,
      :new_record? => false,
      :source_id => 1,
      :keyword => "value for keyword",
      :positive => false
    )
  end

  it "renders the edit filter form" do
    render
    
    response.should have_tag("form[action=#{filter_path(@filter)}][method=post]") do
      with_tag('input#filter_source_id[name=?]', "filter[source_id]")
      with_tag('input#filter_keyword[name=?]', "filter[keyword]")
      with_tag('input#filter_positive[name=?]', "filter[positive]")
    end
  end
end


