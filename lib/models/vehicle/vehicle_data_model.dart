class VehicleDataResponse {
  final String subcategory;
  final List<String> makes;
  final Map<String, List<String>>? models;
  final int totalMakes;
  final int? totalModels;

  VehicleDataResponse({
    required this.subcategory,
    required this.makes,
    this.models,
    required this.totalMakes,
    this.totalModels,
  });

  factory VehicleDataResponse.fromJson(Map<String, dynamic> json) {
    return VehicleDataResponse(
      subcategory: json['subcategory'] ?? '',
      makes: List<String>.from(json['makes'] ?? []),
      models: json['models'] != null 
          ? Map<String, List<String>>.from(
              (json['models'] as Map).map(
                (key, value) => MapEntry(key.toString(), List<String>.from(value))
              )
            )
          : null,
      totalMakes: json['totalMakes'] ?? json['total'] ?? 0,
      totalModels: json['totalModels'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subcategory': subcategory,
      'makes': makes,
      'models': models,
      'totalMakes': totalMakes,
      'totalModels': totalModels,
    };
  }
}

class VehicleModelsResponse {
  final String make;
  final String subcategory;
  final List<String> models;
  final int total;

  VehicleModelsResponse({
    required this.make,
    required this.subcategory,
    required this.models,
    required this.total,
  });

  factory VehicleModelsResponse.fromJson(Map<String, dynamic> json) {
    return VehicleModelsResponse(
      make: json['make'] ?? '',
      subcategory: json['subcategory'] ?? '',
      models: List<String>.from(json['models'] ?? []),
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'make': make,
      'subcategory': subcategory,
      'models': models,
      'total': total,
    };
  }
}

enum VehicleSubcategory {
  cars('CARS'),
  motorcycles('MOTORCYCLES'),
  passengerVehicles('PASSENGER_VEHICLES'),
  commercialTransport('COMMERCIAL_TRANSPORT'),
  constructionVehicles('CONSTRUCTION_VEHICLES');

  const VehicleSubcategory(this.value);
  final String value;

  static VehicleSubcategory fromString(String value) {
    switch (value.toUpperCase()) {
      case 'CARS':
        return VehicleSubcategory.cars;
      case 'MOTORCYCLES':
        return VehicleSubcategory.motorcycles;
      case 'PASSENGER_VEHICLES':
        return VehicleSubcategory.passengerVehicles;
      case 'COMMERCIAL_TRANSPORT':
        return VehicleSubcategory.commercialTransport;
      case 'CONSTRUCTION_VEHICLES':
        return VehicleSubcategory.constructionVehicles;
      default:
        throw ArgumentError('Invalid vehicle subcategory: $value');
    }
  }

  String get displayName {
    switch (this) {
      case VehicleSubcategory.cars:
        return 'Cars';
      case VehicleSubcategory.motorcycles:
        return 'Motorcycles';
      case VehicleSubcategory.passengerVehicles:
        return 'Passenger Vehicles';
      case VehicleSubcategory.commercialTransport:
        return 'Commercial Transport';
      case VehicleSubcategory.constructionVehicles:
        return 'Construction Vehicles';
    }
  }
}
