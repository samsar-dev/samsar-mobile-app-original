import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static const _storage = FlutterSecureStorage();
  static const String _languageKey = 'selected_language';
  
  // Observable current locale
  final Rx<Locale> _currentLocale = const Locale('en', 'US').obs;
  Locale get currentLocale => _currentLocale.value;
  
  // Observable current language name
  final RxString _currentLanguage = 'English'.obs;
  String get currentLanguage => _currentLanguage.value;
  
  // Available languages
  final Map<String, Locale> supportedLanguages = {
    'English': const Locale('en', 'US'),
    'العربية': const Locale('ar', 'SA'),
  };
  
  @override
  void onInit() {
    print('🚀 LanguageController.onInit() called');
    super.onInit();
    print('📱 Current language before loading: ${_currentLanguage.value}');
    print('🌍 Current locale before loading: ${_currentLocale.value}');
    _loadSavedLanguage();
  }
  
  @override
  void onReady() {
    print('✅ LanguageController.onReady() called');
    super.onReady();
    print('📱 Current language in onReady: ${_currentLanguage.value}');
    print('🌍 Current locale in onReady: ${_currentLocale.value}');
    // Ensure language is loaded when controller is ready
    if (_currentLanguage.value == 'English') {
      print('⚠️ Language is still English, reloading...');
      _loadSavedLanguage();
    }
  }
  
  // Load saved language from storage
  Future<void> _loadSavedLanguage() async {
    String? savedLanguage;
    
    try {
      // Try secure storage first
      print('🔍 Trying to load from secure storage...');
      savedLanguage = await _storage.read(key: _languageKey);
      print('📱 Secure storage result: $savedLanguage');
      
      // If secure storage is empty, try SharedPreferences
      if (savedLanguage == null) {
        print('🔍 Secure storage empty, trying SharedPreferences...');
        final prefs = await SharedPreferences.getInstance();
        savedLanguage = prefs.getString(_languageKey);
        print('📱 SharedPreferences result: $savedLanguage');
      }
      
      if (savedLanguage != null && supportedLanguages.containsKey(savedLanguage)) {
        print('✅ Found saved language: $savedLanguage, applying...');
        _updateLanguage(savedLanguage, saveToStorage: false);
        print('✅ Language loaded successfully: $savedLanguage');
      } else {
        print('ℹ️ No saved language found in either storage, using default: English');
      }
    } catch (e) {
      print('❌ Error loading saved language: $e');
      print('🔄 Falling back to default language: English');
    }
  }
  
  // Change language with immediate effect
  Future<void> changeLanguage(String languageName) async {
    print('🔄 changeLanguage() called with: $languageName');
    print('📱 Current language before change: ${_currentLanguage.value}');
    if (supportedLanguages.containsKey(languageName)) {
      print('✅ Language $languageName is supported, updating...');
      await _updateLanguage(languageName, saveToStorage: true);
    } else {
      print('❌ Language $languageName is NOT supported');
      print('🔍 Supported languages: ${supportedLanguages.keys}');
    }
  }
  
  // Update language and locale
  Future<void> _updateLanguage(String languageName, {required bool saveToStorage}) async {
    print('🔧 _updateLanguage() called with: $languageName, saveToStorage: $saveToStorage');
    final locale = supportedLanguages[languageName]!;
    print('🌍 New locale will be: $locale');
    
    // Update observables immediately
    print('📝 Updating observables...');
    _currentLanguage.value = languageName;
    _currentLocale.value = locale;
    print('✅ Observables updated - Language: ${_currentLanguage.value}, Locale: ${_currentLocale.value}');
    
    // Update GetX locale immediately
    print('🔄 Calling Get.updateLocale($locale)...');
    Get.updateLocale(locale);
    print('✅ Get.updateLocale() completed');
    
    // Save to storage if needed
    if (saveToStorage) {
      try {
        print('💾 Saving language to secure storage...');
        await _storage.write(key: _languageKey, value: languageName);
        print('✅ Language saved to secure storage successfully');
        
        // Verify secure storage save
        final saved = await _storage.read(key: _languageKey);
        print('🔍 Verification - saved language: $saved');
        
        // Also save to SharedPreferences as backup
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_languageKey, languageName);
        print('💾 Also saved to SharedPreferences as backup');
        
      } catch (e) {
        print('❌ Error saving to secure storage: $e');
        
        // Fallback to SharedPreferences if secure storage fails
        try {
          print('🔄 Falling back to SharedPreferences...');
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_languageKey, languageName);
          print('✅ Language saved to SharedPreferences successfully');
        } catch (fallbackError) {
          print('❌ Fallback storage also failed: $fallbackError');
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
