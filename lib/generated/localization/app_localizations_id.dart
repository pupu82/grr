// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Gauge R&R';

  @override
  String get brandSubtitle => 'Sistem inspeksi attribute Gauge R&R';

  @override
  String get actionRetry => 'Coba lagi';

  @override
  String get actionOk => 'Mengerti';

  @override
  String get loginTitle => 'Masuk';

  @override
  String get loginSubtitle => 'Gunakan kode karyawan dan kata sandi Anda.';

  @override
  String get employeeCodeLabel => 'Kode karyawan';

  @override
  String get employeeCodePlaceholder => 'Contoh: EMP-0001';

  @override
  String get employeeCodeRequired => 'Kode karyawan wajib diisi.';

  @override
  String get passwordLabel => 'Kata sandi';

  @override
  String get passwordPlaceholder => 'Masukkan kata sandi';

  @override
  String get passwordRequired => 'Kata sandi wajib diisi.';

  @override
  String get signInAction => 'Masuk';

  @override
  String get noAccountPrompt => 'Belum punya akun?';

  @override
  String get registerAction => 'Daftar';

  @override
  String get viewComponentsAction => 'Lihat komponen UI';

  @override
  String get settingsAction => 'Pengaturan';

  @override
  String get registerPageTitle => 'Daftar akun';

  @override
  String get registerHeadline => 'Buat akun inspector';

  @override
  String get registerSubtitle =>
      'Pendaftaran selalu membuat akun inspector berstatus menunggu persetujuan.';

  @override
  String get fullNameLabel => 'Nama lengkap';

  @override
  String get fullNamePlaceholder => 'Nama sesuai data perusahaan';

  @override
  String get fullNameRequired => 'Nama lengkap wajib diisi.';

  @override
  String get confirmPasswordLabel => 'Konfirmasi kata sandi';

  @override
  String get confirmPasswordPlaceholder => 'Ulangi kata sandi';

  @override
  String get passwordMismatch => 'Konfirmasi kata sandi belum sama.';

  @override
  String get submitRegistrationAction => 'Kirim pendaftaran';

  @override
  String get registrationSuccessTitle => 'Permintaan diterima';

  @override
  String get registrationSuccessMessage =>
      'Terima kasih. Bila data yang dikirim memenuhi syarat, administrator akan meninjaunya. Hubungi administrator untuk informasi lebih lanjut.';

  @override
  String get dashboardWelcome => 'Selamat datang';

  @override
  String get dashboardLogout => 'Keluar';

  @override
  String get dashboardSummaryTitle => 'Ringkasan inspeksi';

  @override
  String get dashboardSummaryBody =>
      'Metrik evaluasi, sesi inspeksi, dan laporan akan ditampilkan di sini setelah kontrak API-nya tersedia. Semua perhitungan tetap dilakukan oleh backend Laravel.';

  @override
  String get unknownUser => 'Pengguna';

  @override
  String get unknownValue => '-';

  @override
  String get roleUnknown => 'Peran belum dikenali';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleManager => 'Manager';

  @override
  String get roleInspector => 'Inspector';

  @override
  String get statusPending => 'Menunggu';

  @override
  String get statusActive => 'Aktif';

  @override
  String get statusInactive => 'Tidak aktif';

  @override
  String get verdictGood => 'Baik';

  @override
  String get verdictDefect => 'Cacat';

  @override
  String get settingsPageTitle => 'Pengaturan';

  @override
  String get settingsLanguageSection => 'Bahasa';

  @override
  String get settingsLanguageDescription => 'Pilih bahasa antarmuka aplikasi.';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English (US)';

  @override
  String get languageKorean => '한국어';

  @override
  String get componentsPageTitle => 'Komponen UI';

  @override
  String get componentsButtonsTitle => 'Tombol';

  @override
  String get componentsButtonsDescription =>
      'Penggunaan dasar, varian, status loading, dan status nonaktif.';

  @override
  String get componentsPrimaryAction => 'Aksi utama';

  @override
  String get componentsTonalVariant => 'Varian tonal';

  @override
  String get componentsOutlineVariant => 'Varian outline';

  @override
  String get componentsTextVariant => 'Varian teks';

  @override
  String get componentsLoadingIdle => 'Coba status loading';

  @override
  String get componentsLoadingBusy => 'Memproses…';

  @override
  String get componentsDisabledAction => 'Nonaktif tanpa aksi';

  @override
  String get componentsInputsTitle => 'Input teks';

  @override
  String get componentsInputsDescription =>
      'Label, helper, error, kata sandi, dan status nonaktif.';

  @override
  String get componentsHelperText =>
      'Hanya untuk contoh, tidak dikirim ke API.';

  @override
  String get componentsErrorFieldLabel => 'Input dengan error';

  @override
  String get componentsErrorFieldPlaceholder => 'Coba ketik sesuatu';

  @override
  String get componentsErrorFieldMessage =>
      'Contoh pesan validasi dari backend.';

  @override
  String get componentsPasswordFieldLabel => 'Kata sandi';

  @override
  String get componentsDisabledFieldLabel => 'Input nonaktif';

  @override
  String get componentsDisabledFieldValue => 'Tidak aktif';

  @override
  String get componentsInteractionTitle => 'Interaksi desktop dan mobile';

  @override
  String get componentsInteractionDescription =>
      'Area lipat untuk memastikan tap, klik, dan keyboard bekerja.';

  @override
  String get componentsShowDetails => 'Tampilkan detail';

  @override
  String get componentsHideDetails => 'Sembunyikan detail';

  @override
  String get componentsInteractionBody =>
      'Konten ini muncul dari state nyata, bukan animasi statis. Gunakan Tab untuk berpindah fokus dan Enter untuk mengaktifkan tombol.';

  @override
  String get errorNetwork =>
      'Tidak dapat terhubung ke server. Periksa koneksi Anda.';

  @override
  String get errorTimeout =>
      'Koneksi ke server melebihi batas waktu. Silakan coba lagi.';

  @override
  String get errorUnauthorized =>
      'Sesi Anda telah berakhir. Silakan masuk kembali.';

  @override
  String get errorForbidden => 'Anda tidak memiliki akses untuk tindakan ini.';

  @override
  String get errorValidation =>
      'Data yang dikirim belum valid. Periksa kembali isian Anda.';

  @override
  String get errorNotFound => 'Data yang diminta tidak ditemukan.';

  @override
  String get errorConflict => 'Permintaan bertentangan dengan data saat ini.';

  @override
  String get errorServer =>
      'Server sedang bermasalah. Silakan coba lagi nanti.';

  @override
  String get errorInvalidResponse =>
      'Respons server tidak dikenali. Hubungi administrator bila masalah berlanjut.';

  @override
  String get errorCancelled => 'Permintaan dibatalkan.';

  @override
  String get errorUnknown =>
      'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.';

  @override
  String get errorSessionRestoreFailed =>
      'Sesi tersimpan tidak dapat dibaca. Silakan masuk kembali.';

  @override
  String get errorSessionStorageFailed =>
      'Sesi tidak dapat disimpan di perangkat. Silakan coba lagi.';

  @override
  String get errorSessionClearFailed =>
      'Sesi lokal tidak dapat dihapus sepenuhnya. Tutup aplikasi lalu masuk kembali.';

  @override
  String get errorUnauthenticated =>
      'Sesi Anda telah berakhir. Silakan masuk kembali.';

  @override
  String get errorInvalidCredentials =>
      'Kode karyawan atau kata sandi tidak sesuai.';

  @override
  String get errorAccountPending =>
      'Akun Anda masih menunggu persetujuan administrator.';

  @override
  String get errorAccountInactive =>
      'Akun Anda tidak aktif. Hubungi administrator.';

  @override
  String get errorPasswordChangeRequired =>
      'Anda harus mengganti kata sandi sebelum melanjutkan.';

  @override
  String get errorMethodNotAllowed => 'Permintaan ini tidak didukung.';

  @override
  String get errorTooManyRequests =>
      'Terlalu banyak percobaan. Tunggu sebentar lalu coba lagi.';

  @override
  String get errorHttpError =>
      'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.';

  @override
  String get companyName => 'PT TKG TAEKWANG INDONESIA';

  @override
  String get digitalGrrSystem => 'Digital Gauge R&R System';

  @override
  String get qualityControlPlatform => 'QUALITY CONTROL PLATFORM';

  @override
  String get heroTitle => 'Measurement you can trust.';

  @override
  String get heroSubtitle =>
      'Evaluasi sistem ukur yang konsisten, akurat, dan siap diaudit.';

  @override
  String get welcomeTitle => 'Selamat datang';

  @override
  String get welcomeSubtitle => 'Masuk menggunakan akun perusahaan Anda.';

  @override
  String get rememberMe => 'Ingat saya';

  @override
  String get forgotPassword => 'Lupa kata sandi?';

  @override
  String get forgotPasswordMessage =>
      'Silakan hubungi administrator sistem perusahaan untuk mereset kata sandi akun Anda.';

  @override
  String get securityBadge => 'Akses internal terenkripsi & terproteksi';

  @override
  String get alreadyHaveAccount => 'Sudah punya akun?';

  @override
  String get registerHeroSubtitle =>
      'Bergabung dengan sistem inspeksi kualitas perusahaan.';

  @override
  String get evaluationPageTitle => 'Evaluasi sesi';

  @override
  String get evaluationAgreementTitle => 'Kesesuaian sesi';

  @override
  String get evaluationBetweenAgreement => 'Kesesuaian antar peserta';

  @override
  String get evaluationAllVsStandard => 'Kesesuaian dengan standar';

  @override
  String get evaluationComparedSamples => 'Sampel dibandingkan';

  @override
  String get evaluationExcludedSamples => 'Sampel dikecualikan';

  @override
  String get evaluationParticipantsCompared => 'Peserta dibandingkan';

  @override
  String get evaluationNotAvailable => 'Tidak tersedia';

  @override
  String get evaluationAgreementUnavailableHint =>
      'Kesesuaian membutuhkan minimal dua peserta yang menyelesaikan sesi dan minimal satu sampel yang dapat dibandingkan.';

  @override
  String get evaluationSessionToken => 'Token sesi';

  @override
  String get evaluationSessionDate => 'Tanggal sesi';

  @override
  String get evaluationSessionStatus => 'Status sesi';

  @override
  String get evaluationSamplesCount => 'Jumlah sampel';

  @override
  String get evaluationParticipantsCount => 'Jumlah peserta';

  @override
  String get evaluationParticipantsTitle => 'Metrik evaluasi peserta';

  @override
  String get evaluationParticipantName => 'Peserta';

  @override
  String get evaluationEffectiveness => 'Efektivitas';

  @override
  String get evaluationMissRate => 'Tingkat lolos';

  @override
  String get evaluationFalseAlarmRate => 'Tingkat alarm palsu';

  @override
  String get evaluationStatusHint => 'Status';

  @override
  String get statusIncomplete => 'Belum selesai';

  @override
  String get sessionStatusDraft => 'Draf';

  @override
  String get sessionStatusInProgress => 'Berlangsung';

  @override
  String get sessionStatusCompleted => 'Selesai';

  @override
  String get sessionStatusUnknown => 'Status belum dikenali';

  @override
  String get dashboardActiveSessions => 'Sesi aktif';

  @override
  String get dashboardInspectionProgress => 'Progress inspeksi';

  @override
  String get dashboardLastEffectiveness => 'Efektivitas terakhir';

  @override
  String get dashboardQuickStart => 'Mulai sesi cepat';

  @override
  String get dashboardSystemEffectiveness =>
      'Efektivitas sistem (Semua vs Standar)';

  @override
  String get dashboardJudgementDistribution => 'Distribusi penilaian';

  @override
  String get dashboardAgreementTrend => 'Tren kesesuaian';

  @override
  String get dashboardAuditAttention => 'Perlu perhatian';

  @override
  String get dashboardSystemHealth => 'Kesehatan sistem';

  @override
  String get dashboardPendingUsers => 'User menunggu';

  @override
  String get dashboardForceClose => 'Tutup paksa';

  @override
  String get judgementAcceptable => 'Dapat diterima';

  @override
  String get judgementMarginal => 'Marginal';

  @override
  String get judgementUnacceptable => 'Tidak dapat diterima';

  @override
  String get actionCancel => 'Batal';

  @override
  String get forceCloseConfirmMessage =>
      'Apakah Anda yakin ingin menutup sesi ini secara paksa? Peserta yang belum selesai akan menyimpan jawaban mereka tetapi tidak akan dievaluasi.';
}
