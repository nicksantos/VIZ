class Weather < ActiveRecord::Base
  establish_connection :weather
  set_table_name 'URET01.WX_RUC2_NODES236'
  self.set_primary_key('wx_key')
  #belongs_to :wx_key, :foreign_key => [:x, :y]
end
