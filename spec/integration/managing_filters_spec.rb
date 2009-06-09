require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Managing Filters" do
  before(:each) do
    @valid_attributes = {
      :source_id => 1,
      :keyword => "value for keyword",
      :positive => false
    }
  end

  describe "viewing index" do
    it "lists all Filters" do
      filter = Filter.create!(@valid_attributes)
      visit filters_path
      response.should have_selector("a", :href => filter_path(filter))
    end
  end
end
