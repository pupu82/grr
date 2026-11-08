import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
    Locale('ko'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In id, this message translates to:
  /// **'Gauge R&R'**
  String get appTitle;

  /// No description provided for @brandSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Sistem inspeksi attribute Gauge R&R'**
  String get brandSubtitle;

  /// No description provided for @actionRetry.
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get actionRetry;

  /// No description provided for @actionOk.
  ///
  /// In id, this message translates to:
  /// **'Mengerti'**
  String get actionOk;

  /// No description provided for @loginTitle.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Gunakan kode karyawan dan kata sandi Anda.'**
  String get loginSubtitle;

  /// No description provided for @employeeCodeLabel.
  ///
  /// In id, this message translates to:
  /// **'Kode karyawan'**
  String get employeeCodeLabel;

  /// No description provided for @employeeCodePlaceholder.
  ///
  /// In id, this message translates to:
  /// **'Contoh: EMP-0001'**
  String get employeeCodePlaceholder;

  /// No description provided for @employeeCodeRequired.
  ///
  /// In id, this message translates to:
  /// **'Kode karyawan wajib diisi.'**
  String get employeeCodeRequired;

  /// No description provided for @passwordLabel.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi'**
  String get passwordLabel;

  /// No description provided for @passwordPlaceholder.
  ///
  /// In id, this message translates to:
  /// **'Masukkan kata sandi'**
  String get passwordPlaceholder;

  /// No description provided for @passwordRequired.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi wajib diisi.'**
  String get passwordRequired;

  /// No description provided for @signInAction.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get signInAction;

  /// No description provided for @noAccountPrompt.
  ///
  /// In id, this message translates to:
  /// **'Belum punya akun?'**
  String get noAccountPrompt;

  /// No description provided for @registerAction.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get registerAction;

  /// No description provided for @viewComponentsAction.
  ///
  /// In id, this message translates to:
  /// **'Lihat komponen UI'**
  String get viewComponentsAction;

  /// No description provided for @settingsAction.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settingsAction;

  /// No description provided for @registerPageTitle.
  ///
  /// In id, this message translates to:
  /// **'Daftar akun'**
  String get registerPageTitle;

  /// No description provided for @registerHeadline.
  ///
  /// In id, this message translates to:
  /// **'Buat akun inspector'**
  String get registerHeadline;

  /// No description provided for @registerSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pendaftaran selalu membuat akun inspector berstatus menunggu persetujuan.'**
  String get registerSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama lengkap'**
  String get fullNameLabel;

  /// No description provided for @fullNamePlaceholder.
  ///
  /// In id, this message translates to:
  /// **'Nama sesuai data perusahaan'**
  String get fullNamePlaceholder;

  /// No description provided for @fullNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama lengkap wajib diisi.'**
  String get fullNameRequired;

  /// No description provided for @emailOptionalLabel.
  ///
  /// In id, this message translates to:
  /// **'Email (opsional)'**
  String get emailOptionalLabel;

  /// No description provided for @emailPlaceholder.
  ///
  /// In id, this message translates to:
  /// **'nama@perusahaan.com'**
  String get emailPlaceholder;

  /// No description provided for @emailInvalid.
  ///
  /// In id, this message translates to:
  /// **'Format email belum valid.'**
  String get emailInvalid;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi kata sandi'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordPlaceholder.
  ///
  /// In id, this message translates to:
  /// **'Ulangi kata sandi'**
  String get confirmPasswordPlaceholder;

  /// No description provided for @passwordMismatch.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi kata sandi belum sama.'**
  String get passwordMismatch;

  /// No description provided for @submitRegistrationAction.
  ///
  /// In id, this message translates to:
  /// **'Kirim pendaftaran'**
  String get submitRegistrationAction;

  /// No description provided for @registrationSuccessTitle.
  ///
  /// In id, this message translates to:
  /// **'Permintaan diterima'**
  String get registrationSuccessTitle;

  /// No description provided for @registrationSuccessMessage.
  ///
  /// In id, this message translates to:
  /// **'Terima kasih. Bila data yang dikirim memenuhi syarat, administrator akan meninjaunya. Hubungi administrator untuk informasi lebih lanjut.'**
  String get registrationSuccessMessage;

  /// No description provided for @dashboardWelcome.
  ///
  /// In id, this message translates to:
  /// **'Selamat datang'**
  String get dashboardWelcome;

  /// No description provided for @dashboardLogout.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get dashboardLogout;

  /// No description provided for @dashboardSummaryTitle.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan inspeksi'**
  String get dashboardSummaryTitle;

  /// No description provided for @dashboardSummaryBody.
  ///
  /// In id, this message translates to:
  /// **'Metrik evaluasi, sesi inspeksi, dan laporan akan ditampilkan di sini setelah kontrak API-nya tersedia. Semua perhitungan tetap dilakukan oleh backend Laravel.'**
  String get dashboardSummaryBody;

  /// No description provided for @unknownUser.
  ///
  /// In id, this message translates to:
  /// **'Pengguna'**
  String get unknownUser;

  /// No description provided for @unknownValue.
  ///
  /// In id, this message translates to:
  /// **'-'**
  String get unknownValue;

  /// No description provided for @roleUnknown.
  ///
  /// In id, this message translates to:
  /// **'Peran belum dikenali'**
  String get roleUnknown;

  /// No description provided for @roleAdmin.
  ///
  /// In id, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleManager.
  ///
  /// In id, this message translates to:
  /// **'Manager'**
  String get roleManager;

  /// No description provided for @roleInspector.
  ///
  /// In id, this message translates to:
  /// **'Inspector'**
  String get roleInspector;

  /// No description provided for @statusPending.
  ///
  /// In id, this message translates to:
  /// **'Menunggu'**
  String get statusPending;

  /// No description provided for @statusActive.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get statusActive;

  /// No description provided for @statusInactive.
  ///
  /// In id, this message translates to:
  /// **'Tidak aktif'**
  String get statusInactive;

  /// No description provided for @verdictGood.
  ///
  /// In id, this message translates to:
  /// **'Baik'**
  String get verdictGood;

  /// No description provided for @verdictDefect.
  ///
  /// In id, this message translates to:
  /// **'Cacat'**
  String get verdictDefect;

  /// No description provided for @settingsPageTitle.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settingsPageTitle;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get settingsLanguageSection;

  /// No description provided for @settingsLanguageDescription.
  ///
  /// In id, this message translates to:
  /// **'Pilih bahasa antarmuka aplikasi.'**
  String get settingsLanguageDescription;

  /// No description provided for @languageIndonesian.
  ///
  /// In id, this message translates to:
  /// **'Bahasa Indonesia'**
  String get languageIndonesian;

  /// No description provided for @languageEnglish.
  ///
  /// In id, this message translates to:
  /// **'English (US)'**
  String get languageEnglish;

  /// No description provided for @languageKorean.
  ///
  /// In id, this message translates to:
  /// **'한국어'**
  String get languageKorean;

  /// No description provided for @componentsPageTitle.
  ///
  /// In id, this message translates to:
  /// **'Komponen UI'**
  String get componentsPageTitle;

  /// No description provided for @componentsButtonsTitle.
  ///
  /// In id, this message translates to:
  /// **'Tombol'**
  String get componentsButtonsTitle;

  /// No description provided for @componentsButtonsDescription.
  ///
  /// In id, this message translates to:
  /// **'Penggunaan dasar, varian, status loading, dan status nonaktif.'**
  String get componentsButtonsDescription;

  /// No description provided for @componentsPrimaryAction.
  ///
  /// In id, this message translates to:
  /// **'Aksi utama'**
  String get componentsPrimaryAction;

  /// No description provided for @componentsTonalVariant.
  ///
  /// In id, this message translates to:
  /// **'Varian tonal'**
  String get componentsTonalVariant;

  /// No description provided for @componentsOutlineVariant.
  ///
  /// In id, this message translates to:
  /// **'Varian outline'**
  String get componentsOutlineVariant;

  /// No description provided for @componentsTextVariant.
  ///
  /// In id, this message translates to:
  /// **'Varian teks'**
  String get componentsTextVariant;

  /// No description provided for @componentsLoadingIdle.
  ///
  /// In id, this message translates to:
  /// **'Coba status loading'**
  String get componentsLoadingIdle;

  /// No description provided for @componentsLoadingBusy.
  ///
  /// In id, this message translates to:
  /// **'Memproses…'**
  String get componentsLoadingBusy;

  /// No description provided for @componentsDisabledAction.
  ///
  /// In id, this message translates to:
  /// **'Nonaktif tanpa aksi'**
  String get componentsDisabledAction;

  /// No description provided for @componentsInputsTitle.
  ///
  /// In id, this message translates to:
  /// **'Input teks'**
  String get componentsInputsTitle;

  /// No description provided for @componentsInputsDescription.
  ///
  /// In id, this message translates to:
  /// **'Label, helper, error, kata sandi, dan status nonaktif.'**
  String get componentsInputsDescription;

  /// No description provided for @componentsHelperText.
  ///
  /// In id, this message translates to:
  /// **'Hanya untuk contoh, tidak dikirim ke API.'**
  String get componentsHelperText;

  /// No description provided for @componentsErrorFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Input dengan error'**
  String get componentsErrorFieldLabel;

  /// No description provided for @componentsErrorFieldPlaceholder.
  ///
  /// In id, this message translates to:
  /// **'Coba ketik sesuatu'**
  String get componentsErrorFieldPlaceholder;

  /// No description provided for @componentsErrorFieldMessage.
  ///
  /// In id, this message translates to:
  /// **'Contoh pesan validasi dari backend.'**
  String get componentsErrorFieldMessage;

  /// No description provided for @componentsPasswordFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi'**
  String get componentsPasswordFieldLabel;

  /// No description provided for @componentsDisabledFieldLabel.
  ///
  /// In id, this message translates to:
  /// **'Input nonaktif'**
  String get componentsDisabledFieldLabel;

  /// No description provided for @componentsDisabledFieldValue.
  ///
  /// In id, this message translates to:
  /// **'Tidak aktif'**
  String get componentsDisabledFieldValue;

  /// No description provided for @componentsInteractionTitle.
  ///
  /// In id, this message translates to:
  /// **'Interaksi desktop dan mobile'**
  String get componentsInteractionTitle;

  /// No description provided for @componentsInteractionDescription.
  ///
  /// In id, this message translates to:
  /// **'Area lipat untuk memastikan tap, klik, dan keyboard bekerja.'**
  String get componentsInteractionDescription;

  /// No description provided for @componentsShowDetails.
  ///
  /// In id, this message translates to:
  /// **'Tampilkan detail'**
  String get componentsShowDetails;

  /// No description provided for @componentsHideDetails.
  ///
  /// In id, this message translates to:
  /// **'Sembunyikan detail'**
  String get componentsHideDetails;

  /// No description provided for @componentsInteractionBody.
  ///
  /// In id, this message translates to:
  /// **'Konten ini muncul dari state nyata, bukan animasi statis. Gunakan Tab untuk berpindah fokus dan Enter untuk mengaktifkan tombol.'**
  String get componentsInteractionBody;

  /// No description provided for @errorNetwork.
  ///
  /// In id, this message translates to:
  /// **'Tidak dapat terhubung ke server. Periksa koneksi Anda.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In id, this message translates to:
  /// **'Koneksi ke server melebihi batas waktu. Silakan coba lagi.'**
  String get errorTimeout;

  /// No description provided for @errorUnauthorized.
  ///
  /// In id, this message translates to:
  /// **'Sesi Anda telah berakhir. Silakan masuk kembali.'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In id, this message translates to:
  /// **'Anda tidak memiliki akses untuk tindakan ini.'**
  String get errorForbidden;

  /// No description provided for @errorValidation.
  ///
  /// In id, this message translates to:
  /// **'Data yang dikirim belum valid. Periksa kembali isian Anda.'**
  String get errorValidation;

  /// No description provided for @errorNotFound.
  ///
  /// In id, this message translates to:
  /// **'Data yang diminta tidak ditemukan.'**
  String get errorNotFound;

  /// No description provided for @errorConflict.
  ///
  /// In id, this message translates to:
  /// **'Permintaan bertentangan dengan data saat ini.'**
  String get errorConflict;

  /// No description provided for @errorServer.
  ///
  /// In id, this message translates to:
  /// **'Server sedang bermasalah. Silakan coba lagi nanti.'**
  String get errorServer;

  /// No description provided for @errorInvalidResponse.
  ///
  /// In id, this message translates to:
  /// **'Respons server tidak dikenali. Hubungi administrator bila masalah berlanjut.'**
  String get errorInvalidResponse;

  /// No description provided for @errorCancelled.
  ///
  /// In id, this message translates to:
  /// **'Permintaan dibatalkan.'**
  String get errorCancelled;

  /// No description provided for @errorUnknown.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.'**
  String get errorUnknown;

  /// No description provided for @errorSessionRestoreFailed.
  ///
  /// In id, this message translates to:
  /// **'Sesi tersimpan tidak dapat dibaca. Silakan masuk kembali.'**
  String get errorSessionRestoreFailed;

  /// No description provided for @errorSessionStorageFailed.
  ///
  /// In id, this message translates to:
  /// **'Sesi tidak dapat disimpan di perangkat. Silakan coba lagi.'**
  String get errorSessionStorageFailed;

  /// No description provided for @errorSessionClearFailed.
  ///
  /// In id, this message translates to:
  /// **'Sesi lokal tidak dapat dihapus sepenuhnya. Tutup aplikasi lalu masuk kembali.'**
  String get errorSessionClearFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
