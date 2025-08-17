import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/widgets/build_input_with_options/build_input_with_options.dart';
import 'package:samsar/widgets/build_input/build_input.dart';

class VillaAdvancedDetails extends StatefulWidget {
  const VillaAdvancedDetails({super.key});

  @override
  State<VillaAdvancedDetails> createState() => _VillaAdvancedDetailsState();
}

class _VillaAdvancedDetailsState extends State<VillaAdvancedDetails> {
  // Get the ListingInputController instance
  late final ListingInputController _listingInputController;
  
  // Controllers for villa-specific fields
  final TextEditingController floorController = TextEditingController();
  final TextEditingController parkingController = TextEditingController();
  final TextEditingController poolController = TextEditingController();
  final TextEditingController balconyController = TextEditingController();
  final TextEditingController furnishingController = TextEditingController();
  final TextEditingController heatingController = TextEditingController();
  final TextEditingController coolingController = TextEditingController();
  final TextEditingController securityController = TextEditingController();
  final TextEditingController viewController = TextEditingController();
  final TextEditingController orientationController = TextEditingController();
  final TextEditingController buildingAgeController = TextEditingController();
  final TextEditingController maintenanceFeeController = TextEditingController();
  final TextEditingController energyRatingController = TextEditingController();

  // Dropdown options
  final List<String> furnishingTypes = [
    'Fully Furnished',
    'Semi Furnished',
    'Unfurnished'
  ];

  final List<String> heatingTypes = [
    'Central Heating',
    'Individual Heating',
    'Fireplace',
    'Electric Heating',
    'Gas Heating',
    'None'
  ];

  final List<String> coolingTypes = [
    'Central AC',
    'Split AC',
    'Window AC',
    'Ceiling Fans',
    'None'
  ];

  final List<String> securityTypes = [
    'Gated Community',
    'Security Guard',
    'CCTV',
    'Alarm System',
    'None'
  ];

  final List<String> viewTypes = [
    'Sea View',
    'Mountain View',
    'City View',
    'Garden View',
    'Street View'
  ];

  final List<String> orientationTypes = [
    'North',
    'South',
    'East',
    'West',
    'North-East',
    'North-West',
    'South-East',
    'South-West'
  ];

  final List<String> energyRatings = [
    'A++',
    'A+',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G'
  ];

  @override
  void initState() {
    super.initState();
    // Ensure controller is registered before accessing it
    if (Get.isRegistered<ListingInputController>()) {
      _listingInputController = Get.find<ListingInputController>();
    } else {
      _listingInputController = Get.put(ListingInputController());
    }
    
    // Initialize controllers with existing data
    floorController.text = _listingInputController.floor.value.toString();
    parkingController.text = _listingInputController.parking.value;
    poolController.text = _listingInputController.pool.value;
    balconyController.text = _listingInputController.balcony.value.toString();
    furnishingController.text = _listingInputController.furnishing.value;
    heatingController.text = _listingInputController.heating.value;
    coolingController.text = _listingInputController.cooling.value;
    securityController.text = _listingInputController.security.value;
    viewController.text = _listingInputController.view.value;
    orientationController.text = _listingInputController.orientation.value;
    buildingAgeController.text = _listingInputController.buildingAge.value.toString();
    maintenanceFeeController.text = _listingInputController.maintenanceFee.value;
    energyRatingController.text = _listingInputController.energyRating.value;

    // Add listeners to update the main controller when text changes
    floorController.addListener(() {
      _listingInputController.floor.value = int.tryParse(floorController.text) ?? 0;
    });
    parkingController.addListener(() {
      _listingInputController.parking.value = parkingController.text;
    });
    poolController.addListener(() {
      _listingInputController.pool.value = poolController.text;
    });
    balconyController.addListener(() {
      _listingInputController.balcony.value = int.tryParse(balconyController.text) ?? 0;
    });
    furnishingController.addListener(() {
      _listingInputController.furnishing.value = furnishingController.text;
    });
    heatingController.addListener(() {
      _listingInputController.heating.value = heatingController.text;
    });
    coolingController.addListener(() {
      _listingInputController.cooling.value = coolingController.text;
    });
    securityController.addListener(() {
      _listingInputController.security.value = securityController.text;
    });
    viewController.addListener(() {
      _listingInputController.view.value = viewController.text;
    });
    orientationController.addListener(() {
      _listingInputController.orientation.value = orientationController.text;
    });
    buildingAgeController.addListener(() {
      _listingInputController.buildingAge.value = int.tryParse(buildingAgeController.text) ?? 0;
    });
    maintenanceFeeController.addListener(() {
      _listingInputController.maintenanceFee.value = maintenanceFeeController.text;
    });
    energyRatingController.addListener(() {
      _listingInputController.energyRating.value = energyRatingController.text;
    });
  }

  @override
  void dispose() {
    // Dispose all controllers
    floorController.dispose();
    parkingController.dispose();
    poolController.dispose();
    balconyController.dispose();
    furnishingController.dispose();
    heatingController.dispose();
    coolingController.dispose();
    securityController.dispose();
    viewController.dispose();
    orientationController.dispose();
    buildingAgeController.dispose();
    maintenanceFeeController.dispose();
    energyRatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MOST ESSENTIAL - Villa Basics (Syrian luxury buyers check first)
          Text(
            'villa_essentials'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),

          // 1. Parking Spaces - CRITICAL for Syrian villas (multiple cars)
          BuildInput(
            title: 'parking_spaces'.tr,
            label: 'enter_parking_spaces'.tr,
            textController: parkingController,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 16),

          // 2. Pool - HIGH priority for Syrian villa buyers
          BuildInput(
            title: 'pool'.tr,
            label: 'enter_pool_details'.tr,
            textController: poolController,
          ),

          const SizedBox(height: 16),

          // 3. Furnishing - Important for rental/purchase decisions
          BuildInputWithOptions(
            title: 'furnishing'.tr,
            controller: furnishingController,
            options: furnishingTypes,
          ),

          const SizedBox(height: 24),

          // HIGH PRIORITY - Location & Views (Important for Syrian villa market)
          Text(
            'location_views'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),

          // 4. View Type - Very important for Syrian villa buyers
          BuildInputWithOptions(
            title: 'view'.tr,
            controller: viewController,
            options: viewTypes,
          ),

          const SizedBox(height: 16),

          // 5. Orientation - Important for sunlight/heat management in Syria
          BuildInputWithOptions(
            title: 'orientation'.tr,
            controller: orientationController,
            options: orientationTypes,
          ),

          const SizedBox(height: 24),

          // MEDIUM PRIORITY - Building Information
          Text(
            'building_information'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),

          // 6. Building Age - Moderate importance for villa quality
          BuildInput(
            title: 'building_age'.tr,
            label: 'enter_building_age_years'.tr,
            textController: buildingAgeController,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 24),

          // LOWER PRIORITY - Technical Details
          Text(
            'technical_details'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),

          // 7. Energy Rating - Least important for Syrian market
          BuildInputWithOptions(
            title: 'energy_rating'.tr,
            controller: energyRatingController,
            options: energyRatings,
          ),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? subDarkColor.withOpacity(0.3) : Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Get.isDarkMode ? Colors.green[800]! : Colors.green[200]!),
            ),
            child: Column(
              children: [
                Icon(Icons.villa, color: Colors.green, size: 24),
                const SizedBox(height: 8),
                Text(
                  'villa_specifications'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'villa_specifications_info'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Get.isDarkMode ? greyColor : Colors.green[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
