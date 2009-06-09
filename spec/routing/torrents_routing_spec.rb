require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TorrentsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "torrents", :action => "index").should == "/torrents"
    end
  
    it "maps #new" do
      route_for(:controller => "torrents", :action => "new").should == "/torrents/new"
    end
  
    it "maps #show" do
      route_for(:controller => "torrents", :action => "show", :id => "1").should == "/torrents/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "torrents", :action => "edit", :id => "1").should == "/torrents/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "torrents", :action => "create").should == {:path => "/torrents", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "torrents", :action => "update", :id => "1").should == {:path =>"/torrents/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "torrents", :action => "destroy", :id => "1").should == {:path =>"/torrents/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/torrents").should == {:controller => "torrents", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/torrents/new").should == {:controller => "torrents", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/torrents").should == {:controller => "torrents", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/torrents/1").should == {:controller => "torrents", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/torrents/1/edit").should == {:controller => "torrents", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/torrents/1").should == {:controller => "torrents", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/torrents/1").should == {:controller => "torrents", :action => "destroy", :id => "1"}
    end
  end
end
