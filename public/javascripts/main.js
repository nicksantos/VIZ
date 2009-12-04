var v;
var ge;
var map;
var fuel_gauge_viz;
var air_temp_viz;
var wind_mag_viz;
google.load("earth", "1");
google.load("maps", "2.x");
google.load('visualization', '1', {packages: ['gauge']});
google.load('visualization', '1', {packages: ['areachart']});

function init() {
	//create map
	this.map = new GMap2(document.getElementById("map"));
	initMap();
	
	//create earth
	google.earth.createInstance('earth', initCB, failureCB);
	
	
	drawFuelGauge();
	drawAirChart();
	drawWindChart();
}
function initMap() {


	map.enableScrollWheelZoom();
	// Add GHierarchicalMapTypeControl
	map.addMapType(G_PHYSICAL_MAP);
	//add map over lay
	//var exml = new EGeoXml("exml", map, "/flights.kml");
	//var exml = new GeoXml("exml", map, "flights.kml" , {});
	//exml.parse();
	map.setCenter(new GLatLng(39.46, -74.572778), 12);
}

function initCB(instance) {
	
	
	updateFuelGauge();
	//updateAirChart('14:00', 100);
	//updateAirChart('14:10', 120);
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

function drawFuelGauge() {
      // Create and populate the data table.
      this.fuelGauge = new google.visualization.DataTable();
      fuelGauge.addColumn('string', 'Label');
      fuelGauge.addColumn('number', 'Value');
      fuelGauge.addRows(3);
      fuelGauge.setValue(0, 0, '');
      fuelGauge.setValue(0, 1, 80);      
      // Create and draw the visualization.
      new google.visualization.Gauge(document.getElementById('gauge')).
          draw(fuelGauge, null);
}

function drawAirChart() {
      // Create and populate the data table.
      this.airChart = new google.visualization.DataTable();
      airChart.addColumn('string', 'Time');
      airChart.addColumn('number', 'Temp(K)');
      airChart.addRows(3);
      airChart.setCell(0, 0, '13:30');
      airChart.setCell(1, 0, '13:40');
      airChart.setCell(2, 0, '13:50');
      airChart.setCell(0, 1, 281.744);
      airChart.setCell(1, 1, 281.752);
      airChart.setCell(2, 1, 281.758);
    
      // Create and draw the visualization.
	  document.getElementById('wind_mag').empty();
      v = new google.visualization.AreaChart(document.getElementById('temp_chart'));
	  v.draw(airChart, null);
}

function drawWindChart() {
    // Create and populate the data table.
    var windChart = new google.visualization.DataTable();
    windChart.addColumn('string', 'Time');
    windChart.addColumn('number', 'Temp(K)');
    windChart.addRows(3);
    windChart.setCell(0, 0, '13:30');
    windChart.setCell(1, 0, '13:40');
    windChart.setCell(2, 0, '13:50');
    windChart.setCell(0, 1, 5.821);
    windChart.setCell(1, 1, 5.803);
    windChart.setCell(2, 1, 5.79);
  
    // Create and draw the visualization.
    new google.visualization.AreaChart(document.getElementById('wind_mag')).
        draw(windChart, null);
}

function updateFuelGauge() {
	fuelGauge.setValue(0, 1, 100);
	new google.visualization.Gauge(document.getElementById('gauge')).
          draw(fuelGauge, null);
}

function updateAirChart(time, value){
	var rows = airChart.getSelection().length;
	airChart.addRows(1);
	airChart.setCell(rows, 0, time);
	airChart.setCell(rows, 1, value);
	v.draw(airChart,null);
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
