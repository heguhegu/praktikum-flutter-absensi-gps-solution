import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  /// TODO 1: Memastikan layanan GPS aktif dan izin lokasi diberikan oleh pengguna
  Future<void> ensurePermission() async {
    // 1. Cek apakah GPS perangkat aktif (Geolocator.isLocationServiceEnabled)
    // 2. Cek status izin saat ini (Geolocator.checkPermission)
    // 3. Jika denied, minta izin (Geolocator.requestPermission)
    // 4. Jika deniedForever, lempar Exception dengan pesan yang jelas
    throw UnimplementedError('TODO 1: Implementasikan pengecekan izin GPS');
  }

  /// TODO 2: Mengambil titik koordinat (latitude & longitude) pengguna saat ini
  Future<Position> getCurrentPosition() async {
    await ensurePermission();
    // Gunakan Geolocator.getCurrentPosition dengan LocationAccuracy.high
    throw UnimplementedError('TODO 2: Implementasikan getCurrentPosition()');
  }

  /// TODO 3 (Tugas Mandiri): Memantau pergerakan pengguna secara real-time
  Stream<Position> getPositionStream() {
    // Gunakan Geolocator.getPositionStream dengan distanceFilter: 5
    throw UnimplementedError('TODO 3: Implementasikan getPositionStream()');
  }

  /// TODO 4: Mengubah koordinat menjadi alamat jalan fisik (Reverse Geocoding)
  Future<String> getAddressFromCoordinates(double lat, double lng) async {
    // Gunakan placemarkFromCoordinates(lat, lng) dari paket geocoding
    return 'Alamat belum diimplementasikan';
  }

  /// TODO 5: Menghitung jarak dalam meter antara dua titik koordinat
  double calculateDistanceInMeters(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    // Gunakan Geolocator.distanceBetween(...)
    return 0.0;
  }
}
