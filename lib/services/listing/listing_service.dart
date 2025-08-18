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
  }) async {
    try {
      // Use main listings endpoint
      const String listingsEndpoint = "https://samsar-backend-production.up.railway.app/api/listings";
      
      // Build query parameters
      Map<String, dynamic> queryParams = {};
      
      // Debug logging
      print('🌐 LISTING SERVICE API CALL:');
      print('  Endpoint: $listingsEndpoint');
      print('  Query params: $queryParams');
      
      final response = await _dio.get(listingsEndpoint);

      if (response.statusCode == 200) {
        print('✅ LISTINGS SERVICE SUCCESS');
        print('  Items count: ${response.data['data'].length}');
        
        // Transform the response to match expected format
        final transformedData = {
          'data': {
            'items': response.data['data']
          }
        };
        
        return ApiResponse.success(transformedData);
      } else {
        print('❌ LISTING SERVICE ERROR: ${response.statusCode}');
        return ApiResponse.failure(ApiError.fromJson(response.data));
      }

    } on DioException catch (dioError) {
      print('❌ LISTING SERVICE DIO ERROR: ${dioError.message}');
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
      print('❌ LISTING SERVICE GENERAL ERROR: $e');
      return ApiResponse.failure(
        ApiError(
          fastifyErrorResponse: null,
          errorResponse: null,
        ),
      );
    }
  }
}
