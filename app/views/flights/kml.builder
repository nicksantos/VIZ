xml = Builder::XmlMarkup.new( :indent => 2)

xml.instruct! :xml

xml.kml( "xmlns" => "http://www.opengis.net/kml/2.2" , "xmlns:gx" => "http://www.google.com/kml/ext/2.2" ) do
  xml.Document {
    xml.name("fb_debugABC006_006") #Placeholder we need to be able to get the name of the csv file
	xml.Folder{
		xml.name("ABC006_006")
    @flights.each do |flight|
    xml.Placemark {
      xml.name(Time.at(flight.time).getgm.strftime("%H:%M:%S"))
      xml.description {
              xml.cdata!("\n#{flight.title}<br>time = #{flight.time}<br>long = #{flight.longitude}  &deg;<br>lat = #{flight.latitude} &deg;<br>alt = #{flight.altitude} feet<br>\n")
      }
      xml.visibility("1")
      xml.open("1")
      xml.Style{
        xml.IconStyle{
          xml.Icon{xml.href("http://maps.google.com/mapfiles/kml/shapes/shaded_dot.png")}
          xml.scale("\n0.5\n")
        }
        xml.BalloonStyle{
          xml.bgcolor("ffffffff")
          xml.textcolor("ff000000")
          xml.text{xml.cdata!("$[name]<p>$[description]")}
        }
      }
      xml.Point{
        xml.extrude("1")
        xml.altitudeMode("absolute")
        xml.coordinates("\n#{flight.longitude}, #{flight.latitude}, #{flight.altitude}\n")
      }
    }
    end
	}
  }
end  