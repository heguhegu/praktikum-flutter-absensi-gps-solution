import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  final Geocoding _geocoding = Geocoding();

  /// Memastikan layanan GPS aktif dan izin lokasi diberikan
  Future<void> ensurePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Layanan GPS tidak aktif. Mohon aktifkan GPS Anda.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak oleh pengguna.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Izin lokasi ditolak permanen. Buka Pengaturan Aplikasi untuk mengizinkan.',
      );
    }
  }

  /// Mengambil titik koordinat (latitude & longitude) saat ini
  Future<Position> getCurrentPosition() async {
    await ensurePermission();
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  /// Memantau pergerakan pengguna secara real-time (Stream)
  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    );
  }

  /// Mengubah koordinat menjadi alamat fisik (Reverse Geocoding)
  Future<String> getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await _geocoding.placemarkFromCoordinates(
        lat,
        lng,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        final parts = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
        ].where((part) => part != null && part.isNotEmpty).toList();

        return parts.isNotEmpty ? parts.join(', ') : 'Alamat tidak ditemukan';
      }
      return 'Alamat tidak ditemukan';
    } catch (e) {
      return 'Gagal memuat alamat: $e';
    }
  }

  /// Menghitung jarak dalam meter antara dua titik koordinat
  double calculateDistanceInMeters(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}
