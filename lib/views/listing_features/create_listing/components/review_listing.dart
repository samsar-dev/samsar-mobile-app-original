import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/create_listing_controller.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';

import 'package:samsar/widgets/animated_input_wrapper/animated_input_wrapper.dart';
import 'package:samsar/widgets/app_button/app_button.dart';

class ReviewListing extends StatefulWidget {
  final bool isVehicle;
  final List<String> imageUrls;

  const ReviewListing({
    super.key,
    this.isVehicle = true,
    required this.imageUrls,
  });

  @override
  State<ReviewListing> createState() => _ReviewListingState();
}

// Helper function to parse color from hex string
Color _parseColor(String hexColor) {
  try {
    String hex = hexColor.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF' + hex; // Add opacity if not present
    } else if (hex.length == 3) {
      // Convert shorthand to full hex
      hex = 'FF' + hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2];
    }
    return Color(int.parse(hex, radix: 16));
  } catch (e) {
    return Colors.grey; // Return default color if parsing fails
  }
}

class _ReviewListingState extends State<ReviewListing> {
  //vehicle controllers

  //real estate controllers

  final TextEditingController titleController = TextEditingController();
  final TextEditingController totalAreaController = TextEditingController();
  final TextEditingController yearBuiltController = TextEditingController();
  final TextEditingController bedroomsController = TextEditingController();
  final TextEditingController bathroomsController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController description = TextEditingController();

  //climate and energy
  final TextEditingController heatingController = TextEditingController();
  final TextEditingController coolingController = TextEditingController();
  final TextEditingController energyFeaturesController =
      TextEditingController();
  final TextEditingController energyRatingController = TextEditingController();

  //structure and layout
  final TextEditingController basementController = TextEditingController();
  final TextEditingController basementFeaturesController =
      TextEditingController();
  final TextEditingController atticController = TextEditingController();
  final TextEditingController constructionTypeController =
      TextEditingController();
  final TextEditingController noOfStoriesController = TextEditingController();

  //interior features
  final TextEditingController floortingTypesController =
      TextEditingController();
  final TextEditingController windowFeaturesController =
      TextEditingController();
  final TextEditingController kitchenFeaturesController =
      TextEditingController();
  final TextEditingController bathroomFeaturesController =
      TextEditingController();
  final TextEditingController conditionController = TextEditingController();

  //living space details
  final TextEditingController livingAreaController = TextEditingController();
  final TextEditingController halfBathroomsController = TextEditingController();

  //parking and roof
  final TextEditingController roofTypeController = TextEditingController();
  final TextEditingController parkingController = TextEditingController();
  final TextEditingController parkingSpacesController = TextEditingController();

  late final ListingInputController _listingInputController;

  // Lazy initialization to prevent premature controller instantiation
  CreateListingController? _createListingController;

  // Helper method to check if current subcategory has relevant features
  bool _hasRelevantFeatures() {
    final subCategory = _listingInputController.subCategory.value.toUpperCase();
    
    // Check for real estate features first
    if (!widget.isVehicle) {
      return _listingInputController.selectedFeatures.isNotEmpty;
    }
    
    // Common features for all vehicle types
    bool hasCommonFeatures = _listingInputController.selectedFeatures.isNotEmpty ||
        _listingInputController.noOfAirbags.value > 0 ||
        _listingInputController.abs.value ||
        _listingInputController.tractionControl.value ||
        _listingInputController.laneAssist.value ||
        _listingInputController.parkingSensor.value ||
        _listingInputController.cruiseControl.value;
    
    // Subcategory-specific features
    switch (subCategory) {
      case 'CARS':
      case 'MOTORCYCLES':
        return hasCommonFeatures ||
            _listingInputController.isBlindSpotMonitor.value ||
            _listingInputController.isEmergencyBraking.value ||
            _listingInputController.isAdaptiveCruiseControl.value ||
            _listingInputController.isLedHeadlights.value ;
            
      case 'COMMERCIALS':
        return hasCommonFeatures ||
            _listingInputController.hasHydraulicLift.value ||
            _listingInputController.hasCargoCover.value ||
            _listingInputController.hasTieDownPoints.value ||
            _listingInputController.hasLoadingRamp.value ||
            _listingInputController.hasRefrigeration.value ||
            _listingInputController.hasGpsTracking.value ||
            _listingInputController.hasCommercialLicense.value ||
            _listingInputController.hasCargoBarrier.value;
            
      case 'CONSTRUCTIONS':
        return hasCommonFeatures ||
            _listingInputController.hasHydraulicSystem.value ||
            _listingInputController.hasWorkLights.value ||
            _listingInputController.hasQuickAttach.value ||
            _listingInputController.hasRubberTracks.value ||
            _listingInputController.hasEnclosedCab.value ||
            _listingInputController.hasEmergencyStop.value ||
            _listingInputController.hasRolloverProtection.value ||
            _listingInputController.hasServiceRecords.value ||
            _listingInputController.hasOperatorManual.value;
            
      case 'PASSENGERS':
        return hasCommonFeatures ||
            _listingInputController.hasElectricWindows.value ||
            _listingInputController.hasGpsNavigation.value ||
            _listingInputController.hasUsbCharging.value ||
            _listingInputController.hasBackupCamera.value ||
            _listingInputController.hasSunroof.value ||
            _listingInputController.hasLeatherSeats.value;
            
      default:
        return hasCommonFeatures;
    }
  }

