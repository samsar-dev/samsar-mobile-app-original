import 'package:get/get.dart';

import 'package:samsar/models/listing/real_estate_model.dart';
import 'package:samsar/models/listing/vehicle_model.dart' as vehicle_listing;

class ListingInputController extends GetxController {

  //Basic Listing fields
  RxString title = "".obs;
  RxString description = "".obs;
  RxInt price = 0.obs;
  RxString mainCategory = "".obs;
  RxString subCategory = "".obs;
  RxString listingAction = "".obs; // For Sale, For Rent, Searching
  RxString location = "".obs;
  RxString latitude = "".obs;
  RxString longitude = "".obs;
  RxString sellerType = "".obs; // owner, broker, business_firm
  RxString make = "".obs;
  RxString model = "".obs;
  RxInt year = 0.obs;

  //listing image path
  RxList<String> listingImage = <String>[].obs;

  //advance listing fields
  RxString bodyType = "".obs;
  RxString driveType = "".obs;
  RxString fuelType = "".obs;
  RxString transmissionType = "".obs;
  RxInt horsepower = 0.obs;
  RxString mileage = "".obs;
  RxString serviceHistory = "".obs;
  RxString accidental = "".obs;
  RxString warranty = "".obs;
  RxInt previousOwners = 0.obs;
  RxString condition = "".obs;
  RxString importStatus = "".obs;
  RxString registrationExpiry = "".obs;
  RxString engineSize = "".obs;

  // Truck-specific fields
  RxString payloadCapacity = "".obs;
  RxString towingCapacity = "".obs;

  // Passenger vehicle-specific fields
  RxString seatingCapacity = "".obs;
  RxString doors = "".obs;
  RxString airConditioning = "".obs;
  RxString entertainmentSystem = "".obs;

  // Commercial vehicle-specific fields
  RxString cargoVolume = "".obs;
  RxString axles = "".obs;
  RxString gvwr = "".obs;

  // Construction vehicle-specific fields
  RxString operatingWeight = "".obs;
  RxString bucketCapacity = "".obs;
  RxString liftingCapacity = "".obs;
  RxString reach = "".obs;
  RxString workingHours = "".obs;

  // Real Estate fields
  RxString propertyType = "".obs;
  RxInt bedrooms = 0.obs;
  RxInt bathrooms = 0.obs;
  RxString furnishing = "".obs;
  RxInt floor = 0.obs;
  RxInt totalFloors = 0.obs;
  RxString parking = "".obs;
  RxInt yearBuilt = 0.obs;
  RxString facing = "".obs;
  RxInt balconies = 0.obs;
  RxInt plotSize = 0.obs;
  RxString garden = "".obs;
  RxString pool = "".obs;
  RxString officeType = "".obs;
  RxInt totalArea = 0.obs;
  RxInt meetingRooms = 0.obs;
  RxString zoning = "".obs;
  RxString roadAccess = "".obs;

  // Villa-specific fields
  RxString gardenArea = "".obs;
  RxInt balcony = 0.obs;
  RxString heating = "".obs;
  RxString cooling = "".obs;
  RxString security = "".obs;
  RxString view = "".obs;
  RxString orientation = "".obs;
  RxInt buildingAge = 0.obs;
  RxString maintenanceFee = "".obs;
  RxString energyRating = "".obs;

  // Store-specific fields
  RxString storeType = "".obs;
  RxString floorArea = "".obs;
  RxString storageArea = "".obs;
  RxString frontage = "".obs;
  RxString ceilingHeight = "".obs;
  RxString loadingDock = "".obs;
  RxString hvac = "".obs;
  RxString lighting = "".obs;
  RxString accessibility = "".obs;
  RxString businessLicense = "".obs;
  RxString footTraffic = "".obs;

  RxString exteriorColor = "".obs;

  //features and extras
  RxInt noOfAirbags = 0.obs;
  RxBool abs = false.obs;
  RxBool tractionControl = false.obs;
  RxBool laneAssist = false.obs;
  RxBool isBlindSpotMonitor = false.obs;
  RxBool isEmergencyBraking = false.obs;
  RxBool isAdaptiveCruiseControl = false.obs;
  RxBool isLaneDepartureWarning = false.obs;
  RxBool isFatigueWarningSystem = false.obs;
  RxBool isIsofix = false.obs;
  RxBool isEmergencyCallSystem = false.obs;
  RxBool isSpeedLimited = false.obs;
  RxBool isTirePressureMonitoring = false.obs;
  RxBool parkingSensor = false.obs;
  RxBool isRearCamera = false.obs;
  RxBool isThreeSixtyCamera = false.obs;
  RxBool isTrafficSignRecognition = false.obs;

  RxBool cruiseControl = false.obs;
  RxBool automaticHighBeam = false.obs;
  RxBool lightSensor = false.obs;
  RxBool hillStartAssist = false.obs;
  RxBool parkingAssistOrSelfParking = false.obs;

  RxBool isLedHeadlights = false.obs;
  RxBool isAdaptiveHeadlights = false.obs;
  RxBool isFogLights = false.obs;
  RxBool isDaytimeRunningLights = false.obs;
  RxBool isAmbientLighting = false.obs;

