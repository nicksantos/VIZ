xml = Builder::XmlMarkup.new(:indent => 2)

xml.instruct! :xml

xml.kml( "kmlns" => "http://www.opengis.net/kml/2.2" , "xmlns:gx" => "http://www.google.com/kml/ext/2.2" ) do
  xml.Document {
    xml.name("weather") #Placeholder
    weather_points.each do |weather_data|
    xml.Placemark {
      xml.title(weather_data.time)
      xml.description {
              xml.cdata!("#{weather_data.title}<br>time = #{weather_data.time}<br>long = #{weather_data.longitude}  &deg;<br>lat = #{weather_data.latitude} &deg;<br>alt = #{weather_data.altitude} feet<br>")
      }
    xml.visibility("1")
    xml.open("1")
    xml.style{
    xml.IconStyle{
      xml.icon{
        xml.href("http://maps.google.com/mapfiles/kml/shapes/shaded_dot.png")
      }
        xml.scale("0.5")
      }
      xml.BalloonStyle{
        xml.bgcolor("ffffffff")
        xml.textcolor("ff000000")
        xml.text{xml.cdata!("$[name]<p>[discription]")}
      }
    }
    xml.Model("id"=>"windbarb#{weather_data.magnitude/5*5}"){
      xml.altitudeMode("relativeToGround")
      xml.Location{
        xml.longitude("#{weather_data.longitude}")
        xml.latitude("#{weather_data.latitude}")
        xml.altitude("#{weather_data.altitude}")
      }
      xml.Orientation{
        xml.heading("#{weather_data.heading}")
        xml.tilt("0")
        xml.roll("0")
      }
      xml.Scale{
        xml.x("1");
        xml.y("1");
        xml.z("1");
      }
      xml.Link{
        xml.href("windbarb#{weather_data.magnitude/5*5}.dae")
      }
    }
      #xml.Point{
      #  xml.extrude("1")
      #  xml.altitudeMode("absolute")
      #  xml.coordinates("#{weather.longitude}, #{weather.latitude}, #{weather.altitude}")
      #}
    }
    end
  }
end