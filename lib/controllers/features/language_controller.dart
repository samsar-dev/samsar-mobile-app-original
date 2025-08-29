import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static const _storage = FlutterSecureStorage();
  static const String _languageKey = 'selected_language';

  // Observable current locale - Default to Arabic
  final Rx<Locale> _currentLocale = const Locale('ar', 'SA').obs;
  Locale get currentLocale => _currentLocale.value;

  // Observable current language name - Default to Arabic
  final RxString _currentLanguage = 'العربية'.obs;
  String get currentLanguage => _currentLanguage.value;

  // Available languages
  final Map<String, Locale> supportedLanguages = {
    'English': const Locale('en', 'US'),
    'العربية': const Locale('ar', 'SA'),
  };

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  @override
  void onReady() {
    super.onReady();
    // Language loading is already handled in onInit, no need to reload in onReady
  }

  // Load saved language from storage - for all users
  Future<void> _loadSavedLanguage() async {
    try {
      String? savedLanguage;

      // Try secure storage first
      savedLanguage = await _storage.read(key: _languageKey);

      // If secure storage is empty, try SharedPreferences
      if (savedLanguage == null) {
        final prefs = await SharedPreferences.getInstance();
        savedLanguage = prefs.getString(_languageKey);
      }

      if (savedLanguage != null &&
          supportedLanguages.containsKey(savedLanguage)) {
        _updateLanguage(savedLanguage, saveToStorage: false);
      } else {
        _updateLanguage('العربية', saveToStorage: false);
      }
    } catch (e) {
      _updateLanguage('العربية', saveToStorage: false);
    }
  }

  // Change language with immediate effect
  Future<void> changeLanguage(String languageName) async {
    if (supportedLanguages.containsKey(languageName)) {
      await _updateLanguage(languageName, saveToStorage: true);
    } else {
    }
  }

  // Update language and locale
  Future<void> _updateLanguage(
    String languageName, {
    required bool saveToStorage,
  }) async {
    final locale = supportedLanguages[languageName]!;

    // Update observables immediately
    _currentLanguage.value = languageName;
    _currentLocale.value = locale;

    // Update GetX locale immediately
    Get.updateLocale(locale);

    // Save to storage if needed
    if (saveToStorage) {
      try {
        await _storage.write(key: _languageKey, value: languageName);

        // Verify secure storage save
        final saved = await _storage.read(key: _languageKey);

        // Also save to SharedPreferences as backup
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_languageKey, languageName);
      } catch (e) {

        // Fallback to SharedPreferences if secure storage fails
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_languageKey, languageName);
        } catch (fallbackError) {
        }
      }
    }
  }

  // Get language display name
  String getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }

  // Check if current language is RTL
  bool get isRTL => _currentLocale.value.languageCode == 'ar';

  // Get language flag emoji
  String getLanguageFlag(String languageName) {
    switch (languageName) {
      case 'English':
        return '🇺🇸';
      case 'العربية':
        return '🇸🇦';
      default:
        return '🌐';
    }
  }
}
