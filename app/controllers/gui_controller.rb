class GuiController < ApplicationController
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  def select
    @flights = Flight.all
    respond_to do |format|
      format.html
    end
  end
end
