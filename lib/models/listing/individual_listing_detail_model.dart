class IndividualListingDetailModel {
  IndividualListingDetailModel({
    required this.success,
    required this.data,
    required this.status,
  });

  final bool? success;
  final Data? data;
  final int? status;

  factory IndividualListingDetailModel.fromJson(Map<String, dynamic> json) {
    return IndividualListingDetailModel(
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

  @override
  String toString() {
    return "$success, $data, $status, ";
  }
}

class Data {
  Data({
    required this.id,
    required this.displayId,
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
    required this.sellerType,
    // Vehicle fields at root level
    required this.make,
    required this.model,
    required this.year,
    required this.mileage,
    required this.fuelType,
    required this.transmissionType,
    required this.color,
    required this.condition,
    required this.bodyType,
    required this.accidental,
    required this.engineSize,
  });

  final String? id;
  final String? displayId;
  final String? title;
  final String? description;
  final int? price;
  final Category? category;
  final String? location;
  final List<String> images;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? userId;
  final int? views;
  final Details? details;
  final String? listingAction;
  final String? status;
  final Seller? seller;
  final List<dynamic> savedBy;
  final String? sellerType;
  // Vehicle fields at root level
  final String? make;
  final String? model;
  final int? year;
  final int? mileage;
  final String? fuelType;
  final String? transmissionType;
  final String? color;
  final String? condition;
  final String? bodyType;
  final String? accidental;
  final double? engineSize;

  factory Data.fromJson(Map<String, dynamic> json) {
    print('🔍 [DATA MODEL DEBUG] Parsing root level vehicle fields:');
    print('  - make: ${json["make"]}');
    print('  - model: ${json["model"]}');
    print('  - year: ${json["year"]}');
    print('  - mileage: ${json["mileage"]}');
    print('  - fuelType: ${json["fuelType"]}');
    print('  - transmission: ${json["transmission"]} (backend field name)');
    print('  - exteriorColor: ${json["exteriorColor"]} (backend field name)');
    print('  - condition: ${json["condition"]}');
    print('  - bodyType: ${json["bodyType"]} (backend field name)');
    print('  - accidental: ${json["accidental"]} (backend field name)');
    print('  - engineSize: ${json["engineSize"]} (backend field name)');
    print('  - listingAction: ${json["listingAction"]} (backend field name)');
    print('  - sellerType: ${json["sellerType"]} (backend field name)');
    
    return Data(
      id: json["id"],
      displayId: json["displayId"],
      title: json["title"],
      description: json["description"],
      price: json["price"],
      category: json["category"] == null
          ? null
          : Category.fromJson(json["category"]),
      location: json["location"],
      images: json["images"] == null
          ? []
          : List<String>.from(json["images"]!.map((x) => x)),
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
          : List<dynamic>.from(json["savedBy"]!.map((x) => x)),
      sellerType: json["sellerType"],
      // Vehicle fields at root level
      make: json["make"],
      model: json["model"],
      year: json["year"],
      mileage: json["mileage"],
      fuelType: json["fuelType"],
      transmissionType: json["transmission"], // Backend sends "transmission"
      color: json["exteriorColor"], // Backend sends "exteriorColor"
      condition: json["condition"],
      bodyType: json["bodyType"], // Backend sends "bodyType"
      accidental: json["accidental"], // Backend sends "accidental"
      engineSize: json["engineSize"]?.toDouble(), // Backend sends "engineSize"
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "displayId": displayId,
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
    "savedBy": savedBy.map((x) => x).toList(),
    "sellerType": sellerType,
    // Vehicle fields at root level
    "make": make,
    "model": model,
    "year": year,
    "mileage": mileage,
    "fuelType": fuelType,
    "transmissionType": transmissionType,
    "color": color,
    "condition": condition,
  };

  @override
  String toString() {
    return "$id, $title, $description, $price, $category, $location, $images, $createdAt, $updatedAt, $userId, $views, $details, $listingAction, $status, $seller, $savedBy, ";
  }
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

  @override
  String toString() {
    return "$mainCategory, $subCategory, ";
  }
}

class Details {
  Details({required this.vehicles, required this.realEstate});

  final Vehicles? vehicles;
  final RealEstate? realEstate;

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      vehicles: json["vehicles"] == null
          ? null
          : Vehicles.fromJson(json["vehicles"]),
      realEstate: json["realEstate"] == null
          ? null
          : RealEstate.fromJson(json["realEstate"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "vehicles": vehicles?.toJson(),
    "realEstate": realEstate?.toJson(),
  };

  @override
  String toString() {
    return "$vehicles, $realEstate, ";
  }
}

class Vehicles {
  Vehicles({
    required this.vehicleType,
    required this.make,
    required this.model,
    required this.year,
    required this.mileage,
    required this.fuelType,
    required this.transmissionType,
    required this.color,
    required this.condition,
    required this.warranty,
    required this.previousOwners,
    required this.engineSize,
    required this.accidentFree,
    required this.adaptiveCruiseControl,
    required this.additionalNotes,
    required this.automaticEmergencyBraking,
    required this.bodyType,
    required this.cruiseControl,
    required this.curtainAirbags,
    required this.customsCleared,
    required this.driveType,
    required this.frontAirbags,
    required this.horsepower,
    required this.importStatus,
    required this.kneeAirbags,
    required this.laneDepartureWarning,
    required this.laneKeepAssist,
    required this.navigationSystem,
    required this.roofType,
    required this.serviceHistoryDetails,
    required this.sideAirbags,
    required this.warrantyPeriod,
    required this.serviceHistory,
    required this.registrationExpiry,
    required this.engineNumber,
    // Missing fields from database
    required this.abs,
    required this.airbags,
    required this.features,
    required this.wheelSize,
    required this.wheelType,
    required this.laneAssist,
    required this.parkingBreak,
    required this.emissionClass,
    required this.parkingSensor,
    required this.fuelEfficiency,
    required this.tractionControl,
    required this.registrationStatus,
    // Additional fields from user's JSON
    required this.doors,
    required this.seats,
    required this.torque,
    required this.bluetooth,
    required this.androidAuto,
    required this.appleCarPlay,
    required this.parkingAidCamera,
    // Missing fields from ListingInputController
    required this.blindSpotMonitor,
    required this.emergencyBraking,
    required this.fatigueWarningSystem,
    required this.isofix,
    required this.emergencyCallSystem,
    required this.speedLimited,
    required this.tirePressureMonitoring,
    required this.rearCamera,
    required this.threeSixtyCamera,
    required this.trafficSignRecognition,
    required this.automaticHighBeam,
    required this.lightSensor,
    required this.hillStartAssist,
    required this.parkingAssist,
    required this.ledHeadlights,
    required this.adaptiveHeadlights,
    required this.fogLights,
    required this.daytimeRunningLights,
    required this.ambientLighting,
    required this.premiumSoundSystem,
    required this.wirelessCharging,
    required this.usbPorts,
    required this.onboardComputer,
    required this.dabFmRadio,
    required this.wifiHotspot,
    required this.integratedStreaming,
    required this.rearSeatEntertainment,
    required this.summerTires,
    required this.payloadCapacity,
    required this.towingCapacity,
    required this.seatingCapacity,
    required this.airConditioning,
    required this.entertainmentSystem,
    required this.cargoVolume,
    required this.axles,
    required this.gvwr,
    required this.operatingWeight,
    required this.bucketCapacity,
    required this.liftingCapacity,
    required this.reach,
    required this.workingHours,
  });

  final String? vehicleType;
  final String? make;
  final String? model;
  final int? year;
  final int? mileage;
  final String? fuelType;
  final String? transmissionType;
  final String? color;
  final String? condition;
  final String? warranty;
  final int? previousOwners;
  final String? engineSize;
  final bool? accidentFree;
  final bool? adaptiveCruiseControl;
  final String? additionalNotes;
  final bool? automaticEmergencyBraking;
  final String? bodyType;
  final bool? cruiseControl;
  final bool? curtainAirbags;
  final bool? customsCleared;
  final String? driveType;
  final bool? frontAirbags;
  final int? horsepower;
  final String? importStatus;
  final bool? kneeAirbags;
  final bool? laneDepartureWarning;
  final bool? laneKeepAssist;
  final String? navigationSystem;
  final String? roofType;
  final String? serviceHistoryDetails;
  final bool? sideAirbags;
  final String? warrantyPeriod;
  final List<String> serviceHistory;
  final String? registrationExpiry;
  final String? engineNumber;
  // Missing fields from database
  final bool? abs;
  final int? airbags;
  final List<String> features;
  final String? wheelSize;
  final String? wheelType;
  final bool? laneAssist;
  final String? parkingBreak;
  final String? emissionClass;
  final String? parkingSensor;
  final String? fuelEfficiency;
  final bool? tractionControl;
  final String? registrationStatus;
  // Additional fields from user's JSON
  final int? doors;
  final int? seats;
  final int? torque;
  final bool? bluetooth;
  final bool? androidAuto;
  final bool? appleCarPlay;
  final bool? parkingAidCamera;
  // Missing fields from ListingInputController
  final bool? blindSpotMonitor;
  final bool? emergencyBraking;
  final bool? fatigueWarningSystem;
  final bool? isofix;
  final bool? emergencyCallSystem;
  final bool? speedLimited;
  final bool? tirePressureMonitoring;
  final bool? rearCamera;
  final bool? threeSixtyCamera;
  final bool? trafficSignRecognition;
  final bool? automaticHighBeam;
  final bool? lightSensor;
  final bool? hillStartAssist;
  final bool? parkingAssist;
  final bool? ledHeadlights;
  final bool? adaptiveHeadlights;
  final bool? fogLights;
  final bool? daytimeRunningLights;
  final bool? ambientLighting;
  final bool? premiumSoundSystem;
  final bool? wirelessCharging;
  final bool? usbPorts;
  final bool? onboardComputer;
  final bool? dabFmRadio;
  final bool? wifiHotspot;
  final bool? integratedStreaming;
  final bool? rearSeatEntertainment;
  final bool? summerTires;
  final String? payloadCapacity;
  final String? towingCapacity;
  final String? seatingCapacity;
  final String? airConditioning;
  final String? entertainmentSystem;
  final String? cargoVolume;
  final String? axles;
  final String? gvwr;
  final String? operatingWeight;
  final String? bucketCapacity;
  final String? liftingCapacity;
  final String? reach;
  final String? workingHours;

  factory Vehicles.fromJson(Map<String, dynamic> json) {
    return Vehicles(
      vehicleType: json["vehicleType"],
      make: json["make"],
      model: json["model"],
      year: json["year"],
      mileage: json["mileage"],
      fuelType: json["fuelType"],
      transmissionType: json["transmissionType"],
      color: json["color"],
      condition: json["condition"],
      warranty: json["warranty"],
      previousOwners: json["previousOwners"],
      engineSize: json["engineSize"],
      accidentFree: json["accidentFree"],
      adaptiveCruiseControl: json["adaptiveCruiseControl"],
      additionalNotes: json["additionalNotes"],
      automaticEmergencyBraking: json["automaticEmergencyBraking"],
      bodyType: json["bodyType"],
      cruiseControl: json["cruiseControl"],
      curtainAirbags: json["curtainAirbags"],
      customsCleared: json["customsCleared"],
      driveType: json["driveType"],
      frontAirbags: json["frontAirbags"],
      horsepower: json["horsepower"],
      importStatus: json["importStatus"],
      kneeAirbags: json["kneeAirbags"],
      laneDepartureWarning: json["laneDepartureWarning"],
      laneKeepAssist: json["laneKeepAssist"],
      navigationSystem: json["navigationSystem"],
      roofType: json["roofType"],
      serviceHistoryDetails: json["serviceHistoryDetails"],
      sideAirbags: json["sideAirbags"],
      warrantyPeriod: json["warrantyPeriod"],
      serviceHistory: json["serviceHistory"] == null
          ? []
          : List<String>.from(json["serviceHistory"]!.map((x) => x)),
      registrationExpiry: json["registrationExpiry"],
      engineNumber: json["engineNumber"],
      // Missing fields from database
      abs: json["abs"],
      airbags: json["airbags"],
      features: json["features"] == null
          ? []
          : List<String>.from(json["features"]!.map((x) => x)),
      wheelSize: json["wheelSize"],
      wheelType: json["wheelType"],
      laneAssist: json["laneAssist"],
      parkingBreak: json["parkingBreak"],
      emissionClass: json["emissionClass"],
      parkingSensor: json["parkingSensor"],
      fuelEfficiency: json["fuelEfficiency"],
      tractionControl: json["tractionControl"],
      registrationStatus: json["registrationStatus"],
      // Additional fields from user's JSON
      doors: json["doors"],
      seats: json["seats"],
      torque: json["torque"],
      bluetooth: json["bluetooth"],
      androidAuto: json["androidAuto"],
      appleCarPlay: json["appleCarPlay"],
      parkingAidCamera: json["parkingAidCamera"],
      // Missing fields from ListingInputController
      blindSpotMonitor: json["blindSpotMonitor"],
      emergencyBraking: json["emergencyBraking"],
      fatigueWarningSystem: json["fatigueWarningSystem"],
      isofix: json["isofix"],
      emergencyCallSystem: json["emergencyCallSystem"],
      speedLimited: json["speedLimited"],
      tirePressureMonitoring: json["tirePressureMonitoring"],
      rearCamera: json["rearCamera"],
      threeSixtyCamera: json["threeSixtyCamera"],
      trafficSignRecognition: json["trafficSignRecognition"],
      automaticHighBeam: json["automaticHighBeam"],
      lightSensor: json["lightSensor"],
      hillStartAssist: json["hillStartAssist"],
      parkingAssist: json["parkingAssist"],
      ledHeadlights: json["ledHeadlights"],
      adaptiveHeadlights: json["adaptiveHeadlights"],
      fogLights: json["fogLights"],
      daytimeRunningLights: json["daytimeRunningLights"],
      ambientLighting: json["ambientLighting"],
      premiumSoundSystem: json["premiumSoundSystem"],
      wirelessCharging: json["wirelessCharging"],
      usbPorts: json["usbPorts"],
      onboardComputer: json["onboardComputer"],
      dabFmRadio: json["dabFmRadio"],
      wifiHotspot: json["wifiHotspot"],
      integratedStreaming: json["integratedStreaming"],
      rearSeatEntertainment: json["rearSeatEntertainment"],
      summerTires: json["summerTires"],
      payloadCapacity: json["payloadCapacity"],
      towingCapacity: json["towingCapacity"],
      seatingCapacity: json["seatingCapacity"],
      airConditioning: json["airConditioning"],
      entertainmentSystem: json["entertainmentSystem"],
      cargoVolume: json["cargoVolume"],
      axles: json["axles"],
      gvwr: json["gvwr"],
      operatingWeight: json["operatingWeight"],
      bucketCapacity: json["bucketCapacity"],
      liftingCapacity: json["liftingCapacity"],
      reach: json["reach"],
      workingHours: json["workingHours"],
    );
  }

  Map<String, dynamic> toJson() => {
    "vehicleType": vehicleType,
    "make": make,
    "model": model,
    "year": year,
    "mileage": mileage,
    "fuelType": fuelType,
    "transmissionType": transmissionType,
    "color": color,
    "condition": condition,
    "warranty": warranty,
    "previousOwners": previousOwners,
    "engineSize": engineSize,
    "accidentFree": accidentFree,
    "adaptiveCruiseControl": adaptiveCruiseControl,
    "additionalNotes": additionalNotes,
    "automaticEmergencyBraking": automaticEmergencyBraking,
    "bodyType": bodyType,
    "cruiseControl": cruiseControl,
    "curtainAirbags": curtainAirbags,
    "customsCleared": customsCleared,
    "driveType": driveType,
    "frontAirbags": frontAirbags,
    "horsepower": horsepower,
    "importStatus": importStatus,
    "kneeAirbags": kneeAirbags,
    "laneDepartureWarning": laneDepartureWarning,
    "laneKeepAssist": laneKeepAssist,
    "navigationSystem": navigationSystem,
    "roofType": roofType,
    "serviceHistoryDetails": serviceHistoryDetails,
    "sideAirbags": sideAirbags,
    "warrantyPeriod": warrantyPeriod,
    "serviceHistory": serviceHistory.map((x) => x).toList(),
    "registrationExpiry": registrationExpiry,
    "engineNumber": engineNumber,
    // Missing fields from database
    "abs": abs,
    "airbags": airbags,
    "features": features.map((x) => x).toList(),
    "wheelSize": wheelSize,
    "wheelType": wheelType,
    "laneAssist": laneAssist,
    "parkingBreak": parkingBreak,
    "emissionClass": emissionClass,
    "parkingSensor": parkingSensor,
    "fuelEfficiency": fuelEfficiency,
    "tractionControl": tractionControl,
    "registrationStatus": registrationStatus,
    // Additional fields from user's JSON
    "doors": doors,
    "seats": seats,
    "torque": torque,
    "bluetooth": bluetooth,
    "androidAuto": androidAuto,
    "appleCarPlay": appleCarPlay,
    "parkingAidCamera": parkingAidCamera,
    // Missing fields from ListingInputController
    "blindSpotMonitor": blindSpotMonitor,
    "emergencyBraking": emergencyBraking,
    "fatigueWarningSystem": fatigueWarningSystem,
    "isofix": isofix,
    "emergencyCallSystem": emergencyCallSystem,
    "speedLimited": speedLimited,
    "tirePressureMonitoring": tirePressureMonitoring,
    "rearCamera": rearCamera,
    "threeSixtyCamera": threeSixtyCamera,
    "trafficSignRecognition": trafficSignRecognition,
    "automaticHighBeam": automaticHighBeam,
    "lightSensor": lightSensor,
    "hillStartAssist": hillStartAssist,
    "parkingAssist": parkingAssist,
    "ledHeadlights": ledHeadlights,
    "adaptiveHeadlights": adaptiveHeadlights,
    "fogLights": fogLights,
    "daytimeRunningLights": daytimeRunningLights,
    "ambientLighting": ambientLighting,
    "premiumSoundSystem": premiumSoundSystem,
    "wirelessCharging": wirelessCharging,
    "usbPorts": usbPorts,
    "onboardComputer": onboardComputer,
    "dabFmRadio": dabFmRadio,
    "wifiHotspot": wifiHotspot,
    "integratedStreaming": integratedStreaming,
    "rearSeatEntertainment": rearSeatEntertainment,
    "summerTires": summerTires,
    "payloadCapacity": payloadCapacity,
    "towingCapacity": towingCapacity,
    "seatingCapacity": seatingCapacity,
    "airConditioning": airConditioning,
    "entertainmentSystem": entertainmentSystem,
    "cargoVolume": cargoVolume,
    "axles": axles,
    "gvwr": gvwr,
    "operatingWeight": operatingWeight,
    "bucketCapacity": bucketCapacity,
    "liftingCapacity": liftingCapacity,
    "reach": reach,
    "workingHours": workingHours,
  };

  @override
  String toString() {
    return "$vehicleType, $make, $model, $year, $mileage, $fuelType, $transmissionType, $color, $condition, $warranty, $previousOwners, $engineSize, $accidentFree, $adaptiveCruiseControl, $additionalNotes, $automaticEmergencyBraking, $bodyType, $cruiseControl, $curtainAirbags, $customsCleared, $driveType, $frontAirbags, $horsepower, $importStatus, $kneeAirbags, $laneDepartureWarning, $laneKeepAssist, $navigationSystem, $roofType, $serviceHistoryDetails, $sideAirbags, $warrantyPeriod, $serviceHistory, $registrationExpiry, $engineNumber, $abs, $airbags, $features, $wheelSize, $wheelType, $laneAssist, $parkingBreak, $emissionClass, $parkingSensor, $fuelEfficiency, $tractionControl, $registrationStatus, $doors, $seats, $torque, $bluetooth, $androidAuto, $appleCarPlay, $parkingAidCamera, ";
  }
}

class RealEstate {
  RealEstate({
    required this.propertyType,
    required this.bedrooms,
    required this.bathrooms,
    required this.totalArea,
    required this.furnishing,
    required this.floor,
    required this.totalFloors,
    required this.parking,
    required this.yearBuilt,
    required this.facing,
    required this.balconies,
    required this.garden,
    required this.pool,
    required this.plotSize,
    required this.officeType,
    required this.zoning,
    required this.roadAccess,
    // Missing fields from store advanced details
    required this.storeType,
    required this.floorArea,
    required this.storageArea,
    required this.frontage,
    required this.ceilingHeight,
    required this.loadingDock,
    required this.security,
    required this.hvac,
    required this.lighting,
    required this.accessibility,
    required this.businessLicense,
    required this.footTraffic,
    // Missing fields from villa advanced details
    required this.balcony,
    required this.heating,
    required this.cooling,
    required this.view,
    required this.orientation,
    required this.buildingAge,
    required this.maintenanceFee,
    required this.energyRating,
  });

  final String? propertyType;
  final int? bedrooms;
  final int? bathrooms;
  final int? totalArea;
  final String? furnishing;
  final int? floor;
  final int? totalFloors;
  final String? parking;
  final int? yearBuilt;
  final String? facing;
  final int? balconies;
  final String? garden;
  final String? pool;
  final int? plotSize;
  final String? officeType;
  final String? zoning;
  final String? roadAccess;
  // Missing fields from store advanced details
  final String? storeType;
  final String? floorArea;
  final String? storageArea;
  final String? frontage;
  final String? ceilingHeight;
  final String? loadingDock;
  final String? security;
  final String? hvac;
  final String? lighting;
  final String? accessibility;
  final String? businessLicense;
  final String? footTraffic;
  // Missing fields from villa advanced details
  final int? balcony;
  final String? heating;
  final String? cooling;
  final String? view;
  final String? orientation;
  final int? buildingAge;
  final String? maintenanceFee;
  final String? energyRating;

  factory RealEstate.fromJson(Map<String, dynamic> json) {
    return RealEstate(
      propertyType: json["propertyType"],
      bedrooms: json["bedrooms"],
      bathrooms: json["bathrooms"],
      totalArea: json["totalArea"],
      furnishing: json["furnishing"],
      floor: json["floor"],
      totalFloors: json["totalFloors"],
      parking: json["parking"],
      yearBuilt: json["yearBuilt"],
      facing: json["facing"],
      balconies: json["balconies"],
      garden: json["garden"],
      pool: json["pool"],
      plotSize: json["plotSize"],
      officeType: json["officeType"],
      zoning: json["zoning"],
      roadAccess: json["roadAccess"],
      // Missing fields from store advanced details
      storeType: json["storeType"],
      floorArea: json["floorArea"],
      storageArea: json["storageArea"],
      frontage: json["frontage"],
      ceilingHeight: json["ceilingHeight"],
      loadingDock: json["loadingDock"],
      security: json["security"],
      hvac: json["hvac"],
      lighting: json["lighting"],
      accessibility: json["accessibility"],
      businessLicense: json["businessLicense"],
      footTraffic: json["footTraffic"],
      // Missing fields from villa advanced details
      balcony: json["balcony"],
      heating: json["heating"],
      cooling: json["cooling"],
      view: json["view"],
      orientation: json["orientation"],
      buildingAge: json["buildingAge"],
      maintenanceFee: json["maintenanceFee"],
      energyRating: json["energyRating"],
    );
  }

  Map<String, dynamic> toJson() => {
    "propertyType": propertyType,
    "bedrooms": bedrooms,
    "bathrooms": bathrooms,
    "totalArea": totalArea,
    "furnishing": furnishing,
    "floor": floor,
    "totalFloors": totalFloors,
    "parking": parking,
    "yearBuilt": yearBuilt,
    "facing": facing,
    "balconies": balconies,
    "garden": garden,
    "pool": pool,
    "plotSize": plotSize,
    "officeType": officeType,
    "zoning": zoning,
    "roadAccess": roadAccess,
    // Missing fields from store advanced details
    "storeType": storeType,
    "floorArea": floorArea,
    "storageArea": storageArea,
    "frontage": frontage,
    "ceilingHeight": ceilingHeight,
    "loadingDock": loadingDock,
    "security": security,
    "hvac": hvac,
    "lighting": lighting,
    "accessibility": accessibility,
    "businessLicense": businessLicense,
    "footTraffic": footTraffic,
    // Missing fields from villa advanced details
    "balcony": balcony,
    "heating": heating,
    "cooling": cooling,
    "view": view,
    "orientation": orientation,
    "buildingAge": buildingAge,
    "maintenanceFee": maintenanceFee,
    "energyRating": energyRating,
  };

  @override
  String toString() {
    return "$propertyType, $bedrooms, $bathrooms, $totalArea, $furnishing, $floor, $totalFloors, $parking, $yearBuilt, $facing, $balconies, $garden, $pool, $plotSize, $officeType, $zoning, $roadAccess, ";
  }
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

  @override
  String toString() {
    return "$id, $username, $profilePicture, $allowMessaging, $privateProfile, ";
  }
}
