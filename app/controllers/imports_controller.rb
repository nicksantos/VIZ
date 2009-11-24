class ImportsController < ApplicationController
  #before_filter :login_required #protect controller from anonymous users

  def new
    @import = Import.new
	end

	def create
    @import = Import.new(params[:import])

    respond_to do |format|
      if @import.save!
        flash[:notice] = 'CSV data was successfully imported.'
        format.html { redirect_to(@import) }
      else
        flash[:error] = 'CSV data import failed.'
        format.html { render :action => "new" }
      end
    end
	end

	def show
    @import = Import.find(params[:id])
	end

	def proc_csv
    @import = Import.find(params[:id])
    lines = parse_csv_file(@import.csv.path)
    lines.shift #comment this line out if your CSV file doesn't contain a header row
    if lines.size > 0
      @import.processed = lines.size
      lines.each do |line|
        case @import.datatype
        when "releases"
          new_release(line)
        end
      end
      @import.save
      flash[:notice] = "CSV data processing was successful."
      redirect_to :action => "show", :id => @import.id
    else
      flash[:error] = "CSV data processing failed."
      render :action => "show", :id => @import.id
    end
	end

private

  def parse_csv_file(path_to_csv)
    lines = []

    #if not installed run, sudo gem install fastercsv
    #http://fastercsv.rubyforge.org/
    require 'fastercsv' 

    FasterCSV.foreach(path_to_csv) do |row|
      lines << row
    end
    lines
  end

	def new_release(line)
    params = Hash.new
      params[:flight] = Hash.new
      params[:flight]["title"] = line[0]
  	  params[:flight]["time"] = line[1]
      params[:flight]["latitude"] = line[3]
      params[:flight]["longitude"] = line[4]
  	  params[:flight]["altitude"] = line[5]
      params[:flight]["groundspeed"] = line[11]
      params[:flight]["heading"] = line[12]
  	  params[:flight]["air_temp"] = line[7]
      params[:flight]["air_density"] = line[8]
      params[:flight]["pressure"] = line[9]
      flight = Flight.new(params[:flight])
    flight.save
	end

end