  RxBool isBluetooth = false.obs;
  RxBool isAppleCarPlay = false.obs;
  RxBool isAndroidAuto = false.obs;
  RxBool isPremiumSoundSystem = false.obs;
  RxBool isWirelessCharging = false.obs;
  RxBool isUsbPorts = false.obs;
  RxBool isOnboardComputer = false.obs;
  RxBool isDabOrFmRadio = false.obs;
  RxBool isWifiHotspot = false.obs;
  RxBool isIntegratedStreaming = false.obs;
  RxBool isRearSeatEntertainment = false.obs;

  RxBool isCentralLocking = false.obs;
  RxBool isImmobilizer = false.obs;
  RxBool isAlarmSystem = false.obs;
  RxBool isPowerSteering = false.obs;
  RxBool isSummerTires = false.obs;
  
  // General features list for all subcategories
  RxList<String> selectedFeatures = <String>[].obs;
  
  // Additional feature fields for different subcategories
  // Real Estate Features
  RxBool hasElevator = false.obs;
  RxBool hasBalcony = false.obs;
  RxBool hasParking = false.obs;
  RxBool hasCentralHeating = false.obs;
  RxBool hasFurnished = false.obs;
  RxBool hasInternetReady = false.obs;
  RxBool hasSecuritySystem = false.obs;
  RxBool hasConcierge = false.obs;
  RxBool hasGenerator = false.obs;
  RxBool hasWaterHeater = false.obs;
  RxBool hasStorageRoom = false.obs;
  
  // House/Villa specific
  RxBool hasGarden = false.obs;
  RxBool hasGarage = false.obs;
  RxBool hasTerrace = false.obs;
  RxBool hasBasement = false.obs;
  RxBool hasFireplace = false.obs;
  RxBool hasSwimmingPool = false.obs;
  RxBool hasSolarPanels = false.obs;
  RxBool hasWaterWell = false.obs;
  
  // Office specific
  RxBool hasReceptionArea = false.obs;
  RxBool hasMeetingRooms = false.obs;
  RxBool hasKitchenArea = false.obs;
  RxBool hasDisabledAccess = false.obs;
  
  // Land specific
  RxBool hasWaterAccess = false.obs;
  RxBool hasElectricityAccess = false.obs;
  RxBool hasRoadAccess = false.obs;
  RxBool hasAgriculturalUse = false.obs;
  RxBool hasResidentialZoning = false.obs;
  RxBool hasCommercialZoning = false.obs;
  RxBool hasFlatTerrain = false.obs;
  RxBool hasFenced = false.obs;
  RxBool hasFruitTrees = false.obs;
  RxBool hasBuildingPermit = false.obs;
  RxBool hasCornerLot = false.obs;
  
  // Store specific
  RxBool hasStreetFront = false.obs;
  RxBool hasDisplayWindows = false.obs;
  RxBool hasCustomerParking = false.obs;
  RxBool hasLoadingDock = false.obs;
  RxBool hasOfficeSpace = false.obs;
  RxBool hasRestroom = false.obs;
  
  // Commercial Vehicle Features
  RxBool hasHydraulicLift = false.obs;
  RxBool hasCargoCover = false.obs;
  RxBool hasTieDownPoints = false.obs;
  RxBool hasLoadingRamp = false.obs;
  RxBool hasRefrigeration = false.obs;
  RxBool hasGpsTracking = false.obs;
  RxBool hasCommercialLicense = false.obs;
  RxBool hasCargoBarrier = false.obs;
  
  // Construction Vehicle Features
  RxBool hasHydraulicSystem = false.obs;
  RxBool hasWorkLights = false.obs;
  RxBool hasQuickAttach = false.obs;
  RxBool hasRubberTracks = false.obs;
  RxBool hasEnclosedCab = false.obs;
  RxBool hasEmergencyStop = false.obs;
  RxBool hasRolloverProtection = false.obs;
  RxBool hasServiceRecords = false.obs;
  RxBool hasOperatorManual = false.obs;
  
  // Passenger Vehicle Features
  RxBool hasElectricWindows = false.obs;
  RxBool hasGpsNavigation = false.obs;
  RxBool hasUsbCharging = false.obs;
  RxBool hasBackupCamera = false.obs;
  RxBool hasSunroof = false.obs;
  RxBool hasLeatherSeats = false.obs;

  //to set the basic details
  void setBasicDetails({
    String title = '',
    String description = '',
    int price = 0,
    String mainCategory = '',
    String subCategory = '',
    String listingAction = '',
    String location = '',
    String latitude = '',
    String longitude = '',
    String make = '',
    String model = '',
    int year = 0,
  }) {
    this.title.value = title;
    this.description.value = description;
    this.price.value = price;
    this.mainCategory.value = mainCategory;
    this.subCategory.value = subCategory;
    this.listingAction.value = listingAction;
    this.location.value = location;
    this.latitude.value = latitude;
    this.longitude.value = longitude;
    this.make.value = make;
    this.model.value = model;
    this.year.value = year; 
  }


