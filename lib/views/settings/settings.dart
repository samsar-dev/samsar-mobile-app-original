import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/features/settings_controller.dart';
import 'package:samsar/controllers/features/theme_controller.dart';
import 'package:samsar/controllers/features/language_controller.dart';
import 'package:samsar/widgets/app_button/app_button.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String selectedTimezone = 'UTC +5:30 (IST)';

  final List<String> timezones = [
    'UTC -8:00 (PST)',
    'UTC -5:00 (EST)',
    'UTC +0:00 (GMT)',
    'UTC +5:30 (IST)',
    'UTC +8:00 (CST)',
  ];

  final List<String> visibilityOptions = ['Public', 'Private'];
  final SettingsController _settingsController = Get.put(SettingsController());
  final ThemeController _themeController = Get.put(ThemeController());
  final LanguageController _languageController = Get.put(LanguageController());

  @override
  void initState() {
    super.initState();
    // Fetch settings on first load only
    _settingsController.getSettingsController();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "settings".tr,
          style: TextStyle(
            color: Theme.of(context).appBarTheme.titleTextStyle?.color ?? Theme.of(context).textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_settingsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildLabel(screenWidth, screenHeight, "preferences".tr),
                  SizedBox(height: screenHeight * 0.02),

                  settingCard(
                    screenWidth,
                    screenHeight,
                    title: "language".tr,
                    child: modernLanguageSwitcher(),
                  ),

                  settingCard(
                    screenWidth,
                    screenHeight,
                    title: "dark_theme".tr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _themeController.isDarkMode.value ? "enabled".tr : "disabled".tr,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        Switch.adaptive(
                          value: _themeController.isDarkMode.value,
                          activeColor: blueColor,
                          onChanged: (val) => _themeController.toggleTheme(),
                        ),
                      ],
                    ),
                  ),

                  settingCard(
                    screenWidth,
                    screenHeight,
                    title: "timezone".tr,
                    child: customDropdown(
                      selectedValue: selectedTimezone,
                      items: timezones,
                      onChanged: (val) => setState(() => selectedTimezone = val),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),
                  buildLabel(screenWidth, screenHeight, "notifications".tr),
                  SizedBox(height: screenHeight * 0.01),

                  Obx(() => settingCard(
                        screenWidth,
                        screenHeight,
                        title: "inbox_messages".tr,
                        child: customCheckbox(
                          title: "inbox_messages".tr,
                          subtitle: "inbox_messages_desc".tr,
                          value: _settingsController.messageNotifications.value,
                          onChanged: (val) => _settingsController.messageNotifications.value = val,
                        ),
                      )),

                  Obx(() => settingCard(
                        screenWidth,
                        screenHeight,
                        title: "listing_updates".tr,
                        child: customCheckbox(
                          title: "listing_status".tr,
                          subtitle: "listing_status_desc".tr,
                          value: _settingsController.listingNotifications.value,
                          onChanged: (val) => _settingsController.listingNotifications.value = val,
                        ),
                      )),

                  Obx(() => settingCard(
                        screenWidth,
                        screenHeight,
                        title: "login_notifications".tr,
                        child: customCheckbox(
                          title: "new_login_alerts".tr,
                          subtitle: "new_login_alerts_desc".tr,
                          value: _settingsController.loginNotifications.value,
                          onChanged: (val) => _settingsController.loginNotifications.value = val,
                        ),
                      )),

                  Obx(() => settingCard(
                        screenWidth,
                        screenHeight,
                        title: "newsletter".tr,
                        child: customCheckbox(
                          title: "samsar_weekly".tr,
                          subtitle: "samsar_weekly_desc".tr,
                          value: _settingsController.newsletterSubscribed.value,
                          onChanged: (val) => _settingsController.newsletterSubscribed.value = val,
                        ),
                      )),

                  SizedBox(height: screenHeight * 0.03),
                  buildLabel(screenWidth, screenHeight, "privacy".tr),
                  SizedBox(height: screenHeight * 0.01),

                  Obx(() => settingCard(
                        screenWidth,
                        screenHeight,
                        title: "profile_visibility".tr,
                        child: customDropdown(
                          selectedValue: _settingsController.privateProfile.value ? "private".tr : "public".tr,
                          items: ["public".tr, "private".tr],
                          onChanged: (val) => {
                              _settingsController.privateProfile.value = val == "private".tr,
                          },
                        ),
                      )),

                  Obx(() => settingCard(
                        screenWidth,
                        screenHeight,
                        title: "show_online_status".tr,
                        child: customCheckbox(
                          title: "show_online".tr,
                          subtitle: "show_online_desc".tr,
                          value: _settingsController.showOnlineStatus.value,
                          onChanged: (val) => _settingsController.showOnlineStatus.value = val,
                        ),
                      )),

                  Obx(() => settingCard(
                        screenWidth,
                        screenHeight,
                        title: "show_phone".tr,
                        child: customCheckbox(
                          title: "phone_visibility".tr,
                          subtitle: "phone_visibility_desc".tr,
                          value: _settingsController.showPhoneNumber.value,
                          onChanged: (val) => _settingsController.showPhoneNumber.value = val,
                        ),
                      )),

                  Obx(() => settingCard(
                        screenWidth,
                        screenHeight,
                        title: "show_email".tr,
                        child: customCheckbox(
                          title: "email_visibility".tr,
                          subtitle: "email_visibility_desc".tr,
                          value: _settingsController.showEmail.value,
                          onChanged: (val) => _settingsController.showEmail.value = val,
                        ),
                      )),

                  Obx(() => settingCard(
                        screenWidth,
                        screenHeight,
                        title: "allow_direct_messaging".tr,
                        child: customCheckbox(
                          title: "enable_dms_title".tr,
                          subtitle: "enable_dms_desc".tr,
                          value: _settingsController.allowMessaging.value,
                          onChanged: (val) => _settingsController.allowMessaging.value = val,
                        ),
                      )),

                  SizedBox(height: screenHeight * 0.03),

                  Center(
                    child: AppButton(
                      widthSize: 0.65,
                      heightSize: 0.06,
                      text: "save_settings".tr,
                      buttonColor: blueColor,
                      textColor: whiteColor,
                      onPressed: () => _settingsController.updateSettingsController(),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildLabel(double screenWidth, double screenHeight, String title) {
    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.02, left: screenWidth * 0.01),
      child: Text(
        title,
        style: TextStyle(
          color: blueColor,
          fontSize: screenWidth * 0.05,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget settingCard(double screenWidth, double screenHeight,
      {required String title, required Widget child}) {
    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.015),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget customDropdown({
    required String selectedValue,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedValue,
          borderRadius: BorderRadius.circular(12),
          dropdownColor: Theme.of(context).cardColor,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Theme.of(context).iconTheme.color),
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 16),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(Icons.language, color: Theme.of(context).iconTheme.color?.withOpacity(0.7), size: 20),
                  const SizedBox(width: 8),
                  Text(item),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) => onChanged(value!),
        ),
      ),
    );
  }

  Widget customCheckbox({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: blueColor,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      value: value,
      onChanged: (val) => onChanged(val!),
    );
  }

  Widget modernLanguageSwitcher() {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: _languageController.supportedLanguages.entries.map((entry) {
            final languageName = entry.key;
            final isSelected = _languageController.currentLanguage == languageName;
            final flag = _languageController.getLanguageFlag(languageName);
            
            return Expanded(
              child: GestureDetector(
                onTap: () async {
                  print('👆 Language switcher tapped: $languageName');
                  print('📱 Current selected: ${_languageController.currentLanguage}');
                  print('❓ Is selected: $isSelected');
                  
                  if (!isSelected) {
                    print('🔄 Starting language change process...');
                    
                    // Immediate visual feedback
                    await _languageController.changeLanguage(languageName);
                    
                    print('✅ Language change completed');
                    print('📱 New current language: ${_languageController.currentLanguage}');
                    print('🌍 New current locale: ${_languageController.currentLocale}');
                    
                    // Show success message
                    Get.snackbar(
                      'language_changed'.tr,
                      '',
                      duration: const Duration(seconds: 1),
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green.shade100,
                      colorText: Colors.green.shade800,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 8,
                      icon: Icon(Icons.check_circle, color: Colors.green.shade600),
                    );
                  } else {
                    print('⚠️ Language already selected: $languageName');
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? blueColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: blueColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ] : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        flag,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          languageName,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 4),
                        Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}
