require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FiltersController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "filters", :action => "index").should == "/filters"
    end
  
    it "maps #new" do
      route_for(:controller => "filters", :action => "new").should == "/filters/new"
    end
  
    it "maps #show" do
      route_for(:controller => "filters", :action => "show", :id => "1").should == "/filters/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "filters", :action => "edit", :id => "1").should == "/filters/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "filters", :action => "create").should == {:path => "/filters", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "filters", :action => "update", :id => "1").should == {:path =>"/filters/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "filters", :action => "destroy", :id => "1").should == {:path =>"/filters/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/filters").should == {:controller => "filters", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/filters/new").should == {:controller => "filters", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/filters").should == {:controller => "filters", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/filters/1").should == {:controller => "filters", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/filters/1/edit").should == {:controller => "filters", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/filters/1").should == {:controller => "filters", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/filters/1").should == {:controller => "filters", :action => "destroy", :id => "1"}
    end
  end
end
