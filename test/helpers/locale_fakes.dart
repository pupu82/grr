import 'package:grr/utils/storage.dart';

/// In-memory [LocaleStorage] used by unit tests.
class InMemoryLocaleStorage implements LocaleStorage {
  String? storedLanguageCode;
  bool failOnRead = false;
  bool failOnWrite = false;

  @override
  Future<String?> readLanguageCode() async {
    if (failOnRead) {
      throw Exception('storage unavailable');
    }
    return storedLanguageCode;
  }

  @override
  Future<void> writeLanguageCode(String languageCode) async {
    if (failOnWrite) {
      throw Exception('storage unavailable');
    }
    storedLanguageCode = languageCode;
  }
}
