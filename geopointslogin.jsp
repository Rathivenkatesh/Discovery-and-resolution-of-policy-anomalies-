<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Xacml</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="description" content="Your Website Description" />
<meta name="keywords" content="keywords, go, here" />
<link href="style.css" rel="stylesheet" type="text/css" media="screen" />

<!-- Map Script -->
<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAASVxhHYHDXQAqpEDfYFy8QRRPAhcmAL9EK4LYhXPFcNEqDQuheBR8NRxel3F4ofI4X1RJV5_khVkbWQ&amp;sensor=false"type="text/javascript">
</script>

<style type="text/css">

#map {
    width: 1349px;
    height: 500px;
    border: 1px solid gray;
    margin-top: 1px;
    margin-left: 1px;
}
</style>

<script type="text/javascript">
//<![CDATA[

// This application is provided by Kjell Scharning
//  Licensed under the Apache License, Version 2.0;
//  http://www.apache.org/licenses/LICENSE-2.0
//  OpenStreetMap (OSM): http://www.openstreetmap.org/
//  OSM licence, Creative Commons: http://creativecommons.org/licenses/by-sa/2.0/legalcode

function gob(e){if(typeof(e)=='object')return(e);if(document.getElementById)return(document.getElementById(e));return(eval(e))}

var map;
var zoomvalue;
var j1 = 0;
var toolID = 1;
var codeID = 1;
var shapeID = 1;
var polyShape;
var holeShape = new Array();
//var hn = 0; // hole number in one and same polygon
var ph = 0; // total number of holes on map
var normalMode = true;
var polygonMode = false;
var markerMode = false;
var circlemode = false;
var rectanglemode = false;
var holemode = false;
var option1mode = false;
var option2mode = false;
//var headfoot = true;
var mylistener;
var editlistener;
var pathlistener;
var droppolypointlistener;
var holelistener = new Array();
var editing = false;
var holeediting = false;
var notext = false;
var polygonDepth = "0.0";
var polyPoints = new Array();
var holePoints = new Array();
var holesarray = new Array();
var encpoints = new Array();
var encarray = new Array();
var holecoords = new Array();
var holebuilding;
var tinymarker;
var geocoder = null;

var mousemovepoint;
var editingstyles = 0;
var header = "";
//var lineColor2 = "#000000"; // black line
var cur = 0;
var plmcur = 0;
var polygonstyles = new Array();
var polylinestyles = new Array();
var placemarks = new Array();
var polygonholes = new Array();
var centerMarker = null;
var radiusMarker = null;
var markerissaved = true;
var lookatsaved = false;

var tinyIcon = new GIcon();
tinyIcon.image = "icons/marker_20_red.png";
//tinyIcon.shadow = "http://labs.google.com/ridefinder/images/mm_20_shadow.png";
tinyIcon.iconSize = new GSize(12,20);
tinyIcon.shadowSize = new GSize(22,20);
tinyIcon.iconAnchor = new GPoint(6,20);
tinyIcon.infoWindowAnchor = new GPoint(5,1);
// Set up our GMarkerOptions object literal
var markerOptions = {icon:tinyIcon};

var pathpoint = [];
//var gmarkers = [];
var state = 0;
var num = 0;
var gdir = new GDirections(null,null);

var holeguide = 'Create polygon with one or more holes.\n' +
'Draw a closed shape in Polyline draw mode first, if you have not done that already.' +
'Then click "Draw hole".\n' +
'When finished, choose Polygon draw mode.';
var circleguide = "Ready for circle\n" +
            "Use Polygon mode to draw a filled circle\n" +
            "Click the map where you want the center of the circle to be\n" +
            "Click at radius distance\n" +
            "and the circle is drawn";
var rectangleguide = "Ready for rectangle\n" +
            "Use Polygon mode to draw a filled rectangle\n" +
            "Click where you want the upper right corner placed";
var presentationguide = 'Click the "Document, Placemark" button to edit "name" and "description" elements.\n' +
'Click on the map. Create marker, polyline, polygon freehand or circle-shaped or rectangle. ' +
'You may change draw mode at any time while drawing polyline and polygon. ' +
'Use the Close Polyshape button to let start and end meet (not needed if you draw circle or rectangle).\n' +
'Choose Draw mode: Combinations to draw paths, routes, directions with markers.\n' +
'The "Edit lines" button is a toggle button - click to start editing, and click to stop editing.\n' +
'To draw more than one shape: When finished with a shape, click "Next shape". No need to copy and save first. The "KML" button will give you all the KML code you have created.\n' +
'A finished shape on the map may be edited. Click on it. If you ' +
'inspect or edit finished markers, always click on "Next shape" before ' +
'you click on next marker, else infoWindow content will not swap.\n' +
'To draw polygon with hole(-s): Click "Holes" and follow the instructions.' +
'If you draw outer shape counterclockwise, draw inner shape clockwise and viceversa, else it will not work in all browsers.\n' +
'Uncheck "Live code presentation" for greater speed when you draw shapes with large amount of points.\n' +
'Check it when you want to see the code.';
var pathguide = "Click on map to place a marker. Click again for next marker and so on. " +
    "A line is drawn each time you add a marker.\n" +
    "You may change style for the line with 'Style options'. Click 'Edit lines' if you want to edit the line.\n" +
    "Complete code is only available for KML and is presented in the text area.\n" +
    "Text for the markers infowindows may be added when you are finished drawing.\n" +
    "Click 'Next shape' to finish the drawing.\n" +
    "Then click on the marker you want to give 'name' and 'description'.\n" +
    "Then click on 'Document, Placemark' and enter your content.\n" +
    "Then click 'Next shape' and go on with other markers.\n" +
    "Always click 'Next shape' before you click on a marker.\n" +
    "No harm is done if you click too much on 'Next shape'.\n" +
    "A 'tinymarker' always indicates an active shape. 'KML' always shows complete code.";

var docuname = "KML file with polygon for bird species range";
var docudesc = "Source various books and websites";

function polystyle() {
    this.name = "rangecolour";
    this.kmlcolor = "660000FF";
    this.kmlfill = "660000FF";
    this.color = "#FF0000";
    this.fill = "#FF0000";
    this.width = 1;
    this.lineopac = .6;
    this.fillopac = .4;
    this.fillonoff = 1;
    this.lineonoff = 1;
}
function linestyle() {
    this.name = "linecolour";
    this.kmlcolor = "660000FF";
    this.color = "#FF0000";
    this.width = 3;
    this.lineopac = 0.6;
}
function placemarkobject() {
    this.name = "distribution/range";
    this.desc = "";
    this.polygonstyle = "rangecolour";
    this.linestyle = "linecolour";
    this.curstyle = 0;
    this.tess = 1;
    this.alt = "clampToGround";
    this.plmtext = "";
    this.jstext = "";
    this.toolID = 1;
    this.hole = 0;
    this.ID = 0;
}
function holeobject() {
    this.points = "";
    this.plm = 0;
}
function createholeobject() {
    var newhole = new holeobject();
    polygonholes.push(newhole);
}
function createstyleobjects() {
    var polygonstyle = new polystyle();
    polygonstyles.push(polygonstyle);
    var polylinestyle = new linestyle();
    polylinestyles.push(polylinestyle);
}
function createplacemarkobject() {
    var thisplacemark = new placemarkobject();
    placemarks.push(thisplacemark);
}
function load() {
    if(GBrowserIsCompatible()) {
        map = new GMap2(document.getElementById("map"), {draggableCursor:'default',draggingCursor:'pointer'});
        map.setCenter(new GLatLng(45.0,7.0),3);

        var copyOSM = new GCopyrightCollection("OSM map data @<a target=\"_blank\" href=\"http://www.openstreetmap.org/\"> OpenStreetMap</a>-contributors,<a target=\"_blank\" href=\"http://creativecommons.org/licenses/by-sa/2.0/legalcode\"> CC BY-SA</a>");
        copyOSM.addCopyright(new GCopyright(1, new GLatLngBounds(new GLatLng(-90,-180), new GLatLng(90,180)), 0, " "));
        var tilesMapnik = new GTileLayer(copyOSM, 1, 17, {tileUrlTemplate: 'http://tile.openstreetmap.org/{Z}/{X}/{Y}.png'});
        var mapMapnik = new GMapType([tilesMapnik], G_NORMAL_MAP.getProjection(), "OSM");
        map.addMapType(mapMapnik);

        /*var customUI = map.getDefaultUI();
        customUI.controls.maptypecontrol = false;
        customUI.controls.menumaptypecontrol = true;
        map.setUI(customUI);*/
        map.setUIToDefault();
        mylistener = GEvent.addListener(map,'click',mapClick);
        geocoder = new GClientGeocoder();
        GEvent.addListener(map,"mousemove",function(point){
            mousemovepoint = point;
            var LnglatStr6 = point.lng().toFixed(6) + ', ' + point.lat().toFixed(6);
            var latLngStr6 = point.lat().toFixed(6) + ', ' + point.lng().toFixed(6);
            gob("over").options[0].text = LnglatStr6;
            gob("over").options[1].text = latLngStr6;
            });
        GEvent.addListener(map,"zoomend",mapzoom);
        createstyleobjects();
        createplacemarkobject();
        createholeobject();
    }
}

