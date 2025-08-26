class CityInfo {
  final String name;
  final double latitude;
  final double longitude;
  final List<NeighborInfo> neighbors;

  CityInfo({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.neighbors,
  });

  factory CityInfo.fromJson(Map<String, dynamic> json) {
    return CityInfo(
      name: json['name'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      neighbors:
          (json['neighbors'] as List<dynamic>?)
              ?.map((neighbor) => NeighborInfo.fromJson(neighbor))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'neighbors': neighbors.map((neighbor) => neighbor.toJson()).toList(),
    };
  }
}

class NeighborInfo {
  final String name;
  final double latitude;
  final double longitude;

  NeighborInfo({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory NeighborInfo.fromJson(Map<String, dynamic> json) {
    return NeighborInfo(
      name: json['name'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'latitude': latitude, 'longitude': longitude};
  }
}

class LocationSearchResult {
  final String placeId;
  final String displayName;
  final double lat;
  final double lon;
  final LocationAddress? address;
  final LocationNameDetails? nameDetails;

  LocationSearchResult({
    required this.placeId,
    required this.displayName,
    required this.lat,
    required this.lon,
    this.address,
    this.nameDetails,
  });

  factory LocationSearchResult.fromJson(Map<String, dynamic> json) {
    return LocationSearchResult(
      placeId: json['place_id'] ?? '',
      displayName: json['display_name'] ?? '',
      lat: (json['lat'] ?? 0.0).toDouble(),
      lon: (json['lon'] ?? 0.0).toDouble(),
      address: json['address'] != null
          ? LocationAddress.fromJson(json['address'])
          : null,
      nameDetails: json['namedetails'] != null
          ? LocationNameDetails.fromJson(json['namedetails'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'display_name': displayName,
      'lat': lat,
      'lon': lon,
      'address': address?.toJson(),
      'namedetails': nameDetails?.toJson(),
    };
  }
}

class LocationAddress {
  final String? city;
  final String? municipality;
  final String? country;
  final String? countryCode;

  LocationAddress({
    this.city,
    this.municipality,
    this.country,
    this.countryCode,
  });

  factory LocationAddress.fromJson(Map<String, dynamic> json) {
    return LocationAddress(
      city: json['city'],
      municipality: json['municipality'],
      country: json['country'],
      countryCode: json['country_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'municipality': municipality,
      'country': country,
      'country_code': countryCode,
    };
  }
}

class LocationNameDetails {
  final String? name;
  final String? nameAr;
  final String? nameEn;

  LocationNameDetails({this.name, this.nameAr, this.nameEn});

  factory LocationNameDetails.fromJson(Map<String, dynamic> json) {
    return LocationNameDetails(
      name: json['name'],
      nameAr: json['name:ar'],
      nameEn: json['name:en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'name:ar': nameAr, 'name:en': nameEn};
  }
}