  // Helper method to get filtered features based on current subcategory
  List<Widget> _getFilteredFeatures(double screenWidth) {
    final subCategory = _listingInputController.subCategory.value.toUpperCase();
    List<Widget> features = [];
    
    // For real estate, just show selected features
    if (!widget.isVehicle) {
      features.addAll(_listingInputController.selectedFeatures.map((feature) => 
        _buildFeatureChip(feature.tr, screenWidth)
      ));
      return features;
    }
    
    // Common features for all vehicle types
    features.addAll(_listingInputController.selectedFeatures.map((feature) => 
      _buildFeatureChip(feature.tr, screenWidth)
    ));
    
    // Airbags with count
    if (_listingInputController.noOfAirbags.value > 0) {
      features.add(_buildFeatureChip('${'airbags'.tr} (${_listingInputController.noOfAirbags.value})', screenWidth));
    }
    
    // Common safety features
    if (_listingInputController.abs.value) features.add(_buildFeatureChip('ABS', screenWidth));
    if (_listingInputController.tractionControl.value) features.add(_buildFeatureChip('traction_control'.tr, screenWidth));
    if (_listingInputController.laneAssist.value) features.add(_buildFeatureChip('lane_assist'.tr, screenWidth));
    if (_listingInputController.parkingSensor.value) features.add(_buildFeatureChip('parking_sensor'.tr, screenWidth));
    if (_listingInputController.cruiseControl.value) features.add(_buildFeatureChip('cruise_control'.tr, screenWidth));
    
    // Subcategory-specific features
    switch (subCategory) {
      case 'CARS':
      case 'MOTORCYCLES':
        // Car and motorcycle specific features
        if (_listingInputController.isBlindSpotMonitor.value) features.add(_buildFeatureChip('blind_spot_monitor'.tr, screenWidth));
        if (_listingInputController.isEmergencyBraking.value) features.add(_buildFeatureChip('emergency_braking'.tr, screenWidth));
        if (_listingInputController.isAdaptiveCruiseControl.value) features.add(_buildFeatureChip('adaptive_cruise_control'.tr, screenWidth));
        if (_listingInputController.isLedHeadlights.value) features.add(_buildFeatureChip('led_headlights'.tr, screenWidth));
        if (_listingInputController.isBluetooth.value) features.add(_buildFeatureChip('bluetooth'.tr, screenWidth));
        if (_listingInputController.isAppleCarPlay.value) features.add(_buildFeatureChip('apple_carplay'.tr, screenWidth));
        if (_listingInputController.isAndroidAuto.value) features.add(_buildFeatureChip('android_auto'.tr, screenWidth));
        break;
        
      case 'COMMERCIALS':
        // Commercial vehicle specific features
        if (_listingInputController.hasHydraulicLift.value) features.add(_buildFeatureChip('hydraulic_lift'.tr, screenWidth));
        if (_listingInputController.hasCargoCover.value) features.add(_buildFeatureChip('cargo_cover'.tr, screenWidth));
        if (_listingInputController.hasTieDownPoints.value) features.add(_buildFeatureChip('tie_down_points'.tr, screenWidth));
        if (_listingInputController.hasLoadingRamp.value) features.add(_buildFeatureChip('loading_ramp'.tr, screenWidth));
        if (_listingInputController.hasRefrigeration.value) features.add(_buildFeatureChip('refrigeration'.tr, screenWidth));
        if (_listingInputController.hasGpsTracking.value) features.add(_buildFeatureChip('gps_tracking'.tr, screenWidth));
        if (_listingInputController.hasCommercialLicense.value) features.add(_buildFeatureChip('commercial_license'.tr, screenWidth));
        if (_listingInputController.hasCargoBarrier.value) features.add(_buildFeatureChip('cargo_barrier'.tr, screenWidth));
        break;
        
      case 'CONSTRUCTIONS':
        // Construction vehicle specific features
        if (_listingInputController.hasHydraulicSystem.value) features.add(_buildFeatureChip('hydraulic_system'.tr, screenWidth));
        if (_listingInputController.hasWorkLights.value) features.add(_buildFeatureChip('work_lights'.tr, screenWidth));
        if (_listingInputController.hasQuickAttach.value) features.add(_buildFeatureChip('quick_attach'.tr, screenWidth));
        if (_listingInputController.hasRubberTracks.value) features.add(_buildFeatureChip('rubber_tracks'.tr, screenWidth));
        if (_listingInputController.hasEnclosedCab.value) features.add(_buildFeatureChip('enclosed_cab'.tr, screenWidth));
        if (_listingInputController.hasEmergencyStop.value) features.add(_buildFeatureChip('emergency_stop'.tr, screenWidth));
        if (_listingInputController.hasRolloverProtection.value) features.add(_buildFeatureChip('rollover_protection'.tr, screenWidth));
        if (_listingInputController.hasServiceRecords.value) features.add(_buildFeatureChip('service_records'.tr, screenWidth));
        if (_listingInputController.hasOperatorManual.value) features.add(_buildFeatureChip('operator_manual'.tr, screenWidth));
        break;
        
      case 'PASSENGERS':
        // Passenger vehicle specific features
        if (_listingInputController.hasElectricWindows.value) features.add(_buildFeatureChip('electric_windows'.tr, screenWidth));
        if (_listingInputController.hasGpsNavigation.value) features.add(_buildFeatureChip('gps_navigation'.tr, screenWidth));
        if (_listingInputController.hasUsbCharging.value) features.add(_buildFeatureChip('usb_charging'.tr, screenWidth));
        if (_listingInputController.hasBackupCamera.value) features.add(_buildFeatureChip('backup_camera'.tr, screenWidth));
        if (_listingInputController.hasSunroof.value) features.add(_buildFeatureChip('sunroof'.tr, screenWidth));
        if (_listingInputController.hasLeatherSeats.value) features.add(_buildFeatureChip('leather_seats'.tr, screenWidth));
        break;
    }
    
    return features;
  }

