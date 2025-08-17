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
  final String sellerType;
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
    required this.sellerType,
    required this.listingImage,
    required this.details,
  });
}

class RealEstateDetails {
  final String propertyType;
  final int? bedrooms;
  final int? bathrooms;
  final String? furnishing;
  final int? floor;
  final int? totalFloors;
  final String? parking;
  final int? yearBuilt;
  final String? facing;
  final int? balconies;
  final int? plotSize;
  final String? garden;
  final String? pool;
  final String? officeType;
  final int? totalArea;
  final int? meetingRooms;
  final String? zoning;
  final String? roadAccess;

  RealEstateDetails({
    required this.propertyType,
    this.bedrooms,
    this.bathrooms,
    this.furnishing,
    this.floor,
    this.totalFloors,
    this.parking,
    this.yearBuilt,
    this.facing,
    this.balconies,
    this.plotSize,
    this.garden,
    this.pool,
    this.officeType,
    this.totalArea,
    this.meetingRooms,
    this.zoning,
    this.roadAccess,
  });

  Map<String, dynamic> toJson() => {
        'propertyType': propertyType,
        if (bedrooms != null) 'bedrooms': bedrooms,
        if (bathrooms != null) 'bathrooms': bathrooms,
        if (furnishing != null) 'furnishing': furnishing,
        if (floor != null) 'floor': floor,
        if (totalFloors != null) 'totalFloors': totalFloors,
        if (parking != null) 'parking': parking,
        if (yearBuilt != null) 'yearBuilt': yearBuilt,
        if (facing != null) 'facing': facing,
        if (balconies != null) 'balconies': balconies,
        if (plotSize != null) 'plotSize': plotSize,
        if (garden != null) 'garden': garden,
        if (pool != null) 'pool': pool,
        if (officeType != null) 'officeType': officeType,
        if (totalArea != null) 'totalArea': totalArea,
        if (meetingRooms != null) 'meetingRooms': meetingRooms,
        if (zoning != null) 'zoning': zoning,
        if (roadAccess != null) 'roadAccess': roadAccess,
      };
}