// mapClick - Handles the event of a user clicking anywhere on the map. activated by listener
// Adds a new point to the map and draws either a new line from the last point
// or a new polygon section depending on the drawing mode.
// A click on a shape reactivates it.
function mapClick(section, clickedPoint){
    if(editing === true) stopediting();
    // a drawn shape has been clicked, get ready to reactivate it
    if(polyPoints.length === 0 && section !== null) {
        // polylines and polygons will give error message for .getTitle
        // markers will give error message for .getVertex
        // solution is to use try...catch
        try {
            var idforclickedsection = section.getTitle(); // markers have been saved with this as an ID
        }catch(err){
            idforclickedsection = section.getVertex(0).lng().toFixed(3); // polylines and polygons have been saved with this as an ID
        }
        if(idforclickedsection) {
            newlook(idforclickedsection, section); // find this shape in the saved placemarks array and print its saved information in text area
        }
    }else{ // a click on a free space on the map
        if(polygonMode){
            pushpoint(mousemovepoint); // do not remember why not clicked point, maybe a Firefox problem?
        }else{
            if(markerMode) {
                createmarker(clickedPoint);
                logCoordinates();
            }else{
                if(section === null) pushpoint(clickedPoint);
            }
        }
    }
}

function createmarker(point) {
    if(polyPoints.length > 0) {
        polyPoints = [];
        if(polyShape) map.removeOverlay(polyShape);
        if(holeShape.length > 0) {
            for(var i = 0; i < holeShape.length; i++) {
                map.removeOverlay(holeShape[i]);
            }
        }
        if(tinymarker) map.removeOverlay(tinymarker);
    }
    polyPoints[0] = point;
    placemarks[plmcur].ID = polyPoints[0];
    var realmarker = new GMarker(point, {title:placemarks[plmcur].ID});
    map.addOverlay(realmarker);
    markerissaved = false;
    GEvent.removeListener(mylistener);
    GEvent.addListener(realmarker, "click", function() {
        realmarker.openInfoWindowHtml(placemarks[plmcur].name+"<br />"+placemarks[plmcur].desc);
    });
    GEvent.addListener(realmarker, "infowindowclose", function() {
        if (markerissaved === false) alert('Click "Next shape" and try again');
    });
}

function pushpoint(point){
    if(normalMode === true){
        if(holemode){
            // Push onto polypoints of existing poly, building inner boundary
            holePoints.push(point);
        }else{
            polyPoints.push(point);
        }
        drawCoordinates();
    }else{
        if(circlemode) clickforCircle(point);
        if(rectanglemode) collectrectanglepoints(point);
        if(option1mode) option1(point);
        if(option2mode) option2(point);
    }
}

function newlook(id,shape) {
    // step through saved placemark objects until the one clicked on is found
    for (var i = 0; i < placemarks.length; i++) {
        if (placemarks[i].ID == id) break;
    }
    plmcur = i;
    cur = placemarks[plmcur].curstyle;
    toolID = gob("toolchoice").value = placemarks[plmcur].toolID;
    setTool();
    // if it is a marker. remove mapclicklistener else close infoWindow could elicit a mapclick
    if(toolID == 3 || toolID == 4) {
        GEvent.removeListener(mylistener);
        polyPoints[0] = placemarks[plmcur].ID;
        tinymarker = new GMarker(polyPoints[0], markerOptions);
        map.addOverlay(tinymarker);
    }else{
        // if polyline or polygon, fill pointsarray(-s). print marker at startpoint
        var j = shape.getVertexCount(); // get the amount of points
        for (i=0; i<j; i++){
            polyPoints[i] = shape.getVertex(i); // update polyPoints array
        }
        tinymarker = new GMarker(polyPoints[0], markerOptions); // marker always at startpoint
        map.addOverlay(tinymarker);
        if (placemarks[plmcur].hole !== 0) { // if hole(-s), get holepoints
            var thesepoints = [];
            for(i=0; i<polygonholes.length; i++) {
                if(polygonholes[i].plm == placemarks[plmcur].ID) {
                    thesepoints.push(polygonholes[i].points);
                }
            }
            for(i=0; i<thesepoints.length; i++) {
                if(i == thesepoints.length-1) {
                    holePoints = thesepoints[i];
                }else{
                    holesarray.push(thesepoints[i]);
                }
            }
            thesepoints = [];
            holemode = true;
        }
    }
    polyShape = shape;
    lookatsaved = true;
    if(codeID == 1) coo.value = header + placemarks[plmcur].plmtext + '</Document>\n</kml>';
    if(codeID == 2) logCoordinates();
}
// Called from newlook, createhole, editlines, subclean, closeopt, toolchoice
function setTool(){
    if (markerMode && markerissaved === false) {
        nextshape();
    }
    if(editing === true) stopediting();
    gob('EditButton').disabled = '';
    gob('CloseButton').disabled = '';
    gob('dlpButton').disabled = '';
    gob('holesbutton').disabled = '';
    gob('shapechoice').disabled = '';
    //gob('dlpButton').value = 'Delete Last Point';
    normalMode = true;
    option1mode = false;
    option2mode = false;
    if(toolID == 1){ // Polyline
        polygonMode = false;
        markerMode = false;
        if(polyPoints.length > 1) drawCoordinates();
    }
    if(toolID == 2){ // Polygon
        polygonMode = true;
        markerMode = false;
        if(polyPoints.length > 1) drawCoordinates();
        closethis("holes");
        gob('nextshapebutton').disabled = '';
    }
    if(toolID == 3){ // Marker
        if(polyPoints.length > 1){
            clearMap();
            gob('toolchoice').value = 3;
        }
        polygonMode = false;
        markerMode = true;
        holemode = false;
        circlemode = false;
        rectanglemode = false;
        gob('EditButton').disabled = 'disabled';
        gob('CloseButton').disabled = 'disabled';
        //gob('dlpButton').value = 'Delete Marker';
        gob('dlpButton').disabled = 'disabled';
        gob('holesbutton').disabled = 'disabled';
        gob('lengthandarea').value = 'Length/Area';
        if(codeID == 3) showCode();
    }
    if(toolID == 4){ // Combinations
        if(polyPoints.length > 1){
            clearMap();
            gob('toolchoice').value = 4;
        }
        polygonMode = false;
        markerMode = false;
        showthis("moreoptions");
        gob('lengthandarea').value = 'Length/Area';
        gob('CloseButton').disabled = 'disabled';
        gob('dlpButton').disabled = 'disabled';
        gob('holesbutton').disabled = 'disabled';
        gob('shapechoice').disabled = 'disabled';
    }
    if(rectanglemode) normalMode = false;
    if(circlemode) normalMode = false;
}

