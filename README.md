# Gauge R&R Flutter Client

Aplikasi mobile Flutter untuk Gauge Repeatability and Reproducibility (Attribute Agreement Analysis / AAA). Aplikasi ini berkomunikasi dengan backend Laravel REST API sebagai satu-satunya sumber kebenaran (*single source of truth*) untuk aturan bisnis, autentikasi Sanctum, otorisasi peran, integritas data, dan perhitungan metrik evaluasi.

## 1. Tech Stack

- **Framework**: Flutter 3.x (Dart 3.x)
- **HTTP Client**: Dio (terpusat di `lib/utils/request.dart`)
- **State Management**: Provider (`ChangeNotifier` terpusat di `lib/store/`)
- **Lokalisasi**: Flutter gen-l10n dengan file ARB (`id_ID` default, `en_US`, `ko_KR`)
- **Asset Generation**: FlutterGen (`flutter_gen_runner` & `build_runner`)
- **Tipografi**: Pretendard
- **Desain UI**: Hybrid Material 3 (`ThemeData` dengan custom palette) dan Cupertino (dialog konfirmasi, action sheet, segmented control inspeksi)

## 2. Struktur Proyek

```text
lib/
├── api/                   # Deklarasi request API (auth, master data, dll.)
├── components/            # Komponen UI reusable yang business-agnostic
├── constants/             # Konstanta global dan enum aplikasi
├── generated/
│   ├── assets/            # Kode asset hasil generate (FlutterGen)
│   └── localization/      # Kode lokalisasi hasil generate (gen-l10n)
├── l10n/                  # Sumber ARB (app_id.arb, app_en.arb, app_ko.arb)
├── model/                 # Typed model data (serialisasi JSON)
│   ├── auth/              # Login/register request dan sesi login
│   ├── user/              # User dan TeamSummary (UserResource)
│   ├── master_data/       # Plant, Team, PartType, Sample, SampleKeyHistory
│   ├── session/           # InspectionSession, SessionSample, Participant, Trial, Result
│   ├── report/            # GrrEvaluation, SessionEvaluation, EvaluationAgreement, ParticipantMetrics, SessionEvaluationResult
│   └── model_json.dart    # Helper parsing JSON toleran yang dipakai semua model
├── pages/                 # Halaman UI / routing
├── router/                # Konfigurasi router navigasi
├── store/                 # State management Provider
├── theme/                 # Sistem tema, palet warna, dan tipografi
├── utils/                 # Client Dio, AppConfig, storage, dan mapper error
├── bootstrap.dart
└── main.dart
```

### Batas Import

- `model/**` tidak boleh mengimpor `api/**`, `pages/**`, atau `store/**`.
- `api/**` tidak boleh mengimpor `pages/**`.
- `components/**` tidak boleh bergantung pada halaman bisnis.

## 3. Lapisan Model

Model Flutter disinkronkan dengan model Eloquent Laravel di `app/Models` dan `app/Http/Resources`:

| Model Flutter | Sumber Laravel | Identifier publik |
|---|---|---|
| `User` | `User` / `UserResource` | `id` (UUID) |
| `TeamSummary` | `UserResource.team` | `id` (integer) |
| `Plant` | `Plant` / `PlantResource` | `id` (integer) |
| `Team` | `Team` / `TeamResource` | `id` (integer) |
| `PartType` | `PartType` / `PartTypeResource` | `id` (integer) |
| `Sample` | `Sample` / `SampleResource` | `id` (integer) |
| `SampleKeyHistory` | `SampleKeyHistory` / `SampleKeyHistoryResource` | `id` (integer) |
| `InspectionSession` | `InspectionSession` | `uuid` |
| `SessionSample` | `SessionSample` | belum ditetapkan kontrak |
| `SessionParticipant` | `SessionParticipant` | belum ditetapkan kontrak |
| `InspectorTrial` | `InspectorTrial` | belum ditetapkan kontrak |
| `InspectionResult` | `InspectionResult` | belum ditetapkan kontrak |
| `GrrEvaluation` | `GrrEvaluation` | belum ditetapkan kontrak |
| `SessionEvaluation` | `SessionEvaluation` | belum ditetapkan kontrak |
| `EvaluationAgreement` | `SessionAgreementResult` | — |
| `SessionEvaluationSummary` | computed evaluation session summary | `id` (uuid) |
| `SessionEvaluationResult` | `SessionMetricsResource` | — |

Aturan yang dijaga oleh lapisan model:

- Nilai enum dari backend yang tidak dikenal tidak pernah membuat aplikasi crash; nilainya dipetakan ke `null` (status "tidak diketahui").
- Metrik desimal (`decimal:2` di Laravel) diterima sebagai string maupun angka, lalu di-parse menjadi `double?`. `null` berarti "tidak tersedia".
- `Verdict` tetap `good`/`defect`; label terjemahan hanya untuk tampilan.
- ID internal (bigint) pada model sesi/evaluasi disimpan sebagai field nullable dan tidak pernah dipakai sebagai identifier publik.
- Serialisasi JSON model sesi mengikuti nama kolom Laravel karena endpoint sesi belum ada di kontrak; lihat batasan di bagian 6.

## 4. Konfigurasi Lingkungan

Konfigurasi runtime diinjeksi saat build menggunakan `--dart-define` melalui `AppConfig`:

