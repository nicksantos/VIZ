class Weather < ActiveRecord::Base
  establish_connection :weather
  #set_table_name "URET01.WX_RUC2_NODES236"
end
