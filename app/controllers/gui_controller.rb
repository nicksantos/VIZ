class GuiController < ApplicationController
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  def select
    @flights = Flight.find( :all, :select => 'DISTINCT Title' )
    respond_to do |format|
      format.html
    end
  end
end
