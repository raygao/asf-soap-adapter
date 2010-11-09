class AdapterHomesController < ApplicationController
  # GET /adapter_homes
  # GET /adapter_homes.xml
  def index
    @adapter_homes = AdapterHome.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @adapter_homes }
    end
  end

  # GET /adapter_homes/1
  # GET /adapter_homes/1.xml
  def show
    @adapter_home = AdapterHome.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @adapter_home }
    end
  end

  # GET /adapter_homes/new
  # GET /adapter_homes/new.xml
  def new
    @adapter_home = AdapterHome.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @adapter_home }
    end
  end

  # GET /adapter_homes/1/edit
  def edit
    @adapter_home = AdapterHome.find(params[:id])
  end

  # POST /adapter_homes
  # POST /adapter_homes.xml
  def create
    @adapter_home = AdapterHome.new(params[:adapter_home])

    respond_to do |format|
      if @adapter_home.save
        format.html { redirect_to(@adapter_home, :notice => 'AdapterHome was successfully created.') }
        format.xml  { render :xml => @adapter_home, :status => :created, :location => @adapter_home }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @adapter_home.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /adapter_homes/1
  # PUT /adapter_homes/1.xml
  def update
    @adapter_home = AdapterHome.find(params[:id])

    respond_to do |format|
      if @adapter_home.update_attributes(params[:adapter_home])
        format.html { redirect_to(@adapter_home, :notice => 'AdapterHome was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @adapter_home.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /adapter_homes/1
  # DELETE /adapter_homes/1.xml
  def destroy
    @adapter_home = AdapterHome.find(params[:id])
    @adapter_home.destroy

    respond_to do |format|
      format.html { redirect_to(adapter_homes_url) }
      format.xml  { head :ok }
    end
  end
end
