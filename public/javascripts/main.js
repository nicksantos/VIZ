var ge;
var map;
var fuelGauge;
var fuelGaugeViz;
var airTempChart;
var airTempRows;
var airTempViz;
var windMagChart;
var windMagRows;
var windMagViz;
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
}

function initCB(instance) {
  //get the kml for the map and earth from this URL 
  var href = 'http://localhost:3000/flights.kml?id='+importId+'&flightId='+flightIds[0];
  //setup google earth window
  ge = instance;
  ge.getWindow().setVisibility(true);
  // add a navigation control
  ge.getNavigationControl().setVisibility(ge.VISIBILITY_AUTO);
  
  // remove some layers
  ge.getLayerRoot().enableLayerById(ge.LAYER_BORDERS, false);
  ge.getLayerRoot().enableLayerById(ge.LAYER_ROADS, false);
  
	// Create a new LookAt
	var lookAt = ge.createLookAt('');

	// Set the position values
	lookAt.setLatitude(39.46);
	lookAt.setLongitude(-74.572778);
	lookAt.setRange(1000.0); //default is 0.0

	// Update the view in Google Earth
	ge.getView().setAbstractView(lookAt);
  
  updateFuelGauge(80);
  updateAirChart('14:00', 100.00);
  updateWindChart('14:00', 120.00);

  
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
  });
  
   google.earth.addEventListener(ge.getView(), 'viewchange', function(evt) {

    var totalBounds = new GLatLngBounds();

    // get the globe bounds (method 1)
    var globeBounds = ge.getView().getViewportGlobeBounds();
    var fakeBoundsCenter = null;

    if (globeBounds) {
      globeBounds.setNorth(Math.min(globeBounds.getNorth(), 85));
      globeBounds.setSouth(Math.max(globeBounds.getSouth(), -85));

      if (globeBounds.getEast() == 180 && globeBounds.getWest() == -180) {
      fakeBoundsCenter = new GLatLng(0, 0);
      var globeBoundsPolygon = new GPolygon([
        new GLatLng(globeBounds.getNorth(), -179),
        new GLatLng(globeBounds.getNorth(), 0),
        new GLatLng(globeBounds.getNorth(), 179),
        new GLatLng(globeBounds.getSouth(), 179),
        new GLatLng(globeBounds.getSouth(), 0),
        new GLatLng(globeBounds.getSouth(), -179),
        new GLatLng(globeBounds.getNorth(), -179)],
        '#0000ff', 2, 1.00,
        '#0000ff',    0.25,
        { clickable: false });
      } else {
      var globeBoundsPolygon = new GPolygon([
        new GLatLng(globeBounds.getNorth(), globeBounds.getWest()),
        new GLatLng(globeBounds.getNorth(), globeBounds.getEast()),
        new GLatLng(globeBounds.getSouth(), globeBounds.getEast()),
        new GLatLng(globeBounds.getSouth(), globeBounds.getWest()),
        new GLatLng(globeBounds.getNorth(), globeBounds.getWest())],
        '#0000ff', 2, 1.00,
        '#0000ff',    0.25,
        { clickable: false });
      }

      var polyBounds = globeBoundsPolygon.getBounds();
      totalBounds.extend(polyBounds.getNorthEast());
      totalBounds.extend(polyBounds.getSouthWest());
    }

    // hit test the corners (method 2)
    var hitTestTL = ge.getView().hitTest(0, ge.UNITS_FRACTION, 0, ge.UNITS_FRACTION, ge.HIT_TEST_GLOBE);
    var hitTestTR = ge.getView().hitTest(1, ge.UNITS_FRACTION, 0, ge.UNITS_FRACTION, ge.HIT_TEST_GLOBE);
    var hitTestBR = ge.getView().hitTest(1, ge.UNITS_FRACTION, 1, ge.UNITS_FRACTION, ge.HIT_TEST_GLOBE);
    var hitTestBL = ge.getView().hitTest(0, ge.UNITS_FRACTION, 1, ge.UNITS_FRACTION, ge.HIT_TEST_GLOBE);

    // ensure that all hit tests succeeded (i.e. the viewport is 2d-mappable)
    if (hitTestTL && hitTestTR && hitTestBL && hitTestBR) {
      var hitTestBoundsPolygon = new GPolygon([
        new GLatLng(hitTestTL.getLatitude(), hitTestTL.getLongitude()),
        new GLatLng(hitTestTR.getLatitude(), hitTestTR.getLongitude()),
        new GLatLng(hitTestBR.getLatitude(), hitTestBR.getLongitude()),
        new GLatLng(hitTestBL.getLatitude(), hitTestBL.getLongitude()),
        new GLatLng(hitTestTL.getLatitude(), hitTestTL.getLongitude())],
        '#ff0000', 2, 1.00,
        '#ff0000',    0.25,
        { clickable: false });

      var polyBounds = hitTestBoundsPolygon.getBounds();
      totalBounds.extend(polyBounds.getNorthEast());
      totalBounds.extend(polyBounds.getSouthWest());
    }

    if (!totalBounds.isEmpty()) {
      map.setCenter(fakeBoundsCenter ? fakeBoundsCenter : totalBounds.getCenter(),
        map.getBoundsZoomLevel(totalBounds));
    }
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
      fuelGauge.addColumn('string', 'Fuel Gauge');
      fuelGauge.addColumn('number', 'Weight');
      fuelGauge.addRows(3);
      fuelGauge.setValue(0, 0, '');    
      // Create and draw the visualization.
      fuelGaugeViz = new google.visualization.Gauge(document.getElementById('gauge'));
      fuelGaugeViz.draw(fuelGauge, null);
}

function drawAirChart() {
      // Create and populate the data table.
      this.airTempChart = new google.visualization.DataTable();
      airTempChart.addColumn('string', 'Time');
      airTempChart.addColumn('number', 'Temp(K)');
	  airTempRows = 0;
      // Create and draw the visualization.
    airTempViz=new google.visualization.AreaChart(document.getElementById('temp_chart'));
    airTempViz.draw(airTempChart, null);
}

function drawWindChart() {
    // Create and populate the data table.
    windMagChart = new google.visualization.DataTable();
    windMagChart.addColumn('string', 'Time');
    windMagChart.addColumn('number', 'Knots');
	windMagRows =0;
    // Create and draw the visualization.
    windMagViz =new google.visualization.AreaChart(document.getElementById('wind_mag'));
    windMagViz.draw(windMagChart, null);
}

function updateFuelGauge(value) {
  fuelGauge.setValue(0, 1, value);
  fuelGaugeViz.draw(fuelGauge, null);
}

function updateAirChart(time, value){
  airTempChart.addRows(1);
  airTempChart.setCell(airTempRows, 0, time);
  airTempChart.setCell(airTempRows, 1, value);
  airTempRows++;
  airTempViz.draw(airTempChart,null);
}

function updateWindChart(time, value){
  windMagChart.addRows(1);
  windMagChart.setCell(windMagRows, 0, time);
  windMagChart.setCell(windMagRows, 1, value);
  windMagRows++;
  windMagViz.draw(windMagChart,null);
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
