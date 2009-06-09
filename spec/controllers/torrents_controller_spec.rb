require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TorrentsController do

  def mock_torrent(stubs={})
    @mock_torrent ||= mock_model(Torrent, stubs)
  end
  
  describe "GET index" do
    it "assigns all torrents as @torrents" do
      Torrent.stub!(:find).with(:all).and_return([mock_torrent])
      get :index
      assigns[:torrents].should == [mock_torrent]
    end
  end

  describe "GET show" do
    it "assigns the requested torrent as @torrent" do
      Torrent.stub!(:find).with("37").and_return(mock_torrent)
      get :show, :id => "37"
      assigns[:torrent].should equal(mock_torrent)
    end
  end

  describe "GET new" do
    it "assigns a new torrent as @torrent" do
      Torrent.stub!(:new).and_return(mock_torrent)
      get :new
      assigns[:torrent].should equal(mock_torrent)
    end
  end

  describe "GET edit" do
    it "assigns the requested torrent as @torrent" do
      Torrent.stub!(:find).with("37").and_return(mock_torrent)
      get :edit, :id => "37"
      assigns[:torrent].should equal(mock_torrent)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created torrent as @torrent" do
        Torrent.stub!(:new).with({'these' => 'params'}).and_return(mock_torrent(:save => true))
        post :create, :torrent => {:these => 'params'}
        assigns[:torrent].should equal(mock_torrent)
      end

      it "redirects to the created torrent" do
        Torrent.stub!(:new).and_return(mock_torrent(:save => true))
        post :create, :torrent => {}
        response.should redirect_to(torrent_url(mock_torrent))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved torrent as @torrent" do
        Torrent.stub!(:new).with({'these' => 'params'}).and_return(mock_torrent(:save => false))
        post :create, :torrent => {:these => 'params'}
        assigns[:torrent].should equal(mock_torrent)
      end

      it "re-renders the 'new' template" do
        Torrent.stub!(:new).and_return(mock_torrent(:save => false))
        post :create, :torrent => {}
        response.should render_template('new')
      end
    end
    
  end

  describe "PUT update" do
    
    describe "with valid params" do
      it "updates the requested torrent" do
        Torrent.should_receive(:find).with("37").and_return(mock_torrent)
        mock_torrent.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :torrent => {:these => 'params'}
      end

      it "assigns the requested torrent as @torrent" do
        Torrent.stub!(:find).and_return(mock_torrent(:update_attributes => true))
        put :update, :id => "1"
        assigns[:torrent].should equal(mock_torrent)
      end

      it "redirects to the torrent" do
        Torrent.stub!(:find).and_return(mock_torrent(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(torrent_url(mock_torrent))
      end
    end
    
    describe "with invalid params" do
      it "updates the requested torrent" do
        Torrent.should_receive(:find).with("37").and_return(mock_torrent)
        mock_torrent.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :torrent => {:these => 'params'}
      end

      it "assigns the torrent as @torrent" do
        Torrent.stub!(:find).and_return(mock_torrent(:update_attributes => false))
        put :update, :id => "1"
        assigns[:torrent].should equal(mock_torrent)
      end

      it "re-renders the 'edit' template" do
        Torrent.stub!(:find).and_return(mock_torrent(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end
    
  end

  describe "DELETE destroy" do
    it "destroys the requested torrent" do
      Torrent.should_receive(:find).with("37").and_return(mock_torrent)
      mock_torrent.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "redirects to the torrents list" do
      Torrent.stub!(:find).and_return(mock_torrent(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(torrents_url)
    end
  end

end
