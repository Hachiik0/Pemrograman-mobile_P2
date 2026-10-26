# Penjelasan Kode Aplikasi Catatan

Dokumen ini menjelaskan alur utama aplikasi catatan dan operasi CRUD SQLite,
terutama yang dikelola oleh `DatabaseHelper`.

## Gambaran alur aplikasi

Aplikasi dimulai dari `main()` di [`lib/main.dart`](../lib/main.dart), yang
menjalankan `MyApp` dan menampilkan `HomeScreen`. Layar utama di
[`lib/screens/home_screen.dart`](../lib/screens/home_screen.dart) memuat daftar
catatan, pencarian, serta aksi tambah, edit, dan hapus.

Data catatan direpresentasikan oleh model `Note` di
[`lib/models/note.dart`](../lib/models/note.dart). Model ini mengubah data
antara objek Dart dan bentuk `Map` yang digunakan SQLite. Akses database
dilakukan melalui `DatabaseHelper` di
[`lib/db/database_helper.dart`](../lib/db/database_helper.dart), sedangkan
formulir untuk menambah dan mengedit catatan berada di
[`lib/screens/note_form.dart`](../lib/screens/note_form.dart).

## `DatabaseHelper` dan CRUD

`DatabaseHelper` menjadi satu pintu akses database. `instance` menerapkan pola
singleton agar aplikasi menggunakan satu pengelola database. Getter `database`
membuka database saat diperlukan dan menyimpan objeknya di `_database` untuk
digunakan kembali. Database disimpan sebagai `notes.db`.

### Create — menambah catatan

Metode `insert(Note note)` mengubah objek `Note` menjadi `Map` melalui
`note.toMap()`, kemudian menyisipkannya ke tabel `notes`. Kolom `id` dibuat
otomatis oleh SQLite karena didefinisikan sebagai
`INTEGER PRIMARY KEY AUTOINCREMENT`.

Pada `NoteForm`, penyimpanan memanggil `insert` ketika formulir digunakan untuk
membuat catatan baru.

### Read — membaca catatan

Metode `getAllNotes()` mengambil semua baris dari tabel `notes`. Hasilnya
diurutkan berdasarkan `created_at` terbaru, kemudian `id` terbaru. Setiap baris
diubah menjadi objek `Note` dengan `Note.fromMap`.

Metode `searchNotes(String keyword)` juga membaca data, tetapi hanya mengambil
catatan yang judul atau isinya cocok dengan kata kunci. Parameter pencarian
dikirim menggunakan `whereArgs`, sehingga nilainya tidak digabungkan langsung
ke dalam perintah SQL.

### Update — memperbarui catatan

Metode `update(Note note)` memperbarui data catatan berdasarkan `id`. Kondisi
`where: 'id = ?'` membatasi perubahan pada catatan yang cocok, dan `whereArgs`
menyediakan nilai ID tersebut.

Pada `NoteForm`, metode ini dipanggil saat formulir menerima catatan yang sudah
ada untuk diedit.

### Delete — menghapus catatan

Metode `delete(int id)` menghapus baris dari tabel `notes` berdasarkan `id`.
Sebelum memanggilnya, layar utama meminta konfirmasi pengguna. Setelah
penghapusan berhasil, daftar catatan dimuat ulang.

### Menutup koneksi

Metode `close()` menutup koneksi database yang sedang digunakan dan
mengosongkan `_database`. Jika database dibutuhkan lagi, getter `database`
akan membukanya kembali.

## Struktur tabel dan migrasi

Database menggunakan versi **2**, yang ditetapkan pada pemanggilan
`openDatabase`. Untuk instalasi baru, `_createDB` membuat tabel `notes` dengan
struktur berikut:

| Kolom | Tipe dan aturan | Kegunaan |
| --- | --- | --- |
| `id` | `INTEGER PRIMARY KEY AUTOINCREMENT` | ID unik yang dibuat otomatis oleh SQLite |
| `title` | `TEXT NOT NULL` | Judul catatan |
| `content` | `TEXT NOT NULL` | Isi catatan |
| `created_at` | `TEXT NOT NULL` | Waktu pembuatan dalam format ISO 8601 |
| `category` | `TEXT NOT NULL` | Kategori catatan |
| `color` | `INTEGER NOT NULL` | Nilai warna catatan |

Untuk database lama, `_onUpgrade` menangani perpindahan dari versi sebelum 2
tanpa menghapus catatan yang sudah ada. Migrasi menambahkan kolom:

- `created_at` dengan nilai awal teks kosong (`''`);
- `category` dengan nilai awal `'Pribadi'`;
- `color` dengan nilai awal `4294965700`.

Setelah kolom waktu ditambahkan, catatan lama yang `created_at`-nya masih
kosong diisi dengan waktu migrasi menggunakan format ISO 8601. Nilai awal
kategori dan warna mempertahankan tampilan yang sesuai untuk catatan lama.

## Hubungan model dengan tabel

`Note.toMap()` memetakan properti model (`id`, `title`, `content`, `createdAt`,
`category`, dan `color`) ke nama kolom SQLite. Properti `createdAt` disimpan
dengan nama kolom `created_at`.

Sebaliknya, `Note.fromMap()` membentuk objek `Note` dari baris database.
Kategori dan warna memiliki nilai cadangan jika data yang dibaca tidak
menyediakan nilai tersebut. Daftar kategori beserta warna bawaannya
didefinisikan pada `Note.categoryColors`.
