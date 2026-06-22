# Task Tracker App

Aplikasi Flutter untuk tracking task. 
Dibuat menggunakan Flutter + Supabase sebagai backend.

---

## Cara Menjalankan Project

### Project Requirements
- Flutter SDK 3.44.2+
- Android Studio / VS Code
- Device atau Emulator (Android/iOS)
- Koneksi internet (untuk pertama kali load data)

### Step by Step Guide

1. **Clone repository**
```bash
   git clone https://github.com/USERNAME/REPO_NAME.git
   cd REPO_NAME
```

2. **Install dependencies**
```bash
   flutter pub get
```

3. **Jalankan aplikasi**
```bash
   flutter run
```

> Supabase URL dan anon key sudah tersedia di dalam project untuk kemudahan evaluasi.
> Untuk production, keys akan disimpan di environment variable.

---

## Arsitektur

Project ini menggunakan **Layered Architecture** dengan 3 lapisan utama:

### Penjelasan tiap lapisan

**`core/feature/`** — Berisi abstract class `TaskRepository` yang mendefinisikan kontrak:
apa saja operasi yang tersedia (getTasks, createTask, updateTaskStatus, getTasksCount, dll).
Lapisan ini tidak tahu bagaimana data diambil, hanya mendefinisikan apa yang perlu ada.

**`core/data/source/`** — Dua sumber data:
- `RemoteSource` → berkomunikasi langsung dengan Supabase (GET, POST, PATCH)
- `LocalSource` → menyimpan dan membaca cache dari device menggunakan SharedPreferences

**`core/data/repositories/`** — `TaskRepoProd` mengatur logika:
- Jika online → ambil dari Supabase, simpan ke cache
- Jika offline → baca dari cache
- Jika cache kosong dan offline → throw error

**`presenter/`** — Berisi UI dan state management:
- Setiap halaman punya folder sendiri berisi `page`, `cubit`, dan `state`
- `component/` berisi widget yang dipakai ulang di banyak tempat

## State Management

Project ini menggunakan **Cubit** dari package `flutter_bloc`.

### State yang digunakan per fitur

**Task List**
- `TaskListInitial` → state awal
- `TaskListLoading` → proses fetch data dari Supabase atau cache
- `TaskListLoaded` → data berhasil dimuat, berisi tasks, totalCount, doneCount, pendingCount, hasMore, currentPage
- `TaskListLoadingMore` → untuk load data berikutnya (infinite scroll/ pagination)
- `TaskListEmpty` → tidak ada task sama sekali
- `TaskListError` → terjadi error, tidak ada data sama sekali

**Add Task**
- `AddTaskInitial` → state awal
- `AddTaskLoading` → proses kirim data ke Supabase
- `AddTaskSuccess` → task berhasil ditambahkan
- `AddTaskError` → gagal menambahkan task

**Task Detail**
- `TaskDetailInitial` → state awal
- `TaskDetailLoading` → proses fetch detail task
- `TaskDetailLoaded` → detail berhasil dimuat
- `TaskDetailUpdating` → proses update status, tombol loading tapi data tetap tampil
- `TaskDetailError` → terjadi error saat fetch atau update

---

## Alasan Memilih Approach Ini

### Mengapa Cubit?

**Cubit** kelebihan:
- Lebih sederhana dari BLoC — tidak perlu mendefinisikan Events terpisah
- Eksplisit — setiap input user memanggil method yang jelas di Cubit
- Gampang di-test — state bisa diverifikasi langsung dengan `bloc_test`
- Scalable — jika kompleksitas bertambah, Cubit bisa di-upgrade ke BLoC tanpa ubah struktur

Cubit cocok untuk project ini karena alur datanya straightforward:
user action → async call ke repository → emit state baru.

### Mengapa Layered Architecture?

- **Separation of concerns** — setiap lapisan punya tanggung jawab yang jelas
- **Testable** — repository dan cubit bisa di-test tanpa UI dan tanpa Supabase nyata
- **Maintainable** — kalau ganti backend, cukup ganti implementasi di `source/` tanpa sentuh UI
- **Scalable** — fitur baru tinggal tambah folder di `feature/` dan `view/`

### Mengapa Supabase?

- Auto-generate REST API (GET/POST/PATCH) dari tabel yang dibuat
- Tidak perlu buat backend sendiri, fokus bisa di Flutter
- Mendukung Row Level Security untuk kebutuhan production
- Free tier cukup untuk kebutuhan technical test ini

---

## Bonus Point yang Diimplementasikan

| Fitur | Implementasi |
|---|---|
| Local caching | `SharedPreferences` menyimpan tasks dan counts (total, done, pending), expire 10 menit |
| Offline support | `connectivity_plus` cek koneksi, fallback ke cache jika offline |
| Unit test | `bloc_test` + `mocktail` untuk test Cubit tanpa koneksi Supabase |
| Widget test | Test tampilan `TaskListPage` dengan mock repository |
| Pagination | `range()` Supabase, load 10 task per halaman, infinite scroll otomatis saat scroll ke bawah |
| CI/CD | GitHub Actions — analyze + test + build APK otomatis setiap push ke main |
| Reusable widget system | `AppButton`, `AppText`, `AppSnackbar`, `StatusBadge`, `TaskCard`, `TaskFormField`, dll |

---

## Cara Demo Offline Support & Local Caching

1. Jalankan app dan tunggu task list muncul (data load dari Supabase)
2. Matikan koneksi di emulator:
```bash
   adb shell svc wifi disable
   adb shell svc data disable
```
3. Tekan `R` di terminal untuk hot restart
4. Task list tetap muncul dari cache
5. Coba tambah task → muncul error "No internet connection"
6. Nyalakan kembali koneksi:
```bash
   adb shell svc wifi enable
   adb shell svc data enable
```
7. Pull to refresh → data fresh dari Supabase
