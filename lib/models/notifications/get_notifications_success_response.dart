class GetNotificationSuccessResponse {
  GetNotificationSuccessResponse({required this.success, required this.data});

  final bool? success;
  final Data? data;

  factory GetNotificationSuccessResponse.fromJson(Map<String, dynamic> json) {
    return GetNotificationSuccessResponse(
      success: json["success"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {"success": success, "data": data?.toJson()};

  @override
  String toString() {
    return "$success, $data, ";
  }
}

class Data {
  Data({required this.items, required this.pagination});

  final List<Item> items;
  final Pagination? pagination;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      items: json["items"] == null
          ? []
          : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      pagination: json["pagination"] == null
          ? null
          : Pagination.fromJson(json["pagination"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "items": items.map((x) => x.toJson()).toList(),
    "pagination": pagination?.toJson(),
  };

  @override
  String toString() {
    return "$items, $pagination, ";
  }
}

class Item {
  Item({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.listingId,
    required this.read,
    required this.createdAt,
    required this.updatedAt,
    required this.targetId,
    required this.targetType,
  });

  final String? id;
  final String? userId;
  final String? type;
  final String? title;
  final String? message;
  final String? listingId;
  final bool? read;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic targetId;
  final String? targetType;

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json["id"],
      userId: json["userId"],
      type: json["type"],
      title: json["title"],
      message: json["message"],
      listingId: json["listingId"],
      read: json["read"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      targetId: json["targetId"],
      targetType: json["targetType"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "type": type,
    "title": title,
    "message": message,
    "listingId": listingId,
    "read": read,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "targetId": targetId,
    "targetType": targetType,
  };

  @override
  String toString() {
    return "$id, $userId, $type, $title, $message, $listingId, $read, $createdAt, $updatedAt, $targetId, $targetType, ";
  }
}

class Pagination {
  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? pages;

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json["page"],
      limit: json["limit"],
      total: json["total"],
      pages: json["pages"],
    );
  }

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
    "pages": pages,
  };

  @override
  String toString() {
    return "$page, $limit, $total, $pages, ";
  }
}
