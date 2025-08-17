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

    factory FavoriteModel.fromJson(Map<String, dynamic> json){ 
        return FavoriteModel(
            id: json["id"],
            title: json["title"],
            description: json["description"],
            price: json["price"],
            category: json["category"] == null ? null : Category.fromJson(json["category"]),
            location: json["location"],
            images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            userId: json["userId"],
            details: json["details"] == null ? null : Details.fromJson(json["details"]),
            listingAction: json["listingAction"],
            status: json["status"],
            seller: json["seller"] == null ? null : Seller.fromJson(json["seller"]),
            savedBy: json["savedBy"] == null ? [] : List<SavedBy>.from(json["savedBy"]!.map((x) => SavedBy.fromJson(x))),
            favorite: json["favorite"],
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
    String toString(){
        return "$id, $title, $description, $price, $category, $location, $images, $createdAt, $updatedAt, $userId, $details, $listingAction, $status, $seller, $savedBy, $favorite, ";
    }
}