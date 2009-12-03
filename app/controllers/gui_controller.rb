class GuiController < ApplicationController
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  def select
	id = params[:id]
    @flights = Flight.find( :all, :select => 'DISTINCT Title, import_id', :conditions => ["import_id = ?", id])
    respond_to do |format|
      format.html
    end
  end
  
  def loadFlights
	@flight_ids = params[:flight_ids]
	  
  end
end