  // Validation method to check required fields based on backend API requirements
  bool _validateRequiredFields() {
    List<String> errors = [];

    // Debug: Log all current values

    // Backend required fields validation
    if (_listingInputController.title.value.isEmpty) {
      errors.add("Title is required");
    }

    if (_listingInputController.description.value.isEmpty) {
      errors.add("Description is required");
    }

    if (_listingInputController.price.value <= 0) {
      errors.add("Valid price is required");
    }

    if (_listingInputController.mainCategory.value.isEmpty) {
      errors.add("Main category is required");
    }

    if (_listingInputController.subCategory.value.isEmpty) {
      errors.add("Sub category is required");
    }

    if (_listingInputController.location.value.isEmpty) {
      errors.add("Location is required");
    }

    if (_listingInputController.latitude.value.isEmpty ||
        _listingInputController.longitude.value.isEmpty) {
      errors.add("Valid latitude and longitude are required");
    }

    // Category-specific validation
    if (widget.isVehicle) {
      // Vehicle-specific requirements
      if (_listingInputController.make.value.isEmpty) {
        errors.add("Vehicle make is required");
      }

      if (_listingInputController.model.value.isEmpty) {
        errors.add("Vehicle model is required");
      }

      if (_listingInputController.year.value <= 1900) {
        errors.add("Valid year is required");
      }
    } else {
      // Real estate-specific requirements
      if (_listingInputController.totalArea.value <= 0) {
        errors.add("Total area is required");
      }
      
      // Check for seller type and listing action
      if (_listingInputController.sellerType.value.isEmpty) {
        errors.add("Seller type is required");
      }
      
      if (_listingInputController.listingAction.value.isEmpty) {
        errors.add("Listing action is required");
      }
    }

    if (_listingInputController.listingImage.isEmpty) {
      errors.add("At least one image is required");
    }

    if (errors.isNotEmpty) {
    }

    if (errors.isNotEmpty) {
      // Show detailed error message with all missing fields
      String errorMessage =
          "Please fix the following issues:\n\n" +
          errors.map((e) => "• $e").join("\n");

      Get.dialog(
        AlertDialog(
          title: Text(
            'validation_error'.tr,
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Text(errorMessage, style: TextStyle(fontSize: 14)),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('ok'.tr, style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      );
      return false;
    }

    return true;
  }

  @override
  void initState() {
    super.initState();

    // BULLETPROOF CONTROLLER ACCESS
    try {
      if (Get.isRegistered<ListingInputController>()) {
        _listingInputController = Get.find<ListingInputController>();
      } else {
        _listingInputController = Get.put(
          ListingInputController(),
          permanent: true,
        );
      }
    } catch (e) {
      _listingInputController = Get.put(
        ListingInputController(),
        permanent: true,
      );
    }


    // Debug controller state at review screen entry

    // CRITICAL FIX: If controller data is empty but we have images from widget, sync them
    if (_listingInputController.listingImage.isEmpty &&
        widget.imageUrls.isNotEmpty) {
      _listingInputController.listingImage.value = List<String>.from(
        widget.imageUrls,
      );
    }

    // Check for data preservation issues
    if (_listingInputController.title.value.isEmpty) {
    }
    if (_listingInputController.price.value == 0) {
    }
    if (_listingInputController.listingImage.isEmpty) {
    }

    // Check for advanced details preservation
    if (_listingInputController.bodyType.value.isEmpty &&
        _listingInputController.fuelType.value.isEmpty &&
        _listingInputController.transmissionType.value.isEmpty) {
    }

    // CRITICAL: Check if we have ANY data at all
    bool hasAnyData =
        _listingInputController.title.value.isNotEmpty ||
        _listingInputController.make.value.isNotEmpty ||
        _listingInputController.model.value.isNotEmpty ||
        _listingInputController.price.value > 0 ||
        _listingInputController.listingImage.isNotEmpty;

    if (!hasAnyData) {

      // Show error dialog to user
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.dialog(
          AlertDialog(
            title: Text(
              'data_missing'.tr,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            content: Text('no_listing_data_message'.tr),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Close dialog
                  Get.back(); // Go back to previous screen
                },
                child: Text('go_back'.tr, style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        );
      });
    }

  }

  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed height container for scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    AnimatedInputWrapper(
                      delayMilliseconds: 0,
                      child: ImagePlaceHolder(imageUrls: widget.imageUrls),
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    Obx(() {
                      return AnimatedInputWrapper(
                        delayMilliseconds: 100,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.02),
                            child: Text(
                              _listingInputController.title.value.isNotEmpty
                                  ? _listingInputController.title.value
                                  : "No Title Available",
                              style: TextStyle(
                                color:
                                    _listingInputController
                                        .title
                                        .value
                                        .isNotEmpty
                                    ? blackColor
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.055,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: screenHeight * 0.02),

                    // Content based on vehicle/real estate type
                    widget.isVehicle
                        ? vehicleWidget(screenHeight, screenWidth)
                        : realEstateWidget(screenHeight, screenWidth),

                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),

            // Fixed bottom button area
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: AppButton(
                widthSize: 0.65,
                heightSize: 0.07,
                buttonColor: blueColor,
                text: "Create",
                textColor: whiteColor,
                onPressed: () {
                  if (widget.isVehicle) {
                    // Validate required fields before submission
                    if (_validateRequiredFields()) {

                      // Use the createCarModel method which includes all features and extras
                      final carModel = _listingInputController
                          .createVehicleModel();

                      // Lazy initialization of controller only when needed for submission
                      _createListingController ??= Get.put(
                        CreateListingController(),
                      );
                      _createListingController!.createCarListingController(
                        carModel,
                      );
                    } else {
                    }
                  } else {
                    // 🔧 CRITICAL FIX: Handle real estate listings
                    
                    // Validate required fields for real estate
                    if (_validateRequiredFields()) {

                      // Create real estate model
                      final realEstateModel = _listingInputController
                          .createRealEstateModel();

                      // Lazy initialization of controller only when needed for submission
                      _createListingController ??= Get.put(
                        CreateListingController(),
                      );
                      _createListingController!.createRealEstateListingController(
                        realEstateModel,
                      );
                    } else {
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoCard({
    required double screenWidth,
    required double screenHeight,
    required String title,
    required List<Map<String, dynamic>> data,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            title,
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.w700,
              color: blueColor,
            ),
          ),
          const SizedBox(height: 14),

          // Divider
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 10),

          // Dynamic rows
          ...data.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.label_important_outline,
                    size: 18,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${item['label']}: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      fontSize: screenWidth * 0.038,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        if (item['isColor'] == true &&
                            item['value']?.isNotEmpty == true)
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: _parseColor(item['value']!),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  ),
                                ),
                              ),
                              Text(
                                item['value']!,
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: screenWidth * 0.038,
                                ),
                              ),
                            ],
                          )
                        else
                          Expanded(
                            child: Text(
                              item['value']!.isNotEmpty ? item['value']! : "N/A",
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: screenWidth * 0.038,
                              ),
                              softWrap: true,
                              maxLines: null,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget vehicleWidget(double screenHeight, double screenWidth) {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            AnimatedInputWrapper(
              delayMilliseconds: 250,
              child: infoCard(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                title: 'basic_info'.tr,
                data: [
                  {
                    "label": 'make'.tr,
                    "value": _listingInputController.make.value,
                  },
                  {
                    "label": 'model'.tr,
                    "value": _listingInputController.model.value,
                  },
                  {
                    "label": 'year'.tr,
                    "value": _listingInputController.year.value.toString(),
                  },
                  {
                    "label": 'price'.tr,
                    "value": _listingInputController.price.value.toString(),
                  },
                  {
                    "label": 'location'.tr,
                    "value": _listingInputController.location.value,
                  },
                  {
                    "label": 'description'.tr,
                    "value": _listingInputController.description.value,
                  },
                  {
                    "label": 'listing_action_type'.tr,
                    "value": _listingInputController.listingAction.value.tr,
                  },
                  if (_listingInputController.sellerType.value.isNotEmpty)
                    {
                      "label": 'seller_type'.tr,
                      "value": _listingInputController.sellerType.value,
                    },
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.003),
            AnimatedInputWrapper(
              delayMilliseconds: 300,
              child: infoCard(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                title: 'engine_and_performance'.tr,
                data: [
                  if (_listingInputController.horsepower.value > 0)
                    {
                      "label": 'horsepower'.tr,
                      "value": '${_listingInputController.horsepower.value} HP',
                    },
                  if (_listingInputController.mileage.value.isNotEmpty &&
                      int.parse(_listingInputController.mileage.value) > 0)
                    {
                      "label": 'mileage'.tr,
                      "value": '${_listingInputController.mileage.value} km',
                    },
                    if (_listingInputController.engineSize.value.isNotEmpty)
                      {
                        "label": 'engine_size'.tr,
                        "value": _listingInputController.engineSize.value,
                      },
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.003),
            AnimatedInputWrapper(
              delayMilliseconds: 350,
              child: infoCard(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                title: 'vehicle_specifications'.tr,
                data: [
                  {
                    "label": 'body_type'.tr,
                    "value": _listingInputController.bodyType.value,
                  },
                  if (_listingInputController.driveType.value.isNotEmpty &&
                      _listingInputController.driveType.value != 'N/A')
                    {
                      "label": 'drivetrain'.tr,
                      "value": _listingInputController.driveType.value,
                    },
                  // Only show fuel type and transmission for cars and motorcycles, not construction vehicles
                  if (_listingInputController.subCategory.value.toUpperCase() != 'CONSTRUCTIONS' &&
                      _listingInputController.fuelType.value.isNotEmpty &&
                      _listingInputController.fuelType.value != 'N/A')
                    {
                      "label": 'fuel_type'.tr,
                      "value": _listingInputController.fuelType.value,
                    },
                  if (_listingInputController.subCategory.value.toUpperCase() != 'CONSTRUCTIONS' &&
                      _listingInputController.transmissionType.value.isNotEmpty &&
                      _listingInputController.transmissionType.value != 'N/A')
                    {
                      "label": 'transmission'.tr,
                      "value": _listingInputController.transmissionType.value,
                    },
                  if (_listingInputController.payloadCapacity.value.isNotEmpty)
                    {
                      "label": 'payload_capacity'.tr,
                      "value":
                          '${_listingInputController.payloadCapacity.value} kg',
                    },
                  if (_listingInputController.towingCapacity.value.isNotEmpty)
                    {
                      "label": 'towing_capacity'.tr,
                      "value":
                          '${_listingInputController.towingCapacity.value} kg',
                    },
                  // Motorcycle fields
                  if (_listingInputController.condition.value.isNotEmpty)
                    {
                      "label": 'condition'.tr,
                      "value": _listingInputController.condition.value.tr,
                    },
                  if (_listingInputController.previousOwners.value > 0)
                    {
                      "label": 'previous_owners'.tr,
                      "value": _listingInputController.previousOwners.value
                          .toString(),
                    },
                  if (_listingInputController.warranty.value.isNotEmpty)
                    {
                      "label": 'warranty'.tr,
                      "value": _listingInputController.warranty.value.tr,
                    },
                  if (_listingInputController.accidental.value.isNotEmpty)
                    {
                      "label": 'accidental'.tr,
                      "value": _listingInputController.accidental.value.tr,
                    },
                  if (_listingInputController.serviceHistory.value.isNotEmpty)
                    {
                      "label": 'service_history'.tr,
                      "value": _listingInputController.serviceHistory.value.tr,
                    },
                  if (_listingInputController.abs.value)
                    {
                      "label": 'abs'.tr,
                      "value": 'yes'.tr,
                    },
                  if (_listingInputController.tractionControl.value)
                    {
                      "label": 'traction_control'.tr,
                      "value": 'yes'.tr,
                    },
                  if (_listingInputController.laneAssist.value)
                    {
                      "label": 'lane_assist'.tr,
                      "value": 'yes'.tr,
                    },
                  if (_listingInputController.parkingSensor.value)
                    {
                      "label": 'parking_sensor'.tr,
                      "value": 'yes'.tr,
                    },
                  if (_listingInputController.cruiseControl.value)
                    {
                      "label": 'cruise_control'.tr,
                      "value": 'yes'.tr,
                    },
                  // Commercial vehicle features
                  if (_listingInputController.hasHydraulicLift.value)
                    {
                      "label": 'hydraulic_lift'.tr,
                      "value": 'yes'.tr,
                    },
                  if (_listingInputController.hasCargoCover.value)
                    {
                      "label": 'cargo_cover'.tr,
                      "value": 'yes'.tr,
                    },
                  if (_listingInputController.hasRefrigeration.value)
                    {
                      "label": 'refrigeration'.tr,
                      "value": 'yes'.tr,
                    },
                  // Construction vehicle features
                  if (_listingInputController.hasHydraulicSystem.value)
                    {
                      "label": 'hydraulic_system'.tr,
                      "value": 'yes'.tr,
                    },
                  if (_listingInputController.hasWorkLights.value)
                    {
                      "label": 'work_lights'.tr,
                      "value": 'yes'.tr,
                    },
                  if (_listingInputController.hasRolloverProtection.value)
                    {
                      "label": 'rollover_protection'.tr,
                      "value": 'yes'.tr,
                    },
                  // Passenger vehicle features
                  if (_listingInputController.hasElectricWindows.value)
                    {
                      "label": 'electric_windows'.tr,
                      "value": 'yes'.tr,
                    },
                  if (_listingInputController.hasBackupCamera.value)
                    {
                      "label": 'backup_camera'.tr,
                      "value": 'yes'.tr,
                    },
                  if (_listingInputController.hasLeatherSeats.value)
                    {
                      "label": 'leather_seats'.tr,
                      "value": 'yes'.tr,
                    },
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.003),
            
            // Features and Extras section for vehicles - filter by subcategory
            if (_hasRelevantFeatures())
              AnimatedInputWrapper(
                delayMilliseconds: 350,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section title
                      Text(
                        'features_and_extras'.tr,
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      
                      // Features grid - filtered by subcategory
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _getFilteredFeatures(screenWidth),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: screenHeight * 0.003),
            
            // Passenger Vehicle Details
            if (_listingInputController.subCategory.value.toUpperCase() ==
                    'PASSENGERS' &&
                (_listingInputController.seatingCapacity.value.isNotEmpty ||
                    _listingInputController.doors.value.isNotEmpty ||
                    _listingInputController.airConditioning.value.isNotEmpty ||
                    _listingInputController
                        .entertainmentSystem
                        .value
                        .isNotEmpty))
              AnimatedInputWrapper(
                delayMilliseconds: 400,
                child: infoCard(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  title: 'passenger_vehicle_details'.tr,
                  data: [
                    if (_listingInputController
                        .seatingCapacity
                        .value
                        .isNotEmpty)
                      {
                        "label": 'seating_capacity'.tr,
                        "value": _listingInputController.seatingCapacity.value,
                      },
                    if (_listingInputController.doors.value.isNotEmpty)
                      {
                        "label": 'doors'.tr,
                        "value": _listingInputController.doors.value,
                      },
                    if (_listingInputController
                        .airConditioning
                        .value
                        .isNotEmpty)
                      {
                        "label": 'air_conditioning'.tr,
                        "value":
                            _listingInputController.airConditioning.value.tr,
                      },
                    if (_listingInputController
                        .entertainmentSystem
                        .value
                        .isNotEmpty)
                      {
                        "label": 'entertainment_system'.tr,
                        "value": _listingInputController
                            .entertainmentSystem
                            .value
                            .tr,
                      },
                  ],
                ),
              ),

            // Commercial Vehicle Details
            if (_listingInputController.subCategory.value.toUpperCase() ==
                    'COMMERCIALS' &&
                (_listingInputController.cargoVolume.value.isNotEmpty ||
                    _listingInputController.axles.value.isNotEmpty ||
                    _listingInputController.gvwr.value.isNotEmpty))
              AnimatedInputWrapper(
                delayMilliseconds: 400,
                child: infoCard(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  title: 'commercial_vehicle_details'.tr,
                  data: [
                    if (_listingInputController.cargoVolume.value.isNotEmpty)
                      {
                        "label": 'cargo_volume'.tr,
                        "value":
                            '${_listingInputController.cargoVolume.value} m³',
                      },
                    if (_listingInputController.axles.value.isNotEmpty)
                      {
                        "label": 'axles'.tr,
                        "value": _listingInputController.axles.value,
                      },
                    if (_listingInputController.gvwr.value.isNotEmpty)
                      {
                        "label": 'gvwr'.tr,
                        "value": '${_listingInputController.gvwr.value} kg',
                      },
                  ],
                ),
              ),

            // Construction Vehicle Details
            if (_listingInputController.subCategory.value.toUpperCase() ==
                    'CONSTRUCTIONS' &&
                (_listingInputController.operatingWeight.value.isNotEmpty ||
                    _listingInputController.bucketCapacity.value.isNotEmpty ||
                    _listingInputController.liftingCapacity.value.isNotEmpty ||
                    _listingInputController.reach.value.isNotEmpty ||
                    _listingInputController.workingHours.value.isNotEmpty))
              AnimatedInputWrapper(
                delayMilliseconds: 400,
                child: infoCard(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  title: 'construction_vehicle_details'.tr,
                  data: [
                    if (_listingInputController
                        .operatingWeight
                        .value
                        .isNotEmpty)
                      {
                        "label": 'operating_weight'.tr,
                        "value":
                            '${_listingInputController.operatingWeight.value} kg',
                      },
                    if (_listingInputController.bucketCapacity.value.isNotEmpty)
                      {
                        "label": 'bucket_capacity'.tr,
                        "value":
                            '${_listingInputController.bucketCapacity.value} m³',
                      },
                    if (_listingInputController
                        .liftingCapacity
                        .value
                        .isNotEmpty)
                      {
                        "label": 'lifting_capacity'.tr,
                        "value":
                            '${_listingInputController.liftingCapacity.value} kg',
                      },
                    if (_listingInputController.reach.value.isNotEmpty)
                      {
                        "label": 'reach'.tr,
                        "value": '${_listingInputController.reach.value} m',
                      },
                    if (_listingInputController.workingHours.value.isNotEmpty)
                      {
                        "label": 'working_hours'.tr,
                        "value":
                            '${_listingInputController.workingHours.value} hours',
                      },
                  ],
                ),
              ),
            SizedBox(height: screenHeight * 0.003),
            // Legal and Documentation - only show if fields have meaningful values
            if ((_listingInputController.importStatus.value.isNotEmpty &&
                    _listingInputController.importStatus.value != 'N/A') ||
                (_listingInputController.registrationExpiry.value.isNotEmpty &&
                    _listingInputController.registrationExpiry.value != 'N/A'))
              AnimatedInputWrapper(
                delayMilliseconds: 450,
                child: infoCard(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  title: 'legal_and_documentation'.tr,
                  data: [
                    if (_listingInputController.importStatus.value.isNotEmpty &&
                        _listingInputController.importStatus.value != 'N/A')
                      {
                        "label": 'import_status'.tr,
                        "value": _listingInputController.importStatus.value,
                      },
                    if (_listingInputController
                            .registrationExpiry
                            .value
                            .isNotEmpty &&
                        _listingInputController.registrationExpiry.value !=
                            'N/A')
                      {
                        "label": 'registration_expiry_date'.tr,
                        "value":
                            _listingInputController.registrationExpiry.value,
                      },
                  ],
                ),
              ),
            SizedBox(height: screenHeight * 0.003),
            // Only show Color & Appearance if there's actual color data
            if (_listingInputController.exteriorColor.value.isNotEmpty &&
                _listingInputController.exteriorColor.value != 'N/A' &&
                _listingInputController.exteriorColor.value != '#000000')
              AnimatedInputWrapper(
                delayMilliseconds: 500,
                child: infoCard(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                  title: 'color_and_appearance'.tr,
                  data: [
                    {
                      "label": 'exterior_color'.tr,
                      "value": _listingInputController.exteriorColor.value,
                      "isColor": true,
                    },
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget realEstateWidget(double screenHeight, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        children: [
          // Basic Info
          AnimatedInputWrapper(
            delayMilliseconds: 200,
            child: infoCard(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              title: "Basic Info".tr,
              data: [
                {
                  "label": "Title".tr,
                  "value": _listingInputController.title.value,
                },
                if (_listingInputController.totalArea.value > 0)
                  {
                    "label": "Total Area".tr,
                    "value": "${_listingInputController.totalArea.value} sqm",
                  },
                if (_listingInputController.yearBuilt.value > 0)
                  {
                    "label": "Year Built".tr,
                    "value": _listingInputController.yearBuilt.value.toString(),
                  },
                if (_listingInputController.bedrooms.value > 0)
                  {
                    "label": "Bedrooms".tr,
                    "value": _listingInputController.bedrooms.value.toString(),
                  },
                if (_listingInputController.bathrooms.value > 0)
                  {
                    "label": "Bathrooms".tr,
                    "value": _listingInputController.bathrooms.value.toString(),
                  },
                {
                  "label": "Price".tr,
                  "value": _listingInputController.price.value.toString(),
                },
                {
                  "label": "Location".tr,
                  "value": _listingInputController.location.value,
                },
                if (_listingInputController.description.value.isNotEmpty)
                  {
                    "label": "Description".tr,
                    "value": _listingInputController.description.value,
                  },
                {
                  "label": 'listing_action_type'.tr,
                  "value": _listingInputController.listingAction.value.tr,
                },
                if (_listingInputController.sellerType.value.isNotEmpty)
                  {
                    "label": 'seller_type'.tr,
                    "value": _listingInputController.sellerType.value.tr,
                  },
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.01),

          // Property Details
          if (_listingInputController.furnishing.value.isNotEmpty ||
              _listingInputController.floor.value > 0 ||
              _listingInputController.totalFloors.value > 0 ||
              _listingInputController.parking.value.isNotEmpty ||
              _listingInputController.facing.value.isNotEmpty ||
              _listingInputController.balconies.value > 0 ||
              _listingInputController.plotSize.value > 0 ||
              _listingInputController.garden.value.isNotEmpty ||
              _listingInputController.pool.value.isNotEmpty ||
              _listingInputController.officeType.value.isNotEmpty ||
              _listingInputController.zoning.value.isNotEmpty ||
              _listingInputController.roadAccess.value.isNotEmpty)
            AnimatedInputWrapper(
              delayMilliseconds: 300,
              child: infoCard(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                title: "Property Details".tr,
                data: [
                  if (_listingInputController.furnishing.value.isNotEmpty)
                    {
                      "label": "Furnishing".tr,
                      "value": _listingInputController.furnishing.value,
                    },
                  if (_listingInputController.floor.value > 0)
                    {
                      "label": "Floor Number".tr,
                      "value": _listingInputController.floor.value.toString(),
                    },
                  if (_listingInputController.totalFloors.value > 0)
                    {
                      "label": "Total Floors".tr,
                      "value": _listingInputController.totalFloors.value
                          .toString(),
                    },
                  if (_listingInputController.parking.value.isNotEmpty)
                    {
                      "label": "Parking".tr,
                      "value": _listingInputController.parking.value,
                    },
                  if (_listingInputController.facing.value.isNotEmpty)
                    {
                      "label": "Facing Direction".tr,
                      "value": _listingInputController.facing.value,
                    },
                  if (_listingInputController.balconies.value > 0)
                    {
                      "label": "Balconies".tr,
                      "value": _listingInputController.balconies.value
                          .toString(),
                    },
                  if (_listingInputController.plotSize.value > 0)
                    {
                      "label": "Plot Size".tr,
                      "value": "${_listingInputController.plotSize.value} sqm",
                    },
                  if (_listingInputController.garden.value.isNotEmpty)
                    {
                      "label": "Garden".tr,
                      "value": _listingInputController.garden.value,
                    },
                  if (_listingInputController.pool.value.isNotEmpty)
                    {
                      "label": "Pool".tr,
                      "value": _listingInputController.pool.value,
                    },
                  if (_listingInputController.officeType.value.isNotEmpty)
                    {
                      "label": "Office Type".tr,
                      "value": _listingInputController.officeType.value,
                    },
                  if (_listingInputController.zoning.value.isNotEmpty)
                    {
                      "label": "Zoning".tr,
                      "value": _listingInputController.zoning.value,
                    },
                  if (_listingInputController.roadAccess.value.isNotEmpty)
                    {
                      "label": "Road Access".tr,
                      "value": _listingInputController.roadAccess.value,
                    },
                  if (_listingInputController.buildingAge.value > 0)
                    {
                      "label": "Building Age".tr,
                      "value": "${_listingInputController.buildingAge.value} years",
                    },
                  if (_listingInputController.orientation.value.isNotEmpty)
                    {
                      "label": "Orientation".tr,
                      "value": _listingInputController.orientation.value,
                    },
                  if (_listingInputController.view.value.isNotEmpty)
                    {
                      "label": "View".tr,
                      "value": _listingInputController.view.value,
                    },
                ],
              ),
            ),

          SizedBox(height: screenHeight * 0.01),

          // Climate & Energy - Currently not implemented in controller
          // Will be added when these fields are available in ListingInputController
          SizedBox(height: screenHeight * 0.01),

          // Structure & Layout - Currently not implemented in controller
          // Will be added when these fields are available in ListingInputController
          SizedBox(height: screenHeight * 0.01),

          // Interior Features
          if (_listingInputController.condition.value.isNotEmpty)
            AnimatedInputWrapper(
              delayMilliseconds: 600,
              child: infoCard(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                title: "Interior Features".tr,
                data: [
                  if (_listingInputController.condition.value.isNotEmpty)
                    {
                      "label": "Condition".tr,
                      "value": _listingInputController.condition.value,
                    },
                  // Other interior features not yet implemented in controller
                ],
              ),
            ),

          SizedBox(height: screenHeight * 0.01),

          // Living Space Details - Currently not implemented in controller
          // Will be added when these fields are available in ListingInputController
          SizedBox(height: screenHeight * 0.01),

          // Features and Extras section for real estate
          if (_hasRelevantFeatures())
            AnimatedInputWrapper(
              delayMilliseconds: 700,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: EdgeInsets.all(screenWidth * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Features & Extras".tr,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    Wrap(
                      children: _getFilteredFeatures(screenWidth),
                    ),
                  ],
                ),
              ),
            ),
            
        ],
      ),
    );
  }

  // Helper method to build feature chips for the features section
  Widget _buildFeatureChip(String feature, double screenWidth) {
    return Container(
      margin: EdgeInsets.only(right: screenWidth * 0.02, bottom: screenWidth * 0.02),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.03,
        vertical: screenWidth * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue.shade200,
          width: 1,
        ),
      ),
      child: Text(
        feature,
        style: TextStyle(
          fontSize: screenWidth * 0.035,
          fontWeight: FontWeight.w500,
          color: Colors.blue.shade700,
        ),
      ),
    );
  }
}

class ImagePlaceHolder extends StatefulWidget {
  final List<String> imageUrls;

  const ImagePlaceHolder({super.key, required this.imageUrls});

  @override
  State<ImagePlaceHolder> createState() => _ImagePlaceHolderState();
}

class _ImagePlaceHolderState extends State<ImagePlaceHolder> {
  int _currentIndex = 0;
  late List<String> _images;

  @override
  void initState() {
    super.initState();

    // Set up images
    _images = List<String>.from(widget.imageUrls);
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      if (_images.isEmpty) {
        _currentIndex = 0;
      } else {
        _currentIndex = _currentIndex.clamp(0, _images.length - 1);
      }
    });
  }

  Widget _buildImageWidget(String imagePath) {

    // Check if it's a URL or local file path
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Icon(Icons.error, color: Colors.red),
          );
        },
      );
    } else {
      // Handle local file path
      String cleanPath = imagePath;
      // Remove file:// prefix if present
      if (cleanPath.startsWith('file://')) {
        cleanPath = cleanPath.substring(7);
      }

      return Image.file(
        File(cleanPath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Icon(Icons.error, color: Colors.red),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_images.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.width * 0.75,
        color: Colors.grey[300],
        alignment: Alignment.center,
        child: Text('no_images_selected'.tr),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = width * 0.75; // Taller than 16:9 (75% of width)

        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              PageView.builder(
                itemCount: _images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  if (index >= _images.length) {
                    return Container(
                      width: width,
                      height: height,
                      color: Colors.grey[300],
                      child: Center(child: Text('image_not_found'.tr)),
                    );
                  }

                  return Stack(
                    children: [
                      SizedBox(
                        width: width,
                        height: height,
                        child: _buildImageWidget(_images[index]),
                      ),
                      // ❌ Remove Button
                      Positioned(
                        top: height * 0.15,
                        right: width * 0.08,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(width * 0.015),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: width * 0.05,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              // Dot indicator
              Positioned(
                bottom: height * 0.02,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_images.length, (index) {
                    bool isActive =
                        _currentIndex == index && index < _images.length;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: EdgeInsets.symmetric(horizontal: width * 0.01),
                      width: isActive ? width * 0.03 : width * 0.02,
                      height: isActive ? width * 0.03 : width * 0.02,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.white : Colors.white54,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
