import 'package:get/get.dart';
import 'package:samsar/controllers/features/filter_controller.dart';
import 'package:samsar/models/listing/listing_response.dart';
import 'package:samsar/services/listing/listing_service.dart';

class ListingController extends GetxController {
  final ListingService _service = ListingService();
  late final FilterController _filterController;
  
  @override
  void onInit() {
    super.onInit();
    // Initialize FilterController in onInit to ensure it's available
    _filterController = Get.find<FilterController>();
    fetchListings(isInitial: true);
  }

  var listings = <Item>[].obs;
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var hasMore = true.obs;

  int _page = 1;
  final int _limit = 10;

  // Main category filter (vehicles or real_estate)
  var selectedCategory = ''.obs;

  Future<void> fetchListings({bool isInitial = false}) async {
    if (isInitial) {
      _page = 1;
      print('🧹 CLEARING LISTINGS - Current count: ${listings.length}');
      listings.clear();
      print('🧹 LISTINGS CLEARED - New count: ${listings.length}');
      hasMore.value = true;
    } else {
      if (!hasMore.value) return;
      isMoreLoading.value = true;
    }

    isLoading.value = isInitial;

    // Get filter values from FilterController
    final mainCategory = selectedCategory.value.isNotEmpty ? selectedCategory.value : null;
    final subCategory = _filterController.selectedSubcategory.value.isNotEmpty ? _filterController.selectedSubcategory.value : null;
    final listingAction = _filterController.selectedListingType.value.isNotEmpty ? _filterController.selectedListingType.value : null;
    final sortBy = _filterController.selectedSort.value.isNotEmpty ? _getSortByValue(_filterController.selectedSort.value) : null;
    final sortOrder = _filterController.selectedSort.value.isNotEmpty ? _getSortOrderValue(_filterController.selectedSort.value) : null;
    final year = _filterController.selectedYear.value;
    final minPrice = _filterController.minPrice.value;
    final maxPrice = _filterController.maxPrice.value;
    
    print('🏠 FETCHING LISTINGS WITH BACKEND FILTERS:');
    print('  mainCategory: $mainCategory');
    print('  subCategory: $subCategory');
    print('  listingAction: $listingAction');
    print('  sortBy: $sortBy, sortOrder: $sortOrder');
    print('  year: $year');
    print('  minPrice: $minPrice, maxPrice: $maxPrice');
    print('  page: $_page, limit: $_limit');

    final response = await _service.getListingsService();

    if (response.successResponse != null) {
      try {
        print('📝 RAW API RESPONSE: ${response.successResponse}');
        final listingResponse = ListingResponse.fromJson(response.successResponse!);
        final newItems = listingResponse.data?.items ?? [];

        // Apply client-side filtering since Railway backend doesn't support the new filters yet
        final filtered = _applyAllFilters(newItems);
        listings.addAll(filtered);
        
        print('✅ FETCHED ${newItems.length} ITEMS, FILTERED TO ${filtered.length}');
        print('📝 FINAL FILTERED ITEMS BEING DISPLAYED:');
        for (int i = 0; i < filtered.length; i++) {
          print('  $i: ${filtered[i].title} (${filtered[i].year ?? 'no year'})');
        }

        // Endpoint returns all items at once, so no more pages
        hasMore.value = false;
      } catch (e) {
        print('❌ JSON PARSING ERROR: $e');
        print('  Raw response: ${response.successResponse}');
        hasMore.value = false;
      }
    } else {
      print('❌ FAILED TO FETCH LISTINGS: ${response.apiError?.message}');
    }

    isLoading.value = false;
    isMoreLoading.value = false;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    fetchListings(isInitial: true);
  }
  
  /// Apply filters to current listings without refetching from API
  void applyFilters() {
    print('🔄 APPLYING FILTERS TO EXISTING LISTINGS');
    // Re-fetch to get fresh data and apply filters
    fetchListings(isInitial: true);
  }
  
  /// Convert filter sort value to backend sortBy parameter
  String? _getSortByValue(String sortValue) {
    switch (sortValue) {
      case 'newest_first':
        return 'createdAt';
      case 'price_high_to_low':
      case 'price_low_to_high':
        return 'price';
      case 'location_a_to_z':
      case 'location_z_to_a':
        return null; // Location sorting not supported by backend yet
      default:
        return null;
    }
  }
  
  /// Convert filter sort value to backend sortOrder parameter
  String? _getSortOrderValue(String sortValue) {
    switch (sortValue) {
      case 'newest_first':
      case 'price_high_to_low':
      case 'location_z_to_a':
        return 'desc';
      case 'price_low_to_high':
      case 'location_a_to_z':
        return 'asc';
      default:
        return 'desc';
    }
  }

  void loadMore() {
    if (!isLoading.value && !isMoreLoading.value) {
      fetchListings();
    }
  }
  
