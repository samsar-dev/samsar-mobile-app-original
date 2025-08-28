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
        print('User granted permission');
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('User granted provisional permission');
      }
    } else {
      if (kDebugMode) {
        print('User declined or has not accepted permission');
      }
    }

    // Get the token
    String? token = await _firebaseMessaging.getToken();
    if (kDebugMode) {
      print('FCM Token: $token');
    }

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
      }

      if (message.notification != null) {
        if (kDebugMode) {
          print('Message also contained a notification: ${message.notification}');
        }
        
        // Show notification dialog when app is in foreground
        _showNotificationDialog(message);
      }
    });

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
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
      print('FCM Token: $token');
      
      // Send token to backend
      if (token != null) {
        await _sendTokenToBackend(token);
      }
      
      return token;
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  static Future<void> _sendTokenToBackend(String token) async {
    try {
      final authApiService = AuthApiServices();
      final response = await authApiService.updateFCMTokenService(token);
      
      if (response.isSuccess) {
        print('✅ FCM token successfully sent to backend: $token');
      } else {
        print('❌ Failed to send FCM token to backend: ${response.apiError?.message}');
      }
    } catch (e) {
      print('❌ Error sending FCM token to backend: $e');
    }
  }

  // Subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    if (kDebugMode) {
      print('Subscribed to topic: $topic');
    }
  }

  // Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    if (kDebugMode) {
      print('Unsubscribed from topic: $topic');
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
      print('Notification tapped: ${message.data}');
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
    print('Handling a background message: ${message.messageId}');
  }
}
