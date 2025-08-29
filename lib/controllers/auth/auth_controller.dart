import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/api_route_constants.dart';
import 'package:samsar/models/auth/login_model.dart';
import 'package:samsar/services/auth/auth_api_services.dart';
import 'package:samsar/views/auth/mobile/login/login_view.dart';
import 'package:samsar/views/home/home_view.dart';
import 'package:samsar/widgets/custom_snackbar/custom_snackbar.dart';
import 'package:samsar/widgets/loading_dialog/loading_dialog.dart';
import 'package:samsar/utils/error_message_mapper.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/services/firebase_messaging_service.dart';

class AuthController extends GetxController {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AuthApiServices _authApiServices = AuthApiServices();

  final Rxn<User> user = Rxn<User>();
  final RxString accessToken = ''.obs;
  final RxBool isSessionRestored = false.obs;

  final RxBool isLoading = false.obs;
  final RxBool registerLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _restoreSession();
  }

  // Helper method to check if user is authenticated
  bool get isAuthenticated {
    return user.value != null && accessToken.value.isNotEmpty;
  }

  // Helper method to check if session restoration is complete
  bool get isSessionReady {
    return isSessionRestored.value;
  }

  Future<void> _restoreSession() async {
    try {
      final raw = await _storage.read(key: "samsar_user_data");

      if (raw != null) {
        final json = jsonDecode(raw);
        final loginModel = LoginModel.fromJson(json);

        if (loginModel.data?.user != null &&
            loginModel.data?.tokens?.accessToken != null) {
          // Validate user still exists on server before restoring session
          final isValid = await _validateUserExists(
            loginModel.data!.tokens!.accessToken!,
          );

          if (isValid) {
            user.value = loginModel.data!.user;
            accessToken.value = loginModel.data!.tokens!.accessToken!;
            await _storage.write(
              key: 'user_email',
              value: user.value?.email ?? "",
            );
          } else {
            await _clearInvalidSession();
          }
        } else {
          await _clearInvalidSession();
        }
      } else {
      }
    } catch (e) {
      await _clearInvalidSession();
    } finally {
      // Always mark session restoration as complete
      isSessionRestored.value = true;
    }
  }

  Future<bool> _validateUserExists(String token) async {
    try {
      final response = await _authApiServices.getUserProfile(token);

      if (response.apiError != null) {
        final errorCode = response.apiError?.errorResponse?.error?.code;

        // If user not found, account inactive, or email not verified, clear session
        if (errorCode == 'USER_NOT_FOUND' ||
            errorCode == 'ACCOUNT_INACTIVE' ||
            errorCode == 'EMAIL_NOT_VERIFIED' ||
            errorCode == 'INVALID_TOKEN' ||
            errorCode == 'TOKEN_EXPIRED') {
          return false;
        }

        // For other errors (like network issues), assume user exists to avoid blocking registration
        return true;
      }

      if (response.successResponse != null &&
          response.successResponse!['data'] != null) {
        return true;
      }

      return true; // Changed: assume user exists if we can't validate to avoid blocking registration
    } catch (e) {
      return true; // Changed: assume user exists on error to avoid blocking registration
    }
  }

  Future<void> _clearInvalidSession() async {
    try {
      await _storage.deleteAll(); // Clear all stored data including user_email
      user.value = null;
      accessToken.value = '';
      
      // Clear listing data when clearing invalid session
      try {
        if (Get.isRegistered<ListingInputController>()) {
          final listingController = Get.find<ListingInputController>();
          listingController.clearAllData();
        }
      } catch (e) {
      }
      
    } catch (e) {
    }
  }

  Future<String?> getAccessToken() async {
    final raw = await _storage.read(key: "samsar_user_data");
    if (raw != null) {
      final parsed = jsonDecode(raw);
      return parsed['data']?['tokens']?['accessToken'];
    }
    return null;
  }

  Future<void> _checkLocalLogin() async {
    // final token = await _storage.read(key: 'samsar_access_token');
    final userJson = await _storage.read(key: 'samsar_user_data');

    if (userJson != null) {
      // accessToken.value = token;
      user.value = User.fromJson(jsonDecode(userJson));
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      loadingDialog('authenticating'.tr);

      final result = await _authApiServices.loginService(email, password);

      Get.back(); // Close dialog

      if (result.apiError != null) {
        String errorMessage = "Unexpected error occurred";

        // Extract error code and message
        final errorCode = result.apiError?.errorResponse?.error?.code;
        final originalMessage = result.apiError?.errorResponse?.error?.message;

        // Handle specific authentication errors
        if (errorCode == 'USER_NOT_FOUND') {
          errorMessage = 'account_does_not_exist'.tr;
          await logout(); // Clear local session
          return;
        } else if (errorCode == 'ACCOUNT_INACTIVE') {
          errorMessage = 'account_inactive'.tr;
          await logout(); // Clear local session
          return;
        } else if (errorCode == 'EMAIL_NOT_VERIFIED') {
          errorMessage = 'email_not_verified_login'.tr;
          return;
        } else if (originalMessage != null &&
            originalMessage.contains("Rate limit exceeded")) {
          final retryTime = ErrorMessageMapper.extractRetryTime(
            originalMessage,
          );
          errorMessage = ErrorMessageMapper.getErrorMessage(
            'RATE_LIMIT_EXCEEDED',
            retryAfter: retryTime,
          );
        } else {
          errorMessage = ErrorMessageMapper.getErrorMessage(errorCode);
        }

        showCustomSnackbar(errorMessage, true);
        return;
      }

      if (result.apiError?.fastifyErrorResponse != null) {
        final message =
            result.apiError?.fastifyErrorResponse?.message ??
            'validation_error'.tr;
        showCustomSnackbar("${'validation_error'.tr}: $message", true);
        return;
      }

      final rawData = result.successResponse;

      if (rawData == null) {
        showCustomSnackbar('something_went_wrong'.tr, true);
        return;
      }

      final loginModel = LoginModel.fromJson(rawData);
      user.value = loginModel.data?.user;
      accessToken.value = loginModel.data?.tokens?.accessToken ?? "";

      if (user.value == null) {
        isLoading.value = false;

        showCustomSnackbar('user_not_present'.tr, true);
        return;
      }

      await _storage.write(
        key: 'samsar_user_data',
        value: jsonEncode(loginModel.toJson()),
      );
      await _storage.write(key: 'user_email', value: user.value?.email ?? "");

      // Send FCM token to backend after successful login
      _sendFCMTokenToBackend();

      Get.offAll(() => const HomeView());
      showCustomSnackbar('login_successful'.tr, false);
    } catch (e) {
      Get.back();
      showCustomSnackbar(
        'login_failed'.trParams({'error': e.toString()}),
        true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String userName,
    required String password,
  }) async {
    try {
      registerLoading.value = true;
      loadingDialog('registering'.tr);

      final result = await _authApiServices.registerService(
        name: name,
        email: email,
        username: userName,
        password: password,
      );

      Get.back();

      if (result.apiError?.errorResponse != null) {
        final errorCode = result.apiError?.errorResponse?.error?.code;
        final originalMessage =
            result.apiError?.errorResponse?.error?.message ??
            'Registration failed';

        String errorMessage;

        // Handle rate limiting first
        if (originalMessage.contains("Rate limit exceeded")) {
          final retryTime = ErrorMessageMapper.extractRetryTime(
            originalMessage,
          );
          errorMessage = ErrorMessageMapper.getErrorMessage(
            'RATE_LIMIT_EXCEEDED',
            retryAfter: retryTime,
          );
        } else {
          // Use error mapper for other errors
          errorMessage = ErrorMessageMapper.getErrorMessage(errorCode);
        }

        showCustomSnackbar(errorMessage, true);
        return;
      }

      // Success - verification code sent
      showCustomSnackbar('registration_successful'.tr, false);
    } catch (e) {
      Get.back();
      showCustomSnackbar(
        'registration_failed'.trParams({'error': e.toString()}),
        true,
      );
    } finally {
      registerLoading.value = false;
    }
  }

  Future<void> verifyCode(String email, String code) async {
    try {
      isLoading.value = true;
      loadingDialog('verifying_code'.tr);

      final result = await _authApiServices.verifyCodeService(
        email: email,
        code: code,
      );

      Get.back();

      // Check if there's an error
      if (result.apiError != null) {
        final errorCode = result.apiError?.errorResponse?.error?.code;
        final errorMessage =
            result.apiError?.errorResponse?.error?.message ??
            'Verification failed';

        switch (errorCode) {
          case 'INVALID_CODE':
            showCustomSnackbar('invalid_code'.tr, true);
            break;
          case 'CODE_EXPIRED':
            showCustomSnackbar('code_expired'.tr, true);
            break;
          case 'ALREADY_VERIFIED':
            showCustomSnackbar('already_verified'.tr, false);
            break;
          default:
            showCustomSnackbar(errorMessage, true);
        }
        return;
      }

      // Success case - verification completed
      showCustomSnackbar('registration_successful'.tr, false);
      await Future.delayed(const Duration(seconds: 1));
      Get.offAll(() => LoginView());
    } catch (e) {
      Get.back();
      showCustomSnackbar(
        'verification_failed'.trParams({'error': e.toString()}),
        true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendVerification(String email) async {
    try {
      isLoading.value = true;
      loadingDialog('sending_verification_code'.tr);

      final result = await _authApiServices.resendVerificationService(
        email: email,
      );

      Get.back();

      if (result.apiError?.errorResponse != null) {
        final errorCode = result.apiError?.errorResponse?.error?.code;
        final errorMessage =
            result.apiError?.errorResponse?.error?.message ??
            'Failed to resend verification code';
        final retryAfter = result.apiError?.errorResponse?.error?.retryAfter;

        switch (errorCode) {
          case 'RESEND_RATE_LIMITED':
            if (retryAfter != null) {
              showCustomSnackbar(
                'resend_rate_limited'.trParams({
                  'seconds': retryAfter.toString(),
                }),
                true,
              );
            } else {
              showCustomSnackbar(
                'resend_rate_limited'.trParams({'seconds': '60'}),
                true,
              );
            }
            break;
          case 'ALREADY_VERIFIED':
            showCustomSnackbar('already_verified'.tr, false);
            break;
          case 'EMAIL_SEND_FAILED':
            showCustomSnackbar('email_send_failed'.tr, true);
            break;
          default:
            showCustomSnackbar(errorMessage, true);
        }
        return;
      }

      if (result.apiError?.fastifyErrorResponse != null) {
        showCustomSnackbar(
          result.apiError?.fastifyErrorResponse?.message ?? 'resend_failed'.tr,
          true,
        );
        return;
      }

      showCustomSnackbar('code_sent_again'.tr, false);
    } catch (e) {
      Get.back();
      showCustomSnackbar(
        'resend_failed'.trParams({'error': e.toString()}),
        true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    user.value = null;
    accessToken.value = '';
    
    // Clear listing data to prevent cached data from appearing in new sessions
    try {
      if (Get.isRegistered<ListingInputController>()) {
        final listingController = Get.find<ListingInputController>();
        listingController.clearAllData();
      }
    } catch (e) {
    }
    
    Get.offAll(() => LoginView());
    showCustomSnackbar('logout_successful'.tr, true);
  }

  Future<void> updateProfile({
    required String name,
    required String username,
    required String bio,
    required String street,
    required String city,
    String? phone,
    File? profileImage,
  }) async {
    try {
      isLoading.value = true;
      loadingDialog('updating_profile'.tr);


      if (user.value?.id == null) {
        Get.back();
        showCustomSnackbar(
          'User session is invalid. Please log in again.'.tr,
          true,
        );
        return;
      }

      final token = await _storage.read(key: "samsar_user_data");
      if (token == null) {
        Get.back();
        showCustomSnackbar(
          'Authentication token not found. Please log in again.'.tr,
          true,
        );
        return;
      }

      final userData = jsonDecode(token);
      final accessToken = userData['data']['tokens']['accessToken'];


      final response = await _authApiServices.updateProfileService(
        token: accessToken,
        name: name,
        username: username,
        bio: bio,
        street: street,
        city: city,
        phone: phone,
        profileImage: profileImage,
      );

      Get.back();


      if (response.apiError != null) {
        showCustomSnackbar(
          response.apiError?.errorResponse?.error?.message ??
              'Failed to update profile'.tr,
          true,
        );
        return;
      }

      if (response.successResponse == null) {
        showCustomSnackbar('no_response_data'.tr, true);
        return;
      }

      // Check if the response contains user data
      if (response.successResponse!.containsKey('data') &&
          response.successResponse!['data'] != null) {
        final updatedUser = User.fromJson(response.successResponse!['data']);
        user.value = updatedUser;

        final raw = await _storage.read(key: "samsar_user_data");
        if (raw != null) {
          final loginData = jsonDecode(raw);
          loginData['data']['user'] = updatedUser.toJson();
          await _storage.write(
            key: "samsar_user_data",
            value: jsonEncode(loginData),
          );
        }
      } else {
        // API returned success but no user data - update local user with current values

        // If we uploaded a profile image, fetch the updated user profile
        if (profileImage != null) {
          try {
            await fetchUserProfile(); // This will fetch and update the user profile with the new image URL
            showCustomSnackbar('profile_updated_successfully'.tr, false);
            user.refresh();
            return; // Exit early since fetchUserProfile() already updated the user
          } catch (e) {
            // Continue with local update as fallback
          }
        }

        if (user.value != null) {
          user.value = User(
            id: user.value!.id,
            email: user.value!.email,
            username: username,
            role: user.value!.role,
            createdAt: user.value!.createdAt,
            updatedAt: DateTime.now(),
            phone: phone ?? '',
            profilePicture: profileImage != null
                ? (response.successResponse?['data']?['profilePicture'] ??
                      user.value!.profilePicture)
                : user.value!.profilePicture,
            bio: bio,
            name: name,
            dateOfBirth: user.value!.dateOfBirth,
            street: street,
            city: city,
            allowMessaging: user.value!.allowMessaging,
            listingNotifications: user.value!.listingNotifications,
            messageNotifications: user.value!.messageNotifications,
            loginNotifications: user.value!.loginNotifications,
            showEmail: user.value!.showEmail,
            showOnlineStatus: user.value!.showOnlineStatus,
            showPhoneNumber: user.value!.showPhoneNumber,
            privateProfile: user.value!.privateProfile,
          );

          // Update local storage with new values
          final raw = await _storage.read(key: "samsar_user_data");
          if (raw != null) {
            final loginData = jsonDecode(raw);
            loginData['data']['user']['name'] = name;
            loginData['data']['user']['username'] = username;
            loginData['data']['user']['bio'] = bio;
            loginData['data']['user']['street'] = street;
            loginData['data']['user']['city'] = city;
            loginData['data']['user']['phone'] = phone;
            if (response.successResponse?['data']?['profilePicture'] != null) {
              loginData['data']['user']['profilePicture'] =
                  response.successResponse!['data']['profilePicture'];
            }
            await _storage.write(
              key: "samsar_user_data",
              value: jsonEncode(loginData),
            );
          }
        }
      }

      showCustomSnackbar('profile_updated_successfully'.tr, false);

      // Force refresh user state to ensure immediate UI update
      user.refresh();
    } catch (e, stackTrace) {
      Get.back();
      showCustomSnackbar(
        'profile_update_error'.trParams({'error': e.toString()}),
        true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      final token = await _storage.read(key: "samsar_user_data");
      if (token == null) {
        return;
      }

      final userData = jsonDecode(token);
      final accessToken = userData['data']['tokens']['accessToken'];


      final response = await _authApiServices.getUserProfile(accessToken);


      if (response.successResponse != null &&
          response.successResponse!['data'] != null) {
        final updatedUser = User.fromJson(response.successResponse!['data']);

        user.value = updatedUser;

        // Update local storage
        final raw = await _storage.read(key: "samsar_user_data");
        if (raw != null) {
          final loginData = jsonDecode(raw);
          loginData['data']['user'] = updatedUser.toJson();
          await _storage.write(
            key: "samsar_user_data",
            value: jsonEncode(loginData),
          );
        } else {
        }

      } else {
        showCustomSnackbar('fetch_profile_failed'.tr, true);
      }
    } catch (e) {
    }
  }

  // Send FCM token to backend after login
  Future<void> _sendFCMTokenToBackend() async {
    try {
      final token = await FirebaseMessagingService.getToken();
      if (token != null) {
      } else {
      }
    } catch (e) {
    }
  }
}
