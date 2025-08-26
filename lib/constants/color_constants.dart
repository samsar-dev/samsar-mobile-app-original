// import 'package:flutter/material.dart';

// const Color whiteColor = Color.fromRGBO(255, 255, 255, 1);
// const Color blackColor = Color.fromRGBO(0, 0, 0, 1);
// const Color sheetColor = Color.fromRGBO(52, 83, 183, 1);
// const Color lightblueColor = Color.fromRGBO(59, 129, 246, 1);
// const Color purpleColor = Color.fromRGBO(79, 69, 228, 1);
// const Color blueColor = Color.fromRGBO(28, 78, 216, 1);
// const Color greyColor = Color.fromRGBO(103, 112, 124, 1);

// //dark theme
// const Color primaryDarkColor = Color.fromRGBO(17,24,39, 1);
// const Color subDarkColor = Color.fromRGBO(31,41,55, 1);
// const Color cardDarkColor = Color.fromRGBO(129,145,170, 1);

// //images
// const AssetImage carError = AssetImage("lib/assets/error_car_mascot.png");

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Adaptive Colors
Color get whiteColor =>
    Get.isDarkMode ? const Color(0xFF121212) : const Color(0xFFFFFFFF);
Color get blackColor =>
    Get.isDarkMode ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
Color get greyColor =>
    Get.isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF676C78);
Color get cardColor =>
    Get.isDarkMode ? const Color(0xFF1F1F1F) : const Color(0xFFFFFFFF);

// Static Colors
const Color blueColor = Color.fromRGBO(28, 78, 216, 1);
const Color lightblueColor = Color.fromRGBO(59, 129, 246, 1);
const Color purpleColor = Color.fromRGBO(79, 69, 228, 1);

// Dark Mode Support
const Color primaryDarkColor = Color.fromRGBO(17, 24, 39, 1);
const Color subDarkColor = Color.fromRGBO(31, 41, 55, 1);

// Fallback image
const AssetImage carError = AssetImage("lib/assets/error_car_mascot.png");
