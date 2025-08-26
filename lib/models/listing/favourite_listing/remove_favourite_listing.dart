class RemoveFavouriteListing {
  RemoveFavouriteListing({
    required this.success,
    required this.data,
    required this.status,
  });

  final bool? success;
  final dynamic data;
  final int? status;

  factory RemoveFavouriteListing.fromJson(Map<String, dynamic> json) {
    return RemoveFavouriteListing(
      success: json["success"],
      data: json["data"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data,
    "status": status,
  };

  @override
  String toString() {
    return "$success, $data, $status, ";
  }
}
