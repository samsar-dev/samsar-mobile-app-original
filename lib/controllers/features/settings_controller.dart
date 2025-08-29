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
      isLoading.value = true;

      // Wait for auth controller to be ready
      int attempts = 0;
      while (!_authController.isSessionReady && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      if (!_authController.isAuthenticated) {
        showCustomSnackbar("Please log in to access settings.", true);
        isLoading.value = false;
        return;
      }

      final accessToken = await _authController.getAccessToken();
      if (accessToken == null) {
        showCustomSnackbar(
          "Access token not found. Please log in again.",
          true,
        );
        isLoading.value = false;
        return;
      }

      final result = await SettingsService().getUserSettingsService(
        accessToken,
      );

      if (result.isSuccess && result.successResponse != null) {
        final settings = GetSettingsModel.fromJson(result.successResponse!);

        allowMessaging.value = settings.data?.allowMessaging ?? false;
        listingNotifications.value =
            settings.data?.listingNotifications ?? false;
        messageNotifications.value =
            settings.data?.messageNotifications ?? false;
        loginNotifications.value = settings.data?.loginNotifications ?? false;
        newsletterSubscribed.value =
            settings.data?.newsletterSubscribed ?? false;
        showEmail.value = settings.data?.showEmail ?? false;
        showOnlineStatus.value = settings.data?.showOnlineStatus ?? false;
        showPhoneNumber.value = settings.data?.showPhoneNumber ?? false;
        privateProfile.value = settings.data?.privateProfile ?? false;

        hasLoadedSettings.value = true;
      } else {
        showCustomSnackbar(
          "Failed to load settings: ${result.apiError?.message ?? 'Unknown error'}",
          true,
        );
      }
    } catch (e) {
      showCustomSnackbar("Failed to load settings: ${e.toString()}", true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSettingsController() async {
    try {
      isLoading.value = true;

      // Ensure user is authenticated
      if (!_authController.isAuthenticated) {
        showCustomSnackbar("Please log in to update settings.", true);
        isLoading.value = false;
        return;
      }

      final accessToken = await _authController.getAccessToken();
      if (accessToken == null) {
        showCustomSnackbar(
          "Access token not found. Please log in again.",
          true,
        );
        isLoading.value = false;
        return;
      }

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
        },
      };

      final result = await SettingsService().updateUserSettingsService(
        accessToken: accessToken,
        requestBody: requestBody,
      );

      if (result.isSuccess) {
        showCustomSnackbar("Settings updated successfully", false);
      } else {
        showCustomSnackbar(
          "Failed to update settings: ${result.apiError?.message ?? 'Unknown error'}",
          true,
        );
      }
    } catch (e) {
      showCustomSnackbar("Failed to update settings: ${e.toString()}", true);
    } finally {
      isLoading.value = false;
    }
  }
}
