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
final TextEditingController frontageController = TextEditingController();
// Optional
final TextEditingController zoningController = TextEditingController();
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
    'Other',
  ];

  final List<String> securitySystems = [
    'CCTV',
    'Alarm System',
    'Security Guard',
    'Access Control',
    'Fire Safety',
    'None',
  ];

  final List<String> hvacTypes = [
    'Central AC',
    'Split AC',
    'Ducted AC',
    'Ventilation Only',
    'None',
  ];

  final List<String> lightingTypes = [
    'LED Lighting',
    'Fluorescent',
    'Natural Light',
    'Mixed Lighting',
    'Basic Lighting',
  ];

  final List<String> accessibilityFeatures = [
    'Wheelchair Accessible',
    'Elevator Access',
    'Ramp Access',
    'Wide Doorways',
    'Accessible Restrooms',
    'None',
  ];

  final List<String> zoningTypes = [
    'Commercial',
    'Mixed Use',
    'Retail',
    'Industrial',
    'Other',
  ];

  final List<String> footTrafficLevels = [
    'Very High',
    'High',
    'Medium',
    'Low',
    'Very Low',
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
    frontageController.text = _listingInputController.frontage.value;
    
    // securitySystemController.text = '';
    zoningController.text = _listingInputController.zoning.value;
    footTrafficController.text = _listingInputController.footTraffic.value;

    // Add listeners to update the main controller when text changes
    storeTypeController.addListener(() {
      _listingInputController.storeType.value = storeTypeController.text;
    });
    floorAreaController.addListener(() {
      _listingInputController.floorArea.value = floorAreaController.text;
    });
    frontageController.addListener(() {
      _listingInputController.frontage.value = frontageController.text;
    });
     
    // Security system listener removed
    zoningController.addListener(() {
      _listingInputController.zoning.value = zoningController.text;
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
    frontageController.dispose();
    zoningController.dispose();
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

         

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? subDarkColor.withOpacity(0.3)
                  : Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Get.isDarkMode
                    ? Colors.orange[800]!
                    : Colors.orange[200]!,
              ),
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
