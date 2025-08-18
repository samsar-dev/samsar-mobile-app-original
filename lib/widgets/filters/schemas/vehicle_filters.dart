class VehicleFilters {
  // Base filters for all vehicles
  static const List<String> all = [
    "location",
    "price", 
    "sort"
  ];

  // Car-specific filters
  static const List<String> car = [
    "location",
    "price",
    "sort",
    "make",
    "model", 
    "year",
    "mileage",
    "fuel",
    "transmission",
    "bodyType",
    "driveType",
    "condition"
  ];

  // Motorcycle-specific filters
  static const List<String> motorcycle = [
    "location",
    "price",
    "sort",
    "brand",
    "model",
    "year", 
    "engineCapacity",
    "mileage",
    "condition",
    "motorcycleType"
  ];

  // Truck-specific filters
  static const List<String> truck = [
    "location",
    "price",
    "sort",
    "make",
    "model",
    "year",
    "mileage",
    "fuel",
    "transmission",
    "payloadCapacity",
    "towingCapacity",
    "condition"
  ];

  // Van-specific filters
  static const List<String> van = [
    "location",
    "price",
    "sort",
    "make",
    "model",
    "year",
    "mileage",
    "fuel",
    "transmission",
    "seatingCapacity",
    "condition"
  ];

  // Bus-specific filters
  static const List<String> bus = [
    "location",
    "price",
    "sort",
    "make",
    "model",
    "year",
    "mileage",
    "fuel",
    "seatingCapacity",
    "condition"
  ];

  // Tractor-specific filters
  static const List<String> tractor = [
    "location",
    "price",
    "sort",
    "make",
    "model",
    "year",
    "horsepower",
    "condition",
    "attachments"
  ];

  // Get filters for specific subcategory
  static List<String> getFiltersForSubcategory(String subcategory) {
    switch (subcategory.toLowerCase()) {
      case 'car':
      case 'cars':
        return car;
      case 'motorcycle':
      case 'motorcycles':
        return motorcycle;
      case 'truck':
      case 'trucks':
        return truck;
      case 'van':
      case 'vans':
        return van;
      case 'bus':
      case 'buses':
        return bus;
      case 'tractor':
      case 'tractors':
        return tractor;
      default:
        return all; // Fallback to base filters
    }
  }

  // Get all available vehicle subcategories
  static const List<String> subcategories = [
    'car',
    'motorcycle', 
    'truck',
    'van',
    'bus',
    'tractor'
  ];
}
