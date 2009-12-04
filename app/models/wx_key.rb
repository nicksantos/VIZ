class WxKey < ActiveRecord::Base
  establish_connection :weather
  belongs_to :weather
  belongs_to :weathervalues
end
