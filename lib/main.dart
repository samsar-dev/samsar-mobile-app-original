import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/controllers/auth/auth_controller.dart';
import 'package:samsar/controllers/features/theme_controller.dart';
import 'package:samsar/controllers/features/language_controller.dart';
import 'package:samsar/translations/app_translations.dart';
import 'package:samsar/views/spalsh_screen/splash_screen_view.dart';


void main() {
  // Performance optimizations
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize only essential controllers at startup
  // Other controllers will be lazy-loaded when needed
  Get.put(AuthController(), permanent: true);
  Get.put(LanguageController(), permanent: true);
  
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeController _themeController = Get.put(ThemeController());
  final LanguageController _languageController = Get.find<LanguageController>();

  // Memory cleanup method for performance optimization
  void _performMemoryCleanup() {
    // Clean up unused controllers to free memory
    try {
      Get.deleteAll(force: false);
    } catch (e) {
      // Controllers might not exist, ignore errors
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🎨 MyApp.build() called');
    return Obx(
      () {
        print('🔄 Obx rebuilding MyApp...');
        print('🌍 Current locale: ${_languageController.currentLocale}');
        print('📱 Current language: ${_languageController.currentLanguage}');
        print('➡️ Is RTL: ${_languageController.isRTL}');
        
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          // Performance optimizations
          smartManagement: SmartManagement.keepFactory,
          defaultTransition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 200),
          // Memory management
          routingCallback: (routing) {
            // Clean up unused controllers when navigating
            if (routing?.isBack == true) {
              _performMemoryCleanup();
            }
          },
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            cardColor: Colors.grey.shade50,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              iconTheme: IconThemeData(color: Colors.black),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Color(0xFF007BFF), // blueColor
              unselectedItemColor: Colors.grey,
            ),
            textTheme: TextTheme(
              titleLarge: TextStyle(color: Colors.black),
              titleMedium: TextStyle(color: Colors.grey[800]),
              bodyLarge: TextStyle(color: Colors.black87),
              bodyMedium: TextStyle(color: Colors.grey[700]),
            ),
            iconTheme: IconThemeData(color: Colors.grey[600]),
            dividerColor: Colors.grey.shade300,
            shadowColor: Colors.black,
            inputDecorationTheme: InputDecorationTheme(
              fillColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Color(0xFF121212),
            cardColor: Color(0xFF1E1E1E),
            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF1E1E1E),
              selectedItemColor: Color(0xFF007BFF), // blueColor
              unselectedItemColor: Colors.grey[400],
            ),
            textTheme: TextTheme(
              titleLarge: TextStyle(color: Colors.white),
              titleMedium: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.grey[300]),
            ),
            iconTheme: IconThemeData(color: Colors.grey[400]),
            dividerColor: Colors.grey[600],
            shadowColor: Colors.white,
            inputDecorationTheme: InputDecorationTheme(
              fillColor: Color(0xFF2C2C2C),
            ),
          ),
          themeMode: _themeController.theme,
          // Language and localization support
          translations: AppTranslations(),
          locale: _languageController.currentLocale,
          fallbackLocale: const Locale('en', 'US'),
          // RTL support
          builder: (context, child) {
            print('🏠 App builder called with locale: ${_languageController.currentLocale}');
            return Directionality(
              textDirection: _languageController.isRTL 
                  ? TextDirection.rtl 
                  : TextDirection.ltr,
              child: child!,
            );
          },
          // Routes configuration - using basic route setup
          // getPages: AppRoutes.appRoutes(),
          home: SplashScreenView()
        );
      }
    );
  }
}