import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:samsar/models/listing/listing_response.dart';
import 'package:samsar/constants/api_route_constants.dart';
import 'package:samsar/widgets/custom_snackbar/custom_snackbar.dart';
import 'dart:convert';

class UserListingsController extends GetxController {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        "Accept-Encoding": "gzip, deflate",
      },
      responseType: ResponseType.json,
    ),
  );
  
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  // Observable variables
  var isLoading = false.obs;
  var userListings = <Item>[].obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserListings();
  }

  /// Fetch user's listings from backend
  Future<void> fetchUserListings() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      print('🔍 [USER LISTINGS] Fetching user listings...');

      // Get access token for authentication
      final token = await _getAccessToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.get(
        '/api/listings/user',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      
      print('🔍 [USER LISTINGS] Response status: ${response.statusCode}');
      print('🔍 [USER LISTINGS] Response data: ${response.data}');
      print('🔍 [USER LISTINGS] Response type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        // Handle different response formats
        if (response.data == null) {
          print('🔍 [USER LISTINGS] Response data is null - user has no listings');
          userListings.value = [];
          return;
        }

        // Check if response.data is the listings array directly
        if (response.data is List) {
          final listingsData = response.data as List;
          print('🔍 [USER LISTINGS] Direct array response with ${listingsData.length} listings');
          
          userListings.value = listingsData
              .map((listingJson) => Item.fromJson(listingJson))
              .toList();
        }
        // Check if response.data has success field
        else if (response.data is Map && response.data['success'] == true) {
          final data = response.data['data'];
          final listingsData = data['listings'] as List;
          
          print('🔍 [USER LISTINGS] Structured response with ${listingsData.length} listings');
          
          userListings.value = listingsData
              .map((listingJson) => Item.fromJson(listingJson))
              .toList();
        }
        // Check if response.data has data field directly
        else if (response.data is Map && response.data['data'] != null) {
          final data = response.data['data'];
          if (data['listings'] != null) {
            final listingsData = data['listings'] as List;
            print('🔍 [USER LISTINGS] Data field response with ${listingsData.length} listings');
            
            userListings.value = listingsData
                .map((listingJson) => Item.fromJson(listingJson))
                .toList();
          } else {
            print('🔍 [USER LISTINGS] Data field exists but no listings array');
            userListings.value = [];
          }
        }
        else {
          print('🔍 [USER LISTINGS] Unknown response format - treating as empty');
          userListings.value = [];
        }
            
        print('✅ [USER LISTINGS] Successfully loaded ${userListings.length} listings');
      } else {
        throw Exception('Failed to fetch user listings: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [USER LISTINGS] Error fetching listings: $e');
      hasError.value = true;
      
      if (e is DioException) {
        if (e.response?.statusCode == 401) {
          errorMessage.value = 'Please log in to view your listings';
        } else if (e.response?.statusCode == 404) {
          errorMessage.value = 'No listings found';
        } else {
          errorMessage.value = 'Failed to load listings. Please try again.';
        }
      } else {
        errorMessage.value = 'An unexpected error occurred';
      }
      
      showCustomSnackbar(errorMessage.value, true);
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh user listings
  Future<void> refreshListings() async {
    await fetchUserListings();
  }

  /// Delete a listing
  Future<void> deleteListing(String listingId) async {
    try {
      print('🔍 [USER LISTINGS] Deleting listing: $listingId');
      
      // Get access token for authentication
      final token = await _getAccessToken();
      if (token == null) {
        throw Exception('User not authenticated');
      }

      final response = await _dio.delete(
        '/api/listings/$listingId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Remove Content-Type header for DELETE requests to avoid empty body error
          },
          contentType: null,
        ),
      );
      
      print('🔍 [USER LISTINGS] Delete response status: ${response.statusCode}');
      print('🔍 [USER LISTINGS] Delete response data: ${response.data}');
      
      if (response.statusCode == 200) {
        // Handle different response formats
        bool success = false;
        
        if (response.data != null && response.data is Map) {
          success = response.data['success'] == true;
        } else if (response.statusCode == 200) {
          // Sometimes delete returns 200 with no body, which is also success
          success = true;
        }
        
        if (success) {
          // Remove from local list
          userListings.removeWhere((listing) => listing.id == listingId);
          showCustomSnackbar('Listing deleted successfully', false);
          print('✅ [USER LISTINGS] Listing deleted successfully');
        } else {
          throw Exception('Delete operation failed: ${response.data}');
        }
      } else {
        throw Exception('Failed to delete listing: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [USER LISTINGS] Error deleting listing: $e');
      
      // Enhanced error handling for DioException
      if (e is DioException) {
        print('🔍 [USER LISTINGS] DioException details:');
        print('  - Status code: ${e.response?.statusCode}');
        print('  - Response data: ${e.response?.data}');
        print('  - Request path: ${e.requestOptions.path}');
        print('  - Request headers: ${e.requestOptions.headers}');
        
        String errorMessage = 'Failed to delete listing';
        if (e.response?.statusCode == 400) {
          errorMessage = 'Bad request - ${e.response?.data?['error'] ?? 'Invalid request'}';
        } else if (e.response?.statusCode == 401) {
          errorMessage = 'Not authorized to delete this listing';
        } else if (e.response?.statusCode == 404) {
          errorMessage = 'Listing not found';
        } else if (e.response?.statusCode == 403) {
          errorMessage = 'Permission denied - you can only delete your own listings';
        }
        
        showCustomSnackbar(errorMessage, true);
      } else {
        showCustomSnackbar('Failed to delete listing', true);
      }
    }
  }

  /// Get listings count
  int get listingsCount => userListings.length;

  /// Check if user has listings
  bool get hasListings => userListings.isNotEmpty;

  /// Helper method to get access token from secure storage
  Future<String?> _getAccessToken() async {
    try {
      final raw = await _storage.read(key: "samsar_user_data");
      if (raw != null) {
        final userData = jsonDecode(raw);
        // Access token is nested in data.tokens.accessToken structure
        return userData['data']?['tokens']?['accessToken'];
      }
      return null;
    } catch (e) {
      print('❌ [USER LISTINGS] Error getting access token: $e');
      return null;
    }
  }
}
