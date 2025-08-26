import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';

class MainNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MainNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: onTap,
      currentIndex: currentIndex,
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
          Theme.of(context).scaffoldBackgroundColor,
      selectedItemColor:
          Theme.of(context).bottomNavigationBarTheme.selectedItemColor ??
          blueColor,
      unselectedItemColor:
          Theme.of(context).bottomNavigationBarTheme.unselectedItemColor ??
          Theme.of(context).unselectedWidgetColor,
      items: [
        BottomNavigationBarItem(
          icon: const FaIcon(FontAwesomeIcons.house),
          label: "home".tr,
        ),
        BottomNavigationBarItem(
          icon: const FaIcon(FontAwesomeIcons.heart),
          label: "favourites".tr,
        ),
        BottomNavigationBarItem(
          icon: const FaIcon(FontAwesomeIcons.plus),
          label: "listing".tr,
        ),
        BottomNavigationBarItem(
          icon: const FaIcon(FontAwesomeIcons.comments),
          label: "chats".tr,
        ),
        BottomNavigationBarItem(
          icon: const FaIcon(FontAwesomeIcons.user),
          label: "profile".tr,
        ),
      ],
    );
  }
}
