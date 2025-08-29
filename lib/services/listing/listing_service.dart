import 'package:dio/dio.dart';
import 'package:samsar/models/api_error.dart';
import 'package:samsar/models/api_response.dart';

class ListingService {
  final Dio _dio = Dio();

  Future<ApiResponse<Map<String, dynamic>>> getListingsService({
    String? mainCategory,
    String? subCategory,
    String? listingAction,
    String? sortBy,
    String? sortOrder,
    int? year,
    int? builtYear,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 10,
    bool forceRefresh = false,
  }) async {
    try {
      // Use main listings endpoint
      const String listingsEndpoint =
          "https://samsar-backend-production.up.railway.app/api/listings";

      // Build query parameters
      Map<String, dynamic> queryParams = {};

      // Add cache-busting parameter for refresh
      if (forceRefresh) {
        queryParams['_t'] = DateTime.now().millisecondsSinceEpoch;
      }

      // Debug logging

      final response = await _dio.get(
        listingsEndpoint,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.statusCode == 200) {

        // Transform the response to match expected format
        final transformedData = {
          'data': {'items': response.data['data']},
        };

        return ApiResponse.success(transformedData);
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