function setCode(){
    if(codeID == 1 || codeID == 2){ //KML
        if(polyPoints.length > 0){
            logCoordinates();
        }else{
            if(circlemode) coo.value = circleguide;
            if(rectanglemode) coo.value = rectangleguide;
            if(circlemode === false && rectanglemode === false) coo.value = presentationguide;
        }
    }
    if(codeID == 3){ // Javascript
        if(polyPoints.length) showCode();
    }
}
// Called from closeholesdiv, subclean, shapechoice
function setShape(){
    if(shapeID == 1){ // Freehand
        circlemode = false;
        rectanglemode = false;
        coo.value = presentationguide;
    }
    if(shapeID == 2){ // Circle
        circlemode = true;
        rectanglemode = false;
        normalMode = false;
        if(!polyPoints.length) coo.value = circleguide;
    }
    if(shapeID == 3){ // Rectangle
        rectanglemode = true;
        circlemode = false;
        normalMode = false;
        if(!polyPoints.length) coo.value = rectangleguide;
        showthis("rectangle");
    }
}
function setoption1() {
    normalMode = false;
    option1mode = true;
    polylinestyles[cur].kmlcolor = "FFFF0000";
    polylinestyles[cur].color = "#0000FF";
    polylinestyles[cur].width = 4;
    polylinestyles[cur].lineopac = 1;
    closethis("moreoptions");
    coo.value = pathguide;
}
// Draw mode 'Combinations', first option, was chosen, and there has been a click on the map
function option1(point) {
    if(state === 0) { // this is the first click on the map
        pathpoint[0] = point;
        state = 1;
        num = 1;
        if(pathlistener) GEvent.removeListener(pathlistener);
        createPathMarker(point);
        pathlistener = GEvent.addListener(gdir, "load", function() {
            //Not activated on first mapclick
            var poly = gdir.getPolyline(); //the coordinates for the path between former and latest mapclick
            var polyPointsHelper = [];
            var polyPointsNextHelper = [];
            var j = poly.getVertexCount(); // get the amount of points for the pathline
            for (var i = 0; i<j; i++){
                polyPointsHelper.push(poly.getVertex(i));
            }
            if (polyPoints.length) polyPoints.pop();
            polyPoints = polyPoints.concat(polyPointsHelper);
            drawCoordinates(); //Draw the line and log it's coordinates
            markerMode = true; //Enter markerMode to log the marker data
            var a = plmcur; //Hide current plmcur
            plmcur = plmcur + num - 1; //placemarks[plmcur].toolID = 3; is logged in logCoordinates
            polyPointsNextHelper[0] = polyPoints[0]; //Hide current polyPoints[0]
            if(num == 2) { //when activated, on second mapclick, the first marker has to be registered
                polyPoints[0] = polyPointsHelper[0]; // Replace polyPoints[0]'s value with the value for the first marker
                //stylesforthisplacemark();
                logCoordinates(); // This function asks for polyPoints[0]. Writes in text area
            }
            polyPoints[0] = polyPointsHelper[polyPointsHelper.length-1]; // Replace with value for the latest added marker
            plmcur++;
            //stylesforthisplacemark();
            logCoordinates();
            polyPoints[0] = polyPointsNextHelper[0]; //Restore polyPoints[0]
            plmcur = a; //Restore plmcur
            markerMode = false;
            showKML();
        });
    }else{
        num++;
        createPathMarker(point);
        pathpoint[num-1] = point;
        directions(num-1);
    }
}
function setoption2() {
    normalMode = false;
    option2mode = true;
    num = 0;
    closethis("moreoptions");
    coo.value = pathguide;
}
function option2(point) {
    var polyPointsHelper = [];
    polyPoints.push(point);
    drawCoordinates();
    num++;
    createPathMarker(point);
    polyPointsHelper[0] = polyPoints[0]; // I have to 'lend' polyPoints[0] for use in logCoordinates
    polyPoints[0] = point;
    var a = plmcur; //Hide current plmcur
    plmcur = plmcur + num;
    markerMode = true; //Enter markerMode to save the marker data
    logCoordinates();
    polyPoints[0] = polyPointsHelper[0]; //Restore polyPoints[0]
    plmcur = a; //Restore plmcur
    markerMode = false;
    showKML();
}
function createPathMarker(point) {
    createplacemarkobject();
    var a = plmcur+num;
    placemarks[a].ID = point;
    var marker = new GMarker(point, {title:point});
    map.addOverlay(marker);
    GEvent.addListener(marker, "click", function() {
        marker.openInfoWindowHtml(placemarks[a].name+"<br />"+placemarks[a].desc);
    });
}
function directions(i) {
    var a = pathpoint[i-1].toUrlValue(6);
    var b = pathpoint[i].toUrlValue(6);
    a = "from: "+a + " to: " + b;
    gdir.load(a, {getPolyline:true}); //polyline data has to be collected in listener
}
// Holes button has been pressed
function holeshape() {
    if(holePoints.length === 0) {
        coo.value = holeguide;
        toolID = gob('toolchoice').value = 1; // polyline draw mode
        setTool();
        gob('holeok').disabled = '';
        gob('holeok').value = "Draw hole";
        showthis("holes");
    }
}
// Called from 'Draw hole' button in holes div, prepares holebuilding
function createhole() {
    if(holePoints.length === 0) {
        if(polyPoints.length > 0) {
            gob('nextshapebutton').disabled = 'disabled'; // Will be abled when polygon is chosen
            gob('holesbutton').disabled = 'disabled'; // to activate the polygon with hole
            if(polygonMode) {
                toolID = gob('toolchoice').value = 1; // polyline draw mode
                setTool();
            }
            map.removeOverlay(tinymarker);
            holemode = true;
        }
    }
}
function nexthole() {
    if(holePoints.length > 0) {
        map.removeOverlay(tinymarker);
        GEvent.removeListener(mylistener);
        mylistener = GEvent.addListener(map,'click',mapClick);
        holesarray.push(holePoints);
        holecoords.push(holebuilding);
        gob('holeok').value = holesarray.length + ". hole saved";
        gob('holeok').disabled = 'disabled';
        holePoints = [];
        ph++;
        createholeobject();
    }
}
// Called from closebutton on holes div (opened with holeshape)
function closeholesdiv() {
    gob('nextshapebutton').disabled = '';
    gob('holesbutton').disabled = '';
    gob('holeok').disabled = '';
    gob('holeok').value = "Draw hole";
    closethis('holes');
    if(polyPoints.length === 0) setShape(); // used for guide presentation in text area
}
// First and second stop for circle
function clickforCircle(point){
    if(!centerMarker){
        centerMarker = new GMarker(point,{title:"Start"});
        map.addOverlay(centerMarker);
    }
    else if(!radiusMarker){
        radiusMarker = point;
        collectcirclepoints(); // fill the polyPoints array with all the points needed to draw a circle
        map.removeOverlay(centerMarker);
        centerMarker = null;
        radiusMarker = null;
        drawCoordinates();
    }
}
function collectcirclepoints(){
    var zoom = map.getZoom();
    var normalProj = G_NORMAL_MAP.getProjection();
  	var centerPt = normalProj.fromLatLngToPixel(centerMarker.getPoint(),zoom);
  	var radiusPt = normalProj.fromLatLngToPixel(radiusMarker,zoom);
    with (Math){
	    var radius = floor(sqrt(pow((centerPt.x-radiusPt.x),2) + pow((centerPt.y-radiusPt.y),2)));
        for (var a = 0 ; a < 361 ; a+=10 ){
        	var aRad = a*(PI/180);
        	y = centerPt.y + radius * sin(aRad)
        	x = centerPt.x + radius * cos(aRad)
        	var p = new GPoint(x,y);
            if(holemode){
        	    holePoints.push(normalProj.fromPixelToLatLng(p, zoom));
            }else{
                polyPoints.push(normalProj.fromPixelToLatLng(p, zoom));
            }
	    }
        if(holemode){
            var helper = [];
            var k = 0;
            var j = holePoints.length;
            for (var i = j-1; i>-1; i--) {
                helper[k] = holePoints[i];
                k++;
            }
            holePoints = helper;
        }
    }
}
function collectrectanglepoints(latlng){
    var lat = latlng.lat();
    var lon = latlng.lng();
    var latOffset = gob("recheight").value;
    var lonOffset = gob("recwidth").value;
    var firstPoint = new GLatLng(parseFloat(lat - latOffset),parseFloat(lon - lonOffset));
    var secondPoint = new GLatLng(parseFloat(lat + latOffset),parseFloat(lon - lonOffset));
    var thirdPoint = new GLatLng(parseFloat(lat + latOffset),parseFloat(lon + lonOffset));
    var fourthPoint = new GLatLng(parseFloat(lat - latOffset),parseFloat(lon + lonOffset));
    document.getElementById("recok").value = "Use entered values";
    if(holemode){
        holePoints.push(firstPoint);
        holePoints.push(fourthPoint);
        holePoints.push(thirdPoint);
        holePoints.push(secondPoint);
        holePoints.push(firstPoint);
    }else{
        polyPoints.push(firstPoint);
        polyPoints.push(secondPoint);
        polyPoints.push(thirdPoint);
        polyPoints.push(fourthPoint);
        polyPoints.push(firstPoint);
    }
    drawCoordinates();
}
// let start and end meet, a button has been clicked
function closePoly(){
    if(!circlemode && !rectanglemode){ // in circlemode this has been done in function collectcirclepoints
        // Push onto polypoints of existing polyline
        if(holemode){
            if(holePoints.length > 2){
                holePoints.push(holePoints[0]);
            }
        }else{
            // Push onto polypoints of existing polyline/polygon
            if(polyPoints.length > 2) polyPoints.push(polyPoints[0]);
        }
        drawCoordinates();
    }
}
function stopediting(){
    GEvent.removeListener(editlistener);
    GEvent.removeListener(droppolypointlistener);
    polyShape.disableEditing();
    editing = false;
    mylistener = GEvent.addListener(map,'click',mapClick);
    if(holeShape[0] != []){
        for(var i=0; i<holeShape.length; i++) {
            GEvent.removeListener(holelistener[i]);
            holeShape[i].disableEditing();
        }
        holeediting = false;
    }
}
// the "Edit lines" button has been pressed
function editlines(){
    if(editing === true){
        stopediting();
        //drawCoordinates();
    }else{
        if(polyPoints.length > 0){
            toolID = gob('toolchoice').value = 1; // editing is set to be possible only in polyline draw mode
            setTool();
            GEvent.removeListener(mylistener);
            polyShape.enableEditing();
            editlistener = GEvent.addListener(polyShape,'lineupdated',updateCoordinates);
            editing = true;
            droppolypointlistener = GEvent.addListener(polyShape, "click", function(latlng, index) {
                if (typeof index == "number") {
                    polyShape.deleteVertex(index);
                    updateCoordinates();
                }
            });
            if(holeShape[0] != []){
                for(var i=0; i<holeShape.length; i++) {
                    holeShape[i].enableEditing();
                    holelistener[i] = GEvent.addListener(holeShape[i],'lineupdated',updateCoordinates);
                }
                holeediting = true;
                holecoords = [];
                holesarray = [];
            }
            coo.value = "Drag a point. To remove a point, click on it. When finished editing, click the edit-button again or continue drawing.";
        }
    }
}
// when editing lines, the points arrays are updated with this function. activated by listener
function updateCoordinates(){
    polyPoints = [];
    var j = polyShape.getVertexCount(); // get the amount of points
    for (var i = 0; i<j; i++){
        polyPoints[i] = polyShape.getVertex(i); // update polyPoints array
    }
    if(holeShape.length){
        var text = "";
        var points = [];
        for(i=0; i<holeShape.length-1; i++) {
            j = holeShape[i].getVertexCount(); // get the amount of points
            for (var m = 0; m<j; m++){
                points[m] = holeShape[i].getVertex(m);
                var lat = points[m].lat();
                var longi = points[m].lng();
                text += roundVal(longi) + "," + roundVal(lat) + "," + polygonDepth + " \n";
            }
            holecoords[i] = text;
            holesarray[i] = points;
            text = "";
            points = [];
        }
        i = holeShape.length-1;
        j = holeShape[i].getVertexCount();
        for (var n=0; n<j; n++){
            holePoints[n] = holeShape[i].getVertex(n); // update holePoints array
        }
    }
    logCoordinates();
}
// draw on the map
function drawCoordinates(){
    // Recreate shapes
    if(polyPoints.length > 0){
        if(polyShape) map.removeOverlay(polyShape); //a Polygon or a Polyline
        if(holeShape.length > 0) { //holeShape is an array of holes for the polygon-with-holes-to-be
            for(var i = 0; i < holeShape.length; i++) {
                map.removeOverlay(holeShape[i]);
            }
        }
        if(tinymarker) map.removeOverlay(tinymarker);
        //if(polygonstyles[cur].lineonoff == 0) polygonstyles[cur].color = polygonstyles[cur].fill;
        if(polygonMode){ // polygon
            if(holePoints.length > 0){ // let's create a polygon with a hole, with help from PolylineEncoder.js
                encpoints = [];
                var verySmall = 0.00001;
        		var myZoomFactor = 2;
        		var myNumLevels = 18;
        		var polylineEncoder = new PolylineEncoder(myNumLevels,myZoomFactor,verySmall,true); // in PolylineEncoder.js
        		encpoints.push(polylineEncoder.dpEncode(polyPoints));
                for(i = 0; i < holesarray.length; i++) {
                    encpoints.push(polylineEncoder.dpEncode(holesarray[i]));
                }
                if(holePoints.length > 0) {
                    encpoints.push(polylineEncoder.dpEncode(holePoints));
                }
                encarray = [];
                for (i=0; i<encpoints.length; i++) {
                    encarray[i] ={
                    points: encpoints[i].encodedPoints,
                    levels: encpoints[i].encodedLevels,
                    color: polygonstyles[cur].color,
                    opacity: polygonstyles[cur].lineopac,
                    weight: polygonstyles[cur].width,
                    numLevels: 18,
                    zoomFactor: 2};
                }
                polyShape = new GPolygon.fromEncoded({
                    polylines: encarray,
                    fill: true,
                    color: polygonstyles[cur].fill,
                    opacity: polygonstyles[cur].fillopac,
                    outline: true
                });
                placemarks[plmcur].jstext = jscopy(); // save a printable version of the javascript
                placemarks[plmcur].hole = 1; // remember that this polygon has hole(-s)
                if(lookatsaved === false) {
                    createholeobject();
                    ph++;
                }
                GEvent.removeListener(mylistener);
            }else{ // normal polygon
                if(polyPoints.length == 2){ // line between the 2 first points must be drawn as Polyline for Firefox to understand
                    polyShape = new GPolyline(polyPoints,polygonstyles[cur].color,polygonstyles[cur].width,polygonstyles[cur].lineopac);
                }else{
                    polyShape = new GPolygon(polyPoints,polygonstyles[cur].color,polygonstyles[cur].width,polygonstyles[cur].lineopac,polygonstyles[cur].fill,polygonstyles[cur].fillopac);
                }
                //addshapelistener(polyShape);
            }
        }else{ // polyline
            polyShape = new GPolyline(polyPoints,polylinestyles[cur].color,polylinestyles[cur].width,polylinestyles[cur].lineopac);
            // polyline, intended to be the hole border
            if(holePoints.length > 0) {
                i = 0;
                if(holesarray.length > 0) { // re-draw already completed holes
                    for(i = 0; i < holesarray.length; i++) {
                        holeShape[i] = new GPolyline(holesarray[i],polygonstyles[cur].color,polylinestyles[cur].width,polylinestyles[cur].lineopac);
                    }
                }
                holeShape[i] = new GPolyline(holePoints,polygonstyles[cur].color,polylinestyles[cur].width,polylinestyles[cur].lineopac);
                // two properties to be remembered for the hole object
                polygonholes[ph].points = holePoints;
                polygonholes[ph].plm = polyPoints[0].lng().toFixed(3);
            }
            if(polyPoints.length > 1) {
                var length = polyShape.getLength().toFixed(2)+" meters";
                gob("lengthandarea").value = length;
            }
        }
        // the shape(-s) has been created. now add to map
        if(holePoints.length > 0){
            tinymarker = new GMarker(holePoints[0], markerOptions); // marker always at startpoint
            map.addOverlay(tinymarker);
        }else{
            tinymarker = new GMarker(polyPoints[0], markerOptions); // marker always at startpoint
            map.addOverlay(tinymarker);
        }
        // add the updated holeshape(s), drawn as polylines
        if(holePoints.length > 0 && !polygonMode) {
            for(i = 0; i < holeShape.length; i++) {
                map.addOverlay(holeShape[i]);
            }
        }
        map.addOverlay(polyShape);
        logCoordinates();
        if(polygonMode && polyPoints.length > 2) {
            var area = polyShape.getArea().toFixed(2)+"m²";
            gob("lengthandarea").value = area;
            //alert(polyShape.getArea);
        }
    }
}

