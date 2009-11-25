var ge;
google.load("earth", "1");
google.load("maps", "2.x");
google.load('visualization', '1', {packages: ['gauge']});
google.load('visualization', '1', {packages: ['areachart']});

function init() {
	google.earth.createInstance('earth', initCB, failureCB);
	var map = new GMap2(document.getElementById("map"));
	  map.setCenter(new GLatLng(37.437657, -122.157841), 12);
	  map.enableScrollWheelZoom();
	  map.addControl(new GLargeMapControl3D());
	  // Add GHierarchicalMapTypeControl
	  map.addMapType(G_PHYSICAL_MAP);
	  var hControl = new GHierarchicalMapTypeControl();
	  hControl.addRelationship(G_SATELLITE_MAP, G_HYBRID_MAP, "Labels", false);
	  map.addControl(hControl);
	 
	  // Add ContextMenuControl to the map
	  map.addControl(new ContextMenuControl());
}

function initCB(instance) {
	ge = instance;
	ge.getWindow().setVisibility(true);
	
	// add a navigation control
	ge.getNavigationControl().setVisibility(ge.VISIBILITY_AUTO);
	
	// add some layers
	ge.getLayerRoot().enableLayerById(ge.LAYER_BORDERS, true);
	ge.getLayerRoot().enableLayerById(ge.LAYER_ROADS, true);

	// create the tour by fetching it out of a KML file
	var href = 'http://localhost:3000/flights.kml'
	
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
	
	document.getElementById('installed-plugin-version').innerHTML =
	  ge.getPluginVersion().toString();
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
