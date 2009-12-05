class WxKey < ActiveRecord::Base
  establish_connection :weather
  #set_table_name 'URET01.WX_RUC2_VALUES20050317'
  #belongs_to :weather
  #set_primary_keys :x, :y
  #has_many :weather, :class_name => 'weather', :foreign_key => [:x, :y]
end
