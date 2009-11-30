var ge;

var map;

google.load("earth", "1");
google.load("maps", "2.x");
google.load('visualization', '1', {packages: ['gauge']});
google.load('visualization', '1', {packages: ['areachart']});

function init() {
	//create earth
	google.earth.createInstance('earth', initCB, failureCB);
	
	//create map
	this.map = new GMap2(document.getElementById("map"));
}

function initCB(instance) {
	
	//get the kml for the map and earth from this URL
	var href = 'http://localhost:3000/flights.kml';
	
	ge = instance;
	ge.getWindow().setVisibility(true);
	//set inital view of earth
	var la = ge.createLookAt('');
      la.set(39.46,  -74.572778,
        0, // altitude
        ge.ALTITUDE_RELATIVE_TO_GROUND,
        0, // heading
        0, // straight-down tilt
        10000 // range (inverse of zoom)
        );
    ge.getView().setAbstractView(la);
	
	//set inital view of map
	map.setCenter(new GLatLng(39.46, -74.572778), 12);
	map.enableScrollWheelZoom();
	// Add GHierarchicalMapTypeControl
	map.addMapType(G_PHYSICAL_MAP);
	
	DS_directions = new google.maps.Directions(map, null);
	//add map over lay
	var geoXml = new GGeoXml(href);
	map.addOverlay(geoXml);
	
	// add a navigation control
	ge.getNavigationControl().setVisibility(ge.VISIBILITY_AUTO);
	
	// add some layers
	ge.getLayerRoot().enableLayerById(ge.LAYER_BORDERS, true);
	ge.getLayerRoot().enableLayerById(ge.LAYER_ROADS, true);
	
	// create the tour by fetching it out of a KML file
	google.earth.fetchKml(ge, href, function(kmlObject) {
	  if (!kmlObject) {
		// wrap alerts in API callbacks and event handlers
		// in a setTimeout to prevent deadlock in some browsers
		setTimeout(function() {
		  alert('Bad or null KML.');
		}, 0);
		return;
	  }
	
	  // Show the entire KML file in the plugin.
	  ge.getFeatures().appendChild(kmlObject);
	  var arr = xml2array(href);
	  
	  $('#time_value').html("<div>"+arr['xml']['kml']['Document'][0]);
	  
	  // Walk the DOM looking for a KmlTour
	  walkKmlDom(kmlObject, function() {
		if (this.getType() == 'KmlTour') {
		  ge.getTourPlayer().setTour(this);
		  return false; // stop the DOM walk here.
		}
	  });
	  
	  // make the slider for dragging the tour timeline
	  var slider = new SimpleSlider(document.getElementById('slider-container'), {
		onSlide: function(pos) {
		  ge.getTourPlayer().setCurrentTime(pos);
		},
		max: ge.getTourPlayer().getDuration(),
		formatPosFn: formatTime
	  });
	
	  window.setInterval(function() {
		slider.setPosition(ge.getTourPlayer().getCurrentTime());
	  }, 50);
	});
	
	
}

function failureCB(errorCode) {
}

function playTour() {
	ge.getTourPlayer().play();
}

function pauseTour() {
	ge.getTourPlayer().pause();
}

function resetTour() {
	ge.getTourPlayer().reset();
}

function formatTime(sec) {
	var pad2 = function(n) {
	  return (n < 10) ? '0' + n : n;
	};

	sec = Math.floor(sec);

	var min = Math.floor(sec / 60);
	sec = sec % 60;

	var hrs = Math.floor(min / 60);
	min = min % 60;

	var str = '';
	str += hrs

	return (hrs ? (hrs + ':' + pad2(min)) : min) + ':' + pad2(sec);
}
