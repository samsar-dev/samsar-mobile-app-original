import 'package:get/get.dart';

class ErrorMessageMapper {
  /// Maps backend error codes to user-friendly messages
  static String getErrorMessage(String? errorCode, {String? retryAfter}) {
    switch (errorCode?.toUpperCase()) {
      // Authentication Errors
      case 'INVALID_CREDENTIALS':
        return 'invalid_credentials_message'.tr;
      case 'USER_NOT_FOUND':
        return 'user_not_found_message'.tr;
      case 'UNAUTHORIZED':
        return 'unauthorized_message'.tr;
      case 'TOKEN_EXPIRED':
        return 'token_expired_message'.tr;
      case 'INVALID_TOKEN':
        return 'invalid_token_message'.tr;
      
      // Validation Errors
      case 'VALIDATION_ERROR':
        return 'validation_error_message'.tr;
      case 'INVALID_INPUT':
        return 'invalid_input_message'.tr;
      case 'INVALID_PASSWORD':
        return 'invalid_password_message'.tr;
      case 'WEAK_PASSWORD':
        return 'weak_password_message'.tr;
      
      // Registration/Email Errors
      case 'EMAIL_ALREADY_EXISTS':
        return 'email_already_exists_message'.tr;
      case 'USERNAME_TAKEN':
        return 'username_taken_message'.tr;
      case 'ALREADY_VERIFIED':
        return 'already_verified_message'.tr;
      
      // Verification Errors
      case 'INVALID_CODE':
        return 'invalid_code_message'.tr;
      case 'CODE_EXPIRED':
        return 'code_expired_message'.tr;
      case 'EMAIL_SEND_FAILED':
        return 'email_send_failed_message'.tr;
      
      // Server Errors
      case 'SERVER_ERROR':
      case 'INTERNAL_ERROR':
        return 'server_error_message'.tr;
      case 'AUTH_ERROR':
        return 'auth_error_message'.tr;
      
      // Rate Limiting
      case 'RATE_LIMIT_EXCEEDED':
        if (retryAfter != null) {
          return 'rate_limit_exceeded_with_time'.trParams({'time': retryAfter});
        }
        return 'rate_limit_exceeded_message'.tr;
      
      // Default
      default:
        return 'unexpected_error'.tr;
    }
  }

  /// Extracts retry time from rate limit error message
  static String? extractRetryTime(String? message) {
    if (message == null) return null;
    
    // Extract minutes from "Rate limit exceeded, retry in X minutes"
    final regex = RegExp(r'retry in (\d+) minutes?');
    final match = regex.firstMatch(message);
    if (match != null) {
      final minutes = int.tryParse(match.group(1) ?? '');
      if (minutes != null) {
        if (minutes >= 60) {
          final hours = (minutes / 60).floor();
          final remainingMinutes = minutes % 60;
          if (remainingMinutes == 0) {
            return hours == 1 ? '1 hour' : '$hours hours';
          } else {
            return '$hours hour${hours > 1 ? 's' : ''} and $remainingMinutes minute${remainingMinutes > 1 ? 's' : ''}';
          }
        } else {
          return minutes == 1 ? '1 minute' : '$minutes minutes';
        }
      }
    }
    
    return null;
  }

  /// Handles Railway rate limiting responses
  static String handleRateLimitResponse(Map<String, dynamic>? responseData) {
    if (responseData == null) return getErrorMessage('RATE_LIMIT_EXCEEDED');
    
    final message = responseData['message'] as String?;
    final retryTime = extractRetryTime(message);
    
    return getErrorMessage('RATE_LIMIT_EXCEEDED', retryAfter: retryTime);
  }
}
