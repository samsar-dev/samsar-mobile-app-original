import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:samsar/models/api_response.dart';
import 'package:samsar/models/api_error.dart';
import 'package:samsar/constants/api_route_constants.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

class AuthApiServices {
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
        "Accept-Encoding": "gzip, deflate",
      },
      responseType: ResponseType.json,
    ),
  );

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Helper method to get access token from secure storage
  Future<String?> _getAccessToken() async {
    try {
      final raw = await _storage.read(key: "samsar_user_data");
      if (raw != null) {
        final json = jsonDecode(raw);
        return json['data']?['tokens']?['accessToken'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> loginService(
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        loginRoute,
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(response.data as Map<String, dynamic>);
      } else {
        // Handle unexpected status code with error body
        return ApiResponse.failure(ApiError.fromJson(response.data));
      }
    } on DioException catch (dioError) {
      // Handle specific HTTP error codes like 401, 403
      if (dioError.response != null) {
        final statusCode = dioError.response?.statusCode;
        if (statusCode == 401 || statusCode == 403) {
          return ApiResponse.failure(
            ApiError.fromMessage(('invalid_credentials_message').tr),
          );
        }

        // Try to parse a structured error from the response body
        if (dioError.response?.data != null) {
          return ApiResponse.failure(
            ApiError.fromJson(dioError.response!.data),
          );
        }
      }

      // Handle timeout, network, or other unexpected Dio errors
      return ApiResponse.failure(
        ApiError.fromMessage(('server_error_message').tr),
      );
    } catch (e) {
      // Handle unknown parsing or unexpected errors
      return ApiResponse.failure(
        ApiError(fastifyErrorResponse: null, errorResponse: null),
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> registerService({
    required String name,
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        registerRoute, // make sure this is defined in api_route_constants.dart
        data: {
          "name": name,
          "email": email,
          "username": username,
          "password": password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(response.data as Map<String, dynamic>);
      } else {
        return ApiResponse.failure(ApiError.fromJson(response.data));
      }
    } on DioException catch (dioError) {
      if (dioError.response != null && dioError.response?.data != null) {
        return ApiResponse.failure(ApiError.fromJson(dioError.response!.data));
      }

      return ApiResponse.failure(
        ApiError(fastifyErrorResponse: null, errorResponse: null),
      );
    } catch (e) {
      return ApiResponse.failure(
        ApiError(fastifyErrorResponse: null, errorResponse: null),
      );
    }
  }

  // Verify Code Service
  Future<ApiResponse<Map<String, dynamic>>> verifyCodeService({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _dio.post(
        verifyCodeRoute, // Make sure this is defined in your api_route_constants.dart
        data: {"email": email, "code": code},
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(response.data as Map<String, dynamic>);
      } else {
        return ApiResponse.failure(ApiError.fromJson(response.data));
      }
    } on DioException catch (dioError) {
      if (dioError.response != null && dioError.response?.data != null) {
        return ApiResponse.failure(ApiError.fromJson(dioError.response!.data));
      }

      return ApiResponse.failure(
        ApiError(errorResponse: null, fastifyErrorResponse: null),
      );
    } catch (e) {
      return ApiResponse.failure(
        ApiError(errorResponse: null, fastifyErrorResponse: null),
      );
    }
  }

  // Resend Verification Code Service
  Future<ApiResponse<Map<String, dynamic>>> resendVerificationService({
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        resendVerificationRoute,
        data: {"email": email},
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(response.data as Map<String, dynamic>);
      } else {
        return ApiResponse.failure(ApiError.fromJson(response.data));
      }
    } on DioException catch (dioError) {
      if (dioError.response != null && dioError.response?.data != null) {
        return ApiResponse.failure(ApiError.fromJson(dioError.response!.data));
      }

      return ApiResponse.failure(
        ApiError(errorResponse: null, fastifyErrorResponse: null),
      );
    } catch (e) {
      return ApiResponse.failure(
        ApiError(errorResponse: null, fastifyErrorResponse: null),
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> updateProfileService({
    required String token,
    required String name,
    required String username,
    required String bio,
    required String street,
    required String city,
    String? phone,
    File? profileImage,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'username': username,
        'bio': bio,
        'street': street,
        'city': city,
        'phone': phone ?? '',
      });

      if (profileImage != null) {

        formData.files.add(
          MapEntry(
            'profilePicture',
            await MultipartFile.fromFile(
              profileImage.path,
              filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
            ),
          ),
        );
      } else {
      }


      final response = await _dio.put(
        updateProfileRoute,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );


      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data != null) {
          return ApiResponse.success(response.data as Map<String, dynamic>);
        } else {
          // Success but no data returned
          return ApiResponse.success({
            'message': ('profile_updated_successfully').tr,
          });
        }
      } else {
        if (response.data != null) {
          final error = ApiError.fromJson(response.data);
          return ApiResponse.failure(error);
        } else {
          return ApiResponse.failure(
            ApiError.fromMessage(('profile_update_failed').tr),
          );
        }
      }
    } on DioException catch (dioError) {

      if (dioError.response != null && dioError.response?.data != null) {
        return ApiResponse.failure(ApiError.fromJson(dioError.response!.data));
      }

      return ApiResponse.failure(
        ApiError.fromMessage(('profile_update_failed').tr),
      );
    } catch (e) {
      return ApiResponse.failure(
        ApiError.fromMessage('${('unexpected_error').tr}: $e'),
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> getUserProfile(String token) async {
    try {

      final response = await _dio.get(
        getUserProfileRoute,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Accept-Encoding': 'gzip, deflate, br',
          },
          responseType: ResponseType.json,
        ),
      );


      if (response.statusCode == 200) {
        if (response.data != null) {
          return ApiResponse.success(response.data as Map<String, dynamic>);
        } else {
          return ApiResponse.failure(
            ApiError.fromMessage(('no_response_data').tr),
          );
        }
      } else {
        return ApiResponse.failure(ApiError.fromJson(response.data));
      }
    } on DioException catch (dioError) {

      if (dioError.response != null && dioError.response?.data != null) {
        return ApiResponse.failure(ApiError.fromJson(dioError.response!.data));
      }
      return ApiResponse.failure(
        ApiError.fromMessage(('fetch_profile_failed').tr),
      );
    } catch (e) {
      return ApiResponse.failure(
        ApiError.fromMessage('${('unexpected_error').tr}: $e'),
      );
    }
  }

  // Send email change verification code
  Future<ApiResponse<Map<String, dynamic>>> sendEmailChangeVerificationService(
    String newEmail,
  ) async {
    try {
      // Get the access token from storage
      final token = await _getAccessToken();

      if (token != null) {
      }

      if (token == null) {
        return ApiResponse.failure(
          ApiError.fromMessage(('unauthorized_message').tr),
        );
      }


      final response = await _dio.post(
        sendEmailChangeVerificationRoute,
        data: {"newEmail": newEmail},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );


      if (response.statusCode == 200) {
        return ApiResponse.success(response.data as Map<String, dynamic>);
      } else {
        return ApiResponse.failure(ApiError.fromJson(response.data));
      }
    } on DioException catch (dioError) {

      if (dioError.response != null && dioError.response?.data != null) {
        try {
          final apiError = ApiError.fromJson(dioError.response!.data);
          return ApiResponse.failure(apiError);
        } catch (parseError) {
          return ApiResponse.failure(
            ApiError.fromMessage(
              '${('server_error_message').tr}: ${dioError.response?.statusCode}',
            ),
          );
        }
      }
      return ApiResponse.failure(
        ApiError.fromMessage(
          '${('verification_send_failed').tr}: ${dioError.message}',
        ),
      );
    } catch (e, stackTrace) {
      return ApiResponse.failure(
        ApiError.fromMessage('${('unexpected_error').tr}: $e'),
      );
    }
  }

  // Change email with verification code
  Future<ApiResponse<Map<String, dynamic>>> changeEmailWithVerificationService(
    String verificationCode,
  ) async {
    try {
      // Get the access token from storage
      final token = await _getAccessToken();

      if (token == null) {
        return ApiResponse.failure(
          ApiError.fromMessage(('unauthorized_message').tr),
        );
      }


      final response = await _dio.post(
        changeEmailWithVerificationRoute,
        data: {"verificationCode": verificationCode},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );


      if (response.statusCode == 200) {
        return ApiResponse.success(response.data as Map<String, dynamic>);
      } else {
        return ApiResponse.failure(ApiError.fromJson(response.data));
      }
    } on DioException catch (dioError) {

      if (dioError.response != null && dioError.response?.data != null) {
        return ApiResponse.failure(ApiError.fromJson(dioError.response!.data));
      }
      return ApiResponse.failure(
        ApiError.fromMessage(('email_change_failed').tr),
      );
    } catch (e) {
      return ApiResponse.failure(
        ApiError.fromMessage('${('unexpected_error').tr}: $e'),
      );
    }
  }

  // Send forgot password verification code
  Future<ApiResponse<Map<String, dynamic>>> forgotPasswordService(
    String email,
  ) async {
    try {

      final response = await _dio.post(
        forgotPasswordRoute,
        data: {"email": email},
      );


      if (response.statusCode == 200) {
        return ApiResponse.success(response.data as Map<String, dynamic>);
      } else {
        return ApiResponse.failure(ApiError.fromJson(response.data));
      }
    } on DioException catch (dioError) {

      if (dioError.response != null && dioError.response?.data != null) {
        return ApiResponse.failure(ApiError.fromJson(dioError.response!.data));
      }
      return ApiResponse.failure(
        ApiError.fromMessage(('failed_to_send_reset_code').tr),
      );
    } catch (e) {
      return ApiResponse.failure(
        ApiError.fromMessage('${('unexpected_error').tr}: $e'),
      );
    }
  }

  // Reset password with verification code (forgot password flow)
  Future<ApiResponse<Map<String, dynamic>>> resetPasswordService({
    required String email,
    required String verificationCode,
    required String newPassword,
  }) async {
    try {

      final response = await _dio.post(
        changePasswordRoute,
        data: {
          "email": email,
          "verificationCode": verificationCode,
          "newPassword": newPassword,
        },
      );


      if (response.statusCode == 200) {
        return ApiResponse.success(response.data as Map<String, dynamic>);
      } else {
        return ApiResponse.failure(ApiError.fromJson(response.data));
      }
    } on DioException catch (dioError) {

      if (dioError.response != null && dioError.response?.data != null) {
        return ApiResponse.failure(ApiError.fromJson(dioError.response!.data));
      }
      return ApiResponse.failure(
        ApiError.fromMessage(('failed_to_reset_password').tr),
      );
    } catch (e) {
      return ApiResponse.failure(
        ApiError.fromMessage('${('unexpected_error').tr}: $e'),
      );
    }
  }

  // Change password (authenticated user)
  Future<ApiResponse<Map<String, dynamic>>> changePasswordService({
    required String currentPassword,
    required String newPassword,
    required String verificationCode,
  }) async {
    try {
      // Get the access token from storage
      final token = await _getAccessToken();

      if (token == null) {
        return ApiResponse.failure(
          ApiError.fromMessage(('unauthorized_message').tr),
        );
      }


      final response = await _dio.post(
        changePasswordRoute,
        data: {
          "currentPassword": currentPassword,
          "newPassword": newPassword,
          "verificationCode": verificationCode,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );


      if (response.statusCode == 200) {
        return ApiResponse.success(response.data as Map<String, dynamic>);
      } else {
        return ApiResponse.failure(ApiError.fromJson(response.data));
      }
    } on DioException catch (dioError) {

      if (dioError.response != null && dioError.response?.data != null) {
        return ApiResponse.failure(ApiError.fromJson(dioError.response!.data));
      }
      return ApiResponse.failure(
        ApiError.fromMessage(('failed_to_change_password').tr),
      );
    } catch (e) {
      return ApiResponse.failure(
        ApiError.fromMessage('${('unexpected_error').tr}: $e'),
      );
    }
  }

  // Send password change verification code (for authenticated users)
  Future<ApiResponse<Map<String, dynamic>>>
  sendPasswordChangeVerificationService({
    required String currentPassword,
  }) async {
    try {
      // Get the access token from storage
      final token = await _getAccessToken();

      if (token == null) {
        return ApiResponse.failure(
          ApiError.fromMessage(('auth_token_not_found').tr),
        );
      }

      // Get user email from secure storage
      final userEmail = await _storage.read(key: 'user_email');
      if (userEmail == null) {
        return ApiResponse.failure(ApiError.fromMessage(('email_missing').tr));
      }


      final response = await _dio.post(
        sendPasswordChangeVerificationRoute,
        data: {'email': userEmail, 'currentPassword': currentPassword},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );


      if (response.statusCode == 200) {
        return ApiResponse.success(response.data as Map<String, dynamic>);
      } else {
        return ApiResponse.failure(ApiError.fromJson(response.data));
      }
    } on DioException catch (dioError) {

      if (dioError.response != null && dioError.response?.data != null) {
        return ApiResponse.failure(ApiError.fromJson(dioError.response!.data));
      }
      return ApiResponse.failure(
        ApiError.fromMessage(('failed_to_send_verification_code').tr),
      );
    } catch (e) {
      return ApiResponse.failure(
        ApiError.fromMessage('${('unexpected_error').tr}: $e'),
      );
    }
  }

  // Update FCM Token
  Future<ApiResponse<Map<String, dynamic>>> updateFCMTokenService(
    String fcmToken,
  ) async {
    try {
      // Get the access token from storage
      final token = await _getAccessToken();

      if (token == null) {
        return ApiResponse.failure(
          ApiError.fromMessage(('unauthorized_message').tr),
        );
      }


      final response = await _dio.post(
        '/api/fcm/update-token', // FCM route
        data: {"fcmToken": fcmToken},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );


      if (response.statusCode == 200) {
        return ApiResponse.success(response.data as Map<String, dynamic>);
      } else {
        return ApiResponse.failure(ApiError.fromJson(response.data));
      }
    } on DioException catch (dioError) {

      if (dioError.response != null && dioError.response?.data != null) {
        return ApiResponse.failure(ApiError.fromJson(dioError.response!.data));
      }
      return ApiResponse.failure(
        ApiError.fromMessage(('failed_to_update_fcm_token').tr),
      );
    } catch (e) {
      return ApiResponse.failure(
        ApiError.fromMessage('${('unexpected_error').tr}: $e'),
      );
    }
  }
}
