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
  <img src="https://github.com/user-attachments/assets/5c370ded-2e8e-478a-9c08-a2dc02f2818a" width="600"/>
</p>

### 2. Halaman Tambah Insiden
<p align="center">
  <img src="https://github.com/user-attachments/assets/cfeaadc5-8fa3-4641-9ca7-6ada2922ce39" width="600"/>
</p>

### 3. Halaman Setelah Tambah Insiden
<p align="center">
  <img src="https://github.com/user-attachments/assets/34e6f587-fb6c-4736-8e32-4b60bc496039" width="600"/>
</p>

### 4. Halaman Update Insiden
<p align="center">
  <img src="https://github.com/user-attachments/assets/30893e51-573b-43f7-b83d-b053f93d5f6f" width="600"/>
</p>

