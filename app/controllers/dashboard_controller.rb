class DashboardController < ApplicationController
  # GET /dashboard
  
  before_filter :update_torrents
  
  def index
  end
  
end
