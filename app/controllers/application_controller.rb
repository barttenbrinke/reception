# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :set_transmission

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  layout "reception"

  # Get transmission remote up and running
  def set_transmission
    @remote = Remote.new()
  end
  
  # Set the source object
  def set_source
    @source = Source.find(params[:source_id])
  end
  
  def update_torrents
    @remote.update(:skip_sources => true)
  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
