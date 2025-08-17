import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/widgets/build_input_with_options/build_input_with_options.dart';
import 'package:samsar/widgets/build_input/build_input.dart';

class StoreAdvancedDetails extends StatefulWidget {
  const StoreAdvancedDetails({super.key});

  @override
  State<StoreAdvancedDetails> createState() => _StoreAdvancedDetailsState();
}

class _StoreAdvancedDetailsState extends State<StoreAdvancedDetails> {
  // Get the ListingInputController instance
  late final ListingInputController _listingInputController;
  
  // Controllers for store-specific fields
  final TextEditingController storeTypeController = TextEditingController();
  final TextEditingController floorAreaController = TextEditingController();
  final TextEditingController storageAreaController = TextEditingController();
  final TextEditingController frontageController = TextEditingController();
  final TextEditingController ceilingHeightController = TextEditingController();
  final TextEditingController parkingSpacesController = TextEditingController();
  final TextEditingController loadingDockController = TextEditingController();
  final TextEditingController securitySystemController = TextEditingController();
  final TextEditingController hvacController = TextEditingController();
  final TextEditingController lightingController = TextEditingController();
  final TextEditingController accessibilityController = TextEditingController();
  final TextEditingController zoningController = TextEditingController();
  final TextEditingController businessLicenseController = TextEditingController();
  final TextEditingController footTrafficController = TextEditingController();

  // Dropdown options
  final List<String> storeTypes = [
    'Retail Store',
    'Grocery Store',
    'Restaurant',
    'Cafe',
    'Pharmacy',
    'Electronics Store',
    'Clothing Store',
    'Hardware Store',
    'Bookstore',
    'Other'
  ];

  final List<String> securitySystems = [
    'CCTV',
    'Alarm System',
    'Security Guard',
    'Access Control',
    'Fire Safety System',
    'None'
  ];

  final List<String> hvacTypes = [
    'Central AC',
    'Split AC',
    'Ducted AC',
    'Ventilation Only',
    'None'
  ];

  final List<String> lightingTypes = [
    'LED Lighting',
    'Fluorescent',
    'Natural Light',
    'Mixed Lighting',
    'Basic Lighting'
  ];

  final List<String> accessibilityFeatures = [
    'Wheelchair Accessible',
    'Elevator Access',
    'Ramp Access',
    'Wide Doorways',
    'Accessible Restrooms',
    'None'
  ];

  final List<String> zoningTypes = [
    'Commercial',
    'Mixed Use',
    'Retail',
    'Industrial',
    'Other'
  ];

  final List<String> footTrafficLevels = [
    'Very High',
    'High',
    'Medium',
    'Low',
    'Very Low'
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
    storeTypeController.text = _listingInputController.storeType.value;
    floorAreaController.text = _listingInputController.floorArea.value;
    storageAreaController.text = _listingInputController.storageArea.value;
    frontageController.text = _listingInputController.frontage.value;
    ceilingHeightController.text = _listingInputController.ceilingHeight.value;
    parkingSpacesController.text = _listingInputController.parking.value.toString();
    loadingDockController.text = _listingInputController.loadingDock.value;
    securitySystemController.text = _listingInputController.security.value;
    hvacController.text = _listingInputController.hvac.value;
    lightingController.text = _listingInputController.lighting.value;
    accessibilityController.text = _listingInputController.accessibility.value;
    zoningController.text = _listingInputController.zoning.value;
    businessLicenseController.text = _listingInputController.businessLicense.value;
    footTrafficController.text = _listingInputController.footTraffic.value;

    // Add listeners to update the main controller when text changes
    storeTypeController.addListener(() {
      _listingInputController.storeType.value = storeTypeController.text;
    });
    floorAreaController.addListener(() {
      _listingInputController.floorArea.value = floorAreaController.text;
    });
    storageAreaController.addListener(() {
      _listingInputController.storageArea.value = storageAreaController.text;
    });
    frontageController.addListener(() {
      _listingInputController.frontage.value = frontageController.text;
    });
    ceilingHeightController.addListener(() {
      _listingInputController.ceilingHeight.value = ceilingHeightController.text;
    });
    parkingSpacesController.addListener(() {
      _listingInputController.parking.value = parkingSpacesController.text;
    });
    loadingDockController.addListener(() {
      _listingInputController.loadingDock.value = loadingDockController.text;
    });
    securitySystemController.addListener(() {
      _listingInputController.security.value = securitySystemController.text;
    });
    hvacController.addListener(() {
      _listingInputController.hvac.value = hvacController.text;
    });
    lightingController.addListener(() {
      _listingInputController.lighting.value = lightingController.text;
    });
    accessibilityController.addListener(() {
      _listingInputController.accessibility.value = accessibilityController.text;
    });
    zoningController.addListener(() {
      _listingInputController.zoning.value = zoningController.text;
    });
    businessLicenseController.addListener(() {
      _listingInputController.businessLicense.value = businessLicenseController.text;
    });
    footTrafficController.addListener(() {
      _listingInputController.footTraffic.value = footTrafficController.text;
    });
  }

  @override
  void dispose() {
    // Dispose all controllers
    storeTypeController.dispose();
    floorAreaController.dispose();
    storageAreaController.dispose();
    frontageController.dispose();
    ceilingHeightController.dispose();
    parkingSpacesController.dispose();
    loadingDockController.dispose();
    securitySystemController.dispose();
    hvacController.dispose();
    lightingController.dispose();
    accessibilityController.dispose();
    zoningController.dispose();
    businessLicenseController.dispose();
    footTrafficController.dispose();
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
          // MOST ESSENTIAL - Store Basics (Syrian retailers check first)
          Text(
            'store_essentials'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),

          // 1. Store Type - CRITICAL for Syrian commercial market
          BuildInputWithOptions(
            title: 'store_type'.tr,
            controller: storeTypeController,
            options: storeTypes,
          ),

          const SizedBox(height: 16),

          // 2. Floor Area - ESSENTIAL for business planning
          BuildInput(
            title: 'floor_area'.tr,
            label: 'enter_floor_area_sqm'.tr,
            textController: floorAreaController,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 16),

          // 3. Frontage - CRITICAL for Syrian retail (street visibility)
          BuildInput(
            title: 'frontage'.tr,
            label: 'enter_frontage_meters'.tr,
            textController: frontageController,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 16),

          // 4. Parking Spaces - ESSENTIAL for Syrian customers
          BuildInput(
            title: 'parking_spaces'.tr,
            label: 'enter_parking_spaces'.tr,
            textController: parkingSpacesController,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 24),

          // MEDIUM PRIORITY - Physical Features
          Text(
            'physical_features'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),

          // 5. Ceiling Height - Moderate importance for storage/display
          BuildInput(
            title: 'ceiling_height'.tr,
            label: 'enter_ceiling_height_meters'.tr,
            textController: ceilingHeightController,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 24),

     

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? subDarkColor.withOpacity(0.3) : Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Get.isDarkMode ? Colors.orange[800]! : Colors.orange[200]!),
            ),
            child: Column(
              children: [
                Icon(Icons.store, color: Colors.orange, size: 24),
                const SizedBox(height: 8),
                Text(
                  'store_specifications'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'store_specifications_info'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Get.isDarkMode ? greyColor : Colors.orange[700],
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
