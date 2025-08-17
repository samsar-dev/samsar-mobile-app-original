class TrendingListings {
    TrendingListings({
        required this.success,
        required this.data,
        required this.status,
    });

    final bool? success;
    final TrendingData? data;
    final int? status;

    factory TrendingListings.fromJson(Map<String, dynamic> json){ 
        return TrendingListings(
            success: json["success"],
            data: json["data"] == null ? null : TrendingData.fromJson(json["data"]),
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

class TrendingData {
    TrendingData({
        required this.items,
    });

    final List<Item> items;

    factory TrendingData.fromJson(Map<String, dynamic> json){ 
        return TrendingData(
            items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
        );
    }

    Map<String, dynamic> toJson() => {
        "items": items.map((x) => x.toJson()).toList(),
    };

    @override
    String toString(){
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
        required this.mainCategory,
        required this.subCategory,
        required this.location,
        required this.condition,
        required this.listingAction,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.userId,
        required this.bathrooms,
        required this.bedrooms,
        required this.color,
        required this.engineNumber,
        required this.engineSize,
        required this.floors,
        required this.fuelType,

        required this.make,
        required this.mileage,
        required this.model,
        required this.parkingSpaces,
        required this.size,
        required this.transmission,
        required this.utilities,
        required this.year,
        required this.yearBuilt,
        required this.latitude,
        required this.longitude,
        required this.views,
        required this.viewUsersId,
        required this.images,
        required this.count,
    });

    final String? id;
    final String? title;
    final String? description;
    final int? price;
    final String? category;
    final String? mainCategory;
    final String? subCategory;
    final String? location;
    final dynamic condition;
    final String? listingAction;
    final String? status;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? userId;
    final dynamic bathrooms;
    final dynamic bedrooms;
    final dynamic color;
    final dynamic engineNumber;
    final dynamic engineSize;
    final dynamic floors;
    final dynamic fuelType;
    final dynamic make;
    final dynamic mileage;
    final dynamic model;
    final dynamic parkingSpaces;
    final dynamic size;
    final dynamic transmission;
    final dynamic utilities;
    final dynamic year;
    final dynamic yearBuilt;
    final int? latitude;
    final int? longitude;
    final int? views;
    final List<String> viewUsersId;
    final List<Image> images;
    final Count? count;

    factory Item.fromJson(Map<String, dynamic> json){ 
        return Item(
            id: json["id"],
            title: json["title"],
            description: json["description"],
            price: json["price"]?.toInt(),
            category: json["category"],
            mainCategory: json["mainCategory"],
            subCategory: json["subCategory"],
            location: json["location"],
            condition: json["condition"],
            listingAction: json["listingAction"],
            status: json["status"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            userId: json["userId"],
            bathrooms: json["bathrooms"],
            bedrooms: json["bedrooms"],
            color: json["color"],
            engineNumber: json["engineNumber"],
            engineSize: json["engineSize"],
            floors: json["floors"],
            fuelType: json["fuelType"],

            make: json["make"],
            mileage: json["mileage"],
            model: json["model"],
            parkingSpaces: json["parkingSpaces"],
            size: json["size"],
            transmission: json["transmission"],
            utilities: json["utilities"],
            year: json["year"],
            yearBuilt: json["yearBuilt"],
            latitude: json["latitude"] is double ? (json["latitude"] as double).toInt() : json["latitude"],
            longitude: json["longitude"] is double ? (json["longitude"] as double).toInt() : json["longitude"],
            views: json["views"] is double ? (json["views"] as double).toInt() : json["views"],
            viewUsersId: json["viewUsersId"] == null ? [] : List<String>.from(json["viewUsersId"]!.map((x) => x)),
            images: json["images"] == null ? [] : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
            count: json["_count"] == null ? null : Count.fromJson(json["_count"]),
        );
    }

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "price": price,
        "category": category,
        "mainCategory": mainCategory,
        "subCategory": subCategory,
        "location": location,
        "condition": condition,
        "listingAction": listingAction,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "userId": userId,
        "bathrooms": bathrooms,
        "bedrooms": bedrooms,
        "color": color,
        "engineNumber": engineNumber,
        "engineSize": engineSize,
        "floors": floors,
        "fuelType": fuelType,
        "make": make,
        "mileage": mileage,
        "model": model,
        "parkingSpaces": parkingSpaces,
        "size": size,
        "transmission": transmission,
        "utilities": utilities,
        "year": year,
        "yearBuilt": yearBuilt,
        "latitude": latitude,
        "longitude": longitude,
        "views": views,
        "viewUsersId": viewUsersId.map((x) => x).toList(),
        "images": images.map((x) => x.toJson()).toList(),
        "_count": count?.toJson(),
    };

    @override
    String toString(){
        return "$id, $title, $description, $price, $category, $mainCategory, $subCategory, $location, $condition, $listingAction, $status, $createdAt, $updatedAt, $userId, $bathrooms, $bedrooms, $color, $engineNumber, $engineSize, $floors, $fuelType, $make, $mileage, $model, $parkingSpaces, $size, $transmission, $utilities, $year, $yearBuilt, $latitude, $longitude, $views, $viewUsersId, $images, $count, ";
    }
}

class Count {
    Count({
        required this.favorites,
    });

    final int? favorites;

    factory Count.fromJson(Map<String, dynamic> json){ 
        return Count(
            favorites: json["favorites"],
        );
    }

    Map<String, dynamic> toJson() => {
        "favorites": favorites,
    };

    @override
    String toString(){
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

    factory Image.fromJson(Map<String, dynamic> json){ 
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
    String toString(){
        return "$id, $url, $order, $listingId, ";
    }
}
