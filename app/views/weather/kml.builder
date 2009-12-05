xml = Builder::XmlMarkup.new(:indent => 2)

xml.instruct! :xml

xml.kml( "kmlns" => "http://www.opengis.net/kml/2.2" , "xmlns:gx" => "http://www.google.com/kml/ext/2.2" ) do
  xml.Document {
    xml.name("weather") #Placeholder
    l = @weather_points.length
    0.upto(l-1) do |i|
      wpoint = @weather_points[i]
      wvalue = @weather_values[i]
    xml.Placemark {
      xml.title(wvalue.anl_hr)
      xml.description {
              xml.cdata!("time = #{wvalue.anl_hr}<br>long = #{wpoint.lon}  &deg;<br>lat = #{wpoint.lat} &deg;<br>alt = #{wvalue.geopot_alt} feet<br>")
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
    xml.Model("id"=>"windbarb#{wvalue.wind_mag/5*5}"){
      xml.altitudeMode("relativeToGround")
      xml.Location{
        xml.longitude("#{wpoint.lon}")
        xml.latitude("#{wpoint.lat}")
        xml.altitude("#{wvalue.geopot_alt}")
      }
      xml.Orientation{
        xml.heading("#{wvalue.wind_dir}")
        xml.tilt("0")
        xml.roll("0")
      }
      xml.Scale{
        xml.x("1");
        xml.y("1");
        xml.z("1");
      }
      xml.Link{
        xml.href("windbarb#{wvalue.wind_mag/5*5}.dae")
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