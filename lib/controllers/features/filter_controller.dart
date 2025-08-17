import 'package:get/get.dart';
import 'package:samsar/models/search/search_query.dart';
import 'package:samsar/models/location/city_model.dart';

class FilterController extends GetxController {
  // Filter state variables
  RxString selectedSort = ''.obs;
  RxString selectedSubcategory = ''.obs;
  RxString selectedListingType = ''.obs;
  RxString selectedCity = ''.obs;
  RxnInt selectedYear = RxnInt();
  RxnDouble minPrice = RxnDouble();
  RxnDouble maxPrice = RxnDouble();
  
  // Location-based filtering
  Rx<CityInfo?> selectedLocation = Rx<CityInfo?>(null);
  RxDouble radiusKm = 50.0.obs; // Default 50km radius
  RxBool enableLocationFilter = false.obs;
  RxBool sortByDistance = false.obs;
  
  // Filter options
  final List<String> sortOptions = [
    'newest_first',
    'price_high_to_low',
    'price_low_to_high',
    'location_a_to_z',
    'location_z_to_a',
    'distance_nearest_first', // New radius-based sorting
  ];
  
  // Radius options in kilometers
  final List<double> radiusOptions = [5.0, 10.0, 25.0, 50.0, 100.0, 200.0];

  // Backend expects these values in uppercase
  final List<String> subcategories = [
    'CARS',
    'MOTORCYCLES',
    'VANS',
    'BUSES',
    'TRACTORS'
  ];
  
  // Helper to get display name from backend value
  String getDisplayName(String backendValue) {
    switch(backendValue) {
      case 'CARS': return 'Cars';
      case 'MOTORCYCLES': return 'Motorcycles';
      case 'VANS': return 'Vans';
      case 'BUSES': return 'Buses';
      case 'TRACTORS': return 'Tractors';
      default: return backendValue;
    }
  }
  
  final List<String> listingTypes = [
    'for_sale',
    'for_rent'
  ];
  
  final List<String> cities = [
    'damascus',
    'aleppo',
    'homs',
    'lattakia',
    'hama',
    'deir_ezzor',
    'hasekeh',
    'qamishli',
    'raqqa',
    'tartous',
    'ldlib',
    'dara',
    'sweden',
    'quneitra'
  ];
  
  final List<int> years = List.generate(2025 - 1990 + 1, (index) => 2025 - index);

  /// Check if any filters are applied
  bool get hasActiveFilters {
    return selectedSort.value.isNotEmpty ||
           selectedSubcategory.value.isNotEmpty ||
           selectedListingType.value.isNotEmpty ||
           selectedCity.value.isNotEmpty ||
           selectedYear.value != null ||
           minPrice.value != null ||
           maxPrice.value != null ||
           enableLocationFilter.value ||
           sortByDistance.value;
  }

  /// Get count of active filters
  int get activeFilterCount {
    int count = 0;
    if (selectedSort.value.isNotEmpty) count++;
    if (selectedSubcategory.value.isNotEmpty) count++;
    if (selectedListingType.value.isNotEmpty) count++;
    if (selectedCity.value.isNotEmpty) count++;
    if (selectedYear.value != null) count++;
    if (minPrice.value != null) count++;
    if (maxPrice.value != null) count++;
    if (enableLocationFilter.value) count++;
    if (sortByDistance.value) count++;
    return count;
  }