  //set images for listing
  void setImages(List<String> listingImage) {
    this.listingImage.assignAll(listingImage);
  }

  //set advance details
  void setAdvanceDetails({
    String bodyType = '',
    String driveType = '',
    String fuelType = '',
    String transmissionType = '',
    int horsepower = 0,
    String mileage = '',
    String serviceHistory = '',
    String accidental = '',
    String warranty = '',
    int previousOwners = 0,
    String condition = '',
    String importStatus = '',
    String registrationExpiry = '',
    String engineSize = '',
    String exteriorColor = '',
  }) {
    this.bodyType.value = bodyType;
    this.driveType.value = driveType;
    this.fuelType.value = fuelType;
    this.transmissionType.value = transmissionType;
    this.horsepower.value = horsepower;
    this.mileage.value = mileage;
    this.serviceHistory.value = serviceHistory;
    this.accidental.value = accidental;
    this.warranty.value = warranty;
    this.previousOwners.value = previousOwners;
    this.condition.value = condition;
    this.importStatus.value = importStatus;
    this.registrationExpiry.value = registrationExpiry;
    this.engineSize.value = engineSize;
    this.exteriorColor.value = exteriorColor;
  }


  //set features and extras
  void featuresAndExtras({
    int noOfAirbags = 0,
    bool abs = false,
    bool tractionControl = false,
    bool laneAssist = false,
    bool isBlindSpotMonitor = false,
    bool isEmergencyBraking = false,
    bool isAdaptiveCruiseControl = false,
    bool isLaneDepartureWarning = false,
    bool isFatigueWarningSystem = false,
    bool isIsofix = false,
    bool isEmergencyCallSystem = false,
    bool isSpeedLimited = false,
    bool isTirePressureMonitoring = false,
    bool parkingSensor = false,
    bool isRearCamera = false,
    bool isThreeSixtyCamera = false,
    bool isTrafficSignRecognition = false,
    bool cruiseControl = false,
    bool automaticHighBeam = false,
    bool lightSensor = false,
    bool hillStartAssist = false,
    bool parkingAssistOrSelfParking = false,
    bool isLedHeadlights = false,
    bool isAdaptiveHeadlights = false,
    bool isFogLights = false,
    bool isDaytimeRunningLights = false,
    bool isAmbientLighting = false,
    bool isBluetooth = false,
    bool isAppleCarPlay = false,
    bool isAndroidAuto = false,
    bool isPremiumSoundSystem = false,
    bool isWirelessCharging = false,
    bool isUsbPorts = false,
    bool isOnboardComputer = false,
    bool isDabOrFmRadio = false,
    bool isWifiHotspot = false,
    bool isIntegratedStreaming = false,
    bool isRearSeatEntertainment = false,
    bool isCentralLocking = false,
    bool isImmobilizer = false,
    bool isAlarmSystem = false,
    bool isPowerSteering = false,
    bool isSummerTires = false,
  }) {
    this.noOfAirbags.value = noOfAirbags;
    this.abs.value = abs;
    this.tractionControl.value = tractionControl;
    this.laneAssist.value = laneAssist;
    this.isBlindSpotMonitor.value = isBlindSpotMonitor;
    this.isEmergencyBraking.value = isEmergencyBraking;
    this.isAdaptiveCruiseControl.value = isAdaptiveCruiseControl;
    this.isLaneDepartureWarning.value = isLaneDepartureWarning;
    this.isFatigueWarningSystem.value = isFatigueWarningSystem;
    this.isIsofix.value = isIsofix;
    this.isEmergencyCallSystem.value = isEmergencyCallSystem;
    this.isSpeedLimited.value = isSpeedLimited;
    this.isTirePressureMonitoring.value = isTirePressureMonitoring;
    this.parkingSensor.value = parkingSensor;
    this.isRearCamera.value = isRearCamera;
    this.isThreeSixtyCamera.value = isThreeSixtyCamera;
    this.isTrafficSignRecognition.value = isTrafficSignRecognition;
    this.cruiseControl.value = cruiseControl;
    this.automaticHighBeam.value = automaticHighBeam;
    this.lightSensor.value = lightSensor;
    this.hillStartAssist.value = hillStartAssist;
    this.parkingAssistOrSelfParking.value = parkingAssistOrSelfParking;
    this.isLedHeadlights.value = isLedHeadlights;
    this.isAdaptiveHeadlights.value = isAdaptiveHeadlights;
    this.isFogLights.value = isFogLights;
    this.isDaytimeRunningLights.value = isDaytimeRunningLights;
    this.isAmbientLighting.value = isAmbientLighting;
    this.isBluetooth.value = isBluetooth;
    this.isAppleCarPlay.value = isAppleCarPlay;
    this.isAndroidAuto.value = isAndroidAuto;
    this.isPremiumSoundSystem.value = isPremiumSoundSystem;
    this.isWirelessCharging.value = isWirelessCharging;
    this.isUsbPorts.value = isUsbPorts;
    this.isOnboardComputer.value = isOnboardComputer;
    this.isDabOrFmRadio.value = isDabOrFmRadio;
    this.isWifiHotspot.value = isWifiHotspot;
    this.isIntegratedStreaming.value = isIntegratedStreaming;
    this.isRearSeatEntertainment.value = isRearSeatEntertainment;
    this.isCentralLocking.value = isCentralLocking;
    this.isImmobilizer.value = isImmobilizer;
    this.isAlarmSystem.value = isAlarmSystem;
    this.isPowerSteering.value = isPowerSteering;
    this.isSummerTires.value = isSummerTires;
  }

