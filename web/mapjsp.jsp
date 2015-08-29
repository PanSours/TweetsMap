<%-- 
    Document   : mapjsp
    Created on : Feb 10, 2014, 6:36:33 PM
    Author     : Panagiotis
--%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" import="java.io.*, java.net.*"%>

<!DOCTYPE html>
<html>
    <head>
        <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
        <meta charset="utf-8">
        <title>Tweet Locations</title>
        <link rel="shortcut icon" href="imagebuf/marker.png" >
        <style>
            html, body, #map-canvas {
                height: 100%;
                margin: 0px;
                padding: 0px
            }
        </style>

        <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>

        <script>
            // The following example creates complex markers to indicate tweet locations
            // as they appear from the lat,long values in the "TweetsDataset.txt"
            var global_markers = [];
            var allPoints = [];
            var infowindow = new google.maps.InfoWindow({});

            function initialize() {

                geocoder = new google.maps.Geocoder();

                var mapOptions = {
                    zoom: 5,
                    center: new google.maps.LatLng(37.97234987, 23.73046875)
                };

                var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

                setMarkers(map);
            }

            function setMarkers(map) {
                // Add markers to the map
            <%
                    String jspPath = session.getServletContext().getRealPath("/");
                    String fName = jspPath + "/TweetsDataset.txt";
                    System.out.println(jspPath);
                    String thisLine;

                    FileInputStream fis = new FileInputStream(fName);
                    DataInputStream myInput = new DataInputStream(fis);
                    boolean firstLine = true;

                    while ((thisLine = myInput.readLine()) != null) {

                        if (firstLine) {
                            firstLine = false;
                            continue;
                        }

                        String strar[] = thisLine.split("\t");%>

                allPoints.push([<% out.print(strar[1]);%>, <% out.print(strar[2]);%>,<% out.print(strar[4]);%>]);

            <% }%>

                for (var i in allPoints) {

                    var strar = allPoints[i];
                    // obtain the attribues of each marker
                    var lat = parseFloat(strar[0]);
                    var lng = parseFloat(strar[1]);
                    var trailhead_name = strar[2];

                    var myLatlng = new google.maps.LatLng(lat, lng);

                    var contentString = "<html><body><div><p><h2>" + trailhead_name + "</h2></p></div></body></html>";

                    var image = new google.maps.MarkerImage('imagebuf/ticon.png',
                            new google.maps.Size(30, 30),
                            new google.maps.Point(0, 0),
                            new google.maps.Point(30, 30)
                            );

                    var marker = new google.maps.Marker({
                        position: myLatlng,
                        map: map,
                        icon: image,
                        title: "Coordinates: " + lat + " , " + lng + " | Trailhead name: " + trailhead_name});

                    marker['infowindow'] = contentString;

                    global_markers[i] = marker;

                    google.maps.event.addListener(global_markers[i], 'click', function () {

                        infowindow.setContent(this['infowindow']);
                        infowindow.open(map, this);
                    });
                }

            }

            google.maps.event.addDomListener(window, 'load', initialize);

        </script>
    </head>
    <body>
        <div id="map-canvas"></div>
    </body>
</html>