// not used. an option to open infoWindow when a polygon is clicked
function addshapelistener(pol) {
    GEvent.addListener(pol, "click", function(clickedpoint) {
        map.openInfoWindowHtml(clickedpoint,placemarks[plmcur].name);
        });
}

// logCoordinates - prints out coordinates of global polyPoints (and holePoints) array
// saves placemark object properties not already saved
function logCoordinates(){
    //var j = polyPoints.length; // get the amount of points
    var i;
    var lat;
    var longi;
    var plmtext = "";    
    var coords1 = coords2 = "";
    if (notext === true) return;
    if (polyPoints.length === 0) return;
    if(codeID == 3) {
        showCode();
        return;
    }
    if(codeID == 1) {
        if(polygonMode || holemode){
            var polygonheader = '<Placemark><name>'+placemarks[plmcur].name+'</name>\n' +
            '<description>'+placemarks[plmcur].desc+'</description>\n' +
            '<styleUrl>#'+placemarks[plmcur].polygonstyle+'</styleUrl>\n' +
            '<Polygon>\n<tessellate>'+placemarks[plmcur].tess+'</tessellate><altitudeMode>'+placemarks[plmcur].alt+'</altitudeMode>\n' +
            '<outerBoundaryIs><LinearRing><coordinates>\n';
            var polygoncoordsend = "</coordinates></LinearRing></outerBoundaryIs>\n";
            var innercoordsstart = "<innerBoundaryIs><LinearRing><coordinates>\n";
            var innercoordsend = "</coordinates></LinearRing></innerBoundaryIs>\n";
            var polygonfooter = '</Polygon>\n</Placemark>\n';
        }
        if (!polygonMode && !holemode && !markerMode) {
            var lineheader = '<Placemark><name>'+placemarks[plmcur].name+'</name>\n' +
            '<description>'+placemarks[plmcur].desc+'</description>\n' +
            '<styleUrl>#'+placemarks[plmcur].linestyle+'</styleUrl>\n' +
            '<LineString>\n<tessellate>'+placemarks[plmcur].tess+'</tessellate><altitudeMode>'+placemarks[plmcur].alt+'</altitudeMode>\n<coordinates>\n';
            var linefooter = '</coordinates>\n</LineString>\n</Placemark>\n';
        }
        if (markerMode) {
            var markerheader = '<Placemark><name>'+placemarks[plmcur].name+'</name>\n' +
            '<description>'+placemarks[plmcur].desc+'</description>\n<Point>\n<coordinates>';
            var markerfooter = '</coordinates>\n</Point>\n</Placemark>\n';
        }
        header = logHeader();
        header += logStyles();
    }

    // check mode, start placemark printing and placemark saving
    if(polygonMode){ // print polygon
        placemarks[plmcur].toolID = 2;
        // print coords header
        plmtext = polygonheader;
        // loop to print coords within the outerBoundaryIs code
        // coordinates are printed with a maximum of 6 decimal places, function roundVal takes care of this
        for (i=0; i<polyPoints.length; i++){
            lat = polyPoints[i].lat();
            longi = polyPoints[i].lng();
            coords1 += roundVal(longi) + "," + roundVal(lat) + "," + polygonDepth + " \n";
            plmtext += roundVal(longi) + "," + roundVal(lat) + "," + polygonDepth + " \n";
        }
        placemarks[plmcur].ID = polyPoints[0].lng().toFixed(3); // remember this polygon
        plmtext += polygoncoordsend;
        if(holemode){
            // check if there are already one or more saved holes
            if(holecoords.length > 0){
                for(i=0; i<holecoords.length; i++){
                    plmtext += innercoordsstart;
                    plmtext += holecoords[i];
                    plmtext += innercoordsend;
                }
            }
            if(holePoints.length > 0){
                plmtext += innercoordsstart;
                // loop to print inner boundary coords
                for(i=0; i<holePoints.length; i++){
                    lat = holePoints[i].lat();
                    longi = holePoints[i].lng();
                    //coords2 += roundVal(longi) + "," + roundVal(lat) + "," + polygonDepth + " \n";
                    plmtext += roundVal(longi) + "," + roundVal(lat) + "," + polygonDepth + " \n";
                }
                plmtext += innercoordsend;
            }
        }
        plmtext += polygonfooter;
    }
    if(markerMode) {
        placemarks[plmcur].toolID = 3;
        plmtext = markerheader;
        lat = polyPoints[0].lat();
        longi = polyPoints[0].lng();
        coords1 = roundVal(longi) + "," + roundVal(lat);
        plmtext += roundVal(longi) + "," + roundVal(lat);
        plmtext += markerfooter;
    }
    if(!polygonMode && !markerMode) { // print polyline(s)
        if(holemode){ // print a polygon with hole, on the map the shapes are shown as lines, but
            // the kml will be printed as a polygon with a hole, outerBoundaryIs with coordinates
            // and innerBoundaryIs with coordinates
            plmtext = polygonheader;
            // loop to print outer boundary coords
            for (var i=0; i<polyPoints.length; i++){
                lat = polyPoints[i].lat();
                longi = polyPoints[i].lng();
                coords1 += roundVal(longi) + "," + roundVal(lat) + "," + polygonDepth + " \n";
                plmtext += roundVal(longi) + "," + roundVal(lat) + "," + polygonDepth + " \n";
            }
            plmtext += polygoncoordsend;
            if(holecoords.length > 0){
                for(i=0; i<holecoords.length; i++){
                    plmtext += innercoordsstart;
                    plmtext += holecoords[i];
                    plmtext += innercoordsend;
                }
            }
            // loop to print inner boundary coords
            if(holePoints.length > 0){
                holebuilding = "";
                plmtext += innercoordsstart;
                for (i=0; i<holePoints.length; i++){
                    lat = holePoints[i].lat();
                    longi = holePoints[i].lng();
                    coords2 += roundVal(longi) + "," + roundVal(lat) + "," + polygonDepth + " \n";
                    plmtext += roundVal(longi) + "," + roundVal(lat) + "," + polygonDepth + " \n";
                    // holebuilding will be saved to array holecoords when hole is finished. used when more than one hole
                    holebuilding += roundVal(longi) + "," + roundVal(lat) + "," + polygonDepth + " \n";
                }
                plmtext += innercoordsend;
            }
            plmtext += polygonfooter;
        }else{         
            j1++;            
            if(j1>4){
	      alert("Exceeds. Only 4 points allowed.");
            }
            else{
            // print single polyline
            placemarks[plmcur].toolID = 1;
            plmtext = lineheader;
            for (i=0; i<polyPoints.length; i++){
                lat = polyPoints[i].lat();
                longi = polyPoints[i].lng();
                coords1 += roundVal(longi) + "," + roundVal(lat) + "," + polygonDepth + " \n";
                plmtext += roundVal(longi) + "," + roundVal(lat) + "," + polygonDepth + " \n";
            }
            placemarks[plmcur].ID = polyPoints[0].lng().toFixed(3); // remember this polyline
            plmtext += linefooter;
            if(j1==4){		
		var client;
		alert("4 Geo Points Chosen");	
		alert(coords1);
		alert(zoomvalue);
		document.formmap.coordinates.value=coords1;
		document.formmap.zoomlevel.value=zoomvalue;
		document.formmap.action="geopointslogin";
		document.formmap.submit();	
		}
	    }            
        }
    }
    if(codeID == 1) coo.value = header + plmtext + '</Document>\n</kml>';
    if(codeID == 2) coo.value = coords1 + coords2;
    if(lookatsaved === false || (lookatsaved === true && editing === true)) {
        placemarks[plmcur].plmtext = plmtext;
    }
    plmtext = "";
    coords1 = coords2 = "";
}



