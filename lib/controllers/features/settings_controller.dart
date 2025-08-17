import 'package:get/get.dart';
import 'package:samsar/controllers/auth/auth_controller.dart';
import 'package:samsar/models/settings/get_settings_model.dart';
import 'package:samsar/services/settings/settings_service.dart';
import 'package:samsar/widgets/custom_snackbar/custom_snackbar.dart';

class SettingsController extends GetxController {

  final AuthController _authController = Get.put(AuthController());

  RxBool isLoading = false.obs;
  RxBool hasLoadedSettings = false.obs;

  RxBool allowMessaging = false.obs;
  RxBool listingNotifications = false.obs;
  RxBool messageNotifications = false.obs;
  RxBool loginNotifications = false.obs;
  RxBool newsletterSubscribed = false.obs;
  RxBool showEmail = false.obs;
  RxBool showOnlineStatus = false.obs;
  RxBool showPhoneNumber = false.obs;
  RxBool privateProfile = false.obs;

  Future<void> getSettingsController() async {
    try {
      print('🔧 Starting settings load...');
      isLoading.value = true;

      // Wait for auth controller to be ready
      int attempts = 0;
      while (!_authController.isSessionReady && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      if (!_authController.isAuthenticated) {
        print('❌ User not authenticated, cannot load settings');
        showCustomSnackbar("Please log in to access settings.", true);
        isLoading.value = false;
        return;
      }

      final accessToken = await _authController.getAccessToken();
      if (accessToken == null) {
        print('❌ Access token not found');
        showCustomSnackbar("Access token not found. Please log in again.", true);
        isLoading.value = false;
        return;
      }

      print('📡 Fetching settings from API...');
      final result = await SettingsService().getUserSettingsService(accessToken);

      if(result.isSuccess && result.successResponse != null) {
        print('✅ Settings loaded successfully');
        final settings = GetSettingsModel.fromJson(result.successResponse!);

        allowMessaging.value = settings.data?.allowMessaging ?? false;
        listingNotifications.value = settings.data?.listingNotifications ?? false;
        messageNotifications.value = settings.data?.messageNotifications ?? false;
        loginNotifications.value = settings.data?.loginNotifications ?? false;
        newsletterSubscribed.value = settings.data?.newsletterSubscribed ?? false;
        showEmail.value = settings.data?.showEmail ?? false;
        showOnlineStatus.value = settings.data?.showOnlineStatus ?? false;
        showPhoneNumber.value = settings.data?.showPhoneNumber ?? false;
        privateProfile.value = settings.data?.privateProfile ?? false;

        hasLoadedSettings.value = true;
        print('🎯 Settings state updated successfully');
      } else {
        print('❌ Failed to load settings: ${result.apiError?.message}');
        showCustomSnackbar("Failed to load settings: ${result.apiError?.message ?? 'Unknown error'}", true);
      }
    } catch (e) {
      print('❌ Exception loading settings: $e');
      showCustomSnackbar("Failed to load settings: ${e.toString()}", true);
    } finally {
      isLoading.value = false;
      print('🏁 Settings load completed');
    }
  }

  Future<void> updateSettingsController() async {
    try {
      print("🔄 Starting settings update...");
      isLoading.value = true;

      // Ensure user is authenticated
      if (!_authController.isAuthenticated) {
        print('❌ User not authenticated, cannot update settings');
        showCustomSnackbar("Please log in to update settings.", true);
        isLoading.value = false;
        return;
      }

      final accessToken = await _authController.getAccessToken();
      if (accessToken == null) {
        print('❌ Access token not found');
        showCustomSnackbar("Access token not found. Please log in again.", true);
        isLoading.value = false;
        return;
      }

      print('📡 Sending settings update to API...');
      final requestBody = {
        "notifications": {
          "listingUpdates": listingNotifications.value,
          "newInboxMessages": messageNotifications.value,
          "loginNotifications": loginNotifications.value,
          "newsletterSubscribed": newsletterSubscribed.value,
        },
        "privacy": {
          "profileVisibility": privateProfile.value ? "private" : "public",
          "allowMessaging": allowMessaging.value,
          "showEmail": showEmail.value,
          "showOnlineStatus": showOnlineStatus.value,
          "showPhone": showPhoneNumber.value,
        }
      };
      
      final result = await SettingsService().updateUserSettingsService(
        accessToken: accessToken,
        requestBody: requestBody,
      );

      if (result.isSuccess) {
        print("✅ Settings updated successfully on server");
        showCustomSnackbar("Settings updated successfully", false);
      } else {
        print("❌ Settings update failed: ${result.apiError?.message}");
        showCustomSnackbar("Failed to update settings: ${result.apiError?.message ?? 'Unknown error'}", true);
      }
    } catch (e) {
      print('❌ Exception updating settings: $e');
      showCustomSnackbar("Failed to update settings: ${e.toString()}", true);
    } finally {
      isLoading.value = false;
      print('🏁 Settings update completed');
    }
  }
}