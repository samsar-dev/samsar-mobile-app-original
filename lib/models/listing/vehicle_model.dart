class VehicleModel {
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
  final String sellerType;
  final List<String> listingImage;
  final Details details;

  VehicleModel({
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
    required this.sellerType,
    required this.listingImage,
    required this.details,
  });
}

class Details {
  final Map<String, dynamic> json;

  Details({required this.json});

  Map<String, dynamic> toJson() => json;
}
