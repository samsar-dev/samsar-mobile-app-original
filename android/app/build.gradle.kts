plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.samsar.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "29.0.13599879"
    
    // Enable resource optimization
    buildFeatures {
        buildConfig = true
        aidl = false
        renderScript = false
        resValues = false
        shaders = false
        viewBinding = false
        dataBinding = false
    }
    
    // Aggressive packaging options to exclude unnecessary files
    packaging {
        resources {
            excludes += listOf(
                "META-INF/DEPENDENCIES",
                "META-INF/LICENSE",
                "META-INF/LICENSE.txt",
                "META-INF/NOTICE",
                "META-INF/NOTICE.txt",
                "META-INF/*.kotlin_module",
                "**/*.kotlin_metadata",
                "**/*.version",
                "**/*.properties",
                "**/*.md",
                "**/*.txt",
                "**/README*",
                "**/CHANGELOG*",
                "**/LICENSE*",
                "**/NOTICE*",
                "**/*.proto",
                "**/*.bin",
                "**/*.class",
                "lib/x86/**",
                "lib/x86_64/**",
                "lib/mips/**",
                "lib/mips64/**",
                "**/original.png",
                "**/original.jpg",
                "**/original.jpeg",
                "**/*_original.*",
                "**/drawable-ldpi/**",
                "**/drawable-mdpi/**",
                "**/mipmap-ldpi/**",
                "**/mipmap-mdpi/**",
                "**/*.webp",
                "**/kotlin/**",
                "**/META-INF/kotlin*",
                "**/DebugProbesKt.bin",
                "**/*_debug.*",
                "**/unused/**"
            )
        }
        jniLibs {
            useLegacyPackaging = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.samsar.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Optimize native libraries - ARM64 primary, ARMv7 fallback
        ndk {
            abiFilters += listOf("arm64-v8a", "armeabi-v7a")
        }
        
        // Reduce APK size by excluding unused resources
        resourceConfigurations += listOf("en", "ar")
        
        // Additional size optimizations
        multiDexEnabled = false
        vectorDrawables.useSupportLibrary = true
        
        // Remove deprecated aaptOptions - handled by packaging optimization
        
        // Remove duplicate packagingOptions - already defined above
        
        // Keep all densities for compatibility
        // resConfigs will be handled by resource shrinking
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            
            // Aggressive R8/ProGuard optimization for maximum size reduction
            isMinifyEnabled = true
            isShrinkResources = true
            isDebuggable = false
            
            // Use ProGuard rules with networking preservation
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            
            // Additional optimizations
            buildConfigField("boolean", "ENABLE_NETWORKING", "true")
            
            // Simplified APK optimization without splits to avoid AAPT issues
            // APK splitting can cause resource processing conflicts
        }
        
        debug {
            // Optimize debug builds for faster development
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

dependencies {
    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.1.0"))
    
    // Firebase Analytics
    implementation("com.google.firebase:firebase-analytics")
    
    // Firebase Messaging for push notifications
    implementation("com.google.firebase:firebase-messaging")
}

flutter {
    source = "../.."
}