  // Method to create CarModel from collected data
  vehicle_listing.VehicleModel createVehicleModel() {
    // Create features list from all the boolean features
    List<String> featuresList = [];
    if (selectedFeatures.contains('airbags')) featuresList.add("Airbags");
    if (abs.value) featuresList.add("ABS");
    if (tractionControl.value) featuresList.add("Traction Control");
    if (laneAssist.value) featuresList.add("Lane Assist");
    if (isBlindSpotMonitor.value) featuresList.add("Blind Spot Monitor");
    if (isEmergencyBraking.value) featuresList.add("Emergency Braking");
    if (isAdaptiveCruiseControl.value) featuresList.add("Adaptive Cruise Control");
    if (isLaneDepartureWarning.value) featuresList.add("Lane Departure Warning");
    if (isFatigueWarningSystem.value) featuresList.add("Fatigue Warning System");
    if (isIsofix.value) featuresList.add("ISOFIX");
    if (isEmergencyCallSystem.value) featuresList.add("Emergency Call System");
    if (isSpeedLimited.value) featuresList.add("Speed Limiter");
    if (isTirePressureMonitoring.value) featuresList.add("Tire Pressure Monitoring");
    if (parkingSensor.value) featuresList.add("Parking Sensor");
    if (isRearCamera.value) featuresList.add("Rear Camera");
    if (isThreeSixtyCamera.value) featuresList.add("360 Camera");
    if (isTrafficSignRecognition.value) featuresList.add("Traffic Sign Recognition");
    if (cruiseControl.value) featuresList.add("Cruise Control");
    if (automaticHighBeam.value) featuresList.add("Automatic High Beam");
    if (lightSensor.value) featuresList.add("Light Sensor");
    if (hillStartAssist.value) featuresList.add("Hill Start Assist");
    if (parkingAssistOrSelfParking.value) featuresList.add("Parking Assist/Self-Parking");
    if (isLedHeadlights.value) featuresList.add("LED Headlights");
    if (isAdaptiveHeadlights.value) featuresList.add("Adaptive Headlights");
    if (isFogLights.value) featuresList.add("Fog Lights");
    if (isDaytimeRunningLights.value) featuresList.add("Daytime Running Lights");
    if (isAmbientLighting.value) featuresList.add("Ambient Lighting");
    if (isBluetooth.value) featuresList.add("Bluetooth");
    if (isAppleCarPlay.value) featuresList.add("Apple CarPlay");
    if (isAndroidAuto.value) featuresList.add("Android Auto");
    if (isPremiumSoundSystem.value) featuresList.add("Premium Sound System");
    if (isWirelessCharging.value) featuresList.add("Wireless Charging");
    if (isUsbPorts.value) featuresList.add("USB Ports");
    if (isOnboardComputer.value) featuresList.add("Onboard Computer");
    if (isDabOrFmRadio.value) featuresList.add("DAB/FM Radio");
    if (isWifiHotspot.value) featuresList.add("WiFi Hotspot");
    if (isIntegratedStreaming.value) featuresList.add("Integrated Streaming");
    if (isRearSeatEntertainment.value) featuresList.add("Rear Seat Entertainment");
    if (isCentralLocking.value) featuresList.add("Central Locking");
    if (isImmobilizer.value) featuresList.add("Immobilizer");
    if (isAlarmSystem.value) featuresList.add("Alarm System");
    if (isPowerSteering.value) featuresList.add("Power Steering");
    if (isSummerTires.value) featuresList.add("Summer Tires");

    // Create Details JSON object
    final detailsJson = {
      "vehicleType": "car",
      "make": make.value,
      "model": model.value,
      "year": year.value.toString(),
      "mileage": int.tryParse(mileage.value) ?? 0,
      "previousOwners": previousOwners.value,
      "horsepower": horsepower.value,
      "transmissionType": transmissionType.value,
      "fuelType": fuelType.value,
      "color": exteriorColor.value,
      "registrationStatus": importStatus.value,
      "registrationExpiry": registrationExpiry.value,
      "serviceHistory": serviceHistory.value.isNotEmpty ? [serviceHistory.value] : [],
      "warranty": warranty.value,
      "accidentFree": accidental.value == "No" || accidental.value == "false",
      "customsCleared": importStatus.value == "Cleared" || importStatus.value == "Local",
      "airbags": noOfAirbags.value,
      "abs": abs.value,
      "tractionControl": tractionControl.value,
      "laneAssist": laneAssist.value,
      "features": featuresList,
      "driveType": driveType.value,
      "bodyType": bodyType.value,
      "wheelSize": "", // Add if needed
      "wheelType": "", // Add if needed
      "fuelEfficiency": "", // Add if needed
      "emissionClass": "", // Add if needed
      "parkingSensor": parkingSensor.value ? "Yes" : "No",
      "parkingBreak": "", // Add if needed

      // Truck-specific fields
      "payloadCapacity": payloadCapacity.value,
      "towingCapacity": towingCapacity.value,

      // Passenger vehicle fields
      "seatingCapacity": seatingCapacity.value,
      "doors": doors.value,
      "airConditioning": airConditioning.value,
      "entertainmentSystem": entertainmentSystem.value,

      // Commercial vehicle fields
      "cargoVolume": cargoVolume.value,
      "axles": axles.value,
      "gvwr": gvwr.value,

      // Construction vehicle fields
      "operatingWeight": operatingWeight.value,
      "bucketCapacity": bucketCapacity.value,
      "liftingCapacity": liftingCapacity.value,
      "reach": reach.value,
      "workingHours": workingHours.value
    };

    final details = vehicle_listing.Details(json: detailsJson);

    // Create and return CarModel
    return vehicle_listing.VehicleModel(
      title: title.value,
      description: description.value,
       price: price.value.toInt(),
      mainCategory: mainCategory.value.toUpperCase(),
      subCategory: subCategory.value,
      location: location.value,
      latitude: double.tryParse(latitude.value) ?? 0.0,
      longitude: double.tryParse(longitude.value) ?? 0.0,
      condition: condition.value,
      listingAction: _mapListingActionToBackend(listingAction.value),
      sellerType: sellerType.value,
      details: details,
      listingImage: listingImage.toList(),
    );
  }

