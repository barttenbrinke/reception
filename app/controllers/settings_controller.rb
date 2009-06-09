class SettingsController < ApplicationController
  
  # GET /settings
  # GET /settings.xml
  def index
    redirect_to edit_setting_path(@remote.setting)
  end

  # GET /settings/1/edit
  def edit
    @setting = @remote.setting
  end

  # PUT /settings/1
  # PUT /settings/1.xml
  def update
    @setting = @remote.setting
    respond_to do |format|
      if @setting.update_attributes(params[:setting]) && @remote.push_settings(@setting)
        flash[:notice] = 'Setting was successfully updated.'
        format.html { redirect_to( settings_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @setting.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
end
