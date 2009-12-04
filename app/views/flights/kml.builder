xml = Builder::XmlMarkup.new(:indent => 2)
xml.instruct! :xml

xml.kml( "kmlns" => "http://www.opengis.net/kml/2.2" , "xmlns:gx" => "http://www.google.com/kml/ext/2.2" ) do
  xml.Document {
  xml.name("Tour")
  xml.Placemark{
	xml.Model("id"=>"model"){
		xml.altitudeMode("absolute")
		xml.Location("id"=>"planeLocation"){
			xml.latitude(@flights[1].latitude)
			xml.longitude(@flights[1].longitude)
			xml.altitude(@flights[1].altitude)
		}

		xml.Orientation{
			xml.heading(0)
			xml.tilt(0)
			xml.roll(0)
		}

		xml.Scale{
			xml.x(20)
			xml.y(20)
			xml.z(20)
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
					xml.latitude(@flights[1].latitude)
					xml.longitude(@flights[1].longitude)
					xml.altitude(@flights[1].altitude)
					xml.heading(34)
					xml.tilt(0)
					xml.roll(0)
					xml.altitudeMode("absolute")
				}
			}			
			
		   @flights.each do |flight,i|
		   
		   xml.tag!("gx:AnimatedUpdate"){ 
				xml.tag!("gx:duration"){xml.text! "#{2}"}
				xml.Update{
					xml.targetHref()
					xml.Change{
						xml.Location("targetId"=>"planeLocation"){
							xml.latitude(flight.latitude)
							xml.longitude(flight.longitude)
							xml.altitude(flight.altitude)
						}
					
					
					xml.Model("targetId"=>"model"){
						xml.Orientation{
							xml.heading(flight.heading)
							xml.tilt(0)
							xml.roll(0)
						}
						}
					
					}
				}
			}
						
			xml.tag!("gx:FlyTo"){ 
				xml.tag!("gx:duration"){xml.text! "#{2}"}
				xml.flyToMode("smooth");
				xml.Camera{
					xml.latitude(flight.latitude)
					xml.longitude(flight.longitude)
					xml.altitude(flight.altitude + 4000)
					xml.heading(34)
					xml.tilt(0)
					xml.roll(0)
					xml.altitudeMode("absolute")
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
	  xml.name(Time.at(flight.time).getgm.strftime("%H:%M:%S")) #Placeholder we need to be able to get the name of the csv file
      xml.title(flight.time)
      xml.description {
		xml.cdata!("#{flight.title}<br>time = #{flight.time}<br>long = #{flight.latitude}  &deg;<br>lat = #{flight.longitude} &deg;<br>alt = #{flight.altitude} feet<br>")
      }
      xml.visibility("1")
      xml.open("1")
      xml.styleUrl("\#shadedDot")
	  xml.BalloonStyle{
			 xml.bgcolor("ffffffff")
			 xml.textcolor("ff000000")
			 xml.text{xml.cdata!("$[name]<p>[discription]")}
		}
      xml.Point{
        xml.extrude("1")
        xml.altitudeMode("absolute")
        xml.coordinates("#{flight.longitude}, #{flight.latitude}, #{flight.altitude}")
      }
    }
    end
	xml.Placemark{
		xml.LineStyle{
			xml.color("7fff00ff")
			xml.width("15")
		}
		xml.PolyStyle{
			xml.color("7fff00ff")
		}

		xml.name("Absolute")
		xml.visibility("1")
		
		xml.LineString{
			xml.tessellate("1")
			xml.altitudeMode("absolute")
			xml.coordinates("-74.572778, 39.46, 0.0, -74.621667, 39.435278, 1183.3")
		}
	}
	} 
}	
end
