class ListingResponse {
  ListingResponse({
    required this.success,
    required this.data,
    required this.status,
  });

  final bool? success;
  final ListingData? data;
  final int? status;

  factory ListingResponse.fromJson(Map<String, dynamic> json) {
    return ListingResponse(
      success: json["success"],
      data: json["data"] == null ? null : ListingData.fromJson(json["data"]),
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "status": status,
  };

  @override
  String toString() {
    return "$success, $data, $status, ";
  }
}

class ListingData {
  ListingData({required this.items});

  final List<Item> items;

  factory ListingData.fromJson(Map<String, dynamic> json) {
    // Backend returns data as direct array, not nested in items
    if (json["data"] is List) {
      return ListingData(
        items: List<Item>.from(json["data"].map((x) => Item.fromJson(x))),
      );
    } else {
      return ListingData(
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      );
    }
  }

  Map<String, dynamic> toJson() => {
    "items": items.map((x) => x.toJson()).toList(),
  };

  @override
  String toString() {
    return "$items, ";
  }
}

class Item {
  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.location,
    required this.listingAction,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.views,
    required this.images,
    required this.seller,
    required this.details,
    // Root level vehicle fields from backend
    required this.makeRoot,
    required this.modelRoot,
    required this.yearRoot,
    required this.mileageRoot,
    required this.fuelTypeRoot,
    required this.transmissionRoot,
    required this.exteriorColorRoot,
    required this.conditionRoot,
    // Root level real estate fields from backend
    required this.totalAreaRoot,
    required this.yearBuiltRoot,
    required this.furnishingRoot,
    required this.floorRoot,
    required this.totalFloorsRoot,
  });

  final String? id;
  final String? title;
  final String? description;
  final int? price;
  final CategoryInfo? category;
  final String? location;
  final String? listingAction;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? userId;
  final int? views;
  final List<String> images;
  final Seller? seller;
  final Details? details;
  // Root level vehicle fields from backend
  final String? makeRoot;
  final String? modelRoot;
  final int? yearRoot;
  final int? mileageRoot;
  final String? fuelTypeRoot;
  final String? transmissionRoot;
  final String? exteriorColorRoot;
  final String? conditionRoot;
  // Root level real estate fields from backend
  final int? totalAreaRoot;
  final int? yearBuiltRoot;
  final String? furnishingRoot;
  final int? floorRoot;
  final int? totalFloorsRoot;

  // Helper getters for backward compatibility
  String? get mainCategory => category?.mainCategory;
  String? get subCategory => category?.subCategory;

  // Vehicle-specific getters - check root level first, then nested details
  String? get fuelType {
    return fuelTypeRoot ?? details?.vehicles?.fuelType ?? details?.flatDetails?["fuelType"];
  }
  
  int? get year {
    return yearRoot ?? details?.vehicles?.year ?? details?.flatDetails?["year"];
  }
  
  String? get transmission {
    return transmissionRoot ?? details?.vehicles?.transmission ?? details?.flatDetails?["transmissionType"];
  }
  
  int? get mileage {
    return mileageRoot ?? details?.vehicles?.mileage ?? details?.flatDetails?["mileage"];
  }
  
  String? get make {
    return makeRoot ?? details?.vehicles?.make ?? details?.flatDetails?["make"];
  }
  
  String? get model {
    return modelRoot ?? details?.vehicles?.model ?? details?.flatDetails?["model"];
  }

  // Real estate getters from details
  int? get bedrooms =>
      details?.realEstate?.bedrooms ?? details?.flatDetails?["bedrooms"];
  int? get bathrooms =>
      details?.realEstate?.bathrooms ?? details?.flatDetails?["bathrooms"];
  int? get yearBuilt {
    // Check root level first (like individual listing detail model), then nested details
    final yearValue = yearBuiltRoot ?? 
                     details?.realEstate?.yearBuilt ?? 
                     details?.flatDetails?["yearBuilt"] ??
                     details?.flatDetails?["year_built"];
    
    print('🔍 [YEAR BUILT DEBUG] yearBuilt getter called for item: $title');
    print('  - yearBuiltRoot: $yearBuiltRoot');
    print('  - realEstate yearBuilt: ${details?.realEstate?.yearBuilt}');
    print('  - flatDetails yearBuilt: ${details?.flatDetails?["yearBuilt"]}');
    print('  - flatDetails year_built: ${details?.flatDetails?["year_built"]}');
    print('  - final yearValue: $yearValue');
    
    return yearValue;
  }
  String? get size =>
      details?.realEstate?.size ?? details?.flatDetails?["size"];
  
  int? get totalArea {
    // Check root level first (like individual listing detail model), then nested details
    final areaValue = totalAreaRoot ?? 
                     details?.flatDetails?["totalArea"] ?? 
                     details?.flatDetails?["area"] ??
                     details?.realEstate?.size;
    
    if (areaValue is int) return areaValue;
    if (areaValue is String) return int.tryParse(areaValue);
    return null;
  }
  
  int? get floors =>
      details?.realEstate?.floors ?? details?.flatDetails?["floors"];
  String? get utilities =>
      details?.realEstate?.utilities ?? details?.flatDetails?["utilities"];
  int? get parkingSpaces =>
      details?.realEstate?.parkingSpaces ??
      details?.flatDetails?["parkingSpaces"];

  // Common getters - check root level first, then nested details
  String? get color {
    return exteriorColorRoot ?? details?.vehicles?.color ?? details?.realEstate?.color ?? details?.flatDetails?["color"];
  }
  
  String? get condition {
    return conditionRoot ?? details?.vehicles?.condition ?? details?.realEstate?.condition ?? details?.flatDetails?["condition"];
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    print('🔍 [ITEM JSON DEBUG] Raw JSON for item: ${json["title"]}');
    print('  - Raw JSON keys: ${json.keys.toList()}');
    print('  - details keys: ${json["details"]?.keys?.toList()}');
    if (json["details"]?["realEstate"] != null) {
      print('  - realEstate keys: ${json["details"]["realEstate"].keys.toList()}');
    }
    if (json["details"]?["flatDetails"] != null) {
      print('  - flatDetails keys: ${json["details"]["flatDetails"].keys.toList()}');
    }
    
    return Item(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      price: json["price"]?.toInt(),
      category: json["category"] != null
          ? CategoryInfo.fromJson(json["category"])
          : null,
      location: json["location"],
      listingAction: json["listingAction"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      userId: json["userId"],
      views: json["views"] is double
          ? (json["views"] as double).toInt()
          : json["views"],
      images: json["images"] == null ? [] : List<String>.from(json["images"]),
      seller: json["seller"] != null ? Seller.fromJson(json["seller"]) : null,
      details: json["details"] != null
          ? Details.fromJson(json["details"])
          : null,
      // Root level vehicle fields from backend
      makeRoot: json["make"],
      modelRoot: json["model"],
      yearRoot: json["year"],
      mileageRoot: json["mileage"],
      fuelTypeRoot: json["fuelType"],
      transmissionRoot: json["transmission"],
      exteriorColorRoot: json["exteriorColor"],
      conditionRoot: json["condition"],
      // Root level real estate fields from backend
      totalAreaRoot: json["totalArea"],
      yearBuiltRoot: json["yearBuilt"],
      furnishingRoot: json["furnishing"],
      floorRoot: json["floor"],
      totalFloorsRoot: json["totalFloors"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "price": price,
    "category": category?.toJson(),
    "location": location,
    "listingAction": listingAction,
    "status": status,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "userId": userId,
    "views": views,
    "images": images,
    "seller": seller?.toJson(),
    "details": details?.toJson(),
    // Root level vehicle fields
    "make": makeRoot,
    "model": modelRoot,
    "year": yearRoot,
    "mileage": mileageRoot,
    "fuelType": fuelTypeRoot,
    "transmission": transmissionRoot,
    "exteriorColor": exteriorColorRoot,
    "condition": conditionRoot,
  };

  @override
  String toString() {
    return "$id, $title, $description, $price, $category, $location, $listingAction, $status, $createdAt, $updatedAt, $userId, $views, $images, $seller, $details, ";
  }
}

class CategoryInfo {
  CategoryInfo({required this.mainCategory, required this.subCategory});

  final String? mainCategory;
  final String? subCategory;

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      mainCategory: json["mainCategory"],
      subCategory: json["subCategory"],
    );
  }

  Map<String, dynamic> toJson() => {
    "mainCategory": mainCategory,
    "subCategory": subCategory,
  };
}

