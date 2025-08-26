class RealEstateFilters {
  // Base filters for all real estate
  static const List<String> all = ["location", "price", "sort"];

  // House-specific filters
  static const List<String> house = [
    "location",
    "price",
    "sort",
    "bedrooms",
    "bathrooms",
    "area",
    "yearBuilt",
    "furnished",
    "parking",
    "garden",
    "pool",
    "condition",
    "facing",
    "stories",
  ];

  // Apartment-specific filters
  static const List<String> apartment = [
    "location",
    "price",
    "sort",
    "bedrooms",
    "bathrooms",
    "area",
    "floor",
    "totalFloors",
    "furnished",
    "parking",
    "balcony",
    "condition",
    "facing",
    "yearBuilt",
  ];

  // Office-specific filters
  static const List<String> office = [
    "location",
    "price",
    "sort",
    "area",
    "floor",
    "totalFloors",
    "furnished",
    "parking",
    "condition",
    "officeType",
    "yearBuilt",
  ];

  // Land-specific filters
  static const List<String> land = [
    "location",
    "price",
    "sort",
    "plotSize",
    "zoning",
    "roadAccess",
    "utilities",
    "elevation",
    "soilType",
  ];

  // Store-specific filters
  static const List<String> store = [
    "location",
    "price",
    "sort",
    "area",
    "floor",
    "furnished",
    "parking",
    "condition",
    "yearBuilt",
    "footTraffic",
  ];

  // Villa-specific filters
  static const List<String> villa = [
    "location",
    "price",
    "sort",
    "bedrooms",
    "bathrooms",
    "area",
    "yearBuilt",
    "furnished",
    "parking",
    "garden",
    "pool",
    "condition",
    "facing",
    "stories",
    "gatedCommunity",
  ];

  // Get filters for specific subcategory
  static List<String> getFiltersForSubcategory(String subcategory) {
    switch (subcategory.toLowerCase()) {
      case 'house':
      case 'houses':
        return house;
      case 'apartment':
      case 'apartments':
        return apartment;
      case 'office':
      case 'offices':
        return office;
      case 'land':
        return land;
      case 'store':
      case 'stores':
        return store;
      case 'villa':
      case 'villas':
        return villa;
      default:
        return all; // Fallback to base filters
    }
  }

  // Get all available real estate subcategories
  static const List<String> subcategories = [
    'house',
    'apartment',
    'villa',
    'office',
    'store',
    'land',
  ];
}
