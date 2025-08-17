import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/models/search/search_query.dart';
import 'package:samsar/services/search_history_service.dart';
import 'package:samsar/utils/fuzzy_search.dart';


class SearchModuleController extends GetxController{

  final Dio _dio = Dio();

  RxList<SearchIndividualListingModel> searchResults = <SearchIndividualListingModel>[].obs;
  RxList<SearchIndividualListingModel> allResults = <SearchIndividualListingModel>[].obs;
  RxList<String> searchSuggestions = <String>[].obs;
  RxList<String> searchHistory = <String>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  RxInt currentPage = 1.obs;
  RxString currentQuery = ''.obs;
  final int limit = 10;
  SearchQuery lastQuery = SearchQuery(query: '');
  
  @override
  void onInit() {
    super.onInit();
    _initializeSearchData();
  }
  
  /// Initialize search history and suggestions
  Future<void> _initializeSearchData() async {
    await SearchHistoryService.initializeDefaultSuggestions();
    await loadSearchHistory();
  }
  
  /// Load search history from storage
  Future<void> loadSearchHistory() async {
    final history = await SearchHistoryService.getSearchHistory();
    searchHistory.value = history;
  }
  
  /// Get search suggestions based on query
  Future<void> getSearchSuggestions(String query) async {
    if (query.trim().isEmpty) {
      searchSuggestions.clear();
      return;
    }
    
    final suggestions = await SearchHistoryService.getFilteredSuggestions(query, limit: 5);
    searchSuggestions.value = suggestions;
  }
  
  /// Save search query to history
  Future<void> saveSearchQuery(String query) async {
    if (query.trim().isNotEmpty) {
      await SearchHistoryService.saveSearchQuery(query);
      await loadSearchHistory();
    }
  }
  
  /// Clear search history
  Future<void> clearSearchHistory() async {
    await SearchHistoryService.clearSearchHistory();
    searchHistory.clear();
  }
  
  /// Apply local fuzzy search filter to results
  void applyFuzzyFilter(String query) {
    if (query.trim().isEmpty) {
      searchResults.value = allResults.toList();
      return;
    }
    
    final filtered = allResults.where((item) {
      final title = item.title ?? '';
      final description = item.description ?? '';
      final category = item.category?.mainCategory ?? '';
      final subCategory = item.category?.subCategory ?? '';
      
      return FuzzySearch.fuzzyMatch(query, title, threshold: 0.5) ||
             FuzzySearch.fuzzyMatch(query, description, threshold: 0.5) ||
             FuzzySearch.fuzzyMatch(query, category, threshold: 0.7) ||
             FuzzySearch.fuzzyMatch(query, subCategory, threshold: 0.7);
    }).toList();
    
    // Sort by relevance score
    filtered.sort((a, b) {
      final scoreA = FuzzySearch.getRelevanceScore(
        query, 
        a.title ?? '', 
        a.description ?? ''
      );
      final scoreB = FuzzySearch.getRelevanceScore(
        query, 
        b.title ?? '', 
        b.description ?? ''
      );
      return scoreB.compareTo(scoreA);
    });
    
    searchResults.value = filtered;
  }

  Future<void> searchController(SearchQuery query, {bool reset = false}) async {
    if (isLoading.value || (!hasMore.value && !reset)) return;

    if (reset) {
      searchResults.clear();
      allResults.clear();
      currentPage.value = 1;
      hasMore.value = true;
      lastQuery = query;
      currentQuery.value = query.query ?? '';
    }

    isLoading.value = true;

    try {
      // Save search query to history if it's a new search
      if (reset && query.query != null && query.query!.trim().isNotEmpty) {
        await saveSearchQuery(query.query!);
      }

      final queryParams = query.copyWith(page: currentPage.value, limit: limit).toQueryParams();
    
    // Debug: Print query parameters
    print('🔍 Search API Query Parameters:');
    queryParams.forEach((key, value) {
      print('  $key: $value');
    });
    
    // Always use search endpoint for simple text search
    String endpoint = "https://samsar-backend-production.up.railway.app/api/listings/search";
    Map<String, dynamic> apiParams = {
      'query': query.query,
      'category': query.category,
      'page': queryParams['page'],
      'limit': queryParams['limit'],
    };
    
    // Remove null values
    apiParams.removeWhere((key, value) => value == null);
    
    print('🔍 Using SEARCH endpoint for text search only');
    print('  Final API params:');
    apiParams.forEach((key, value) {
      print('    $key: $value');
    });
    
    final response = await _dio.get(
      endpoint,
      queryParameters: apiParams,
      options: Options(
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

      final data = response.data;

      if (data != null && data['success'] == true) {
        final items = data['data']['items'] as List? ?? [];
        final newResults = items.map((e) => SearchIndividualListingModel.fromJson(e)).toList();
        
        print('📊 API RESPONSE SUCCESS:');
        print('  Total items received: ${items.length}');
        print('  Parsed results: ${newResults.length}');
        print('  hasMore: ${data['data']['hasMore']}');
        
        if (reset) {
          print('  🔄 RESET: Replacing all results');
          allResults.value = newResults;
        } else {
          print('  ➕ APPEND: Adding to existing results');
          allResults.addAll(newResults);
        }
        
        print('  Total allResults count: ${allResults.length}');
        
        // Apply fuzzy search filter
        applyFuzzyFilter(currentQuery.value);
        
        print('  After fuzzy filter - searchResults count: ${searchResults.length}');
        
        hasMore.value = data['data']['hasMore'] ?? false;
        currentPage.value++;
        
        // Show success message only for new searches
        if (reset && newResults.isNotEmpty) {
          print('🎉 Showing success message: Found ${newResults.length} results');
          showCustomSnackbar("Found ${newResults.length} results", false);
        }
      } else {
        final errorMsg = data?['error'] ?? 'Unknown error occurred';
        showCustomSnackbar("Search failed: $errorMsg", true);
        return;
      }
      
    } on DioException catch (e) {
      String errorMessage = 'Network error occurred';
      
      if (e.type == DioExceptionType.sendTimeout) {
        errorMessage = 'Connection timeout. Please check your internet.';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Request timeout. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'Connection error. Please check your internet.';
      } else if (e.response?.statusCode == 404) {
        errorMessage = 'Search service not available.';
      } else if (e.response?.statusCode == 500) {
        errorMessage = 'Server error. Please try again later.';
      }
      
      showCustomSnackbar(errorMessage, true);
    } catch (e) {
      showCustomSnackbar("Unexpected error: ${e.toString()}", true);
    } finally {
      isLoading.value = false;
    }
  }
  
  /// Perform local fuzzy search on existing results
  void performLocalSearch(String query) {
    currentQuery.value = query;
    applyFuzzyFilter(query);
  }
  
  void showCustomSnackbar(String message, bool isError) {
    Get.snackbar(
      isError ? 'Error' : 'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
  
  /// Convert search query params to listings API format

}