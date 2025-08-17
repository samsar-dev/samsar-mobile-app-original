# Flutter-specific ProGuard rules for maximum APK size reduction

# Keep Flutter engine classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.**

# Keep Dart VM classes
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }

# Aggressive optimization settings
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 10
-allowaccessmodification
-dontpreverify
-repackageclasses ''

# Remove debug logging to save space
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}

# Remove print statements from Dart code
-assumenosideeffects class dart.developer.log {
    public static void log(...);
}

# Optimize Google Fonts
-keep class com.google.fonts.** { *; }
-dontwarn com.google.fonts.**

# Optimize Font Awesome
-keep class com.fortawesome.** { *; }
-dontwarn com.fortawesome.**

# Keep connectivity plus classes
-keep class dev.fluttercommunity.plus.connectivity.** { *; }
-dontwarn dev.fluttercommunity.plus.connectivity.**

# Keep Dio HTTP client classes
-keep class dio.** { *; }
-dontwarn dio.**

# Keep Geolocator classes
-keep class com.baseflow.geolocator.** { *; }
-dontwarn com.baseflow.geolocator.**

# Keep Geocoding classes
-keep class com.baseflow.geocoding.** { *; }
-dontwarn com.baseflow.geocoding.**

# Keep Image Picker classes
-keep class io.flutter.plugins.imagepicker.** { *; }
-dontwarn io.flutter.plugins.imagepicker.**

# Keep Shared Preferences classes
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-dontwarn io.flutter.plugins.sharedpreferences.**

# Keep Secure Storage classes
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-dontwarn com.it_nomads.fluttersecurestorage.**

# Optimize native libraries
-keep class com.android.** { *; }
-dontwarn com.android.**

# Remove unused resources
-keep class **.R
-keep class **.R$* {
    <fields>;
}

# Optimize reflection usage
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Remove unused code aggressively
-dontwarn **
-ignorewarnings

# Optimize string usage
-optimizations !code/simplification/string

# Remove unused classes and methods
-dontshrink
-dontoptimize

# Actually, enable shrinking and optimization for maximum size reduction
-dontshrink
-dontoptimize
# Override above - we DO want shrinking and optimization
-dontwarn
-ignorewarnings

# Final optimization pass
-optimizations *
-optimizationpasses 10
