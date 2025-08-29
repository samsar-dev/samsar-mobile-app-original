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

  Future<void> fetchListings({
    bool isInitial = false,
    bool forceRefresh = false,
  }) async {
    if (isInitial) {
      _page = 1;
      listings.clear();
      hasMore.value = true;
    } else {
      if (!hasMore.value) return;
      isMoreLoading.value = true;
    }

    isLoading.value = isInitial;

    // Get filter values from FilterController
    final mainCategory = selectedCategory.value.isNotEmpty
        ? selectedCategory.value
        : null;
    final subCategory = _filterController.selectedSubcategory.value.isNotEmpty
        ? _filterController.selectedSubcategory.value
        : null;
    final listingAction = _filterController.selectedListingType.value.isNotEmpty
        ? _filterController.selectedListingType.value
        : null;
    final sortBy = _filterController.selectedSort.value.isNotEmpty
        ? _getSortByValue(_filterController.selectedSort.value)
        : null;
    final sortOrder = _filterController.selectedSort.value.isNotEmpty
        ? _getSortOrderValue(_filterController.selectedSort.value)
        : null;
    final year = _filterController.selectedYear.value;
    final minPrice = _filterController.minPrice.value;
    final maxPrice = _filterController.maxPrice.value;


    final response = await _service.getListingsService(
      forceRefresh: forceRefresh,
    );

    if (response.successResponse != null) {
      try {
        final listingResponse = ListingResponse.fromJson(
          response.successResponse!,
        );
        final newItems = listingResponse.data?.items ?? [];

        // Prevent duplicates by checking if items already exist
        final existingIds = listings.map((item) => item.id).toSet();
        final uniqueNewItems = newItems
            .where((item) => !existingIds.contains(item.id))
            .toList();


        // Apply client-side filtering since Railway backend doesn't support the new filters yet
        final filtered = _applyAllFilters(uniqueNewItems);
        listings.addAll(filtered);

        for (int i = 0; i < filtered.length; i++) {
        }

        // Endpoint returns all items at once, so no more pages
        hasMore.value = false;
      } catch (e) {
        hasMore.value = false;
      }
    } else {
    }

    isLoading.value = false;
    isMoreLoading.value = false;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    fetchListings(isInitial: true, forceRefresh: true);
  }

  /// Apply filters to current listings without refetching from API
  void applyFilters() {
    
    // Always fetch fresh data when filters are applied to ensure we have complete data
    fetchListings(isInitial: true, forceRefresh: true);
  }

  /// Force refresh listings from backend (for pull-to-refresh)
  Future<void> refreshListings() async {
    await fetchListings(isInitial: true, forceRefresh: true);
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

    var filtered = items;

    // Apply main category filter (vehicles/real_estate)
    if (selectedCategory.value.isNotEmpty) {
      filtered = filtered.where((item) {
        // Handle category mapping: API returns 'VEHICLES' but filter uses 'vehicles'
        final itemCategory = item.mainCategory?.toLowerCase();
        final filterCategory = selectedCategory.value.toLowerCase();

        // Map API categories to filter categories
        String? mappedCategory;
        if (itemCategory == 'vehicles')
          mappedCategory = 'vehicles';
        else if (itemCategory == 'real_estate' || itemCategory == 'realestate')
          mappedCategory = 'real_estate';
        else
          mappedCategory = itemCategory;

        final matches = mappedCategory == filterCategory;
        return matches;
      }).toList();
    }

    // Apply subcategory filter - handle both single and multiple selection
    if (_filterController.selectedSubcategories.isNotEmpty) {
      // Multiple subcategory selection (for real estate)
      final subcategories = _filterController.selectedSubcategories
          .map((s) => s.toUpperCase())
          .toList();
      
      filtered = filtered.where((item) {
        final itemSubcategory = item.subCategory?.toUpperCase() ?? '';
        final matches = subcategories.contains(itemSubcategory);
        if (matches) {
        }
        return matches;
      }).toList();
    } else if (_filterController.selectedSubcategory.value.isNotEmpty) {
      // Single subcategory selection (for vehicles)
      final subcategory = _filterController.selectedSubcategory.value
          .toUpperCase();
      
      filtered = filtered.where((item) {
        final itemSubcategory = item.subCategory?.toUpperCase() ?? '';
        final matches = itemSubcategory == subcategory;
        if (matches) {
        }
        return matches;
      }).toList();
    }

    // Apply listing type filter (for_sale/for_rent)
    if (_filterController.selectedListingType.value.isNotEmpty) {
      final listingType = _filterController.selectedListingType.value;
      filtered = filtered.where((item) {
        final itemListingAction = item.listingAction?.toLowerCase() ?? '';

        // Handle format mismatch: filter uses "for_sale"/"for_rent", API returns "SALE"/"RENT"
        bool matches = false;
        if (listingType.toLowerCase() == 'for_sale' &&
            itemListingAction == 'sale') {
          matches = true;
        } else if (listingType.toLowerCase() == 'for_rent' &&
            itemListingAction == 'rent') {
          matches = true;
        } else if (itemListingAction == listingType.toLowerCase()) {
          matches = true; // Direct match fallback
        }

        return matches;
      }).toList();
    }

    // Apply city filter with improved neighborhood support
    if (_filterController.selectedCity.value.isNotEmpty) {
      final city = _filterController.selectedCity.value;
      filtered = filtered.where((item) {
        final location = item.location?.toLowerCase() ?? '';
        final cityLower = city.toLowerCase();
        
        // Create mapping for major cities to include their Arabic names and common variations
        Map<String, List<String>> cityMappings = {
          'aleppo': ['aleppo', 'حلب', 'halep', 'alep'],
          'damascus': ['damascus', 'دمشق', 'dimashq', 'damas'],
          'homs': ['homs', 'حمص', 'hims'],
          'lattakia': ['lattakia', 'اللاذقية', 'latakia', 'ladhiqiyah'],
          'hama': ['hama', 'حماة', 'hamah'],
          'deir_ezzor': ['deir_ezzor', 'دير الزور', 'deir ez-zor', 'deir al-zor'],
          'hasekeh': ['hasekeh', 'الحسكة', 'al-hasakah', 'hasakah'],
          'qamishli': ['qamishli', 'القامشلي', 'qamishly'],
          'raqqa': ['raqqa', 'الرقة', 'ar-raqqah'],
          'tartous': ['tartous', 'طرطوس', 'tartus'],
          'ldlib': ['ldlib', 'إدلب', 'idlib'],
          'dara': ['dara', 'درعا', 'daraa'],
          'sweden': ['sweden', 'السويد'],
          'quneitra': ['quneitra', 'القنيطرة'],
        };
        
        // Get all possible names for the selected city
        List<String> cityVariations = cityMappings[cityLower] ?? [cityLower];
        
        // Check if location contains any variation of the city name
        bool matches = cityVariations.any((variation) => 
          location.contains(variation.toLowerCase()));
        
        if (matches) {
        }
        
        return matches;
      }).toList();
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
          final yearRegex = RegExp(
            r'\b(19|20)\d{2}\b',
          ); // Match 4-digit years starting with 19 or 20
          final match = yearRegex.firstMatch(title);
          if (match != null) {
            itemYear = int.tryParse(match.group(0) ?? '');
          }
        }

        final matches = itemYear == year;

        return matches;
      }).toList();
    }

    // Apply price range filter
    if (_filterController.minPrice.value != null ||
        _filterController.maxPrice.value != null) {
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
    }

    // Apply vehicle-specific filters
    if (selectedCategory.value.toLowerCase() == 'vehicles') {
      // Fuel Type Filter
      if (_filterController.selectedFuelType.value.isNotEmpty) {
        final fuelType = _filterController.selectedFuelType.value;
        filtered = filtered.where((item) {
          final itemFuelType = item.fuelTypeRoot?.toUpperCase() ?? '';
          final matches = itemFuelType == fuelType.toUpperCase();
          if (matches) {
          }
          return matches;
        }).toList();
      }

      // Transmission Filter
      if (_filterController.selectedTransmission.value.isNotEmpty) {
        final transmission = _filterController.selectedTransmission.value;
        filtered = filtered.where((item) {
          final itemTransmission = item.transmissionRoot?.toUpperCase() ?? '';
          final matches = itemTransmission == transmission.toUpperCase();
          if (matches) {
          }
          return matches;
        }).toList();
      }

      // Body Type Filter (for cars)
      if (_filterController.selectedBodyType.value.isNotEmpty) {
        final bodyType = _filterController.selectedBodyType.value;
        filtered = filtered.where((item) {
          // Check body type from flatDetails or vehicleType
          final itemBodyType = item.details?.flatDetails?['bodyType']?.toString().toUpperCase() ?? 
                              item.details?.vehicles?.vehicleType?.toUpperCase() ?? '';
          final matches = itemBodyType == bodyType.toUpperCase();
          if (matches) {
          }
          return matches;
        }).toList();
      }

      // Condition Filter
      if (_filterController.selectedCondition.value.isNotEmpty) {
        final condition = _filterController.selectedCondition.value;
        filtered = filtered.where((item) {
          final itemCondition = item.conditionRoot?.toUpperCase() ?? '';
          final matches = itemCondition == condition.toUpperCase();
          if (matches) {
          }
          return matches;
        }).toList();
      }

      // Make Filter
      if (_filterController.selectedMake.value.isNotEmpty) {
        final make = _filterController.selectedMake.value;
        filtered = filtered.where((item) {
          final itemMake = item.make?.toUpperCase() ?? '';
          final matches = itemMake == make.toUpperCase();
          if (matches) {
          }
          return matches;
        }).toList();
      }

      // Model Filter
      if (_filterController.selectedModel.value.isNotEmpty) {
        final model = _filterController.selectedModel.value;
        filtered = filtered.where((item) {
          final itemModel = item.model?.toUpperCase() ?? '';
          final matches = itemModel.contains(model.toUpperCase());
          if (matches) {
          }
          return matches;
        }).toList();
      }

      // Mileage Filter
      if (_filterController.selectedMaxMileage.value != null) {
        final maxMileage = _filterController.selectedMaxMileage.value!;
        filtered = filtered.where((item) {
          final itemMileage = item.mileage ?? 0;
          final matches = itemMileage <= maxMileage;
          if (matches) {
          }
          return matches;
        }).toList();
      }
    }

    // Apply real estate-specific filters
    if (selectedCategory.value.toLowerCase() == 'real_estate') {
      // Bedrooms Filter
      if (_filterController.selectedBedrooms.value != null) {
        final bedrooms = _filterController.selectedBedrooms.value!;
        filtered = filtered.where((item) {
          final itemBedrooms = item.bedrooms ?? 0;
          final matches = itemBedrooms == bedrooms;
          if (matches) {
          }
          return matches;
        }).toList();
      }

      // Bathrooms Filter
      if (_filterController.selectedBathrooms.value != null) {
        final bathrooms = _filterController.selectedBathrooms.value!;
        filtered = filtered.where((item) {
          final itemBathrooms = item.bathrooms ?? 0;
          final matches = itemBathrooms == bathrooms;
          if (matches) {
          }
          return matches;
        }).toList();
      }

      // Furnishing Filter
      if (_filterController.selectedFurnishing.value.isNotEmpty) {
        final furnishing = _filterController.selectedFurnishing.value;
        filtered = filtered.where((item) {
          final itemFurnishing = item.details?.flatDetails?['furnishing']?.toString().toUpperCase() ?? 
                                item.details?.realEstate?.utilities?.toUpperCase() ?? '';
          final matches = itemFurnishing == furnishing.toUpperCase();
          if (matches) {
          }
          return matches;
        }).toList();
      }

      // Parking Filter
      if (_filterController.selectedParking.value.isNotEmpty) {
        final parking = _filterController.selectedParking.value;
        filtered = filtered.where((item) {
          final itemParkingSpaces = item.parkingSpaces ?? 0;
          // Map parking spaces to parking filter values
          String itemParking = '';
          if (itemParkingSpaces == 0) itemParking = 'NO_PARKING';
          else if (itemParkingSpaces == 1) itemParking = '1_CAR';
          else if (itemParkingSpaces == 2) itemParking = '2_CARS';
          else if (itemParkingSpaces >= 3) itemParking = '3_PLUS_CARS';
          
          final matches = itemParking == parking.toUpperCase();
          if (matches) {
          }
          return matches;
        }).toList();
      }

      // Area Filter
      if (_filterController.selectedMinArea.value != null || _filterController.selectedMaxArea.value != null) {
        final minArea = _filterController.selectedMinArea.value;
        final maxArea = _filterController.selectedMaxArea.value;
        filtered = filtered.where((item) {
          final itemArea = item.details?.flatDetails?['totalArea']?.toDouble() ?? 
                          item.details?.flatDetails?['area']?.toDouble() ?? 0.0;
          bool matches = true;
          if (minArea != null && itemArea < minArea) matches = false;
          if (maxArea != null && itemArea > maxArea) matches = false;
          if (matches) {
          }
          return matches;
        }).toList();
      }

      // Property Condition Filter
      if (_filterController.selectedCondition.value.isNotEmpty) {
        final condition = _filterController.selectedCondition.value;
        filtered = filtered.where((item) {
          final itemCondition = item.details?.flatDetails?['condition']?.toString().toUpperCase() ?? 
                               item.condition?.toUpperCase() ?? '';
          final matches = itemCondition == condition.toUpperCase();
          if (matches) {
          }
          return matches;
        }).toList();
      }

      // Year Built Filter
      if (_filterController.selectedYearBuilt.value != null) {
        final yearBuilt = _filterController.selectedYearBuilt.value!;
        filtered = filtered.where((item) {
          final itemYearBuilt = item.details?.flatDetails?['yearBuilt']?.toInt() ?? 
                               item.details?.flatDetails?['year_built']?.toInt() ?? 0;
          final matches = itemYearBuilt == yearBuilt;
          if (matches) {
          }
          return matches;
        }).toList();
      }

      // Floor Filter
      if (_filterController.selectedFloor.value != null) {
        final floor = _filterController.selectedFloor.value!;
        filtered = filtered.where((item) {
          final itemFloor = item.details?.flatDetails?['floor']?.toInt() ?? 0;
          final matches = itemFloor == floor;
          if (matches) {
          }
          return matches;
        }).toList();
      }

      // Seller Type Filter
      if (_filterController.selectedSellerType.value.isNotEmpty) {
        final sellerType = _filterController.selectedSellerType.value;
        filtered = filtered.where((item) {
          final itemSellerType = item.details?.flatDetails?['sellerType']?.toString().toUpperCase() ?? 
                                item.details?.flatDetails?['seller_type']?.toString().toUpperCase() ?? '';
          final matches = itemSellerType == sellerType.toUpperCase();
          if (matches) {
          }
          return matches;
        }).toList();
      }
    }

    // Apply sorting
    if (_filterController.selectedSort.value.isNotEmpty) {
      final sortBy = _filterController.selectedSort.value;

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

    return filtered;
  }
}
