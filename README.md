# Cyber Incident Log App

## Deskripsi Aplikasi
Cyber Incident Log App adalah aplikasi mobile berbasis Flutter yang digunakan untuk mencatat insiden keamanan siber. Aplikasi ini memungkinkan pengguna untuk menambahkan, melihat, mengubah, dan menghapus data insiden keamanan.

Aplikasi ini dibuat untuk memenuhi tugas Mini Project 1 pada mata kuliah Pemograman Aplikasi Bergerak.

## Struktur Folder Inti

```text
lib/
|- main.dart
|- models/
|  |- incident.dart
|- providers/
|  |- incident_provider.dart
|- screens/
   |- home_screen.dart
   |- add_incident_screen.dart
   |- detail_incident_screen.dart
```

## Fitur Aplikasi

1. Create (Tambah Data)
   Pengguna dapat menambahkan data insiden keamanan dengan mengisi form input.

2. Read (Tampilkan Data)
   Aplikasi menampilkan daftar seluruh insiden yang telah dimasukkan.

3. Update (Edit Data)
   Pengguna dapat mengubah data insiden seperti judul, tanggal, severity, deskripsi, dan status.

4. Delete (Hapus Data)
   Pengguna dapat menghapus data insiden dari daftar.

5. Multi Page Navigation
   Aplikasi memiliki beberapa halaman:
   - Halaman Utama (Daftar Insiden)
   - Halaman Tambah Insiden
   - Halaman Detail dan Edit Insiden

## Widget yang Digunakan

- MaterialApp
- Scaffold
- AppBar
- ListView
- ListTile
- TextField
- ElevatedButton
- FloatingActionButton
- Navigator
- ChangeNotifier
- Provider

## State Management

Aplikasi ini menggunakan Provider (ChangeNotifier) untuk mengelola state data insiden.

## Cara Penggunaan Singkat

1. Buka aplikasi, lalu tekan tombol `+` untuk menambah insiden.
2. Isi form: judul, tanggal, severity, dan deskripsi.
3. Tekan `Simpan` untuk menyimpan insiden.
4. Tekan item pada daftar untuk melihat detail dan mengubah data.
5. Tekan ikon hapus pada item daftar untuk menghapus insiden.

## Cara Menjalankan Project

1. Clone repository:

```bash
git clone https://github.com/mocharezky04/mini_project_1_pab.git
cd mini_project_1_pab
```

2. Install dependencies:

```bash
flutter pub get
```

3. Jalankan aplikasi:

```bash
flutter run
```

## Screenshot Aplikasi

### 1. Halaman Utama
<p align="center">
  <img src="https://github.com/user-attachments/assets/9bfcce38-1275-4dd9-91d0-7ee2a17f4da8" width="600"/>
</p>

### 2. Halaman Tambah Insiden
<p align="center">
  <img src="https://github.com/user-attachments/assets/f6fc3cae-ada7-4f6e-bad4-939d68faed9d" width="600"/>
</p>

### 3. Halaman Setelah Tambah Insiden
<p align="center">
  <img src="https://github.com/user-attachments/assets/759386fe-71a1-4d3e-bd46-04e586bb6954" width="600"/>
</p>

### 4. Halaman Update Insiden
<p align="center">
  <img src="https://github.com/user-attachments/assets/29dbbd5f-db81-4ee7-ae51-ad1f65feecf0" width="600"/>
</p>
