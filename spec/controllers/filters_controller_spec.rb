require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FiltersController do

  def mock_filter(stubs={})
    @mock_filter ||= mock_model(Filter, stubs)
  end
  
  describe "GET index" do
    it "assigns all filters as @filters" do
      Filter.stub!(:find).with(:all).and_return([mock_filter])
      get :index
      assigns[:filters].should == [mock_filter]
    end
  end

  describe "GET show" do
    it "assigns the requested filter as @filter" do
      Filter.stub!(:find).with("37").and_return(mock_filter)
      get :show, :id => "37"
      assigns[:filter].should equal(mock_filter)
    end
  end

  describe "GET new" do
    it "assigns a new filter as @filter" do
      Filter.stub!(:new).and_return(mock_filter)
      get :new
      assigns[:filter].should equal(mock_filter)
    end
  end

  describe "GET edit" do
    it "assigns the requested filter as @filter" do
      Filter.stub!(:find).with("37").and_return(mock_filter)
      get :edit, :id => "37"
      assigns[:filter].should equal(mock_filter)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created filter as @filter" do
        Filter.stub!(:new).with({'these' => 'params'}).and_return(mock_filter(:save => true))
        post :create, :filter => {:these => 'params'}
        assigns[:filter].should equal(mock_filter)
      end

      it "redirects to the created filter" do
        Filter.stub!(:new).and_return(mock_filter(:save => true))
        post :create, :filter => {}
        response.should redirect_to(filter_url(mock_filter))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved filter as @filter" do
        Filter.stub!(:new).with({'these' => 'params'}).and_return(mock_filter(:save => false))
        post :create, :filter => {:these => 'params'}
        assigns[:filter].should equal(mock_filter)
      end

      it "re-renders the 'new' template" do
        Filter.stub!(:new).and_return(mock_filter(:save => false))
        post :create, :filter => {}
        response.should render_template('new')
      end
    end
    
  end

  describe "PUT update" do
    
    describe "with valid params" do
      it "updates the requested filter" do
        Filter.should_receive(:find).with("37").and_return(mock_filter)
        mock_filter.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :filter => {:these => 'params'}
      end

      it "assigns the requested filter as @filter" do
        Filter.stub!(:find).and_return(mock_filter(:update_attributes => true))
        put :update, :id => "1"
        assigns[:filter].should equal(mock_filter)
      end

      it "redirects to the filter" do
        Filter.stub!(:find).and_return(mock_filter(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(filter_url(mock_filter))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested filter" do
        Filter.should_receive(:find).with("37").and_return(mock_filter)
        mock_filter.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :filter => {:these => 'params'}
      end

      it "assigns the filter as @filter" do
        Filter.stub!(:find).and_return(mock_filter(:update_attributes => false))
        put :update, :id => "1"
        assigns[:filter].should equal(mock_filter)
      end

      it "re-renders the 'edit' template" do
        Filter.stub!(:find).and_return(mock_filter(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested filter" do
      Filter.should_receive(:find).with("37").and_return(mock_filter)
      mock_filter.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the filters list" do
      Filter.stub!(:find).and_return(mock_filter(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(filters_url)
    end
  end

end
