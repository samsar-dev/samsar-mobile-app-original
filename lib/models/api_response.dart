import 'package:samsar/models/api_error.dart';

class ApiResponse<T> {
  final T? successResponse;
  final ApiError? apiError;

  ApiResponse({
    this.successResponse,
    this.apiError,
  });

  /// Check if the API call was successful
  bool get isSuccess => apiError == null;

  /// Get error message if any
  String get message => apiError?.message ?? 'No error';

  /// Factory constructor to create a success response
  factory ApiResponse.success(T data) {
    return ApiResponse<T>(
      successResponse: data,
      apiError: null,
    );
  }

  /// Factory constructor to create an error response
  factory ApiResponse.failure(ApiError error) {
    return ApiResponse<T>(
      successResponse: null,
      apiError: error,
    );
  }
}
