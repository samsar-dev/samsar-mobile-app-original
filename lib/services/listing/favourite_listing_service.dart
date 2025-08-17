import 'package:dio/dio.dart';
import 'package:samsar/constants/api_route_constants.dart';
import 'package:samsar/models/api_error.dart';
import 'package:samsar/models/api_response.dart';


class FavouriteListingService {
  final Dio _dio = Dio();

  Future<ApiResponse<Map<String, dynamic>>> getFavouriteListingService(String token) async {
    try {
      final response = await _dio.get(
        getFavouriteListingRoute,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
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
        ApiError(
          fastifyErrorResponse: null,
          errorResponse: null,
        ),
      );
    } catch (e) {
      return ApiResponse.failure(
        ApiError(
          fastifyErrorResponse: null,
          errorResponse: null,
        ),
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> addFavouriteListingService({
    required String token,
    required String listingId,
  }) async {
    try {

      final response = await _dio.post(
        addListingToFavouriteRoute(listingId),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
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
        ApiError(
          fastifyErrorResponse: null,
          errorResponse: null,
        ),
      );
    } catch (e) {
      return ApiResponse.failure(
        ApiError(
          fastifyErrorResponse: null,
          errorResponse: null,
        ),
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> removeFavouriteListingService({
    required String token,
    required String listingId,
  }) async {
    try {

      print("We are executing this funtion🔥");
      final response = await _dio.delete(
        removeFavouriteListingRoute(listingId), 
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
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
        ApiError(
          fastifyErrorResponse: null,
          errorResponse: null,
        ),
      );
    } catch (e) {
      return ApiResponse.failure(
        ApiError(
          fastifyErrorResponse: null,
          errorResponse: null,
        ),
      );
    }
  }
}
