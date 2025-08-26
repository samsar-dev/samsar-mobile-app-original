import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:samsar/controllers/auth/auth_controller.dart';
import 'package:samsar/models/notifications/get_notifications_success_response.dart';
import 'package:samsar/services/notification/notification_services.dart';
import 'package:samsar/widgets/custom_snackbar/custom_snackbar.dart';

class NotificationController extends GetxController {
  final AuthController _authController = Get.put(AuthController());
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final RxInt notificationsCount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxList<Item> allNotifications = <Item>[].obs;

  Future<void> getNotificationController() async {
    try {
      isLoading(true);

      final String? accessToken = await _authController.getAccessToken();
      if (accessToken == null) {
        showCustomSnackbar("Access token not found", true);
        return;
      }

      final result = await NotificationServices().getNotificationServices(
        accessToken,
      );

      if (result.isSuccess && result.successResponse != null) {
        final data = GetNotificationSuccessResponse.fromJson(
          result.successResponse!,
        );
        allNotifications.value = data.data?.items ?? [];
        notificationsCount.value = allNotifications.length;
      } else {
        showCustomSnackbar(
          result.apiError?.message ?? 'Failed to fetch notifications',
          true,
        );
      }
    } catch (e) {
      showCustomSnackbar("Unexpected error occurred: $e", true);
    } finally {
      isLoading(false);
    }
  }
}