function logHeader() {
    var top = '<?xml version="1.0" encoding="UTF-8"?>\n' +
            '<kml xmlns="http://www.opengis.net/kml/2.2">\n' +
            '<Document><name>'+docuname+'</name>\n' +
            '<description>'+docudesc+'</description>\n';
    return top;
}
function logStyles() {
    var last = "";
    var styles = "";
    //var length = polygonstyles.length;
    if (polygonstyles.length > 1) {
        for (var i=0; i<polygonstyles.length; i++) {
            if (polygonstyles[i].name != last) {
                styles += '<Style id="'+polygonstyles[i].name+'">\n' +
                '<LineStyle><color>'+polygonstyles[i].kmlcolor+'</color><width>'+polygonstyles[i].width+'</width></LineStyle>\n' +
                '<PolyStyle><color>'+polygonstyles[i].kmlfill+'</color></PolyStyle>\n' +
                '</Style>\n';
                last = polygonstyles[i].name;
            }
        }
        for (i=0; i<polygonstyles.length; i++) {
            if (polylinestyles[i].name != last) {
                styles += '<Style id="'+polylinestyles[i].name+'">\n' +
                '<LineStyle><color>'+polylinestyles[i].kmlcolor+'</color><width>'+polylinestyles[i].width+'</width></LineStyle>\n' +
                '</Style>\n';
                last = polylinestyles[i].name;
            }
        }
    }else{ // only 1 polygonstyle and 1 polylinestyle
        styles += '<Style id="'+polygonstyles[cur].name+'">\n' +
        '<LineStyle><color>'+polygonstyles[cur].kmlcolor+'</color><width>'+polygonstyles[cur].width+'</width></LineStyle>\n' +
        '<PolyStyle><color>'+polygonstyles[cur].kmlfill+'</color></PolyStyle>\n' +
        '</Style>\n' +
        '<Style id="'+polylinestyles[cur].name+'">\n' +
        '<LineStyle><color>'+polylinestyles[cur].kmlcolor+'</color><width>'+polylinestyles[cur].width+'</width></LineStyle>\n' +
        '</Style>\n';
    }
    return styles;
}
function mapzoom(){
    var mapZoom = map.getZoom();
    gob("myzoom").value = mapZoom;
    zoomvalue=mapZoom;
}
function mapcenter(){
    var mapCenter = map.getCenter();
    var latLngStr6 = mapCenter.lat().toFixed(6) + ', ' + mapCenter.lng().toFixed(6);
    gob("centerofmap").value = latLngStr6;
}
function showCodeintextarea(){
    if (notext === false){
        gob("presentcode").checked = false;
        notext = true;
    }else{
        gob("presentcode").checked = true;
        notext = false;
        if(polyPoints.length > 0){
            logCoordinates();
        }
    }
}
// make a copy of jscode for polygon with hole(-s)
function jscopy() {
    var jscode = 'var polyShape = new GPolygon.fromEncoded({\npolylines: [\n';
        for(i = 0; i < encarray.length; i++) {
            jscode += '{points: '+encpoints[i].encodedPoints+',\n'+
                         'levels: '+encpoints[i].encodedLevels+',\n'+
                         'color: '+polygonstyles[cur].color+',\n'+
                         'opacity: '+polygonstyles[cur].lineopac+',\n'+
                         'weight: '+polygonstyles[cur].width+',\n'+
                         'numLevels: 18,\n';
            if(i == encarray.length-1) {
                jscode += 'zoomFactor: 2}],\n';
            }else{
                jscode += 'zoomFactor: 2},\n';
            }
        }
        jscode += 'fill: true,\n'+
                      'color: '+polygonstyles[cur].fill+',\n'+
                      'opacity: '+polygonstyles[cur].fillopac+',\n'+
                      'outline: true\n'+
                    '});\n';
        jscode +="map.addOverlay(polyShape);";
        return jscode;
}
function showCode(){ //Javascript, not KML
    var i;
    var lat;
    var longi;
    if(placemarks[plmcur].jstext !== "") { // show code for polygon with hole
        coo.value = placemarks[plmcur].jstext;
        return;
    }
    if(polygonMode && holemode) { // show code for polygon with hole
        coo.value = jscopy();
        return;
    }
    var j = polyPoints.length;
    var k = holePoints.length;
    var pweight = polygonstyles[cur].width;
    var lweight = polylinestyles[cur].width;
    coo.value = "var points =\n[\n";
    if (markerMode) {
        if(polyPoints.length > 1) createmarker(polyPoints[0]);
        lat = polyPoints[0].lat();
        longi = polyPoints[0].lng();
        coo.value += "new GLatLng(" + roundVal(lat) + "," + roundVal(longi) + ")";
    }else{
        for(i=0; i<j; i++){
            lat = polyPoints[i].lat();
            longi = polyPoints[i].lng();
            coo.value += "new GLatLng(" + roundVal(lat) + "," + roundVal(longi) + ")";
            if(i < (j-1)) coo.value += ",\n";
        }
        if(k>0){
            coo.value += ",\n";
            pweight = 0;
            for (i=0; i<k; i++){
                lat = holePoints[i].lat();
                longi = holePoints[i].lng();
                coo.value += "new GLatLng(" + roundVal(lat) + "," + roundVal(longi) + ")";
                if(i < (k-1)) coo.value += ",\n";
            }
        }
    }
    coo.value +="\n];\n";
    if (markerMode) {
        coo.value +="var marker = new GMarker(points);\n";
        coo.value +="map.addOverlay(marker);\n";
        coo.value += 'GEvent.addListener(marker, "click", function() {\n'  +
        'marker.openInfoWindowHtml('+placemarks[plmcur].name+"<br />"+placemarks[plmcur].desc+');\n'  +
        '})';
    }else{
        if(polygonMode){
            coo.value +="var polygon = new GPolygon(points,'" + polygonstyles[cur].color + "'," + pweight + "," + polygonstyles[cur].lineopac + ",'" + polygonstyles[cur].fill + "'," + polygonstyles[cur].fillopac + ");\n";
            coo.value +="map.addOverlay(polygon);";
        }else{
            coo.value +="var polyline = new GPolyline(points,'" + polylinestyles[cur].color + "'," + lweight + "," + polylinestyles[cur].lineopac + ");\n";
            coo.value +="map.addOverlay(polyline);";
        }
        if(gob('holes').style.visibility == 'visible') coo.value += '\n\nBuilding. The code will change to new GPolygon.fromEncoded'
    }
}
function showKML() {
    if (polyPoints.length > 0 || plmcur > 0) {
        if(codeID != 1) {
            codeID = gob('codechoice').value = 1; // complete KML
            setCode();
        }
        coo.value = header;
        for (var i = 0; i < placemarks.length; i++) {
            coo.value += placemarks[i].plmtext;
        }
        coo.value += '</Document>\n</kml>';
    }
}
// not used
function popback(){
    var obj = gob("newcontent");
    obj.style.visibility = "hidden";
}
function removeshape(){
    map.removeOverlay(polyShape);
    nooverlayvariables();
}
function nextshape(){
    //button has been pressed
    if(tinymarker) map.removeOverlay(tinymarker);
    //if(!markerMode) gob('holesbutton').disabled = '';
    gob('lengthandarea').value = 'Length/Area';
    markerissaved = true;
    lookatsaved = false;
    holemode = false;
    GEvent.removeListener(mylistener);
    mylistener = GEvent.addListener(map,'click',mapClick);
    if(polyPoints.length > 0){
        if(editing === true) stopediting();
        plmcur = placemarks.length - 1;
        if(placemarks[plmcur].ID !== 0) {
            createplacemarkobject();
            plmcur = placemarks.length -1;
            stylesforthisplacemark();
        }
        cur = placemarks[plmcur].curstyle;
        nooverlayvariables();
        //removesomemodes();
        num = 0;
    }
}
function subclean(){
    nooverlayvariables();
    removesomemodes();
    toolID = gob('toolchoice').value = 1; // polyline draw mode
    setTool();
    codeID = gob('codechoice').value = 1; // complete KML
    setCode();
    shapeID = gob('shapechoice').value = 1; // freehand
    setShape();
    coo.value = presentationguide;
}
function nooverlayvariables(){
    polyShape = null;
    /*for(var i = 0; i < holesarray.length; i++) {
        holeShape[i] = [];
    }*/
    //while(holeShape.length>0) {holeShape.pop};
    holeShape = [];
    polyPoints = [];
    holePoints = [];
    holesarray = [];
    pathpoint = [];
}
function removesomemodes(){
    holemode = false;
    circlemode = false;
    rectanglemode = false;
    //normalMode = true;
    //polygonMode = false; handled in setTool
    //markerMode = false;
    //option1mode = false;
    //option2mode = false;
    //state = 0;
}
// Clear current Map
function clearMap(){
    if(editing === true) stopediting();
    if(gob("rectangle").style.visibility == "visible") {
        /*map.clearOverlays();
        nooverlayvariables();
        toolID = gob('toolchoice').value = 1; // polyline draw mode
        setTool();
        setShape();
        //coo.value = rectangleguide;
        return;*/
        gob("recok").value = "Use entered values";
        gob("recwidth").value = "20";
        gob("recheight").value = "10";
        closethis("rectangle");
    }
    if(gob("holes").style.visibility == "visible") {
        /*map.clearOverlays();
        nooverlayvariables();
        toolID = gob('toolchoice').value = 1; // polyline draw mode
        setTool();
        coo.value = holeguide;
        holemode = false;*/
        gob('nextshapebutton').disabled = '';
        gob('holesbutton').disabled = '';
        gob('holeok').disabled = '';
        gob('holeok').value = "Draw hole";
        //hn = 0;
        //ph = 0;
        //return;
        closethis("holes");
    }
    subclean();
    map.clearOverlays();
    gob('EditButton').disabled = '';
    gob('CloseButton').disabled = '';
    gob('nextshapebutton').disabled = '';
    gob('holesbutton').disabled = '';
    gob('dlpButton').value = 'Delete Last Point';
    gob('lengthandarea').value = 'Length/Area';
    lookatsaved = false;
    markerissaved = true;
    num = 0;
    state = 0;
    ph = 0;
    cur = 0;
    plmcur = 0;
    placemarks = [];
    createplacemarkobject();
    GEvent.removeListener(mylistener);
    mylistener = GEvent.addListener(map,'click',mapClick);
}
// Delete last Point
// This function removes the last point from the Polyline/Polygon and redraws
// map. It also removes a current marker.
function deleteLastPoint(){
    if(editing === true) stopediting();
    if (markerMode && markerissaved === true) {
        var j = placemarks.length;
        if (j > 1) {
            map.removeOverlay(polyShape);
            // this is how to remove one element from an array and re-index it.
            // plmcur is the key number for the element to be removed
            var newplacemarks = new Array;
            for (var i = 0; i < j; i++) {
                if (i != plmcur) {
                    newplacemarks.push(placemarks[i]);
                }
            }
            placemarks = newplacemarks;
            // j-2 is 0 when the last marker has been removed. the remaining placemark object should be
            // a created object not in use. this may be unneccessary
            if (placemarks[j-2].plmtext !== "") {
                createplacemarkobject();
            }
        }
        if(tinymarker) map.removeOverlay(tinymarker);
        markerissaved = false;
    }else{
        if(!circlemode && !rectanglemode){ // do not allow delete last point in a circle or rectangle
            if(polyPoints || holePoints){
                if(!holemode){
                    // pop last element of polyPoints array
                    polyPoints.pop();
                    drawCoordinates();
                }else{
                    // pop last element of holePoints array
                    holePoints.pop();
                    drawCoordinates();
                }
            }
        }
    }
}
function showAddress(address){
  if(geocoder){
   geocoder.getLatLng(address,
     function(point){
       if(!point){
         alert(address + " not found");
       }else{
         var mapZoom = map.getZoom();
         map.setCenter(point, mapZoom);
         // Create our "tiny" marker icon
         var tinyIcon = new GIcon();
         tinyIcon.image = "http://labs.google.com/ridefinder/images/mm_20_red.png";
         tinyIcon.shadow = "http://labs.google.com/ridefinder/images/mm_20_shadow.png";
         tinyIcon.iconSize = new GSize(12,20);
         tinyIcon.shadowSize = new GSize(22,20);
         tinyIcon.iconAnchor = new GPoint(6,20);
         tinyIcon.infoWindowAnchor = new GPoint(5,1);
         // Set up our GMarkerOptions object literal
         markerOptions = {icon:tinyIcon};
         var centerpoint = new GMarker(point, markerOptions);
         map.addOverlay(centerpoint);
       }
     }
    );
  }
}
function docudetails(){
    if (lookatsaved === false) {
        docuname = gob("doc1").value;
        docudesc = gob("doc2").value;
        placemarks[plmcur].name = gob("plm1").value;
        placemarks[plmcur].desc = gob("plm2").value;
        stylesforthisplacemark();
    }else{
        gob("plm1").value = placemarks[plmcur].name;
        gob("plm2").value = placemarks[plmcur].desc;
        gob("plm3").value = placemarks[plmcur].tess;
        gob("plm4").value = placemarks[plmcur].alt;
        gob("doc1").value = docuname;
        gob("doc2").value = docudesc;
        lookatsaved = false;
    }
    logCoordinates();
}
function savestyles() {
    var newpolystyle = new polystyle();
    var newlinestyle = new linestyle();
    newpolystyle.name = gob("st1").value;
    newpolystyle.width = gob("st3").value;
    newpolystyle.color = gob("st3a").value;
    newpolystyle.lineopac = gob("st3b").value;
    var newlinecolor = getopacityhex(newpolystyle.lineopac) + color_html2kml(""+newpolystyle.color);
    gob("st2").innerHTML = newlinecolor;
    newpolystyle.kmlcolor = newlinecolor;
    newpolystyle.fill = gob("st4a").value;
    newpolystyle.fillopac = gob("st4b").value;
    var newfill = getopacityhex(newpolystyle.fillopac) + color_html2kml(""+newpolystyle.fill);
    gob("st4").innerHTML = newfill;
    newpolystyle.kmlfill = newfill;
    newlinestyle.name = gob("st5").value;
    newlinestyle.width = gob("st7").value;
    newlinestyle.color = gob("st7a").value;
    newlinestyle.lineopac = gob("st7b").value;
    newlinecolor = getopacityhex(newlinestyle.lineopac) + color_html2kml(""+newlinestyle.color);
    gob("st6").innerHTML = newlinecolor;
    newlinestyle.kmlcolor = newlinecolor;
    if (editingstyles == 1) {
        polygonstyles.splice(cur,1,newpolystyle); // replace an existing style object with this new style object
        polylinestyles.splice(cur,1,newlinestyle); // replace an existing style object with this new style object
        editingstyles = 0;
    }else{
        polygonstyles.push(newpolystyle);
        polylinestyles.push(newlinestyle);
        cur = polygonstyles.length - 1;
    }
    gob("stylenumber").innerHTML = (cur+1)+' ';
    placemarks[plmcur].polygonstyle = newpolystyle.name;
    placemarks[plmcur].linestyle = newlinestyle.name;
    placemarks[plmcur].curstyle = cur;
    if(!markerMode) drawCoordinates();
}
function printstyles() {
    gob("st1").value = polygonstyles[cur].name;
    gob("st2").innerHTML = polygonstyles[cur].kmlcolor; // use innerHTML for span tag
    gob("st3").value = polygonstyles[cur].width;
    gob("st3a").value = polygonstyles[cur].color;
    gob("st3b").value = polygonstyles[cur].lineopac;
    gob("st4").innerHTML = polygonstyles[cur].kmlfill;
    gob("st4a").value = polygonstyles[cur].fill;
    gob("st4b").value = polygonstyles[cur].fillopac;
    gob("st5").value = polylinestyles[cur].name;
    gob("st6").innerHTML = polylinestyles[cur].kmlcolor;
    gob("st7").value = polylinestyles[cur].width;
    gob("st7a").value = polylinestyles[cur].color;
    gob("st7b").value = polylinestyles[cur].lineopac;
    gob("stylenumber").innerHTML = (cur+1)+' ';
}
function stylesforthisplacemark() {
    placemarks[plmcur].polygonstyle = polygonstyles[cur].name;
    placemarks[plmcur].linestyle = polylinestyles[cur].name;
    placemarks[plmcur].curstyle = cur;
}
function stepstyles(a) {
    if (a == -1) {
        if (cur > 0) {
            cur--;
            printstyles();
            stylesforthisplacemark();
            if (!markerMode) drawCoordinates();
        }
    }
    if (a == 1) {
        if (cur < polygonstyles.length - 1) {
            cur++;
            printstyles();
            stylesforthisplacemark();
            if (!markerMode) drawCoordinates();
        }
    }
}
function editstyles () {
    editingstyles = 1;
    savestyles();
}
function closeopt() {
    closethis("moreoptions");
    toolID = gob('toolchoice').value = 1; // polyline draw mode
    setTool();
    //coo.value = presentationguide;
}
function closethis(name){
    gob(name).style.visibility = 'hidden';
}
function showthis(name){
    gob(name).style.visibility = 'visible';
}
// the copy part may not work with all web browsers
function copyTextarea(){
    coo.focus();
    coo.select();
    copiedTxt = document.selection.createRange();
    copiedTxt.execCommand("Copy");
}
function roundVal(val){
    if(val.toString().length < 9){
        return val;
    }else{
    	var dec = 6;
    	var result = Math.round(val*Math.pow(10,dec))/Math.pow(10,dec);
    	return result;
    }
}
function color_html2kml(color){
    var newcolor ="FFFFFF";
    if(color.length == 7) newcolor = color.substring(5,7)+color.substring(3,5)+color.substring(1,3);
    return newcolor;
}
function getopacityhex(opa){
    var hexopa = "66";
    if(opa == 0) hexopa = "00";
    if(opa == .0) hexopa = "00";
    if(opa >= .1) hexopa = "1A";
    if(opa >= .2) hexopa = "33";
    if(opa >= .3) hexopa = "4D";
    if(opa >= .4) hexopa = "66";
    if(opa >= .5) hexopa = "80";
    if(opa >= .6) hexopa = "9A";
    if(opa >= .7) hexopa = "B3";
    if(opa >= .8) hexopa = "CD";
    if(opa >= .9) hexopa = "E6";
    if(opa == 1.0) hexopa = "FF";
    if(opa == 1) hexopa = "FF";
    return hexopa;
}

