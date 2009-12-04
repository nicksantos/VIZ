xml = Builder::XmlMarkup.new(:indent => 2)
xml.instruct! :xml
xml.kml( "kmlns" => "http://www.opengis.net/kml/2.2" , "xmlns:gx" => "http://www.google.com/kml/ext/2.2" ) do
  xml.Document {
  xml.name("Tour")
  nextPt = GeoKit::LatLng.normalize([@flights[1].latitude, @flights[1].longitude])
  currentPt = GeoKit::LatLng.normalize([@flights[0].latitude, @flights[0].longitude])
  heading = nextPt.heading_from(currentPt)
  xml.Placemark{
  xml.Model("id"=>"model"){
    xml.altitudeMode("absolute")
    xml.Location("id"=>"planeLocation"){
      xml.latitude(@flights[0].latitude)
      xml.longitude(@flights[0].longitude)
      xml.altitude(@flights[0].altitude)
    }
	
    xml.Orientation("id"=>"planeOrientation"){
      xml.heading(heading)
      xml.tilt(0)
      xml.roll(0)
    }

    xml.Scale{
      xml.x(15)
      xml.y(15)
      xml.z(15)
    }
    xml.Link{
      xml.href("http://localhost:3000/images/hawk.dae")
    }
  }
  }
  
  xml.tag!("gx:Tour"){ 
    xml.name("play me")
    xml.tag!("gx:Playlist"){
      xml.FlyTo {
        xml.tag!("gx:duration") {xml.text! "#{1}"}
        xml.Camera{
          xml.latitude(@flights[0].latitude)
          xml.longitude(@flights[0].longitude)
          xml.altitude(@flights[0].altitude)
          xml.heading(heading)
          xml.tilt(0)
          xml.roll(0)
          xml.altitudeMode("absolute")
        }
      }
        
      l = @flights.length
      heading = 0
      duration = 0
      0.upto(l-1) do |i|
        flight = @flights[i]
        unless i == l-1
          duration = @flights[i+1].time - @flights[i].time
          nextPt = GeoKit::LatLng.normalize([@flights[i+1].latitude, @flights[i+1].longitude])
          currentPt = GeoKit::LatLng.normalize([@flights[i].latitude, @flights[i].longitude])
          heading = nextPt.heading_from(currentPt)
        end
		lastPtlat = @flights[i].latitude
		lastPtlon = @flights[i].longitude
		if i != 0
			lastPtlat = @flights[i - 1].latitude
			lastPtlon = @flights[i - 1].longitude
		end
        xml.tag!("gx:AnimatedUpdate"){
          xml.tag!("gx:duration"){xml.text! "#{duration}"}
		  xml.tag!("gx:flyToMode"){xml.text! "smooth"}
          xml.Update{
            xml.targetHref()
            xml.Change{
              xml.Location("targetId"=>"planeLocation"){
                xml.latitude(flight.latitude)
                xml.longitude(flight.longitude)
                xml.altitude(flight.altitude)
              }
              xml.Orientation("targetId"=>"planeOrientation"){          
                xml.heading(heading)
              }
            } 
          } 
        }    
        xml.tag!("gx:FlyTo"){ 
          xml.tag!("gx:duration"){xml.text! "#{duration}"}
          xml.tag!("gx:flyToMode"){xml.text! "smooth"}
          #xml.Camera{
          #  xml.latitude(lastPtlat)
          #  xml.longitude(lastPtlon)
          #  xml.altitude(flight.altitude)
          #  xml.heading(heading)
          #  xml.tilt(90)
          #  xml.roll(0)
          #  xml.altitudeMode("absolute")
          #}
		  xml.LookAt{
			xml.latitude(flight.latitude)
            xml.longitude(flight.longitude)
            xml.altitude(flight.altitude+20)
			xml.range(700)
			xml.tilt(60)
			xml.heading(heading)
			xml.altitudeMode("relativeToGround")
		  }
        }
      end 
  }
}
  xml.Folder{
    xml.Style("id"=>"shadedDot"){
      xml.IconStyle{
        xml.Icon{xml.href("http://maps.google.com/mapfiles/kml/shapes/shaded_dot.png")}
         xml.scale("0.5")
      }
    }
  
    @flights.each do |flight|
      xml.Placemark {
        xml.name(Time.at(flight.time).getgm.strftime("%H:%M:%S"))
        xml.title(flight.time)
        xml.description {
          xml.cdata!("#{flight.title}<br>time = #{flight.time}<br>long = #{flight.latitude}  &deg;<br>lat = #{flight.longitude} &deg;<br>alt = #{flight.altitude} feet<br>")
        }
        xml.visibility("1")
        xml.open("1")
        xml.styleUrl("\#shadedDot")
        xml.Point{
          xml.extrude("1")
          xml.altitudeMode("absolute")
          xml.coordinates("#{flight.longitude}, #{flight.latitude}, #{flight.altitude}")
        }
      }
    end
    xml.Style("id"=>"path"){
      xml.LineStyle{
        xml.color("7fff00ff")
        xml.width("8")
      }
      xml.PolyStyle{
        xml.color("7fff00ff")
      }
    }

    xml.Placemark{
      xml.name("Absolute")
      xml.styleUrl("\#path")
      xml.LineString{
        xml.tessellate("1")
        xml.altitudeMode("absolute")
        xml.coordinates{
          @flights.each do |flight|
            xml << "#{flight.longitude}, #{flight.latitude}, #{flight.altitude} \n"
          end
        }
      }
    } 
  }
} 
end
