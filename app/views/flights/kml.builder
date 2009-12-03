xml = Builder::XmlMarkup.new(:indent => 2)
xml.instruct! :xml

xml.kml( "kmlns" => "http://www.opengis.net/kml/2.2" , "xmlns:gx" => "http://www.google.com/kml/ext/2.2" ) do
  xml.Document {
  xml.name("Tour")
  xml.Placemark{
	xml.Model("id"=>"model_1"){
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
			xml.x(30)
			xml.y(30)
			xml.z(30)
		}
		xml.Link{
			xml.href("files/hawk.dae")
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
						xml.Model("targetId"=>"model_1"){
								xml.Orientation{
									xml.heading(flight.heading)
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
					xml.altitude(flight.altitude + 4500)
					xml.heading(34)
					xml.tilt(0)
					xml.roll(0)
					xml.altitudeMode("absolute")
				}
			}
		   end
		}
	}
}	
end
