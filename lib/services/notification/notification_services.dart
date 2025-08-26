import 'package:dio/dio.dart';
import 'package:samsar/constants/api_route_constants.dart';
import 'package:samsar/models/api_error.dart';
import 'package:samsar/models/api_response.dart';

class NotificationServices {
  final _dio = Dio();

  Future<ApiResponse<Map<String, dynamic>>> getNotificationServices(
    String accessToken,
  ) async {
    try {
      final response = await _dio.get(
        getNotificationsRoute,
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
}
