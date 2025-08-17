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
      print('🔄 Starting session restoration...');
      final raw = await _storage.read(key: "samsar_user_data");
      
      if (raw != null) {
        print('📱 Found stored session data');
        final json = jsonDecode(raw);
        final loginModel = LoginModel.fromJson(json);

        if (loginModel.data?.user != null && loginModel.data?.tokens?.accessToken != null) {
          user.value = loginModel.data!.user;
          accessToken.value = loginModel.data!.tokens!.accessToken!;
          print('✅ Session restored successfully');
          print('👤 User: ${user.value?.name}');
          print('🔑 Token: ${accessToken.value.substring(0, 10)}...');
          print('🖼️ Profile Picture: ${user.value?.profilePicture}');
        } else {
          print('❌ Invalid session data structure');
          await _clearInvalidSession();
        }
      } else {
        print('ℹ️ No stored session found - user needs to login');
      }
    } catch (e) {
      print('❌ Failed to restore session: $e');
      await _clearInvalidSession();
    } finally {
      // Always mark session restoration as complete
      isSessionRestored.value = true;
      print('🏁 Session restoration completed. Authenticated: ${isAuthenticated}');
    }
  }

  Future<void> _clearInvalidSession() async {
    try {
      await _storage.delete(key: "samsar_user_data");
      user.value = null;
      accessToken.value = '';
      print('🧹 Cleared invalid session data');
    } catch (e) {
      print('❌ Error clearing invalid session: $e');
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
      loadingDialog('Authenticating...');

      final result = await _authApiServices.loginService(email, password);

      Get.back(); // Close dialog

      if (result.apiError != null) {
        showCustomSnackbar(
          result.apiError?.errorResponse?.error?.message ?? "Unexpected error occured",
          true
        );
        return;
      }

      if (result.apiError?.fastifyErrorResponse != null) {
        showCustomSnackbar(
          result.apiError?.fastifyErrorResponse?.message ?? "Unexpected error occurred", 
          true,
        );
        return;
      }


      final rawData = result.successResponse;

      if (rawData == null) {
        showCustomSnackbar("Something went wrong. Try again later.", true);
        return;
      }

      final loginModel = LoginModel.fromJson(rawData);
      user.value = loginModel.data?.user;
      accessToken.value = loginModel.data?.tokens?.accessToken ?? "";


      if(user.value == null) {
        isLoading.value = false;

        showCustomSnackbar("User is not present", true);
        return;
      }



      await _storage.write(key: 'samsar_user_data', value: jsonEncode(loginModel.toJson()));


      Get.offAll(() => const HomeView());
      showCustomSnackbar("Login successful", false);
    } catch (e) {
      Get.back();
      showCustomSnackbar("Login failed: $e", true);
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
      loadingDialog('Registering...');

      final result = await _authApiServices.registerService(
        name: name,
        email: email,
        username: userName,
        password: password
      );

      Get.back();

      if (result.apiError?.errorResponse != null) {
        final errorCode = result.apiError?.errorResponse?.error?.code;
        final errorMessage = result.apiError?.errorResponse?.error?.message ?? 'Registration failed';
        
        // Handle specific error cases with user-friendly messages
        switch (errorCode) {
          case 'USER_ALREADY_VERIFIED':
            showCustomSnackbar('user_already_verified'.tr, true);
            break;
          case 'REGISTRATION_RATE_LIMITED':
            final retryAfter = result.apiError?.errorResponse?.error?.retryAfter;
            if (retryAfter != null) {
              showCustomSnackbar('registration_rate_limited'.trParams({'seconds': retryAfter.toString()}), true);
            } else {
              showCustomSnackbar('registration_rate_limited'.trParams({'seconds': '60'}), true);
            }
            break;
          case 'EMAIL_SEND_FAILED':
            showCustomSnackbar('email_send_failed'.tr, true);
            break;
          case 'DATABASE_ERROR':
            showCustomSnackbar('database_error'.tr, true);
            break;
          default:
            showCustomSnackbar(errorMessage, true);
        }
        return;
      }

      // Success - verification code sent
      showCustomSnackbar('registration_successful'.tr, false);
    } catch (e) {
      Get.back();
      showCustomSnackbar('Registration failed: $e', true);
    } finally {
      registerLoading.value = false;
    }
  }

  Future<void> verifyCode(String email, String code) async {
    try {
      isLoading.value = true;
      loadingDialog('Verifying code...');

      final result = await _authApiServices.verifyCodeService(email: email, code: code);

      Get.back();

      // Check if there's an error
      if (result.apiError != null) {
        final errorCode = result.apiError?.errorResponse?.error?.code;
        final errorMessage = result.apiError?.errorResponse?.error?.message ?? 'Verification failed';
        
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
      showCustomSnackbar('Verification failed: $e', true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendVerification(String email) async {
    try {
      isLoading.value = true;
      loadingDialog('Sending verification code...');

      final result = await _authApiServices.resendVerificationService(email: email);

      Get.back();

      if (result.apiError?.errorResponse != null) {
        final errorCode = result.apiError?.errorResponse?.error?.code;
        final errorMessage = result.apiError?.errorResponse?.error?.message ?? 'Failed to resend verification code';
        final retryAfter = result.apiError?.errorResponse?.error?.retryAfter;
        
        switch (errorCode) {
          case 'RESEND_RATE_LIMITED':
            if (retryAfter != null) {
              showCustomSnackbar('resend_rate_limited'.trParams({'seconds': retryAfter.toString()}), true);
            } else {
              showCustomSnackbar('resend_rate_limited'.trParams({'seconds': '60'}), true);
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
        showCustomSnackbar(result.apiError?.fastifyErrorResponse?.message ?? 'Failed to resend verification code', true);
        return;
      }

      showCustomSnackbar('code_sent_again'.tr, false);
    } catch (e) {
      Get.back();
      showCustomSnackbar('Failed to resend verification code: $e', true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    user.value = null;
    accessToken.value = '';
    Get.offAll(() => LoginView());
    showCustomSnackbar('Logged out successfully', true);
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
      loadingDialog('Updating profile...');

      print('Starting profile update...');
      print('Current user: ${user.value?.toJson()}');

      if (user.value?.id == null) {
        Get.back();
        showCustomSnackbar('User session is invalid. Please log in again.', true);
        return;
      }

      final token = await _storage.read(key: "samsar_user_data");
      if (token == null) {
        Get.back();
        showCustomSnackbar('Authentication token not found. Please log in again.', true);
        return;
      }

      final userData = jsonDecode(token);
      final accessToken = userData['data']['tokens']['accessToken'];
      print('Using access token: ${accessToken.substring(0, 10)}...');

      print('Sending profile data:');
      print('Name: $name');
      print('Username: $username');
      print('Bio: $bio');
      print('Street: $street');
      print('City: $city');
      print('Phone: $phone');
      print('Profile image: ${profileImage?.path}');

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

      print('Profile update response: ${response.toString()}');

      if (response.apiError != null) {
        print('API Error: ${response.apiError}');
        showCustomSnackbar(
          response.apiError?.errorResponse?.error?.message ?? 'Failed to update profile',
          true,
        );
        return;
      }

      if (response.successResponse == null) {
        print('No response data received');
        showCustomSnackbar('No response data received', true);
        return;
      }

      // Check if the response contains user data
      if (response.successResponse!.containsKey('data') && response.successResponse!['data'] != null) {
        final updatedUser = User.fromJson(response.successResponse!['data']);
        user.value = updatedUser;

        final raw = await _storage.read(key: "samsar_user_data");
        if (raw != null) {
          final loginData = jsonDecode(raw);
          loginData['data']['user'] = updatedUser.toJson();
          await _storage.write(key: "samsar_user_data", value: jsonEncode(loginData));
        }
      } else {
        // API returned success but no user data - update local user with current values
        print('API returned success but no user data, updating local user');
        
        // If we uploaded a profile image, fetch the updated user profile
        if (profileImage != null) {
          print('Profile image was uploaded, fetching updated user profile...');
          try {
            await fetchUserProfile(); // This will fetch and update the user profile with the new image URL
            showCustomSnackbar('Profile updated successfully!', false);
            print('Profile update completed successfully');
            user.refresh();
            return; // Exit early since fetchUserProfile() already updated the user
          } catch (e) {
            print('Failed to fetch updated profile: $e');
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
            profilePicture: profileImage != null ? (response.successResponse?['data']?['profilePicture'] ?? user.value!.profilePicture) : user.value!.profilePicture,
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
              loginData['data']['user']['profilePicture'] = response.successResponse!['data']['profilePicture'];
            }
            await _storage.write(key: "samsar_user_data", value: jsonEncode(loginData));
          }
        }
      }

      showCustomSnackbar('Profile updated successfully!', false);
      print('Profile update completed successfully');
      
      // Force refresh user state to ensure immediate UI update
      user.refresh();
    } catch (e, stackTrace) {
      Get.back();
      print('Profile update error: $e');
      print('Stack trace: $stackTrace');
      showCustomSnackbar('Error updating profile: $e', true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserProfile() async {
    try {
      final token = await _storage.read(key: "samsar_user_data");
      if (token == null) {
        print('No token found for profile fetch');
        return;
      }

      final userData = jsonDecode(token);
      final accessToken = userData['data']['tokens']['accessToken'];
      
      print('🔍 Fetching user profile from: $getUserProfileRoute');
      print('🔑 Using access token: ${accessToken.substring(0, 20)}...');
      
      final response = await _authApiServices.getUserProfile(accessToken);
      
      print('📥 Profile fetch response: ${response.toString()}');
      print('✅ Success response: ${response.successResponse}');
      print('❌ Error response: ${response.apiError?.message ?? "Unknown error"}');
      
      if (response.successResponse != null && response.successResponse!['data'] != null) {
        final updatedUser = User.fromJson(response.successResponse!['data']);
        print('🔄 Updating user profile...');
        print('🖼️ New profile picture URL: ${updatedUser.profilePicture}');
        
        user.value = updatedUser;
        
        // Update local storage
        final raw = await _storage.read(key: "samsar_user_data");
        if (raw != null) {
          final loginData = jsonDecode(raw);
          loginData['data']['user'] = updatedUser.toJson();
          await _storage.write(key: "samsar_user_data", value: jsonEncode(loginData));
          print('✅ Local storage updated with new profile picture');
        } else {
          print('❌ Failed to update local storage - no existing data found');
        }
        
        print('✅ User profile updated successfully with new data');
      } else {
        print('Failed to fetch updated user profile');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }
}
