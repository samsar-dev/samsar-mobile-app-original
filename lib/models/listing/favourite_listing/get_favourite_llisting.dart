import 'package:samsar/models/listing/favourite_listing/favourite_model.dart';

class GetFavouriteListingSuccessResponse {
    GetFavouriteListingSuccessResponse({
        required this.success,
        required this.data,
        required this.status,
    });

    final bool? success;
    final FavouriteData? data;
    final int? status;

    factory GetFavouriteListingSuccessResponse.fromJson(Map<String, dynamic> json){ 
        return GetFavouriteListingSuccessResponse(
            success: json["success"],
            data: json["data"] == null ? null : FavouriteData.fromJson(json["data"]),
            status: json["status"],
        );
    }

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "status": status,
    };

    @override
    String toString(){
        return "$success, $data, $status, ";
    }
}

class FavouriteData {
    FavouriteData({
        required this.favorites,
    });

    final List<FavoriteModel> favorites;

    factory FavouriteData.fromJson(Map<String, dynamic> json){ 
        return FavouriteData(
            favorites: json["favorites"] == null ? [] : List<FavoriteModel>.from(json["favorites"]!.map((x) => FavoriteModel.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "favorites": favorites.map((x) => x.toJson()).toList(),
    };

    @override
    String toString(){
        return "$favorites, ";
    }
}


class Category {
    Category({
        required this.mainCategory,
        required this.subCategory,
    });

    final String? mainCategory;
    final String? subCategory;

    factory Category.fromJson(Map<String, dynamic> json){ 
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
    String toString(){
        return "$mainCategory, $subCategory, ";
    }
}

class Details {
    Details({required this.json});
    final Map<String,dynamic> json;

    factory Details.fromJson(Map<String, dynamic> json){ 
        return Details(
        json: json
        );
    }

    Map<String, dynamic> toJson() => {
    };

    @override
    String toString(){
        return "";
    }
}

class SavedBy {
    SavedBy({
        required this.id,
        required this.userId,
    });

    final String? id;
    final String? userId;

    factory SavedBy.fromJson(Map<String, dynamic> json){ 
        return SavedBy(
            id: json["id"],
            userId: json["userId"],
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
    };

    @override
    String toString(){
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

    factory Seller.fromJson(Map<String, dynamic> json){ 
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
    String toString(){
        return "$id, $username, $profilePicture, ";
    }
}
