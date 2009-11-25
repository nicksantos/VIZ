xml.flights {
  @flights.each do |flight|
    xml.flight(:title => flight.name, :time => flight.time, :latitude => flight.latitude, :longitude => flight.longitude)
  end
}