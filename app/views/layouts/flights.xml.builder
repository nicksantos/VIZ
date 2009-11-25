xml.instruct!

xml.flights do
    @flights.each do |flight|
      xml.flight(:title => flight.name, :time => flight.time, :latitude => flight.latitude, :longitude => flight.longitude)
    end
end