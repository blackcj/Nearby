Nearby
================
Nearby is an iOS application that finds the closest cafe to your current location.

SDK TARGET VERSION
---------------------------
iOS 5.0

APPLICATION AUTHOR
---------------------------
Christopher Black
Blacktop Interactive, LLC
chris [at] blacktopinteractive [dot] com

CODE OVERVIEW
---------------------------
- Application built without the interface builder, the view is contracted in SearchView.m
- This application does not use ARC
- AppDelegate kick starts the application
- SearchView is the main view containing the map, search bar and center on me button
- ViewController manages the SearchView
- MapMarker is used to store result sets from the Google Places search

INSTRUCTIONS
---------------------------
- Import application to xCode
- Add your Google Places API key to ViewController.h
- Run application using xCode

TEST CASES
---------------------------
- The application has been profiled and doesn't contain memory leaks
- Unit tests have been added for the MapMarker class

FRAMEWORKS
---------------------------
+ CoreLocation.framework
+ SenTestingKit.framework
+ MapKit.framework
+ QuartzCore.framework
+ UIKit.framework
+ Foundation.framework
+ CoreGraphics.framework

NEXT STEPS
---------------------------
- Add more unit tests
- Add a DetailView page showing more info about the selected marker
- Add type callout to narrow down results by type
- Integrate with multiple APIs (Yelp?)