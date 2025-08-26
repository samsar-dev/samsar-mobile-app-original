import 'package:samsar/models/listing/favourite_listing/add_favourite_listing.dart';

class FavoriteModel {
  FavoriteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.location,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.details,
    required this.listingAction,
    required this.status,
    required this.seller,
    required this.savedBy,
    required this.favorite,
    // Root level vehicle fields
    required this.makeRoot,
    required this.modelRoot,
    required this.yearRoot,
    required this.mileageRoot,
    required this.fuelTypeRoot,
    required this.transmissionTypeRoot,
    required this.colorRoot,
    required this.conditionRoot,
  });

  final String? id;
  final String? title;
  final String? description;
  final int? price;
  final Category? category;
  final String? location;
  final List<String> images;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? userId;
  final Details? details;
  final String? listingAction;
  final String? status;
  final Seller? seller;
  final List<SavedBy> savedBy;
  final bool? favorite;
  // Root level vehicle fields
  final String? makeRoot;
  final String? modelRoot;
  final int? yearRoot;
  final int? mileageRoot;
  final String? fuelTypeRoot;
  final String? transmissionTypeRoot;
  final String? colorRoot;
  final String? conditionRoot;

  // Vehicle-specific getters - check root level first, then nested details
  String? get fuelType {
    final rootLevel = fuelTypeRoot;
    final nested = details?.json['vehicles']?['fuelType'] ?? details?.json['fuelType'];
    final result = rootLevel ?? nested;
    print('🔍 [FAVORITE MODEL DEBUG] FuelType getter: $result (root: $rootLevel, nested: $nested)');
    return result;
  }
  
  int? get year {
    final rootLevel = yearRoot;
    final nested = details?.json['vehicles']?['year'] ?? details?.json['year'];
    final result = rootLevel ?? nested;
    print('🔍 [FAVORITE MODEL DEBUG] Year getter: $result (root: $rootLevel, nested: $nested)');
    return result;
  }
  
  String? get transmission {
    final rootLevel = transmissionTypeRoot;
    final nested = details?.json['vehicles']?['transmissionType'] ?? details?.json['vehicles']?['transmission'] ?? details?.json['transmissionType'] ?? details?.json['transmission'];
    final result = rootLevel ?? nested;
    print('🔍 [FAVORITE MODEL DEBUG] Transmission getter: $result (root: $rootLevel, nested: $nested)');
    return result;
  }
  
  int? get mileage {
    final rootLevel = mileageRoot;
    final nested = details?.json['vehicles']?['mileage'] ?? details?.json['mileage'];
    final result = rootLevel ?? nested;
    print('🔍 [FAVORITE MODEL DEBUG] Mileage getter: $result (root: $rootLevel, nested: $nested)');
    return result;
  }
  
  String? get make {
    final rootLevel = makeRoot;
    final nested = details?.json['vehicles']?['make'] ?? details?.json['make'];
    final result = rootLevel ?? nested;
    print('🔍 [FAVORITE MODEL DEBUG] Make getter: $result (root: $rootLevel, nested: $nested)');
    return result;
  }
  
  String? get model {
    final rootLevel = modelRoot;
    final nested = details?.json['vehicles']?['model'] ?? details?.json['model'];
    final result = rootLevel ?? nested;
    print('🔍 [FAVORITE MODEL DEBUG] Model getter: $result (root: $rootLevel, nested: $nested)');
    return result;
  }

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    print('🔍 [FAVORITE MODEL DEBUG] Parsing favorite with root vehicle fields:');
    print('  - make: ${json["make"]}');
    print('  - model: ${json["model"]}');
    print('  - year: ${json["year"]}');
    print('  - mileage: ${json["mileage"]}');
    print('  - fuelType: ${json["fuelType"]}');
    print('  - transmission: ${json["transmission"]} (backend field name)');
    print('  - exteriorColor: ${json["exteriorColor"]} (backend field name)');
    print('  - condition: ${json["condition"]}');
    
    return FavoriteModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      price: json["price"],
      category: json["category"] == null
          ? null
          : Category.fromJson(json["category"]),
      location: json["location"],
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      userId: json["userId"],
      details: json["details"] == null
          ? null
          : Details.fromJson(json["details"]),
      listingAction: json["listingAction"],
      status: json["status"],
      seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
      savedBy: json["savedBy"] == null
          ? []
          : List<SavedBy>.from(
              json["savedBy"]!.map((x) => SavedBy.fromJson(x))),
      favorite: json["favorite"],
      // Root level vehicle fields (matching backend field names)
      makeRoot: json["make"],
      modelRoot: json["model"],
      yearRoot: json["year"],
      mileageRoot: json["mileage"],
      fuelTypeRoot: json["fuelType"],
      transmissionTypeRoot: json["transmission"], // Backend sends "transmission"
      colorRoot: json["exteriorColor"], // Backend sends "exteriorColor"
      conditionRoot: json["condition"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "price": price,
    "category": category?.toJson(),
    "location": location,
    "images": images.map((x) => x).toList(),
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "userId": userId,
    "details": details?.toJson(),
    "listingAction": listingAction,
    "status": status,
    "seller": seller?.toJson(),
    "savedBy": savedBy.map((x) => x.toJson()).toList(),
    "favorite": favorite,
  };

  @override
  String toString() {
    return "$id, $title, $description, $price, $category, $location, $images, $createdAt, $updatedAt, $userId, $details, $listingAction, $status, $seller, $savedBy, $favorite, ";
  }
}
