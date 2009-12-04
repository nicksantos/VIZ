class WeatherController < ApplicationController
  def index
    @weather_points = WeatherValues.find_by_sql(["SELECT t1.wx_key, t2.wx_key, t1.lat,t1.lon, t2.geopot_alt,t2.anl_hr FROM wx_ruc2_nodes236 t1, wx_ruc2_values20050317new t2 WHERE t1.wx_key = substr (t2.wx_key, 1, instr (t2.wx_key,',',1,2) - 1)  AND (substr (t2.wx_key, instr (t2.wx_key,',',1, 2) + 1, length (t2.wx_key)) NOT IN ('775', '1000') OR substr (t2.wx_key, 1, instr (t2.wx_key,',',1, 2) - 1) <> '1,81') -- substr is being used to get the values before 2nd comma ',' AND t1.lat = ? AND t1.lon = ?  AND t2.geopot_alt = ? And t2.anl_hr = ?",33.57625436767503,-79.7632086877915,7136.155176037566,18])
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

