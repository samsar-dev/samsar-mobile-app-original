class SearchQuery {
  final String? query;
  final String? category;
  final String? subCategory;
  final String? listingAction; // for_sale, for_rent
  final String? city;
  final String? sortBy;
  final int? year;
  final double? minPrice;
  final double? maxPrice;
  // Location-based filtering
  final double? latitude;
  final double? longitude;
  final double? radiusKm;
  final int page;
  final int limit;

  SearchQuery({
    this.query,
    this.category,
    this.subCategory,
    this.listingAction,
    this.city,
    this.sortBy,
    this.year,
    this.minPrice,
    this.maxPrice,
    // Location-based filtering
    this.latitude,
    this.longitude,
    this.radiusKm,
    this.page = 1,
    this.limit = 10,
  });

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    if (query != null && query!.isNotEmpty) params['query'] = query!;
    if (category != null && category!.isNotEmpty)
      params['category'] = category!;
    if (subCategory != null && subCategory!.isNotEmpty)
      params['subCategory'] = subCategory!;
    if (listingAction != null && listingAction!.isNotEmpty)
      params['listingAction'] = listingAction!;
    if (city != null && city!.isNotEmpty) params['city'] = city!;
    if (sortBy != null && sortBy!.isNotEmpty) params['sortBy'] = sortBy!;
    if (year != null) params['year'] = year.toString();
    if (minPrice != null) params['minPrice'] = minPrice.toString();
    if (maxPrice != null) params['maxPrice'] = maxPrice.toString();
    // Location-based parameters
    if (latitude != null) params['latitude'] = latitude.toString();
    if (longitude != null) params['longitude'] = longitude.toString();
    if (radiusKm != null) params['radiusKm'] = radiusKm.toString();
    params['page'] = page.toString();
    params['limit'] = limit.toString();
    return params;
  }

  SearchQuery copyWith({
    String? query,
    String? category,
    String? subCategory,
    String? listingAction,
    String? city,
    String? sortBy,
    int? year,
    double? minPrice,
    double? maxPrice,
    double? latitude,
    double? longitude,
    double? radiusKm,
    int? page,
    int? limit,
  }) {
    return SearchQuery(
      query: query ?? this.query,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      listingAction: listingAction ?? this.listingAction,
      city: city ?? this.city,
      sortBy: sortBy ?? this.sortBy,
      year: year ?? this.year,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusKm: radiusKm ?? this.radiusKm,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  @override
  String toString() {
    return 'SearchQuery(query: $query, category: $category, subCategory: $subCategory, listingAction: $listingAction, city: $city, sortBy: $sortBy, year: $year, minPrice: $minPrice, maxPrice: $maxPrice, latitude: $latitude, longitude: $longitude, radiusKm: $radiusKm, page: $page, limit: $limit)';
  }

  /// Check if this query has any filters applied
  bool get hasFilters {
    return subCategory != null ||
        listingAction != null ||
        city != null ||
        sortBy != null ||
        year != null ||
        minPrice != null ||
        maxPrice != null ||
        latitude != null ||
        longitude != null ||
        radiusKm != null;
  }
}

class SearchIndividualListingModel {
  SearchIndividualListingModel({
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
    // Check root level first, then nested
    final rootLevel = fuelTypeRoot;
    final nested = details?.json['vehicles']?['fuelType'] ?? details?.json['fuelType'];
    final result = rootLevel ?? nested;
    return result;
  }
  
  int? get year {
    final rootLevel = yearRoot;
    final nested = details?.json['vehicles']?['year'] ?? details?.json['year'];
    final result = rootLevel ?? nested;
    return result;
  }
  
  String? get transmission {
    final rootLevel = transmissionTypeRoot;
    final nested = details?.json['vehicles']?['transmissionType'] ?? details?.json['vehicles']?['transmission'] ?? details?.json['transmissionType'] ?? details?.json['transmission'];
    final result = rootLevel ?? nested;
    return result;
  }
  
  int? get mileage {
    final rootLevel = mileageRoot;
    final nested = details?.json['vehicles']?['mileage'] ?? details?.json['mileage'];
    final result = rootLevel ?? nested;
    return result;
  }
  
  String? get make {
    final rootLevel = makeRoot;
    final nested = details?.json['vehicles']?['make'] ?? details?.json['make'];
    final result = rootLevel ?? nested;
    return result;
  }
  
  String? get model {
    final rootLevel = modelRoot;
    final nested = details?.json['vehicles']?['model'] ?? details?.json['model'];
    final result = rootLevel ?? nested;
    return result;
  }

  // Real estate getters
  int? get bedrooms {
    return details?.json['real_estate']?['bedrooms'] ?? details?.json['bedrooms'];
  }
  
  int? get bathrooms {
    return details?.json['real_estate']?['bathrooms'] ?? details?.json['bathrooms'];
  }
  
  int? get yearBuilt {
    return details?.json['real_estate']?['yearBuilt'] ?? details?.json['yearBuilt'];
  }
  
  String? get size {
    return details?.json['real_estate']?['size'] ?? details?.json['size'];
  }
  
  int? get totalArea {
    // Try multiple field names that might contain area data
    final areaValue = details?.json['real_estate']?['totalArea'] ?? 
                     details?.json['totalArea'] ?? 
                     details?.json['real_estate']?['area'] ?? 
                     details?.json['area'];
    
    if (areaValue is int) return areaValue;
    if (areaValue is String) return int.tryParse(areaValue);
    return null;
  }

  factory SearchIndividualListingModel.fromJson(Map<String, dynamic> json) {
    
    return SearchIndividualListingModel(
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
    // Root level vehicle fields
    "make": makeRoot,
    "model": modelRoot,
    "year": yearRoot,
    "mileage": mileageRoot,
    "fuelType": fuelTypeRoot,
    "transmissionType": transmissionTypeRoot,
    "color": colorRoot,
    "condition": conditionRoot,
  };

  @override
  String toString() {
    return "$id, $title, $description, $price, $category, $location, $images, $createdAt, $updatedAt, $userId, $details, $listingAction, $status, $seller, $savedBy, ";
  }
}

class Category {
  Category({required this.mainCategory, required this.subCategory});

  final String? mainCategory;
  final String? subCategory;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      mainCategory: json["mainCategory"],
      subCategory: json["subCategory"],
    );
  }

  Map<String, dynamic> toJson() => {
    "mainCategory": mainCategory,
    "subCategory": subCategory,
  };

  @override
  String toString() {
    return "$mainCategory, $subCategory, ";
  }
}

class Details {
  Details({required this.json});
  final Map<String, dynamic> json;

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(json: json);
  }

  Map<String, dynamic> toJson() => json;

  @override
  String toString() {
    return "Details: $json";
  }
}

class SavedBy {
  SavedBy({required this.id, required this.userId});

  final String? id;
  final String? userId;

  factory SavedBy.fromJson(Map<String, dynamic> json) {
    return SavedBy(id: json["id"], userId: json["userId"]);
  }

  Map<String, dynamic> toJson() => {"id": id, "userId": userId};

  @override
  String toString() {
    return "$id, $userId, ";
  }
}

class Seller {
  Seller({
    required this.id,
    required this.username,
    required this.profilePicture,
  });

  final String? id;
  final String? username;
  final dynamic profilePicture;

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json["id"],
      username: json["username"],
      profilePicture: json["profilePicture"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "profilePicture": profilePicture,
  };

  @override
  String toString() {
    return "$id, $username, $profilePicture, ";
  }
}