  /// Reset all filters to default values
  void resetFilters() {
    print('🔧 RESETTING ALL FILTERS:');
    print('  Before reset:');
    print('    selectedSort: "${selectedSort.value}"');
    print('    selectedSubcategory: "${selectedSubcategory.value}"');
    print('    selectedListingType: "${selectedListingType.value}"');
    print('    selectedCity: "${selectedCity.value}"');
    print('    selectedYear: ${selectedYear.value}');
    print('    minPrice: ${minPrice.value}');
    print('    maxPrice: ${maxPrice.value}');
    print('    selectedLocation: ${selectedLocation.value?.name}');
    print('    radiusKm: ${radiusKm.value}');
    print('    enableLocationFilter: ${enableLocationFilter.value}');
    print('    sortByDistance: ${sortByDistance.value}');
    
    selectedSort.value = '';
    selectedSubcategory.value = '';
    selectedListingType.value = '';
    selectedCity.value = '';
    selectedYear.value = null;
    minPrice.value = null;
    maxPrice.value = null;
    selectedLocation.value = null;
    radiusKm.value = 50.0;
    enableLocationFilter.value = false;
    sortByDistance.value = false;
    
    print('  After reset:');
    print('    selectedSort: "${selectedSort.value}"');
    print('    selectedSubcategory: "${selectedSubcategory.value}"');
    print('    selectedListingType: "${selectedListingType.value}"');
    print('    selectedCity: "${selectedCity.value}"');
    print('    selectedYear: ${selectedYear.value}');
    print('    minPrice: ${minPrice.value}');
    print('    maxPrice: ${maxPrice.value}');
    print('    selectedLocation: ${selectedLocation.value?.name}');
    print('    radiusKm: ${radiusKm.value}');
    print('    enableLocationFilter: ${enableLocationFilter.value}');
    print('    sortByDistance: ${sortByDistance.value}');
    print('🔧 All filters reset to default values');
  }

  /// Create SearchQuery with current filter values
  SearchQuery createSearchQuery({
    String? query,
    String? category,
    int? page,
    int? limit,
  }) {
    // Debug: Print current filter values
    print('🔧 Filter Controller Values:');
    print('  selectedSort: "${selectedSort.value}"');
    print('  selectedSubcategory: "${selectedSubcategory.value}"');
    print('  selectedListingType: "${selectedListingType.value}"');
    print('  selectedCity: "${selectedCity.value}"');
    print('  selectedYear: ${selectedYear.value}');
    print('  minPrice: ${minPrice.value}');
    print('  maxPrice: ${maxPrice.value}');
    print('  📍 LOCATION FILTER VALUES:');
    print('    selectedLocation: ${selectedLocation.value?.name}');
    print('    selectedLocation lat: ${selectedLocation.value?.latitude}');
    print('    selectedLocation lng: ${selectedLocation.value?.longitude}');
    print('    radiusKm: ${radiusKm.value}');
    print('    enableLocationFilter: ${enableLocationFilter.value}');
    print('    sortByDistance: ${sortByDistance.value}');
    
    // Determine final sort option
    String? finalSort = selectedSort.value.isNotEmpty ? selectedSort.value : null;
    if (sortByDistance.value && selectedLocation.value != null) {
      finalSort = 'distance_nearest_first';
      print('  🎯 Using distance-based sorting');
    }
    
    return SearchQuery(
      query: query,
      category: category,
      subCategory: selectedSubcategory.value.isNotEmpty ? selectedSubcategory.value : null,
      listingAction: selectedListingType.value.isNotEmpty ? selectedListingType.value : null,
      city: selectedCity.value.isNotEmpty ? selectedCity.value : null,
      sortBy: finalSort,
      year: selectedYear.value,
      minPrice: minPrice.value,
      maxPrice: maxPrice.value,
      // Location-based parameters
      latitude: enableLocationFilter.value ? selectedLocation.value?.latitude : null,
      longitude: enableLocationFilter.value ? selectedLocation.value?.longitude : null,
      radiusKm: enableLocationFilter.value ? radiusKm.value : null,
      page: page ?? 1,
      limit: limit ?? 10,
    );
  }

  /// Apply filters from SearchQuery
  void applyFromSearchQuery(SearchQuery query) {
    selectedSubcategory.value = query.subCategory ?? '';
    selectedListingType.value = query.listingAction ?? '';
    selectedCity.value = query.city ?? '';
    selectedSort.value = query.sortBy ?? '';
    selectedYear.value = query.year;
    minPrice.value = query.minPrice;
    maxPrice.value = query.maxPrice;
    
    // Apply location filters
    if (query.latitude != null && query.longitude != null) {
      selectedLocation.value = CityInfo(
        name: 'Custom Location',
        latitude: query.latitude!,
        longitude: query.longitude!,
        neighbors: [], // Empty neighbors list for custom location
      );
      enableLocationFilter.value = true;
      radiusKm.value = query.radiusKm ?? 50.0;
    } else {
      selectedLocation.value = null;
      enableLocationFilter.value = false;
    }
    
    sortByDistance.value = query.sortBy == 'distance_nearest_first';
  }

