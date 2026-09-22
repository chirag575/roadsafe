import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/gps_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  final GpsService _gpsService = GpsService();

  StreamSubscription<Position>? _positionSubscription;

  Position? _currentPosition;

  bool _loadingLocation = true;

  String _locationText = 'Getting GPS location...';

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _startGps();
  }

  Future<void> _startGps() async {
    setState(() {
      _loadingLocation = true;
      _locationText = 'Getting GPS location...';
    });

    final serviceEnabled = await _gpsService.isLocationServiceEnabled();

    if (!serviceEnabled) {
      setState(() {
        _loadingLocation = false;
        _locationText = 'Location service is OFF';
      });
      return;
    }

    final permission = await _gpsService.requestPermission();

    if (permission == LocationPermission.denied) {
      setState(() {
        _loadingLocation = false;
        _locationText = 'Location permission denied';
      });
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _loadingLocation = false;
        _locationText = 'Location permission permanently denied';
      });
      return;
    }

    try {
      await _positionSubscription?.cancel();
      final position = await _gpsService.getCurrentLocation();

      if (position == null) {
        setState(() {
          _loadingLocation = false;
          _locationText = 'Unable to get GPS location';
        });
        return;
      }

      _updateLocation(position);

      _positionSubscription = _gpsService.getPositionStream().listen(
            _updateLocation,
          );
    } catch (e) {
      setState(() {
        _loadingLocation = false;
        _locationText = 'GPS Error: $e';
      });
    }
  }

  void _updateLocation(Position position) {
    if (!mounted) return;

    setState(() {
      _currentPosition = position;
      _loadingLocation = false;

      _locationText = '${position.latitude.toStringAsFixed(6)}, '
          '${position.longitude.toStringAsFixed(6)}';
    });

    final LatLng location = LatLng(
      position.latitude,
      position.longitude,
    );

    setState(() {
      _markers.removeWhere(
        (marker) => marker.markerId.value == 'current_location',
      );

      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: location,
          infoWindow: const InfoWindow(
            title: 'Your Location',
            snippet: 'Current GPS position',
          ),
        ),
      );
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLng(location),
    );
  }

  Future<void> _refreshGps() async {
    await _startGps();
  }

  Future<void> _startNavigation() async {
    final position = _currentPosition;
    if (position == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Current GPS location is not available yet.')),
      );
      return;
    }
    final uri = Uri.parse(
      'google.navigation:q=${position.latitude},${position.longitude}&mode=d',
    );
    if (!await launchUrl(uri)) {
      final webUri = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=${position.latitude},${position.longitude}',
      );
      if (!await launchUrl(webUri, mode: LaunchMode.externalApplication) &&
          mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Unable to open Google Maps navigation.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition = _currentPosition;
    final mapLocation = currentPosition == null
      ? null
      : LatLng(currentPosition.latitude, currentPosition.longitude);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RoadSafe AI Map',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (mapLocation != null)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: mapLocation,
                zoom: 16,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              mapToolbarEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_searching, size: 56),
                    const SizedBox(height: 12),
                    Text(_locationText, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _loadingLocation ? null : _refreshGps,
                      icon: const Icon(Icons.my_location),
                      label: const Text('Use Current Location'),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            top: 15,
            left: 15,
            right: 15,
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Current Location',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _locationText,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: _loadingLocation ? null : _refreshGps,
                      icon: const Icon(
                        Icons.refresh,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 15,
            right: 15,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed:
                        _currentPosition == null ? null : _startNavigation,
                    icon: const Icon(Icons.navigation),
                    label: const Text('Start Navigation'),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        LegendItem(color: Colors.blue, text: 'You'),
                        LegendItem(color: Colors.red, text: 'High'),
                        LegendItem(color: Colors.orange, text: 'Medium'),
                        LegendItem(color: Colors.green, text: 'Low'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