//]]>
</script>

</head>

<body onload="load()" onunload="GUnload()">
	<div class="content">
		<div id="top">
			<div class="topright">
			 	<a href="#"><img src="images/sitemap.png" alt="Sitemap" /></a> ^
			 	<a href="#"><img src="images/rss.png" alt="RSS" /></a>
			</div>
		</div>
		<div id="header">

			<div class="headings">
				<h1>Discovery of Anomalies </h1>
				<h2>Using XACML Authorization</h2>
			</div>
		</div>

			<div id="menu">
			  	<ul>
					<li><a href="home">Home</a></li>
					<li><a href="#">Profiles</a></li>
      				<li><a href="#">Requests</a></li>
      			</ul>
			</div>


		<div id="main">
			<div class="right">


				<div class="nav">
				<h2>Right Column</h2>
				<div class="text">
			You could use this space to display the latest news, a calendar, random photos, the choice is yours, its here if you need it.
				</div>
				
				</div>
			</div>
			<div class="left">
				<h2><a href="#">Select Your Geo Points to Proceed:</a></h2>
				
			<div class="img_left"><img src="images/img.jpg" alt="" /></div>
					
					<!-- ZOOM FORM -->
					  <div>
					  <form class="leftfloat" style="margin-right:5px" >
					  <select id="over" style="width:180px;" >
					  <option>LngLat mousemove</option>
					  <option selected="selected">LatLng mousemove</option>
					  </select>
					  Zoom level:
					  <input type="text" size="5" name="myzoom" id="myzoom" value="3" style="width:20px;" />
					  <br>
					  <input type="text" style="width:140px;" id="lengthandarea" value="Length/Area" />
					  </form>
					  <s:form method="post"  name="formmap">
					  	<s:hidden name="coordinates" value=""/>
					  	<s:hidden name="zoomlevel" value=""/>
					  </s:form>
					  </div>
					
					<!-- MAPPPPPPPPPPPPPP -->
						<div style="float:left;width:762px;height:400px;" id="map"></div>
					<!-- MAPPPPPPPPPPPPPP -->
					
			</div>

		</div>

		<div id="footer">
			<div class="info">
				&copy; 2006 Your Site<br />
				Site Design - <a href="http://www.designcreek.com">DesignCreek</a>
			</div>
		</div>
	</div>
</body>
</html>

