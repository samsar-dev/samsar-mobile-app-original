import 'package:samsar/models/error/error_response.dart';
import 'package:samsar/models/error/fastify_error_response.dart';

class ApiError {
  final ErrorResponse? errorResponse;
  final FastifyErrorResponse? fastifyErrorResponse;

  ApiError({
    this.errorResponse,
    this.fastifyErrorResponse,
  });

  /// Create an ApiError from a JSON response
  /// Create an ApiError from a simple message string
  factory ApiError.fromMessage(String message) {
    return ApiError(
      errorResponse: ErrorResponse(
        success: false,
        error: Error(code: 'ERROR', message: message),
      ),
    );
  }

  factory ApiError.fromJson(Map<String, dynamic> json) {
    if (json['code'] == 'FST_ERR_VALIDATION' || json['validation'] != null) {
      return ApiError(
        fastifyErrorResponse: FastifyErrorResponse.fromJson(json),
      );
    } else {
      return ApiError(
        errorResponse: ErrorResponse.fromJson(json),
      );
    }
  }

  /// Get readable error message
 String get message =>
    fastifyErrorResponse?.message ??
    errorResponse?.error?.message ??
    'Unknown error';

}
