class FiltersController < ApplicationController
  # GET /filters
  # GET /filters.xml
  before_filter :set_source
  
  def index
    @filters = @source.filters.all.sort_by{|x| x.keyword}

    torrents = @source.test_filters
    @accepted_torrents = torrents[:accepted].sort_by{|x| x.to_s}
    @rejected_torrents = torrents[:rejected].sort_by{|x| x.to_s}
  end
  
  # GET /filters/new
  # GET /filters/new.xml
  def new
    @filter = Object::Filter.new
    @filter.source = @source

    if params[:positive] == 'false'
      @filter.positive = false
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @filter }
    end
  end

  # GET /filters/1/edit
  def edit
    @filter = Object::Filter.find(params[:id])
  end

  # POST /filters
  # POST /filters.xml
  def create
    @filter = Object::Filter.new(params[:filter])
    @filter.source = @source

    respond_to do |format|
      if @filter.save
        flash[:notice] = 'Filter was successfully created.'
        format.html { redirect_to(@source) }
        format.xml  { render :xml => @filter, :status => :created, :location => @filter }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @filter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /filters/1
  # PUT /filters/1.xml
  def update
    @filter = Object::Filter.find(params[:id])
    @filter.source = @source

    respond_to do |format|
      if @filter.update_attributes(params[:filter])
        flash[:notice] = 'Filter was successfully updated.'
        format.html { redirect_to(@source) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @filter.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /filters/1
  # DELETE /filters/1.xml
  def destroy
    @filter = Object::Filter.find(params[:id])
    @filter.destroy

    respond_to do |format|
      format.html { redirect_to(@source) }
      format.xml  { head :ok }
    end
  end
end
