ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter.class_eval do
  self.emulate_integers_by_column_name = true
  self.emulate_dates_by_column_name = true
  self.emulate_booleans_from_strings = true
  self.string_to_date_format = '%d.%m.%Y'
  self.string_to_time_format = '%d.%m.%Y %H:%M:%S'
end
