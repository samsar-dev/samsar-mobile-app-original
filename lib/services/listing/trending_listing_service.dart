import 'package:dio/dio.dart';
import 'package:samsar/models/api_error.dart';
import 'package:samsar/models/api_response.dart';

class TrendingListingService {
  final Dio _dio = Dio();

  Future<ApiResponse<Map<String, dynamic>>> getTrendingListingsService({
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
      // Use trending endpoint (Railway backend doesn't have the new filter parameters yet)
      const String listingsEndpoint = "https://samsar-backend-production.up.railway.app/api/listings/trending";
      
      // Trending endpoint doesn't accept parameters, so we'll do client-side filtering
      Map<String, dynamic> queryParams = {};
      
      // Debug logging
      print('🌐 TRENDING SERVICE API CALL:');
      print('  Endpoint: $listingsEndpoint');
      print('  Query params: $queryParams');
      
      final response = await _dio.get(listingsEndpoint);

      if (response.statusCode == 200) {
        print('✅ TRENDING SERVICE SUCCESS');
        print('  Items count: ${response.data['data']['items'].length}');
        
        // Print all item titles and years for debugging
        final items = response.data['data']['items'] as List;
        for (int i = 0; i < items.length; i++) {
          final item = items[i];
          print('  Item $i: ${item['title']} - year: ${item['year']}, yearBuilt: ${item['yearBuilt']}');
        }
        return ApiResponse.success(response.data as Map<String, dynamic>);
      } else {
        print('❌ TRENDING SERVICE ERROR: ${response.statusCode}');
        return ApiResponse.failure(ApiError.fromJson(response.data));
      }

    } on DioException catch (dioError) {
      print('❌ TRENDING SERVICE DIO ERROR: ${dioError.message}');
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
      print('❌ TRENDING SERVICE GENERAL ERROR: $e');
      return ApiResponse.failure(
        ApiError(
          fastifyErrorResponse: null,
          errorResponse: null,
        ),
      );
    }
  }
}
