# Cyber Incident Log

## Deskripsi Aplikasi

Cyber Incident Log adalah aplikasi Flutter untuk mencatat insiden keamanan siber.
Pada Mini Project 2, aplikasi ini sudah terintegrasi dengan Supabase sebagai database utama.

## Fitur Aplikasi

- Create: tambah insiden ke Supabase.
- Read: menampilkan daftar insiden dari Supabase.
- Update: edit data insiden.
- Delete: hapus data insiden.
- Navigasi multi halaman:
  - Halaman list insiden
  - Halaman form tambah insiden
  - Halaman form detail/edit insiden
- Validasi input form.
- Snackbar feedback untuk aksi berhasil/gagal.
- Supabase Auth (login/register).
- Dukungan tema light/dark/system dengan pilihan.

## Widget yang Digunakan

- `MaterialApp`
- `Scaffold`
- `AppBar`
- `ListView.builder`
- `ListTile`
- `Card`
- `TextFormField`
- `DropdownButtonFormField`
- `ElevatedButton`
- `FloatingActionButton`
- `AlertDialog`
- `SnackBar`
- `ChangeNotifierProvider` / `Provider`
- `StreamBuilder`

## Struktur Folder Inti

```text
lib/
|- main.dart
|- models/
|  |- incident.dart
|- providers/
|  |- incident_provider.dart
|- services/
|  |- incident_repository.dart
|- screens/
|  |- home_screen.dart
|  |- add_incident_screen.dart
|  |- detail_incident_screen.dart
|- utils/
   |- incident_datetime_formatter.dart
```

## Setup Supabase

1. Buat file `.env` di root project (lihat contoh di `.env.example`):

```env
SUPABASE_URL=YOUR_SUPABASE_URL
SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_KEY
```

2. Jalankan SQL schema di Supabase SQL Editor:

- File SQL: `supabase/incidents_schema.sql`

3. Install dependency:

```bash
flutter pub get
```

4. Jalankan aplikasi:

```bash
flutter run
```

## Screenshot Nilai Tambah

### 1. Halaman Login
<p align="center">
  <img src="https://github.com/user-attachments/assets/f5d3c7c2-ba5e-4e34-b1b8-4390a1653378" width="600"/>
</p>

### 2. Halaman Register
<p align="center">
  <img src="https://github.com/user-attachments/assets/d7a3256b-bc9c-4c4a-8345-71d1accb9081" width="600"/>
</p>

### 3. Halaman DarkMode/mengiktui sistem
<p align="center">
  <img src="https://github.com/user-attachments/assets/83b3231d-bf1a-4a8d-9c2a-ccfdf0dfaa10" width="600"/>
</p>

### 4. Halaman LightMode
<p align="center">
  <img src="https://github.com/user-attachments/assets/551debca-815f-45ff-84ed-b7ca67e5fd59" width="600"/>
</p>
