class WeatherController < ApplicationController
  def index
    @weather_points = Weather.find_by_sql('SELECT t2.wx_key, t1.lat,t1.lon, t2.geopot_alt,t2.anl_hr,t2.wind_mag,t2.wind_dir_to FROM wx_ruc2_nodes236 t1, wx_ruc2_values20050317new t2 WHERE t1.wx_key = substr (t2.wx_key, 1, instr (t2.wx_key,\',\',1,2) - 1) and t1.LAT > 32 and t1.LAT < 33 and t1.LON > -80 and t1.LON < -79 and t2.GEOPOT_ALT < 2000 and t2.GEOPOT_ALT > 1000 and t2.ANL_HR = 18')
    wxval = @weather_points[0]
    @weather_values = WeatherValues.find(wxval)
    
    respond_to do |format|
      format.html # index.html.erb
      format.kml { render :action => "kml" }
    end
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

end