class Seller {
  Seller({
    required this.id,
    required this.username,
    required this.profilePicture,
    required this.allowMessaging,
    required this.privateProfile,
  });

  final String? id;
  final String? username;
  final String? profilePicture;
  final bool? allowMessaging;
  final bool? privateProfile;

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json["id"],
      username: json["username"],
      profilePicture: json["profilePicture"],
      allowMessaging: json["allowMessaging"],
      privateProfile: json["privateProfile"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "profilePicture": profilePicture,
    "allowMessaging": allowMessaging,
    "privateProfile": privateProfile,
  };
}

class Details {
  Details({
    required this.vehicles,
    required this.realEstate,
    required this.flatDetails,
  });

  final VehicleDetails? vehicles;
  final RealEstateDetails? realEstate;
  final Map<String, dynamic>? flatDetails;

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      vehicles: json["vehicles"] != null
          ? VehicleDetails.fromJson(json["vehicles"])
          : null,
      realEstate: json["real_estate"] != null
          ? RealEstateDetails.fromJson(json["real_estate"])
          : null,
      flatDetails: json["vehicles"] == null && json["real_estate"] == null
          ? json
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "vehicles": vehicles?.toJson(),
    "real_estate": realEstate?.toJson(),
    if (flatDetails != null) ...flatDetails!,
  };
}

