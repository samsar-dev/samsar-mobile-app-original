import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/routes/route_names.dart';
import 'package:samsar/views/auth/mobile/code_verification/code_verification_view.dart';
import 'package:samsar/views/auth/mobile/login/login_view.dart';
import 'package:samsar/views/auth/mobile/register/register_view.dart';
import 'package:samsar/views/home/home_view.dart';

class AppRoutes {
  static appRoutes() => [
    // Root route
    GetPage(
      name: '/',
      page: () => HomeView(),
    ),
    
    // Public routes (no authentication required)
    GetPage(
      name: RouteNames.loginView,
      page: () => LoginView(),
      transition: Transition.leftToRight,
      transitionDuration: const Duration(milliseconds: 500)
    ),

    GetPage(
      name: RouteNames.registerView,
      page: () => RegisterView(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 800)
    ),

    GetPage(
      name: RouteNames.codeVerificationView,
      page: () => CodeVerificationView(),
      transition: Transition.leftToRight,
      transitionDuration: Duration(milliseconds: 500),
      curve: Curves.easeIn
    ),

    // Home route (public - no authentication required)
    // Authentication for specific features is handled within HomeView
    GetPage(
      name: RouteNames.homeFeed,
      page: () => HomeView(),
    ),
  ];
}