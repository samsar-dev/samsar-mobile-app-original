import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:samsar/services/auth/auth_api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  // Initialize Firebase Messaging
  static Future<void> initialize() async {
    // Request permission for notifications
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
      }
    } else {
      if (kDebugMode) {
      }
    }

    // Get the token
    String? token = await _firebaseMessaging.getToken();
    if (kDebugMode) {
    }

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
      }

      if (message.notification != null) {
        if (kDebugMode) {
        }
        
        // Show notification dialog when app is in foreground
        _showNotificationDialog(message);
      }
    });

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
      }
      _handleNotificationTap(message);
    });

    // Handle notification tap when app is terminated
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  // Get FCM token
  static Future<String?> getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      
      // Send token to backend
      if (token != null) {
        await _sendTokenToBackend(token);
      }
      
      return token;
    } catch (e) {
      return null;
    }
  }

  static Future<void> _sendTokenToBackend(String token) async {
    try {
      final authApiService = AuthApiServices();
      final response = await authApiService.updateFCMTokenService(token);
      
      if (response.isSuccess) {
      } else {
      }
    } catch (e) {
    }
  }

  // Subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    if (kDebugMode) {
    }
  }

  // Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    if (kDebugMode) {
    }
  }

  // Show notification dialog when app is in foreground
  static void _showNotificationDialog(RemoteMessage message) {
    Get.dialog(
      AlertDialog(
        title: Text(message.notification?.title ?? 'Notification'),
        content: Text(message.notification?.body ?? 'You have a new message'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Dismiss'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _handleNotificationTap(message);
            },
            child: const Text('Open'),
          ),
        ],
      ),
    );
  }

  // Handle notification tap
  static void _handleNotificationTap(RemoteMessage message) {
    if (kDebugMode) {
    }
    
    // Handle navigation based on notification data
    if (message.data.containsKey('route')) {
      String route = message.data['route'];
      Get.toNamed(route);
    } else if (message.data.containsKey('listing_id')) {
      // Navigate to listing details
      String listingId = message.data['listing_id'];
      Get.toNamed('/listing-detail', arguments: {'id': listingId});
    }
    // Add more navigation logic as needed
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
  }
}