  // Method to validate that essential data exists before clearing
  bool hasEssentialData() {
    return title.value.isNotEmpty || 
           description.value.isNotEmpty || 
           price.value > 0 || 
           listingImage.isNotEmpty ||
           make.value.isNotEmpty ||
           model.value.isNotEmpty ||
           year.value > 0;
  }

  // Method to get current data summary for debugging
  Map<String, dynamic> getDataSummary() {
    return {
      'title': title.value,
      'description': description.value.isNotEmpty ? '${description.value.substring(0, description.value.length > 50 ? 50 : description.value.length)}...' : '',
      'price': price.value,
      'make': make.value,
      'model': model.value,
      'year': year.value,
      'subCategory': subCategory.value,
      'location': location.value,
      'imageCount': listingImage.length,
      'bodyType': bodyType.value,
      'fuelType': fuelType.value,
      'transmission': transmissionType.value,
      'mileage': mileage.value,
      'exteriorColor': exteriorColor.value,
    };
  }

  // Method to clear all data (useful for resetting form)
  void clearAllData() {
    print("🚨 CLEARING ALL DATA - Current state: ${getDataSummary()}");
    
    if (hasEssentialData()) {
      print("⚠️ WARNING: Clearing data that contains user input!");
    }
    // Basic fields
    title.value = "";
    description.value = "";
    price.value = 0;
    mainCategory.value = "";
    subCategory.value = "";
    listingAction.value = "";
    location.value = "";
    latitude.value = "";
    longitude.value = "";
    make.value = "";
    model.value = "";
    year.value = 0;
    listingImage.clear();

    // Advanced fields
    bodyType.value = "";
    driveType.value = "";
    fuelType.value = "";
    transmissionType.value = "";
    horsepower.value = 0;
    mileage.value = "";
    serviceHistory.value = "";
    accidental.value = "";
    warranty.value = "";
    previousOwners.value = 0;
    condition.value = "";
    importStatus.value = "";
    registrationExpiry.value = "";
    engineSize.value = "";

    // Truck-specific fields
    payloadCapacity.value = "";
    towingCapacity.value = "";

    // Passenger vehicle fields
    seatingCapacity.value = "";
    doors.value = "";
    airConditioning.value = "";
    entertainmentSystem.value = "";

    // Commercial vehicle fields
    cargoVolume.value = "";
    axles.value = "";
    gvwr.value = "";

    // Construction vehicle fields
    operatingWeight.value = "";
    bucketCapacity.value = "";
    liftingCapacity.value = "";
    reach.value = "";
    workingHours.value = "";

    exteriorColor.value = "";

    // Features and extras - reset all to false
    noOfAirbags.value = 0;
    abs.value = false;
    tractionControl.value = false;
    laneAssist.value = false;
    isBlindSpotMonitor.value = false;
    isEmergencyBraking.value = false;
    isAdaptiveCruiseControl.value = false;
    isLaneDepartureWarning.value = false;
    isFatigueWarningSystem.value = false;
    isIsofix.value = false;
    isEmergencyCallSystem.value = false;
    isSpeedLimited.value = false;
    isTirePressureMonitoring.value = false;
    parkingSensor.value = false;
    isRearCamera.value = false;
    isThreeSixtyCamera.value = false;
    isTrafficSignRecognition.value = false;
    cruiseControl.value = false;
    automaticHighBeam.value = false;
    lightSensor.value = false;
    hillStartAssist.value = false;
    parkingAssistOrSelfParking.value = false;
    isLedHeadlights.value = false;
    isAdaptiveHeadlights.value = false;
    isFogLights.value = false;
    isDaytimeRunningLights.value = false;
    isAmbientLighting.value = false;
    isBluetooth.value = false;
    isAppleCarPlay.value = false;
    isAndroidAuto.value = false;
    isPremiumSoundSystem.value = false;
    isWirelessCharging.value = false;
    isUsbPorts.value = false;
    isOnboardComputer.value = false;
    isDabOrFmRadio.value = false;
    isWifiHotspot.value = false;
    isIntegratedStreaming.value = false;
    isRearSeatEntertainment.value = false;
    isCentralLocking.value = false;
    isImmobilizer.value = false;
    isAlarmSystem.value = false;
    isPowerSteering.value = false;
    isSummerTires.value = false;
    
    print("✅ Data cleared successfully");
  }





