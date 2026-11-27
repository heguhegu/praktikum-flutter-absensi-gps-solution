import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../services/location_service.dart';

class HomeAttendanceScreen extends StatefulWidget {
  const HomeAttendanceScreen({super.key});

  @override
  State<HomeAttendanceScreen> createState() => _HomeAttendanceScreenState();
}

class _HomeAttendanceScreenState extends State<HomeAttendanceScreen> {
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();

  // Koordinat pusat kampus (Sesuaikan dengan kampus Anda)
  final LatLng _campusLocation = const LatLng(
    -6.273065314261358,
    106.52515806386238,
  );
  final double _maxRadiusMeters = 100.0;

  LatLng? _studentLocation;
  double? _distanceToCampus;
  String _address = 'Tekan "Cek GPS" untuk mendeteksi lokasi Anda';
  bool _isLoading = false;
  bool _isTracking = false;

  StreamSubscription<Position>? _positionSubscription;

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _updatePositionData(Position pos) async {
    final LatLng newPos = LatLng(pos.latitude, pos.longitude);
    final double dist = _locationService.calculateDistanceInMeters(
      _campusLocation.latitude,
      _campusLocation.longitude,
      pos.latitude,
      pos.longitude,
    );
    final String addr = await _locationService.getAddressFromCoordinates(
      pos.latitude,
      pos.longitude,
    );

    if (!mounted) return;
    setState(() {
      _studentLocation = newPos;
      _distanceToCampus = dist;
      _address = addr;
    });

    _mapController.move(newPos, 17.5);
  }

  Future<void> _detectLocation() async {
    setState(() => _isLoading = true);
    try {
      final Position pos = await _locationService.getCurrentPosition();
      await _updatePositionData(pos);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleLiveTracking() async {
    if (_isTracking) {
      await _positionSubscription?.cancel();
      setState(() => _isTracking = false);
      return;
    }

    try {
      await _locationService.ensurePermission();
      setState(() => _isTracking = true);

      _positionSubscription = _locationService.getPositionStream().listen(
        (Position pos) async {
          await _updatePositionData(pos);
        },
        onError: (err) {
          if (!mounted) return;
          setState(() => _isTracking = false);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error Live GPS: $err')));
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  void _handleCheckIn() {
    if (_studentLocation == null || _distanceToCampus == null) return;

    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Check-In Berhasil'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Waktu: $timeStr'),
            const SizedBox(height: 4),
            Text(
              'Jarak: ${_distanceToCampus!.toStringAsFixed(1)} meter dari kampus',
            ),
            const SizedBox(height: 4),
            Text(
              'Koordinat: ${_studentLocation!.latitude.toStringAsFixed(6)}, ${_studentLocation!.longitude.toStringAsFixed(6)}',
            ),
            const SizedBox(height: 4),
            Text('Alamat: $_address'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isWithinRadius =
        _distanceToCampus != null && _distanceToCampus! <= _maxRadiusMeters;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Absensi Kampus GPS (P08)'),
        actions: [
          IconButton(
            tooltip: _isTracking
                ? 'Matikan Live Tracking'
                : 'Aktifkan Live Tracking',
            onPressed: _toggleLiveTracking,
            icon: Icon(
              _isTracking ? Icons.gps_fixed : Icons.gps_not_fixed,
              color: _isTracking ? Colors.green : null,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Area Peta Interaktif
          Expanded(
            flex: 3,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _campusLocation,
                initialZoom: 17.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.kampus.absensi_gps_app',
                ),
                // Lingkaran batas radius kampus (100 meter)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _campusLocation,
                      radius: _maxRadiusMeters,
                      useRadiusInMeter: true,
                      color: (isWithinRadius ? Colors.green : Colors.blue)
                          .withValues(alpha: 0.2),
                      borderColor: isWithinRadius ? Colors.green : Colors.blue,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
                // Penanda Titik Kampus & Posisi Mahasiswa
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _campusLocation,
                      width: 60,
                      height: 60,
                      child: const Column(
                        children: [
                          Icon(Icons.school, color: Colors.blue, size: 32),
                          Text(
                            'Kampus',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_studentLocation != null)
                      Marker(
                        point: _studentLocation!,
                        width: 60,
                        height: 60,
                        child: Column(
                          children: [
                            Icon(
                              Icons.person_pin_circle,
                              color: isWithinRadius ? Colors.green : Colors.red,
                              size: 36,
                            ),
                            const Text(
                              'Anda',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Panel Status & Tombol Aksi
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _distanceToCampus == null
                          ? 'Jarak ke Kampus: -'
                          : 'Jarak ke Kampus: ${_distanceToCampus!.toStringAsFixed(1)} meter',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _distanceToCampus == null
                            ? Colors.black87
                            : (isWithinRadius
                                  ? Colors.green.shade700
                                  : Colors.red.shade700),
                      ),
                    ),
                    if (_isTracking)
                      const Chip(
                        label: Text('Live', style: TextStyle(fontSize: 11)),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _detectLocation,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.my_location),
                        label: Text(_isLoading ? 'Mencari...' : 'Cek GPS'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isWithinRadius ? _handleCheckIn : null,
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Check-In'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