class VehicleDetails {
  VehicleDetails({
    required this.make,
    required this.model,
    required this.year,
    required this.mileage,
    required this.fuelType,
    required this.transmission,
    required this.color,
    required this.condition,
    required this.vehicleType,
  });

  final String? make;
  final String? model;
  final int? year;
  final int? mileage;
  final String? fuelType;
  final String? transmission;
  final String? color;
  final String? condition;
  final String? vehicleType;

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      make: json["make"],
      model: json["model"],
      year: json["year"],
      mileage: json["mileage"],
      fuelType: json["fuelType"],
      transmission: json["transmission"],
      color: json["color"],
      condition: json["condition"],
      vehicleType: json["vehicleType"],
    );
  }

  Map<String, dynamic> toJson() => {
    "make": make,
    "model": model,
    "year": year,
    "mileage": mileage,
    "fuelType": fuelType,
    "transmission": transmission,
    "color": color,
    "condition": condition,
    "vehicleType": vehicleType,
  };
}

class RealEstateDetails {
  RealEstateDetails({
    required this.bedrooms,
    required this.bathrooms,
    required this.yearBuilt,
    required this.size,
    required this.floors,
    required this.utilities,
    required this.parkingSpaces,
    required this.color,
    required this.condition,
  });

  final int? bedrooms;
  final int? bathrooms;
  final int? yearBuilt;
  final String? size;
  final int? floors;
  final String? utilities;
  final int? parkingSpaces;
  final String? color;
  final String? condition;

  factory RealEstateDetails.fromJson(Map<String, dynamic> json) {
    return RealEstateDetails(
      bedrooms: json["bedrooms"],
      bathrooms: json["bathrooms"],
      yearBuilt: json["yearBuilt"],
      size: json["size"],
      floors: json["floors"],
      utilities: json["utilities"],
      parkingSpaces: json["parkingSpaces"],
      color: json["color"],
      condition: json["condition"],
    );
  }

  Map<String, dynamic> toJson() => {
    "bedrooms": bedrooms,
    "bathrooms": bathrooms,
    "yearBuilt": yearBuilt,
    "size": size,
    "floors": floors,
    "utilities": utilities,
    "parkingSpaces": parkingSpaces,
    "color": color,
    "condition": condition,
  };
}

class Count {
  Count({required this.favorites});

  final int? favorites;

  factory Count.fromJson(Map<String, dynamic> json) {
    return Count(favorites: json["favorites"]);
  }

  Map<String, dynamic> toJson() => {"favorites": favorites};

  @override
  String toString() {
    return "$favorites, ";
  }
}

class Image {
  Image({
    required this.id,
    required this.url,
    required this.order,
    required this.listingId,
  });

  final String? id;
  final String? url;
  final int? order;
  final String? listingId;

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json["id"],
      url: json["url"],
      order: json["order"],
      listingId: json["listingId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "url": url,
    "order": order,
    "listingId": listingId,
  };

  @override
  String toString() {
    return "$id, $url, $order, $listingId, ";
  }
}
