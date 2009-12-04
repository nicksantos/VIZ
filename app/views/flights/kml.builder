xml = Builder::XmlMarkup.new(:indent => 2)
xml.instruct! :xml

lat = []
lon = []
alt = []

xml.kml( "kmlns" => "http://www.opengis.net/kml/2.2" , "xmlns:gx" => "http://www.google.com/kml/ext/2.2" ) do
  xml.Document {
  xml.name("Tour")
  xml.Placemark{
	xml.Model("id"=>"model"){
		xml.altitudeMode("absolute")
		xml.Location("id"=>"planeLocation"){
			xml.latitude(@flights[0].latitude)
			xml.longitude(@flights[0].longitude)
			xml.altitude(@flights[0].altitude)
		}

		xml.Orientation("id"=>"planeOrientation"){
			xml.heading(@flights[0].heading)
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
					xml.heading(@flights[0].altitude)
					xml.tilt(0)
					xml.roll(0)
					xml.altitudeMode("absolute")
				}
			}			
			
		   i=0
		   heading = 0
		   duration = 0
		   from = String.new
		   to = String.new
		   
		   @flights.each do |flight|
		   
		   lat << flight.latitude
		   lon << flight.longitude
		   alt << flight.altitude
		   
		   if i != @flights.length-1
				duration = @flights[i+1].time - @flights[i].time
				to << @flights[i+1].latitude.to_s << ","
				to << @flights[i+1].longitude.to_s
				from << @flights[i].latitude.to_s << ","
				from << @flights[i].longitude.to_s
				nextPt = GeoKit::LatLng.normalize(to)
				currentPt = GeoKit::LatLng.normalize(from)
				heading = nextPt.heading_from(currentPt)	
			end
		   
		   xml.tag!("gx:AnimatedUpdate"){
				xml.tag!("gx:duration"){xml.text! "#{duration}"}
				#xml.flyToMode("smooth")
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
				xml.flyToMode("smooth")
				xml.Camera{
					xml.latitude(flight.latitude)
					xml.longitude(flight.longitude)
					xml.altitude(flight.altitude + 5000)
					xml.heading(heading)
					xml.tilt(0)
					xml.roll(0)
					xml.altitudeMode("absolute")
				}
			}
			i = i + 1
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
	xml.Style("id"=>"path"){
		xml.LineStyle{
			xml.color("7fff00ff")
			xml.width("8")
		}
		xml.PolyStyle{
			xml.color("7fff00ff")
		}
	}
	cord = String.new
	i=0
	while i < lat.length
		cord << lon[i].to_s << "," << lat[i].to_s << "," << alt[i].to_s << "\n"
		i+=1				
	end
	xml.Placemark{
		xml.name("Absolute")
		xml.styleUrl("\#path")
		xml.LineString{
			xml.tessellate("1")
			xml.altitudeMode("absolute")
			xml.coordinates(cord)
		}
	}
	} 
}	
end
	
