class CreateRealEstateListing {
  CreateRealEstateListing({
    required this.success,
    required this.data,
    required this.status,
  });

  final bool? success;
  final Data? data;
  final int? status;

  factory CreateRealEstateListing.fromJson(Map<String, dynamic> json) {
    return CreateRealEstateListing(
      success: json["success"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
    "status": status,
  };
}

class Data {
  Data({
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
    required this.views,
    required this.details,
    required this.listingAction,
    required this.status,
    required this.seller,
    required this.savedBy,
  });

  final String? id;
  final String? title;
  final String? description;
  final int? price;
  final Category? category;
  final String? location;
  final List<dynamic> images;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? userId;
  final int? views;
  final Details? details;
  final String? listingAction;
  final String? status;
  final Seller? seller;
  final List<SavedBy> savedBy;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
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
          : List<dynamic>.from(json["images"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      userId: json["userId"],
      views: json["views"],
      details: json["details"] == null
          ? null
          : Details.fromJson(json["details"]),
      listingAction: json["listingAction"],
      status: json["status"],
      seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
      savedBy: json["savedBy"] == null
          ? []
          : List<SavedBy>.from(
              json["savedBy"]!.map((x) => SavedBy.fromJson(x)),
            ),
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
    "views": views,
    "details": details?.toJson(),
    "listingAction": listingAction,
    "status": status,
    "seller": seller?.toJson(),
    "savedBy": savedBy.map((x) => x.toJson()).toList(),
  };
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
}

class Details {
  Details({required this.json});
  final Map<String, dynamic> json;

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(json: json);
  }

  Map<String, dynamic> toJson() => json;
}

class SavedBy {
  SavedBy({required this.id, required this.userId});

  final String? id;
  final String? userId;

  factory SavedBy.fromJson(Map<String, dynamic> json) {
    return SavedBy(id: json["id"], userId: json["userId"]);
  }

  Map<String, dynamic> toJson() => {"id": id, "userId": userId};
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
  final dynamic profilePicture;
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

class RealEstateModel {
  final String title;
  final String description;
  final int price;
  final String mainCategory;
  final String subCategory;
  final String location;
  final double? latitude;
  final double? longitude;
  final String condition;
  final String listingAction;
  final List<String> listingImage;
  final RealEstateDetails details;

  RealEstateModel({
    required this.title,
    required this.description,
    required this.price,
    required this.mainCategory,
    required this.subCategory,
    required this.location,
    this.latitude,
    this.longitude,
    required this.condition,
    required this.listingAction,
    required this.listingImage,
    required this.details,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'price': price,
    'mainCategory': mainCategory,
    'subCategory': subCategory,
    'location': location,
    'latitude': latitude,
    'longitude': longitude,
    'condition': condition,
    'listingAction': listingAction,
    'listingImage': listingImage,
    'details': details.toJson(),
  };
}

class RealEstateDetails {
  final String propertyType;
  final Map<String, dynamic> attributes;

  RealEstateDetails({required this.propertyType, required this.attributes});

  Map<String, dynamic> toJson() => {
    'propertyType': propertyType,
    ...attributes,
  };
}
