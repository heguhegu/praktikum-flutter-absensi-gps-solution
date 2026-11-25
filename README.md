# Praktikum Pemrograman Mobile Android dengan Flutter (P08 – P13)
**Studi Kasus Berkelanjutan:** Aplikasi Absensi Kampus Berbasis GPS & Foto Bukti

Repositori ini berisi kode awal (*starter template*) untuk kegiatan praktikum Pertemuan 8 hingga Pertemuan 13. Seluruh pertemuan menggunakan **satu proyek Flutter yang sama** yang dikembangkan secara bertahap menggunakan sistem *branch* Git.

---

## 📋 Daftar Branch per Pertemuan

| Pertemuan | Topik Materi | Branch Starter (Awal Kelas) | Branch Solution (Referensi Akhir) |
| :--- | :--- | :--- | :--- |
| **Pertemuan 8** | **Location Service:** GPS, Validasi Radius, Geocoding, & Peta (`flutter_map`) | `p08-gps-starter` | `p08-gps-solution` |
| **Pertemuan 9** | **Device Feature:** Kamera Selfie (`image_picker`) & Notifikasi Lokal | `p09-camera-notif-starter` | `p09-camera-notif-solution` |
| **Pertemuan 10** | **Local Data Storage:** Profil (`SharedPreferences`) & Database SQLite (`sqflite`) | `p10-sqlite-prefs-starter` | `p10-sqlite-prefs-solution` |
| **Pertemuan 11** | **REST API & MySQL:** Backend PHP Native (XAMPP) & *Offline-First Sync* | `p11-rest-mysql-starter` | `p11-rest-mysql-solution` |
| **Pertemuan 12** | **Integrasi Firebase:** Authentication (Login/Register) & Cloud Firestore | `p12-firebase-starter` | `p12-firebase-solution` |
| **Pertemuan 13** | **Build & Debugging:** Unit Test Radius GPS, DevTools, & Build `.apk` | `p13-test-build-starter` | `p13-test-build-solution` |

---

## 🛠️ Prasyarat Perangkat Lunak

Sebelum memulai praktikum, pastikan perangkat Anda telah terpasang:
1. **Flutter SDK** (versi stabil terbaru) & **Android Studio / VS Code**.
2. **Git** terinstal di sistem operasi.
3. **XAMPP** (Apache & MySQL) — *digunakan mulai Pertemuan 11*.
4. **Node.js, Firebase CLI, & FlutterFire CLI** — *digunakan mulai Pertemuan 12*.

---

## 🚀 Panduan Alur Kerja Mahasiswa (Wajib Dibaca)

### 1. Persiapan Awal (Dilakukan Sekali pada Pertemuan 8)
1. Buat **1 repositori kosong** di akun GitHub pribadi Anda (misalnya: `praktikum-mobile-NIM`).
2. Clone repositori dosen ini ke laptop Anda:
   ```bash
   git clone https://github.com<username-dosen>/praktikum-flutter-absensi-gps.git
   cd praktikum-flutter-absensi-gps
   ```
3. Hubungkan repositori GitHub pribadi Anda sebagai remote bernama `tugas`:
   ```bash
   git remote add tugas https://github.com<username-mahasiswa>/praktikum-mobile-NIM.git
   ```

---

### 2. Memulai Praktikum Setiap Minggu (P08 – P13)
Setiap awal pertemuan, ikuti langkah berikut untuk mengambil *template* minggu berjalan:

1. **Tarik pembaruan branch dari repositori dosen:**
   ```bash
   git fetch origin
   ```
2. **Pindah ke branch starter pertemuan hari ini** (contoh untuk Pertemuan 8):
   ```bash
   git checkout p08-gps-starter
   ```
3. **Buat branch kerja pribadi Anda sendiri:**
   ```bash
   git checkout -b kerja-p08-<NIM>
   ```
4. **Unduh paket dependensi Flutter:**
   ```bash
   flutter pub get
   ```

---

### 3. Mengumpulkan Tugas Mandiri
Setelah selesai mengerjakan praktikum dan bagian `TODO` Tugas Mandiri:

1. **Simpan perubahan ke Git lokal (*commit*):**
   ```bash
   git add .
   git commit -m "Selesai tugas mandiri pertemuan 08"
   ```
2. **Kirim (*push*) branch kerja Anda ke repositori GitHub pribadi:**
   ```bash
   git push -u tugas kerja-p08-<NIM>
   ```

> **⚠️ Aturan Penting:** Selalu pastikan Anda sudah melakukan `git add .` dan `git commit` sebelum berpindah ke *branch* pertemuan berikutnya agar pekerjaan minggu sebelumnya tersimpan aman dan tidak tertimpa.

---

## ⚙️ Catatan Khusus Konfigurasi

* **Pertemuan 11 (Backend XAMPP):** Salin folder `backend_php/` yang tersedia pada *branch* Pertemuan 11 ke dalam direktori `C:\xampp\htdocs\api_absensi\`, lalu impor skema tabel ke phpMyAdmin.
* **Pertemuan 12 (Firebase):** File `lib/firebase_options.dart` dan `android/app/google-services.json` sengaja tidak disertakan pada repositori ini. Jalankan perintah berikut menggunakan akun Firebase pribadi Anda setelah pindah ke *branch* Pertemuan 12:
  ```bash
  flutterfire configure
  ```
