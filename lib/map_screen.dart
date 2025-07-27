import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_integration/direction_repo.dart';

import 'direction_model.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(28.613939, 77.209023),
    zoom: 11.5,
  );

  late GoogleMapController _googleMapController;
  Marker? _origin;
  Marker? _destination;
  double? currentLatitude;
  double? currentLongitude;
  Direction? _info;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permissions are permanently denied, please enable in Settings',
          ),
        ),
      );
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        currentLatitude = position.latitude;
        currentLongitude = position.longitude;
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text("FindMyMap"),
        actions: [
          if (_origin != null)
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                duration: const Duration(milliseconds: 1000),
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin!.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: Text("Origin"),
            ),
          if (_destination != null)
            TextButton(
              onPressed: () => _googleMapController.animateCamera(
                duration: const Duration(milliseconds: 1000),
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destination!.position,
                    zoom: 14.5,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
                textStyle: TextStyle(fontWeight: FontWeight.w600),
              ),
              child: Text("Destination"),
            ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) {
              _googleMapController = controller;
            },
            markers: {
              if (_origin != null) _origin!,
              if (_destination != null) _destination!,
            },
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _info!.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            onLongPress: _addMarker,
          ),
          if (_info != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Text(
                  '${_info!.totalDistance}, ${_info!.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (currentLatitude == null || currentLongitude == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location not available')),
            );
            return;
          }

          CameraPosition newCameraPosition = CameraPosition(
            target: LatLng(currentLatitude!, currentLongitude!),
            zoom: 18.5,
            tilt: 50.0,
          );

          _googleMapController.animateCamera(
            duration: const Duration(milliseconds: 1500),
            CameraUpdate.newCameraPosition(newCameraPosition),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  void _addMarker(LatLng argument) async {
    try {
      if (_origin == null || (_origin != null && _destination != null)) {
        setState(() {
          _origin = Marker(
            markerId: const MarkerId('origin'),
            infoWindow: const InfoWindow(title: 'Origin'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
            position: argument,
          );
          _destination = null;
          _info = null;
        });
      } else {
        setState(() {
          _destination = Marker(
            markerId: const MarkerId('destination'),
            infoWindow: const InfoWindow(title: 'Destination'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            position: argument,
          );
        });

        final directions = await DirectionRepo().getDirection(
          origin: _origin!.position,
          destination: argument,
        );

        if (directions != null) {
          setState(() => _info = directions);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not find a route between these points'),
            ),
          );
        }
      }
    } catch (e) {
      print('Error in _addMarker: $e');
    }
  }
}
