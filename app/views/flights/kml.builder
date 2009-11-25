xml = Builder::XmlMarkup.new(:indent => 2)

xml.instruct! :xml

xml.kml( "kmlns" => "http://www.opengis.net/kml/2.2" , "xmlns:gx" => "http://www.google.com/kml/ext/2.2" ) do
  xml.Document {
    xml.name("fb_debugABC006_006") #Placeholder we need to be able to get the name of the csv file
    @flights.each do |flight|
    xml.Placemark {
      xml.title(flight.time)
      xml.description {
              xml.cdata!("#{flight.title}<br>time = #{flight.time}<br>lat = #{flight.latitude} &deg;<br>log = #{flight.latitude}  &deg;<br>alt = #{flight.altitude} feet<br>")
      }
      xml.visibility("1")
      xml.open("1")
      xml.style{
        xml.IconStyle{
          xml.icon{xml.href("http://maps.google.com/mapfiles/kml/shapes/shaded_dot.png")}
          xml.scale("0.5")
        }
        xml.BalloonStyle{
          xml.bgcolor("ffffffff")
          xml.textcolor("ff000000")
          xml.text{xml.cdata!("$[name]<p>[discription]")}
        }
      }
      xml.Point{
        xml.extrude("1")
        xml.altitudeMode("absolute")
        xml.coordinates("#{flight.latitude}, #{flight.latitude}, #{flight.altitude}")
      }
    }
    end
  }
end  