  RealEstateModel createRealEstateModel() {
    final details = RealEstateDetails(
      propertyType: propertyType.value,
      bedrooms: bedrooms.value,
      bathrooms: bathrooms.value,
      furnishing: furnishing.value,
      floor: floor.value,
      totalFloors: totalFloors.value,
      parking: parking.value,
      yearBuilt: yearBuilt.value,
      facing: facing.value,
      balconies: balconies.value,
      plotSize: plotSize.value,
      garden: garden.value,
      pool: pool.value,
      officeType: officeType.value,
      totalArea: totalArea.value,
      meetingRooms: meetingRooms.value,
      zoning: zoning.value,
      roadAccess: roadAccess.value,

    );

    return RealEstateModel(
      title: title.value,
      description: description.value,
      price: price.value,
      mainCategory: mainCategory.value.toUpperCase(),
      subCategory: subCategory.value,
      location: location.value,
      latitude: double.tryParse(latitude.value) ?? 0.0,
      longitude: double.tryParse(longitude.value) ?? 0.0,
      condition: condition.value,
      listingAction: _mapListingActionToBackend(listingAction.value),
      sellerType: sellerType.value,
      details: details,
      listingImage: listingImage.toList(),
    );
  }

  // Method to safely clear data only after successful submission
  void clearDataAfterSubmission() {
    print("🎉 CLEARING DATA AFTER SUCCESSFUL SUBMISSION");
    clearAllData();
  }

  // Method to backup current data state
  Map<String, dynamic> _dataBackup = {};
  