| Key | Default | Deskripsi |
|---|---|---|
| `API_BASE_URL` | `http://10.0.2.2:8000/api/v1` | URL basis API Laravel (termasuk prefix `/api/v1`) |
| `ENABLE_NETWORK_LOGS` | `false` (aktif di debug) | Mengaktifkan logging ringkas request Dio |

Contoh build dengan URL kustom:
```bash
flutter build apk --dart-define=API_BASE_URL=https://api.domain-anda.com/api/v1
```

Catatan Android:

- Izin `INTERNET` sudah dideklarasikan di manifest utama.
- HTTP cleartext hanya diizinkan pada build `debug` dan `profile` agar dapat terhubung ke backend lokal. Build `release` tetap memblokir cleartext; gunakan HTTPS untuk rilis.

## 5. Integrasi API

Semua request melewati satu instance Dio di `lib/utils/request.dart`:

- Base URL, timeout, header JSON, dan penanganan error dikonfigurasi terpusat.
- Token Sanctum dilampirkan melalui interceptor; token tidak pernah dicatat atau ditampilkan.
- Error dipetakan berdasarkan field `code`, bukan `message`.

### Endpoint yang tersedia

| Method | Path | Keterangan |
|---|---|---|
| `POST` | `/login` | Login dengan `employee_code` dan password |
| `POST` | `/register` | Registrasi akun inspector (selalu `pending`) |
| `GET` | `/user` | Profil pengguna saat ini |
| `POST` | `/logout` | Mencabut token aktif |
| `POST` | `/password` | Mengubah password |
| `GET` | `/sessions/{session}/evaluation` | Menghitung dan mengembalikan evaluasi atribusi (Admin, Manager) |

### Kode error yang ditangani

| `code` | Perilaku klien |
|---|---|
| `unauthenticated` | Hapus sesi dan kembali ke login |
| `invalid_credentials` | Tampilkan pesan kredensial salah |
| `account_pending` | Tampilkan status menunggu persetujuan |
| `account_inactive` | Tampilkan status akun nonaktif |
| `password_change_required` | Arahkan ke alur ubah password |
| `forbidden` | Tampilkan pesan akses ditolak |
| `not_found` | Tampilkan pesan data tidak ditemukan |
| `method_not_allowed` | Tampilkan pesan tidak didukung |
| `validation_failed` | Tampilkan error per field dari `errors` |
| `too_many_requests` | Minta pengguna menunggu |
| `http_error` | Tampilkan pesan error tak terduga |

### Batasan kontrak saat ini

`docs/api-contract.md` (revisi 13) sudah mendefinisikan endpoint sesi dan evaluasi. Sesi inspeksi, session sample, participant, result, dan evaluation kini ada di kontrak, tetapi bagian berikut masih belum dipublikasikan oleh backend:

- Metrik AAA dan kriteria judgement.
- Report dan export.
- Identifier publik untuk session sample.

Evaluasi sesi kini menampilkan `agreement.between_agreement` dan `agreement.all_vs_standard` (string desimal atau `null`) bersama konteks `participants_compared`, `compared_samples` dan `excluded_samples`, serta metrik bagi-partisipan (`effectiveness`, `miss_rate`, `false_alarm_rate`) dan hitungan mentah (`decisions`, `correct_decisions`, `defect_decisions`, `good_decisions`, `missed_defects`, `false_alarms`, `timed_out_samples`). Flutter tidak pernah menghitung nilai ini; backend tetap satu-satunya sumber perhitungan. Perubahan kontrak harus disertai pembaruan salinan di `docs/api-contract.md` dan model/tes terkait.

## 6. Autentikasi

- Login memakai `employee_code` dan password.
- Registrasi mandiri selalu membuat akun `inspector` berstatus `pending`; role tidak pernah dikirim dari klien.
- Selama `must_change_password` aktif, hanya alur ubah password, profil, dan logout yang diizinkan.
- Sesi disimpan melalui storage aman; password tidak pernah disimpan.
- Peran `admin`, `manager`, dan `inspector` hanya memengaruhi tampilan. Otorisasi tetap ditentukan Laravel Policy; aplikasi menangani `401` dan `403` dengan benar.

## 7. Lokalisasi

- Bahasa: `id_ID` (default), `en_US`, dan `ko_KR`.
- Preferensi bahasa disimpan dan dipulihkan saat startup. Bahasa Indonesia dipakai bila belum ada preferensi; locale perangkat tidak menimpa preferensi eksplisit.
- Semua teks antarmuka berasal dari ARB. Nama field API, nilai enum, status, verdict, UUID, dan `code` error tidak pernah diterjemahkan.
- Format tanggal, angka, dan persentase mengikuti locale tanpa mengubah nilai dasarnya.

## 8. Perintah Pengembangan

### Instalasi Dependensi
```bash
flutter pub get
```

### Generasi Kode Asset (FlutterGen)
Jalankan setelah menambah atau memperbarui asset di `pubspec.yaml`:
```bash
dart run build_runner build
```

### Generasi Kode Lokalisasi (l10n)
Jalankan setelah memperbarui file ARB di `lib/l10n/`:
```bash
flutter gen-l10n
```

### Analisis Kode dan Format
```bash
flutter analyze
dart format .
```

### Menjalankan Pengujian
```bash
flutter test
```

### Build APK / App Bundle
```bash
flutter build apk
flutter build appbundle
```

## 9. Sumber Kontrak API & Pedoman

- **API Contract**: [docs/api-contract.md](docs/api-contract.md)
- **Pedoman Pengembang**: [AGENTS.md](AGENTS.md)
