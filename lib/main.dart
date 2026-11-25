import 'package:flutter/material.dart';
import 'screens/home_attendance_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AbsensiGpsApp());
}

class AbsensiGpsApp extends StatelessWidget {
  const AbsensiGpsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absensi Kampus GPS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeAttendanceScreen(),
    );
  }
}
