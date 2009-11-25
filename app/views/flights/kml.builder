xml = Builder::XmlMarkup.new(:indent => 2)

xml.instruct! :xml

xml.kml( "kmlns" => "http://earth.google.com/kml/2.1" ) do
  xml.Document {
    @flights.each do |flight|
    xml.Flight {
      xml.title(flight.title)
    }
    end
  }
end