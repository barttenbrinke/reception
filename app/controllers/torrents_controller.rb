class TorrentsController < ApplicationController
  # GET /torrents
  # GET /torrents.xml
  def index
    @remote.update(:skip_sources => true)

    @active_torrents    = Torrent.active_not_seeding.all.sort_by{|x| x.to_s || ""}
    @paused_torrents    = Torrent.paused.all.sort_by{|x| x.to_s || ""}

    @completed_torrents = Torrent.completed.all(:limit => 20, :order => 'updated_at DESC').sort_by{|x| x.to_s || ""}
    @broken_torrents    = Torrent.broken.all(:limit => 20, :order => 'updated_at DESC').sort_by{|x| x.to_s || ""}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @torrents }
    end
  end

  # GET /torrents/1
  # GET /torrents/1.xml
  def show
    @torrent = Torrent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @torrent }
    end
  end

  # GET /torrents/new
  # GET /torrents/new.xml
  def new
    @torrent = Torrent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @torrent }
    end
  end

  # GET /torrents/1/edit
  def edit
    @torrent = Torrent.find(params[:id])
  end

  # POST /torrents
  # POST /torrents.xml
  def create
    @torrent = Torrent.new(params[:torrent])

    respond_to do |format|
      if @torrent.save
        @remote.push_new_torrents_to_daemon([@torrent])
        flash[:notice] = 'Torrent was successfully created.'
        format.html { redirect_to(@torrent) }
        format.xml  { render :xml => @torrent, :status => :created, :location => @torrent }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @torrent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /torrents/1
  # PUT /torrents/1.xml
  def update
    @torrent = Torrent.find(params[:id])
    result = false
    if params[:status]
      result = @remote.update_state(@torrent, params[:status])
    else
      result = @torrent.update_attributes(params[:torrent])
    end
    
    respond_to do |format|
      if result 
        flash[:notice] = 'Torrent was successfully updated.'
        format.html { redirect_to(torrents_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @torrent.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /torrents/1
  # DELETE /torrents/1.xml
  def destroy
    @torrent = Torrent.find(params[:id])
    @remote.remove_torrent(@torrent)
    @torrent.set_state(:skipped)
    @torrent.save

    respond_to do |format|
      format.html { redirect_to(torrents_url) }
      format.xml  { head :ok }
    end
  end
end