  /// Get translated sort option
  String getTranslatedSortOption(String sortKey) {
    switch (sortKey) {
      case 'newest_first':
        return 'newest_first'.tr;
      case 'price_high_to_low':
        return 'price_high_to_low'.tr;
      case 'price_low_to_high':
        return 'price_low_to_high'.tr;
      case 'location_a_to_z':
        return 'location_a_to_z'.tr;
      case 'location_z_to_a':
        return 'location_z_to_a'.tr;
      case 'distance_nearest_first':
        return 'distance_nearest_first'.tr;
      default:
        return sortKey;
    }
  }

  /// Get translated subcategory
  String getTranslatedSubcategory(String subKey) {
    return subKey.tr;
  }

  /// Get translated listing type
  String getTranslatedListingType(String typeKey) {
    return typeKey.tr;
  }

  /// Get translated city
  String getTranslatedCity(String cityKey) {
    return cityKey.tr;
  }

  /// Set location for filtering
  void setLocationFilter(CityInfo? location, {double? radius}) {
    print('📍 SETTING LOCATION FILTER:');
    print('  Location: ${location?.name}');
    print('  Coordinates: ${location?.latitude}, ${location?.longitude}');
    print('  Radius: ${radius ?? radiusKm.value} km');
    
    selectedLocation.value = location;
    enableLocationFilter.value = location != null;
    if (radius != null) {
      radiusKm.value = radius;
    }
    
    print('  enableLocationFilter: ${enableLocationFilter.value}');
    print('  radiusKm: ${radiusKm.value}');
  }
  
  /// Clear location filter
  void clearLocationFilter() {
    print('🗑️ CLEARING LOCATION FILTER');
    selectedLocation.value = null;
    enableLocationFilter.value = false;
    sortByDistance.value = false;
  }
  
  /// Toggle distance-based sorting
  void toggleDistanceSorting() {
    if (selectedLocation.value != null) {
      sortByDistance.value = !sortByDistance.value;
      print('🎯 TOGGLED DISTANCE SORTING: ${sortByDistance.value}');
      
      if (sortByDistance.value) {
        selectedSort.value = 'distance_nearest_first';
        enableLocationFilter.value = true;
      }
    } else {
      print('⚠️ Cannot enable distance sorting without location');
    }
  }
  
  /// Get current location filter status
  String getLocationFilterStatus() {
    if (!enableLocationFilter.value) return 'No location filter';
    
    String status = 'Location: ${selectedLocation.value?.name ?? "Unknown"}';
    status += ' (${radiusKm.value.toInt()}km radius)';
    
    if (sortByDistance.value) {
      status += ' - Sorted by distance';
    }
    
    return status;
  }

  /// Get filter summary for display
  String getFilterSummary() {
    List<String> activeSummary = [];
    
    if (selectedSort.value.isNotEmpty) {
      activeSummary.add('${'sort'.tr}: ${getTranslatedSortOption(selectedSort.value)}');
    }
    if (selectedSubcategory.value.isNotEmpty) {
      activeSummary.add('${'subcategory'.tr}: ${getTranslatedSubcategory(selectedSubcategory.value)}');
    }
    if (selectedListingType.value.isNotEmpty) {
      activeSummary.add('${'type'.tr}: ${getTranslatedListingType(selectedListingType.value)}');
    }
    if (selectedCity.value.isNotEmpty) {
      activeSummary.add('${'city'.tr}: ${getTranslatedCity(selectedCity.value)}');
    }
    if (selectedYear.value != null) {
      activeSummary.add('${'year'.tr}: ${selectedYear.value}');
    }
    if (minPrice.value != null || maxPrice.value != null) {
      String priceRange = '${'price'.tr}: ';
      if (minPrice.value != null && maxPrice.value != null) {
        priceRange += '${minPrice.value} - ${maxPrice.value}';
      } else if (minPrice.value != null) {
        priceRange += '${'from'.tr} ${minPrice.value}';
      } else if (maxPrice.value != null) {
        priceRange += '${'up_to'.tr} ${maxPrice.value}';
      }
      activeSummary.add(priceRange);
    }
    
    // Add location filter summary
    if (enableLocationFilter.value && selectedLocation.value != null) {
      String locationSummary = '${'location'.tr}: ${selectedLocation.value!.name} (${radiusKm.value.toInt()}km)';
      activeSummary.add(locationSummary);
    }
    
    return activeSummary.join(', ');
  }
}
