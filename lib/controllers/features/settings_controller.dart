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

      final accessToken = await _authController.getAccessToken();

      final result = await SettingsService().getUserSettingsService(accessToken!);

      if(result.isSuccess && result.successResponse != null) {
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
        isLoading.value = false;
      }
      
    } catch (e) {
      print("Failed to get notifications and error is: $e");
    }
  }

  Future<void> updateSettingsController() async {
    try {
      print("🔄 Starting settings update...");
      isLoading.value = true;

      final accessToken = await _authController.getAccessToken();
      if (accessToken == null) throw Exception("Access token is null");
      print("✅ Access token obtained");

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

      print("📦 Sending request body: $requestBody");
      
      final result = await SettingsService().updateUserSettingsService(
        accessToken: accessToken,
        requestBody: requestBody,
      );

      print("📊 API call completed. Success: ${result.isSuccess}");
      if (result.successResponse != null) {
        print("✅ Success response: ${result.successResponse}");
      }
      if (result.apiError != null) {
        print("❌ API Error: ${result.apiError?.message}");
      }

      if (result.isSuccess) {
        // Settings were successfully saved to backend
        // The local state should already reflect the changes since we're using the same values
        print("✅ Settings successfully saved to backend");
        
        // Optionally refresh from server to confirm (but usually not needed)
        // await getSettingsController();
        
        showCustomSnackbar("Settings updated successfully", false);
      } else {
        // If update failed, don't revert settings - keep local changes
        print("❌ Settings update failed, keeping local changes");
        showCustomSnackbar("Failed to update settings: ${result.apiError?.message ?? 'Unknown error'}", true);
      }
    } catch (e) {
      isLoading.value = false;
      showCustomSnackbar("Failed to update settings: ${e.toString()}", true);
    } finally {
      isLoading.value = false;
    }
  }
}