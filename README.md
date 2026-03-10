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
