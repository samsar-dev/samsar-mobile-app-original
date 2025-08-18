import 'vehicle_filters.dart';
import 'real_estate_filters.dart';

class FilterSchemaManager {
  // Get filters based on main category and subcategory
  static List<String> getFilters({
    required String mainCategory,
    String? subcategory,
  }) {
    switch (mainCategory.toLowerCase()) {
      case 'vehicles':
      case 'vehicle':
        if (subcategory != null && subcategory.isNotEmpty) {
          return VehicleFilters.getFiltersForSubcategory(subcategory);
        }
        return VehicleFilters.all;
        
      case 'real_estate':
      case 'realestate':
      case 'property':
        if (subcategory != null && subcategory.isNotEmpty) {
          return RealEstateFilters.getFiltersForSubcategory(subcategory);
        }
        return RealEstateFilters.all;
        
      default:
        // Homepage - only basic filters
        return ['location', 'price', 'sort'];
    }
  }

  // Get available subcategories for a main category
  static List<String> getSubcategories(String mainCategory) {
    switch (mainCategory.toLowerCase()) {
      case 'vehicles':
      case 'vehicle':
        return VehicleFilters.subcategories;
      case 'real_estate':
      case 'realestate':
      case 'property':
        return RealEstateFilters.subcategories;
      default:
        return [];
    }
  }

  // Check if advanced filters should be shown
  static bool shouldShowAdvancedFilters({
    required String mainCategory,
    String? subcategory,
  }) {
    // Advanced filters only show when subcategory is selected
    return subcategory != null && subcategory.isNotEmpty;
  }

  // Get listing action options (for rent/sale/search toggles)
  static List<String> getListingActions() {
    return ['for_sale', 'for_rent', 'searching'];
  }

  // Get translated listing action labels
  static Map<String, String> getListingActionLabels() {
    return {
      'for_sale': 'للبيع',
      'for_rent': 'للإيجار', 
      'searching': 'مطلوب'
    };
  }
}
