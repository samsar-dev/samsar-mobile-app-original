import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/controllers/auth/auth_controller.dart';
import 'package:samsar/routes/route_names.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final AuthController authController = Get.find<AuthController>();

    // Check if user is authenticated
    if (authController.user.value == null ||
        authController.accessToken.isEmpty) {
      // User is not authenticated, redirect to login
      return const RouteSettings(name: RouteNames.loginView);
    }

    // User is authenticated, allow access
    return null;
  }
}