  void backupCurrentData() {
    _dataBackup = {
      // Basic fields
      'title': title.value,
      'description': description.value,
      'price': price.value,
      'mainCategory': mainCategory.value,
      'subCategory': subCategory.value,
      'listingAction': listingAction.value,
      'location': location.value,
      'latitude': latitude.value,
      'longitude': longitude.value,
      'make': make.value,
      'model': model.value,
      'year': year.value,
      'listingImage': List<String>.from(listingImage),
      
      // Advanced fields
      'bodyType': bodyType.value,
      'driveType': driveType.value,
      'fuelType': fuelType.value,
      'transmissionType': transmissionType.value,
      'horsepower': horsepower.value,
      'mileage': mileage.value,
      'serviceHistory': serviceHistory.value,
      'accidental': accidental.value,
      'warranty': warranty.value,
      'previousOwners': previousOwners.value,
      'condition': condition.value,
      'importStatus': importStatus.value,
      'registrationExpiry': registrationExpiry.value,
      'engineSize': engineSize.value,
      'payloadCapacity': payloadCapacity.value,
      'towingCapacity': towingCapacity.value,
      'exteriorColor': exteriorColor.value,
      
      // Passenger vehicle fields
      'seatingCapacity': seatingCapacity.value,
      'doors': doors.value,
      'airConditioning': airConditioning.value,
      'entertainmentSystem': entertainmentSystem.value,
      
      // Commercial vehicle fields
      'cargoVolume': cargoVolume.value,
      'axles': axles.value,
      'gvwr': gvwr.value,
      
      // Construction vehicle fields
      'operatingWeight': operatingWeight.value,
      'bucketCapacity': bucketCapacity.value,
      'liftingCapacity': liftingCapacity.value,
      'reach': reach.value,
      'workingHours': workingHours.value,
      
      // Features
      'noOfAirbags': noOfAirbags.value,
      'abs': abs.value,
      'tractionControl': tractionControl.value,
      'laneAssist': laneAssist.value,
      'isBlindSpotMonitor': isBlindSpotMonitor.value,
      'isEmergencyBraking': isEmergencyBraking.value,
      'isAdaptiveCruiseControl': isAdaptiveCruiseControl.value,
      'isLaneDepartureWarning': isLaneDepartureWarning.value,
      'isFatigueWarningSystem': isFatigueWarningSystem.value,
      'isIsofix': isIsofix.value,
      'isEmergencyCallSystem': isEmergencyCallSystem.value,
      'isSpeedLimited': isSpeedLimited.value,
      'isTirePressureMonitoring': isTirePressureMonitoring.value,
      'parkingSensor': parkingSensor.value,
      'isRearCamera': isRearCamera.value,
      'isThreeSixtyCamera': isThreeSixtyCamera.value,
      'isTrafficSignRecognition': isTrafficSignRecognition.value,
      'cruiseControl': cruiseControl.value,
      'automaticHighBeam': automaticHighBeam.value,
      'lightSensor': lightSensor.value,
      'hillStartAssist': hillStartAssist.value,
      'parkingAssistOrSelfParking': parkingAssistOrSelfParking.value,
      'isLedHeadlights': isLedHeadlights.value,
      'isAdaptiveHeadlights': isAdaptiveHeadlights.value,
      'isFogLights': isFogLights.value,
      'isDaytimeRunningLights': isDaytimeRunningLights.value,
      'isAmbientLighting': isAmbientLighting.value,
      'isBluetooth': isBluetooth.value,
      'isAppleCarPlay': isAppleCarPlay.value,
      'isAndroidAuto': isAndroidAuto.value,
      'isPremiumSoundSystem': isPremiumSoundSystem.value,
      'isWirelessCharging': isWirelessCharging.value,
      'isUsbPorts': isUsbPorts.value,
      'isOnboardComputer': isOnboardComputer.value,
      'isDabOrFmRadio': isDabOrFmRadio.value,
      'isWifiHotspot': isWifiHotspot.value,
      'isIntegratedStreaming': isIntegratedStreaming.value,
      'isRearSeatEntertainment': isRearSeatEntertainment.value,
      'isCentralLocking': isCentralLocking.value,
      'isImmobilizer': isImmobilizer.value,
      'isAlarmSystem': isAlarmSystem.value,
      'isPowerSteering': isPowerSteering.value,
      'isSummerTires': isSummerTires.value,
      
      // Real estate fields
      'propertyType': propertyType.value,
      'bedrooms': bedrooms.value,
      'bathrooms': bathrooms.value,
      'furnishing': furnishing.value,
      'floor': floor.value,
      'totalFloors': totalFloors.value,
      'parking': parking.value,
      'yearBuilt': yearBuilt.value,
      'facing': facing.value,
      'balconies': balconies.value,
      'plotSize': plotSize.value,
      'garden': garden.value,
      'pool': pool.value,
      'officeType': officeType.value,
      'totalArea': totalArea.value,
      'meetingRooms': meetingRooms.value,
      'zoning': zoning.value,
      'roadAccess': roadAccess.value,
    };
    print("💾 Data backed up successfully");
  }

