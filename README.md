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
├── pages/                 # Halaman UI / routing
├── router/                # Konfigurasi router navigasi
├── store/                 # State management Provider
├── theme/                 # Sistem tema, palet warna, dan tipografi
├── utils/                 # Client Dio, AppConfig, storage, dan mapper error
├── bootstrap.dart
└── main.dart
```

## 3. Konfigurasi Lingkungan

Konfigurasi runtime diinjeksi saat build menggunakan `--dart-define` melalui `AppConfig`:

| Key | Default | Deskripsi |
|---|---|---|
| `API_BASE_URL` | `http://10.0.2.2:8000/api/v1` | URL basis API Laravel (termasuk prefix `/api/v1`) |
| `ENABLE_NETWORK_LOGS` | `false` (aktif di debug) | Mengaktifkan logging ringkas request Dio |

Contoh build dengan URL kustom:
```bash
flutter build apk --dart-define=API_BASE_URL=https://api.domain-anda.com/api/v1
```

## 4. Perintah Pengembangan

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

## 5. Sumber Kontrak API & Pedoman

- **API Contract**: [docs/api-contract.md](docs/api-contract.md)
- **Pedoman Pengembang**: [AGENTS.md](AGENTS.md)
