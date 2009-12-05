class WeatherValues < ActiveRecord::Base
  establish_connection :weather
  set_table_name 'URET01.WX_RUC2_VALUES20050317'
  self.set_primary_key('wx_key')
  
end