  // Method to restore data from backup
  void restoreFromBackup() {
    if (_dataBackup.isEmpty) {
      print("⚠️ No backup data available to restore");
      return;
    }

    print("🔄 Restoring data from backup...");
    
    // Basic fields
    title.value = _dataBackup['title'] ?? '';
    description.value = _dataBackup['description'] ?? '';
    price.value = _dataBackup['price'] ?? 0;
    mainCategory.value = _dataBackup['mainCategory'] ?? '';
    subCategory.value = _dataBackup['subCategory'] ?? '';
    listingAction.value = _dataBackup['listingAction'] ?? '';
    location.value = _dataBackup['location'] ?? '';
    latitude.value = _dataBackup['latitude'] ?? '';
    longitude.value = _dataBackup['longitude'] ?? '';
    make.value = _dataBackup['make'] ?? '';
    model.value = _dataBackup['model'] ?? '';
    year.value = _dataBackup['year'] ?? 0;
    listingImage.value = List<String>.from(_dataBackup['listingImage'] ?? []);
    
    // Advanced fields
    bodyType.value = _dataBackup['bodyType'] ?? '';
    driveType.value = _dataBackup['driveType'] ?? '';
    fuelType.value = _dataBackup['fuelType'] ?? '';
    transmissionType.value = _dataBackup['transmissionType'] ?? '';
    horsepower.value = _dataBackup['horsepower'] ?? 0;
    mileage.value = _dataBackup['mileage'] ?? '';
    serviceHistory.value = _dataBackup['serviceHistory'] ?? '';
    accidental.value = _dataBackup['accidental'] ?? '';
    warranty.value = _dataBackup['warranty'] ?? '';
    previousOwners.value = _dataBackup['previousOwners'] ?? 0;
    condition.value = _dataBackup['condition'] ?? '';
    importStatus.value = _dataBackup['importStatus'] ?? '';
    registrationExpiry.value = _dataBackup['registrationExpiry'] ?? '';
    engineSize.value = _dataBackup['engineSize'] ?? '';
    payloadCapacity.value = _dataBackup['payloadCapacity'] ?? '';
    towingCapacity.value = _dataBackup['towingCapacity'] ?? '';

    // Passenger vehicle fields
    seatingCapacity.value = _dataBackup['seatingCapacity'] ?? '';
    doors.value = _dataBackup['doors'] ?? '';
    airConditioning.value = _dataBackup['airConditioning'] ?? '';
    entertainmentSystem.value = _dataBackup['entertainmentSystem'] ?? '';

    // Commercial vehicle fields
    cargoVolume.value = _dataBackup['cargoVolume'] ?? '';
    axles.value = _dataBackup['axles'] ?? '';
    gvwr.value = _dataBackup['gvwr'] ?? '';

    // Construction vehicle fields
    operatingWeight.value = _dataBackup['operatingWeight'] ?? '';
    bucketCapacity.value = _dataBackup['bucketCapacity'] ?? '';
    liftingCapacity.value = _dataBackup['liftingCapacity'] ?? '';
    reach.value = _dataBackup['reach'] ?? '';
    workingHours.value = _dataBackup['workingHours'] ?? '';

    exteriorColor.value = _dataBackup['exteriorColor'] ?? '';
    
    // Features
    noOfAirbags.value = _dataBackup['noOfAirbags'] ?? 0;
    abs.value = _dataBackup['abs'] ?? false;
    tractionControl.value = _dataBackup['tractionControl'] ?? false;
    laneAssist.value = _dataBackup['laneAssist'] ?? false;
    isBlindSpotMonitor.value = _dataBackup['isBlindSpotMonitor'] ?? false;
    isEmergencyBraking.value = _dataBackup['isEmergencyBraking'] ?? false;
    isAdaptiveCruiseControl.value = _dataBackup['isAdaptiveCruiseControl'] ?? false;
    isLaneDepartureWarning.value = _dataBackup['isLaneDepartureWarning'] ?? false;
    isFatigueWarningSystem.value = _dataBackup['isFatigueWarningSystem'] ?? false;
    isIsofix.value = _dataBackup['isIsofix'] ?? false;
    isEmergencyCallSystem.value = _dataBackup['isEmergencyCallSystem'] ?? false;
    isSpeedLimited.value = _dataBackup['isSpeedLimited'] ?? false;
    isTirePressureMonitoring.value = _dataBackup['isTirePressureMonitoring'] ?? false;
    parkingSensor.value = _dataBackup['parkingSensor'] ?? false;
    isRearCamera.value = _dataBackup['isRearCamera'] ?? false;
    isThreeSixtyCamera.value = _dataBackup['isThreeSixtyCamera'] ?? false;
    isTrafficSignRecognition.value = _dataBackup['isTrafficSignRecognition'] ?? false;
    cruiseControl.value = _dataBackup['cruiseControl'] ?? false;
    automaticHighBeam.value = _dataBackup['automaticHighBeam'] ?? false;
    lightSensor.value = _dataBackup['lightSensor'] ?? false;
    hillStartAssist.value = _dataBackup['hillStartAssist'] ?? false;
    parkingAssistOrSelfParking.value = _dataBackup['parkingAssistOrSelfParking'] ?? false;
    isLedHeadlights.value = _dataBackup['isLedHeadlights'] ?? false;
    isAdaptiveHeadlights.value = _dataBackup['isAdaptiveHeadlights'] ?? false;
    isFogLights.value = _dataBackup['isFogLights'] ?? false;
    isDaytimeRunningLights.value = _dataBackup['isDaytimeRunningLights'] ?? false;
    isAmbientLighting.value = _dataBackup['isAmbientLighting'] ?? false;
    isBluetooth.value = _dataBackup['isBluetooth'] ?? false;
    isAppleCarPlay.value = _dataBackup['isAppleCarPlay'] ?? false;
    isAndroidAuto.value = _dataBackup['isAndroidAuto'] ?? false;
    isPremiumSoundSystem.value = _dataBackup['isPremiumSoundSystem'] ?? false;
    isWirelessCharging.value = _dataBackup['isWirelessCharging'] ?? false;
    isUsbPorts.value = _dataBackup['isUsbPorts'] ?? false;
    isOnboardComputer.value = _dataBackup['isOnboardComputer'] ?? false;
    isDabOrFmRadio.value = _dataBackup['isDabOrFmRadio'] ?? false;
    isWifiHotspot.value = _dataBackup['isWifiHotspot'] ?? false;
    isIntegratedStreaming.value = _dataBackup['isIntegratedStreaming'] ?? false;
    isRearSeatEntertainment.value = _dataBackup['isRearSeatEntertainment'] ?? false;
    isCentralLocking.value = _dataBackup['isCentralLocking'] ?? false;
    isImmobilizer.value = _dataBackup['isImmobilizer'] ?? false;
    isAlarmSystem.value = _dataBackup['isAlarmSystem'] ?? false;
    isPowerSteering.value = _dataBackup['isPowerSteering'] ?? false;
    isSummerTires.value = _dataBackup['isSummerTires'] ?? false;
    
    print("✅ Data restored successfully from backup");
  }

  // Helper method to map Flutter listing action values to backend format
  String _mapListingActionToBackend(String flutterAction) {
    switch (flutterAction.toUpperCase()) {
      case 'FOR_SALE':
        return 'SALE';
      case 'FOR_RENT':
        return 'RENT';
      case 'SEARCHING':
        return 'SEARCHING';
      default:
        return 'SALE'; // Default fallback
    }
  }

}