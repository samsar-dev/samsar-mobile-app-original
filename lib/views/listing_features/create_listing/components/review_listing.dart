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
  
  const ReviewListing({super.key, this.isVehicle = true, required this.imageUrls});

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
      hex = 'FF' + 
            hex[0] + hex[0] + 
            hex[1] + hex[1] + 
            hex[2] + hex[2];
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
  final TextEditingController energyFeaturesController = TextEditingController();
  final TextEditingController energyRatingController = TextEditingController();

  //structure and layout
  final TextEditingController basementController = TextEditingController();
  final TextEditingController basementFeaturesController = TextEditingController();
  final TextEditingController atticController = TextEditingController();
  final TextEditingController constructionTypeController = TextEditingController();
  final TextEditingController noOfStoriesController = TextEditingController();

  //interior features
  final TextEditingController floortingTypesController = TextEditingController();
  final TextEditingController windowFeaturesController = TextEditingController();
  final TextEditingController kitchenFeaturesController = TextEditingController();
  final TextEditingController bathroomFeaturesController = TextEditingController();
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

  // Validation method to check required fields based on backend API requirements
  bool _validateRequiredFields() {
    List<String> errors = [];
    
    // Debug: Log all current values
    print("=== REVIEW LISTING VALIDATION DEBUG ===");
    print("Title: '${_listingInputController.title.value}' (empty: ${_listingInputController.title.value.isEmpty})");
    print("Description: '${_listingInputController.description.value}' (empty: ${_listingInputController.description.value.isEmpty})");
    print("Price: ${_listingInputController.price.value} (valid: ${_listingInputController.price.value > 0})");
    print("Main Category: '${_listingInputController.mainCategory.value}' (empty: ${_listingInputController.mainCategory.value.isEmpty})");
    print("Sub Category: '${_listingInputController.subCategory.value}' (empty: ${_listingInputController.subCategory.value.isEmpty})");
    print("Location: '${_listingInputController.location.value}' (empty: ${_listingInputController.location.value.isEmpty})");
    print("Latitude: '${_listingInputController.latitude.value}' (empty: ${_listingInputController.latitude.value.isEmpty})");
    print("Longitude: '${_listingInputController.longitude.value}' (empty: ${_listingInputController.longitude.value.isEmpty})");
    print("Make: '${_listingInputController.make.value}' (empty: ${_listingInputController.make.value.isEmpty})");
    print("Model: '${_listingInputController.model.value}' (empty: ${_listingInputController.model.value.isEmpty})");
    print("Year: ${_listingInputController.year.value} (valid: ${_listingInputController.year.value > 1900})");
    print("Images count: ${_listingInputController.listingImage.length} (valid: ${_listingInputController.listingImage.isNotEmpty})");
    print("========================================");
    
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
    
    // Additional Flutter app requirements
    if (_listingInputController.make.value.isEmpty) {
      errors.add("Vehicle make is required");
    }
    
    if (_listingInputController.model.value.isEmpty) {
      errors.add("Vehicle model is required");
    }
    
    if (_listingInputController.year.value <= 1900) {
      errors.add("Valid year is required");
    }
    
    if (_listingInputController.listingImage.isEmpty) {
      errors.add("At least one image is required");
    }
    
    print("Validation errors found: ${errors.length}");
    if (errors.isNotEmpty) {
      print("Missing fields: ${errors.join(', ')}");
    }
    
    if (errors.isNotEmpty) {
      // Show detailed error message with all missing fields
      String errorMessage = "Please fix the following issues:\n\n" + 
                           errors.map((e) => "• $e").join("\n");
      
      Get.dialog(
        AlertDialog(
          title: Text("Validation Error", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Text(errorMessage, style: TextStyle(fontSize: 14)),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("OK", style: TextStyle(color: Colors.blue)),
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
    _listingInputController = Get.find<ListingInputController>();
    
    print('🔍 === REVIEW LISTING INIT DEBUG START ===');
    print('📱 ReviewListing initState() called');
    print('🖼️ Images received from widget: ${widget.imageUrls.length} images');
    print('🚗 isVehicle: ${widget.isVehicle}');
    
    // Debug controller state at review screen entry
    print('📊 Controller state at review screen entry:');
    print('   📝 Title: "${_listingInputController.title.value}"');
    print('   📝 Description: "${_listingInputController.description.value}"');
    print('   💰 Price: ${_listingInputController.price.value}');
    print('   🏷️ Main Category: "${_listingInputController.mainCategory.value}"');
    print('   🏷️ Sub Category: "${_listingInputController.subCategory.value}"');
    print('   📍 Location: "${_listingInputController.location.value}"');
    print('   🚗 Make: "${_listingInputController.make.value}"');
    print('   🚗 Model: "${_listingInputController.model.value}"');
    print('   📅 Year: ${_listingInputController.year.value}');
    print('   🖼️ Controller images: ${_listingInputController.listingImage.length}');
    print('   🔧 Body Type: "${_listingInputController.bodyType.value}"');
    print('   ⛽ Fuel Type: "${_listingInputController.fuelType.value}"');
    print('   🔄 Transmission: "${_listingInputController.transmissionType.value}"');
    
    // Check for data preservation issues
    if (_listingInputController.title.value.isEmpty) {
      print('⚠️ WARNING: Title is empty in review screen!');
    }
    if (_listingInputController.price.value == 0) {
      print('⚠️ WARNING: Price is 0 in review screen!');
    }
    if (_listingInputController.listingImage.isEmpty) {
      print('⚠️ WARNING: No images in controller at review screen!');
    }
    
    // Check for advanced details preservation
    if (_listingInputController.bodyType.value.isEmpty && 
        _listingInputController.fuelType.value.isEmpty && 
        _listingInputController.transmissionType.value.isEmpty) {
      print('⚠️ WARNING: All advanced details are empty! Advanced details may not be saving.');
    }
    
    print('🔍 === REVIEW LISTING INIT DEBUG END ===');
  }

  @override
  Widget build(BuildContext context) {
    print('ReviewListing: imageUrls = ${widget.imageUrls}'); // Debug print
    print('ReviewListing: _listingInputController.listingImage = ${_listingInputController.listingImage}'); // Debug print

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(

      backgroundColor: whiteColor,

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [

              AnimatedInputWrapper(
                delayMilliseconds: 0,
                child: ImagePlaceHolder(imageUrls: widget.imageUrls)
              ),

              SizedBox(height: screenHeight * 0.01),

              Obx(
                () {
                  return AnimatedInputWrapper(
                    delayMilliseconds: 100,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.02),
                        child: Text(
                          _listingInputController.title.value,
                          style: TextStyle(
                            color: blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.055,
                          ),
                        ),
                      ),
                    ),
                  );
                }
              ),

              SizedBox(height: screenHeight * 0.02),


              widget.isVehicle ? 
              vehicleWidget(screenHeight, screenWidth) :
              realEstateWidget(screenHeight, screenWidth),

             

               SizedBox(height: screenHeight * 0.008,),

                AppButton(
                  widthSize: 0.65, 
                  heightSize: 0.07, 
                  buttonColor: blueColor,
                  text: "Create", 
                  textColor: whiteColor,
                  onPressed: () {
                    if (widget.isVehicle) {
                      // Validate required fields before submission
                      if (_validateRequiredFields()) {
                        print("=== VALIDATION PASSED ===");
                        print("All required fields are valid, proceeding with submission...");
                        
                        // Use the createCarModel method which includes all features and extras
                        final carModel = _listingInputController.createVehicleModel();
                        print("Car model created successfully: $carModel");
                        
                        // Lazy initialization of controller only when needed for submission
                        _createListingController ??= Get.put(CreateListingController());
                        _createListingController!.createCarListingController(carModel);
                      } else {
                        print("=== VALIDATION FAILED ===");
                        print("Submission blocked due to validation errors");
                      }
                    }
                  },
                ),

              SizedBox(height: screenHeight * 0.05,),
            ],
          ),
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
        )
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
        Container(
          height: 1,
          color: Colors.grey.shade300,
        ),
        const SizedBox(height: 10),

        // Dynamic rows
        ...data.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.label_important_outline,
                    size: 18, color: Colors.grey.shade600),
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
                                border: Border.all(color: Colors.grey.shade400, width: 1),
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
                        Text(
                          item['value']!.isNotEmpty ? item['value']! : "N/A",
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: screenWidth * 0.038,
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
                      {"label": 'make'.tr, "value": _listingInputController.make.value},
                      {"label": 'model'.tr, "value": _listingInputController.model.value},
                      {"label": 'year'.tr, "value": _listingInputController.year.value.toString()},
                      {"label": 'price'.tr, "value": _listingInputController.price.value.toString()},
                      {
                        "label": 'location'.tr,
                        "value": _listingInputController.location.value
                      },
                      {
                        "label": 'description'.tr,
                        "value": _listingInputController.description.value
                      },
                      if (_listingInputController.sellerType.value.isNotEmpty)
                        {
                          "label": 'seller_type'.tr,
                          "value": _listingInputController.sellerType.value
                        },
                    ]),
              ),
              SizedBox(
                height: screenHeight * 0.003,
              ),
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
                          "value": '${_listingInputController.horsepower.value} HP'
                        },
                      if (_listingInputController.mileage.value.isNotEmpty &&
                          int.parse(_listingInputController.mileage.value) > 0)
                        {
                          "label": 'mileage'.tr,
                          "value": '${_listingInputController.mileage.value} km'
                        },
                    ]),
              ),
              SizedBox(
                height: screenHeight * 0.003,
              ),
              AnimatedInputWrapper(
                delayMilliseconds: 350,
                child: infoCard(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    title: 'vehicle_specifications'.tr,
                    data: [
                      {
                        "label": 'body_type'.tr,
                        "value": _listingInputController.bodyType.value
                      },
                      if (_listingInputController.driveType.value.isNotEmpty &&
                          _listingInputController.driveType.value != 'N/A')
                        {
                          "label": 'drivetrain'.tr,
                          "value": _listingInputController.driveType.value
                        },
                      {
                        "label": 'fuel_type'.tr,
                        "value": _listingInputController.fuelType.value
                      },
                      {
                        "label": 'transmission'.tr,
                        "value": _listingInputController.transmissionType.value
                      },
                      if (_listingInputController.payloadCapacity.value.isNotEmpty)
                        {
                          "label": 'payload_capacity'.tr,
                          "value": '${_listingInputController.payloadCapacity.value} kg'
                        },
                      if (_listingInputController.towingCapacity.value.isNotEmpty)
                        {
                          "label": 'towing_capacity'.tr,
                          "value": '${_listingInputController.towingCapacity.value} kg'
                        },
                      // Motorcycle fields
                      if (_listingInputController.horsepower.value > 0)
                        {
                          "label": 'horsepower'.tr,
                          "value": '${_listingInputController.horsepower.value} HP'
                        },
                      if (_listingInputController.condition.value.isNotEmpty)
                        {
                          "label": 'condition'.tr,
                          "value": _listingInputController.condition.value.tr
                        },
                      if (_listingInputController.previousOwners.value > 0)
                        {
                          "label": 'previous_owners'.tr,
                          "value": _listingInputController.previousOwners.value.toString()
                        },
                      if (_listingInputController.warranty.value.isNotEmpty)
                        {
                          "label": 'warranty'.tr,
                          "value": _listingInputController.warranty.value.tr
                        },
                      if (_listingInputController.accidental.value.isNotEmpty)
                        {
                          "label": 'accidental'.tr,
                          "value": _listingInputController.accidental.value.tr
                        },
                      if (_listingInputController.serviceHistory.value.isNotEmpty)
                        {
                          "label": 'service_history'.tr,
                          "value": _listingInputController.serviceHistory.value.tr
                        },
                    ]),
              ),
              SizedBox(
                height: screenHeight * 0.003,
              ),
              // Passenger Vehicle Details
              if (_listingInputController.subCategory.value.toUpperCase() == 'PASSENGERS' &&
                  (_listingInputController.seatingCapacity.value.isNotEmpty ||
                      _listingInputController.doors.value.isNotEmpty ||
                      _listingInputController.airConditioning.value.isNotEmpty ||
                      _listingInputController.entertainmentSystem.value.isNotEmpty))
                AnimatedInputWrapper(
                  delayMilliseconds: 400,
                  child: infoCard(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      title: 'passenger_vehicle_details'.tr,
                      data: [
                        if (_listingInputController.seatingCapacity.value.isNotEmpty)
                          {
                            "label": 'seating_capacity'.tr,
                            "value": _listingInputController.seatingCapacity.value
                          },
                        if (_listingInputController.doors.value.isNotEmpty)
                          {
                            "label": 'doors'.tr,
                            "value": _listingInputController.doors.value
                          },
                        if (_listingInputController.airConditioning.value.isNotEmpty)
                          {
                            "label": 'air_conditioning'.tr,
                            "value": _listingInputController.airConditioning.value.tr
                          },
                        if (_listingInputController.entertainmentSystem.value.isNotEmpty)
                          {
                            "label": 'entertainment_system'.tr,
                            "value": _listingInputController.entertainmentSystem.value.tr
                          },
                      ]),
                ),

              // Commercial Vehicle Details
              if (_listingInputController.subCategory.value.toUpperCase() == 'COMMERCIALS' &&
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
                            "value": '${_listingInputController.cargoVolume.value} m³'
                          },
                        if (_listingInputController.axles.value.isNotEmpty)
                          {
                            "label": 'axles'.tr,
                            "value": _listingInputController.axles.value
                          },
                        if (_listingInputController.gvwr.value.isNotEmpty)
                          {
                            "label": 'gvwr'.tr,
                            "value": '${_listingInputController.gvwr.value} kg'
                          },
                      ]),
                ),

              // Construction Vehicle Details
              if (_listingInputController.subCategory.value.toUpperCase() == 'CONSTRUCTIONS' &&
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
                        if (_listingInputController.operatingWeight.value.isNotEmpty)
                          {
                            "label": 'operating_weight'.tr,
                            "value": '${_listingInputController.operatingWeight.value} kg'
                          },
                        if (_listingInputController.bucketCapacity.value.isNotEmpty)
                          {
                            "label": 'bucket_capacity'.tr,
                            "value": '${_listingInputController.bucketCapacity.value} m³'
                          },
                        if (_listingInputController.liftingCapacity.value.isNotEmpty)
                          {
                            "label": 'lifting_capacity'.tr,
                            "value": '${_listingInputController.liftingCapacity.value} kg'
                          },
                        if (_listingInputController.reach.value.isNotEmpty)
                          {
                            "label": 'reach'.tr,
                            "value": '${_listingInputController.reach.value} m'
                          },
                        if (_listingInputController.workingHours.value.isNotEmpty)
                          {
                            "label": 'working_hours'.tr,
                            "value": '${_listingInputController.workingHours.value} hours'
                          },
                      ]),
                ),
              SizedBox(
                height: screenHeight * 0.003,
              ),
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
                          "value": _listingInputController.importStatus.value
                        },
                      if (_listingInputController.registrationExpiry.value.isNotEmpty && 
                          _listingInputController.registrationExpiry.value != 'N/A')
                        {
                          "label": 'registration_expiry_date'.tr,
                          "value": _listingInputController.registrationExpiry.value
                        },
                    ],
                  ),
                ),
              SizedBox(
                height: screenHeight * 0.003,
              ),
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
                      "isColor": true
                    },
                  ],
                ),
              ),
            ],
          ));
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
                {"label": "Title".tr, "value": _listingInputController.title.value},
                if (_listingInputController.totalArea.value > 0)
                  {"label": "Total Area".tr, "value": "${_listingInputController.totalArea.value} sqm"},
                if (_listingInputController.yearBuilt.value > 0)
                  {"label": "Year Built".tr, "value": _listingInputController.yearBuilt.value.toString()},
                if (_listingInputController.bedrooms.value > 0)
                  {"label": "Bedrooms".tr, "value": _listingInputController.bedrooms.value.toString()},
                if (_listingInputController.bathrooms.value > 0)
                  {"label": "Bathrooms".tr, "value": _listingInputController.bathrooms.value.toString()},
                {"label": "Price".tr, "value": _listingInputController.price.value.toString()},
                {"label": "Location".tr, "value": _listingInputController.location.value},
                if (_listingInputController.description.value.isNotEmpty)
                  {"label": "Description".tr, "value": _listingInputController.description.value},
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
              _listingInputController.meetingRooms.value > 0 ||
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
                    {"label": "Furnishing".tr, "value": _listingInputController.furnishing.value},
                  if (_listingInputController.floor.value > 0)
                    {"label": "Floor Number".tr, "value": _listingInputController.floor.value.toString()},
                  if (_listingInputController.totalFloors.value > 0)
                    {"label": "Total Floors".tr, "value": _listingInputController.totalFloors.value.toString()},
                  if (_listingInputController.parking.value.isNotEmpty)
                    {"label": "Parking".tr, "value": _listingInputController.parking.value},
                  if (_listingInputController.facing.value.isNotEmpty)
                    {"label": "Facing Direction".tr, "value": _listingInputController.facing.value},
                  if (_listingInputController.balconies.value > 0)
                    {"label": "Balconies".tr, "value": _listingInputController.balconies.value.toString()},
                  if (_listingInputController.plotSize.value > 0)
                    {"label": "Plot Size".tr, "value": "${_listingInputController.plotSize.value} sqm"},
                  if (_listingInputController.garden.value.isNotEmpty)
                    {"label": "Garden".tr, "value": _listingInputController.garden.value},
                  if (_listingInputController.pool.value.isNotEmpty)
                    {"label": "Pool".tr, "value": _listingInputController.pool.value},
                  if (_listingInputController.officeType.value.isNotEmpty)
                    {"label": "Office Type".tr, "value": _listingInputController.officeType.value},
                  if (_listingInputController.meetingRooms.value > 0)
                    {"label": "Meeting Rooms".tr, "value": _listingInputController.meetingRooms.value.toString()},
                  if (_listingInputController.zoning.value.isNotEmpty)
                    {"label": "Zoning".tr, "value": _listingInputController.zoning.value},
                  if (_listingInputController.roadAccess.value.isNotEmpty)
                    {"label": "Road Access".tr, "value": _listingInputController.roadAccess.value},
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
                    {"label": "Condition".tr, "value": _listingInputController.condition.value},
                  // Other interior features not yet implemented in controller
                ],
              ),
            ),

          SizedBox(height: screenHeight * 0.01),

          // Living Space Details - Currently not implemented in controller
          // Will be added when these fields are available in ListingInputController

          SizedBox(height: screenHeight * 0.01),

          // Parking & Roof
          if (_listingInputController.parking.value.isNotEmpty)
            AnimatedInputWrapper(
              delayMilliseconds: 800,
              child: infoCard(
                screenWidth: screenWidth,
                screenHeight: screenHeight,
                title: "Parking & Roof".tr,
                data: [
                  if (_listingInputController.parking.value.isNotEmpty)
                    {"label": "Parking Type".tr, "value": _listingInputController.parking.value},
                  // Roof type and parking spaces not yet implemented in controller
                ],
              ),
            ),
        ],
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
    print('Building image for path: $imagePath'); // Debug print
    
    // Check if it's a URL or local file path
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Network image error: $error');
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
          print('File image error: $error');
          print('Attempted path: $cleanPath');
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
    print('ImagePlaceHolder: _images = $_images'); // Debug print
    
    if (_images.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.width * 0.75,
        color: Colors.grey[300],
        alignment: Alignment.center,
        child: const Text("No images selected."),
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
                      child: const Center(child: Text('Image not found')),
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
                            child: Icon(Icons.close, color: Colors.white, size: width * 0.05),
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
                    bool isActive = _currentIndex == index && index < _images.length;
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
