# Catatan SQLite

Aplikasi Flutter untuk menyimpan catatan secara lokal menggunakan SQLite.

## Fitur

- Menambah, membaca, mengedit, dan menghapus catatan.
- Meminta konfirmasi sebelum menghapus catatan.
- Mencari catatan berdasarkan judul atau isi.
- Menampilkan tanggal pembuatan serta kategori dan warna catatan.
- Memutakhirkan skema database ke versi 2 tanpa menghapus catatan lama.

## Menjalankan aplikasi

Pastikan Flutter SDK dan Android SDK telah terpasang, lalu jalankan:

```bash
flutter pub get
flutter run
```

Database `notes.db` dibuat di penyimpanan aplikasi. Model catatan berada di
`lib/models/note.dart`, operasi SQLite di `lib/db/database_helper.dart`, dan
antarmuka di `lib/screens/`.

## Pemeriksaan

```bash
flutter analyze
flutter test
```
