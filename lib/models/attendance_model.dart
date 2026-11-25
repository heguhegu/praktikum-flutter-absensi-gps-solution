class AttendanceModel {
  final int? id;
  final String studentName;
  final String nim;
  final String timestamp;
  final double latitude;
  final double longitude;
  final double distanceMeters;
  final String address;
  final String imagePath; // Digunakan pada Pertemuan 9 (Kamera)
  final int isSynced;     // Digunakan pada Pertemuan 11 (Offline-First Sync)

  AttendanceModel({
    this.id,
    required this.studentName,
    required this.nim,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    required this.address,
    this.imagePath = '',
    this.isSynced = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_name': studentName,
      'nim': nim,
      'timestamp': timestamp,
      'latitude': latitude,
      'longitude': longitude,
      'distance_meters': distanceMeters,
      'address': address,
      'image_path': imagePath,
      'is_synced': isSynced,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id']?.toString() ?? ''),
      studentName: map['student_name'] ?? 'Mahasiswa',
      nim: map['nim'] ?? '-',
      timestamp: map['timestamp'] ?? '',
      latitude: double.tryParse(map['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(map['longitude'].toString()) ?? 0.0,
      distanceMeters: double.tryParse(map['distance_meters'].toString()) ?? 0.0,
      address: map['address'] ?? '-',
      imagePath: map['image_path'] ?? '',
      isSynced: int.tryParse(map['is_synced']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final data = toMap();
    data.remove('id');
    data.remove('is_synced');
    return data;
  }
}