  /// Apply client-side filters to items (temporary solution until Railway backend is updated)
  List<Item> _applyAllFilters(List<Item> items) {
    print('🏠 APPLYING CLIENT-SIDE FILTERS:');
    print('  Total items before filtering: ${items.length}');
    
    var filtered = items;
    
    // Apply main category filter (vehicles/real_estate)
    if (selectedCategory.value.isNotEmpty) {
      filtered = filtered.where((item) {
        final matches = item.mainCategory?.toLowerCase() == selectedCategory.value.toLowerCase();
        return matches;
      }).toList();
      print('  After category filter: ${filtered.length} items');
    }
    
    // Apply subcategory filter
    if (_filterController.selectedSubcategory.value.isNotEmpty) {
      // Backend expects subcategory in uppercase (CARS, MOTORCYCLES, etc.)
      final subcategory = _filterController.selectedSubcategory.value.toUpperCase();
      filtered = filtered.where((item) {
        // Compare both in uppercase to ensure case-insensitive match
        final itemSubcategory = item.subCategory?.toUpperCase() ?? '';
        final matches = itemSubcategory == subcategory;
        if (matches) {
          print('    ✓ Matches subcategory: ${item.subCategory} == $subcategory');
        }
        return matches;
      }).toList();
      print('  After subcategory filter ($subcategory): ${filtered.length} items');
    }
    
    // Apply listing type filter (for_sale/for_rent)
    if (_filterController.selectedListingType.value.isNotEmpty) {
      final listingType = _filterController.selectedListingType.value;
      filtered = filtered.where((item) {
        final itemListingAction = item.listingAction?.toLowerCase() ?? '';
        
        // Handle format mismatch: filter uses "for_sale"/"for_rent", API returns "SALE"/"RENT"
        bool matches = false;
        if (listingType.toLowerCase() == 'for_sale' && itemListingAction == 'sale') {
          matches = true;
        } else if (listingType.toLowerCase() == 'for_rent' && itemListingAction == 'rent') {
          matches = true;
        } else if (itemListingAction == listingType.toLowerCase()) {
          matches = true; // Direct match fallback
        }
        
        print('    Checking item: ${item.title} - listingAction: "$itemListingAction" vs filter: "${listingType.toLowerCase()}" = $matches');
        return matches;
      }).toList();
      print('  After listing type filter ($listingType): ${filtered.length} items');
    }
    
    // Apply city filter
    if (_filterController.selectedCity.value.isNotEmpty) {
      final city = _filterController.selectedCity.value;
      filtered = filtered.where((item) {
        final matches = item.location?.toLowerCase().contains(city.toLowerCase()) ?? false;
        return matches;
      }).toList();
      print('  After city filter ($city): ${filtered.length} items');
    }
    
    // Apply year filter
    if (_filterController.selectedYear.value != null) {
      final year = _filterController.selectedYear.value!;
      filtered = filtered.where((item) {
        // Try to get year from item fields first
        int? itemYear = item.year ?? item.yearBuilt;
        
        // If no year in fields, try to extract from title (fallback)
        if (itemYear == null) {
          final title = item.title ?? '';
          final yearRegex = RegExp(r'\b(19|20)\d{2}\b'); // Match 4-digit years starting with 19 or 20
          final match = yearRegex.firstMatch(title);
          if (match != null) {
            itemYear = int.tryParse(match.group(0) ?? '');
          }
        }
        
        final matches = itemYear == year;
        
        print('    Checking item: ${item.title} - year: ${item.year}, yearBuilt: ${item.yearBuilt}, extracted: $itemYear vs filter: $year = $matches');
        return matches;
      }).toList();
      print('  After year filter ($year): ${filtered.length} items');
    }
    
    // Apply price range filter
    if (_filterController.minPrice.value != null || _filterController.maxPrice.value != null) {
      final minPrice = _filterController.minPrice.value;
      final maxPrice = _filterController.maxPrice.value;
      
      filtered = filtered.where((item) {
        final price = item.price;
        if (price == null) return true;
        
        bool matches = true;
        if (minPrice != null && price < minPrice) matches = false;
        if (maxPrice != null && price > maxPrice) matches = false;
        
        return matches;
      }).toList();
      print('  After price filter ($minPrice-$maxPrice): ${filtered.length} items');
    }
    
    // Apply sorting
    if (_filterController.selectedSort.value.isNotEmpty) {
      final sortBy = _filterController.selectedSort.value;
      print('  Applying sort: $sortBy');
      
      switch (sortBy) {
        case 'newest_first':
          filtered.sort((a, b) {
            final aDate = a.createdAt ?? DateTime(1970);
            final bDate = b.createdAt ?? DateTime(1970);
            return bDate.compareTo(aDate);
          });
          break;
        case 'price_high_to_low':
          filtered.sort((a, b) {
            final aPrice = a.price ?? 0;
            final bPrice = b.price ?? 0;
            return bPrice.compareTo(aPrice);
          });
          break;
        case 'price_low_to_high':
          filtered.sort((a, b) {
            final aPrice = a.price ?? 0;
            final bPrice = b.price ?? 0;
            return aPrice.compareTo(bPrice);
          });
          break;
        case 'location_a_to_z':
          filtered.sort((a, b) {
            final aLocation = a.location?.toString() ?? '';
            final bLocation = b.location?.toString() ?? '';
            return aLocation.compareTo(bLocation);
          });
          break;
        case 'location_z_to_a':
          filtered.sort((a, b) {
            final aLocation = a.location?.toString() ?? '';
            final bLocation = b.location?.toString() ?? '';
            return bLocation.compareTo(aLocation);
          });
          break;
      }
    }
    
    print('  Final filtered count: ${filtered.length}');
    return filtered;
  }
}
