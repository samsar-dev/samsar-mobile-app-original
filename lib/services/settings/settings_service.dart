import 'package:dio/dio.dart';
import 'package:samsar/constants/api_route_constants.dart';
import 'package:samsar/models/api_error.dart';
import 'package:samsar/models/api_response.dart';

class SettingsService {
  final Dio _dio = Dio();

  Future<ApiResponse<Map<String, dynamic>>> getUserSettingsService(
    String accessToken,
  ) async {
    try {
      final response = await _dio.get(
        getSettingsRoute,
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
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
        ApiError(fastifyErrorResponse: null, errorResponse: null),
      );
    } catch (e) {
      return ApiResponse.failure(
        ApiError(fastifyErrorResponse: null, errorResponse: null),
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> updateUserSettingsService({
    required String accessToken,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      final response = await _dio.post(
        getSettingsRoute, // Backend expects POST for settings update
        data: requestBody,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
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
        ApiError(fastifyErrorResponse: null, errorResponse: null),
      );
    } catch (e) {
      return ApiResponse.failure(
        ApiError(fastifyErrorResponse: null, errorResponse: null),
      );
    }
  }
}
