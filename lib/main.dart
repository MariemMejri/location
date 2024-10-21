import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import 'package:url_launcher/url_launcher_string.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocationExample(),
    );
  }
}

class LocationExample extends StatefulWidget {
  @override
  _LocationExampleState createState() => _LocationExampleState();
}

class _LocationExampleState extends State<LocationExample> {
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _locationData; // Change to nullable type

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return; // Location services are not enabled
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return; // Location permission denied
      }
    }

    // Get the current location
    _locationData = await location.getLocation();
    setState(() {}); // Update the UI
  }

  // Function to launch Google Maps with the current coordinates
  Future<void> _launchGoogleMaps() async {
    final latitude = _locationData?.latitude;
    final longitude = _locationData?.longitude;
    if (latitude != null && longitude != null) {
      final googleMapsUrl =
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      launchUrlString(googleMapsUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location Example')),
      body: Center(
        child: _locationData == null
            ? CircularProgressIndicator() // Show loading indicator until location is fetched
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Latitude: ${_locationData?.latitude ?? 'N/A'}',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Longitude: ${_locationData?.longitude ?? 'N/A'}',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:
                        _launchGoogleMaps, // Button to launch Google Maps
                    child: Text('Open in Google Maps'),
                  ),
                ],
              ),
      ),
    );
  }
}
