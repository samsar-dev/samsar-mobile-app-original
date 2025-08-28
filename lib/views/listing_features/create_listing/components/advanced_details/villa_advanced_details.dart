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
  final TextEditingController balconyController = TextEditingController();
  final TextEditingController furnishingController = TextEditingController();
  final TextEditingController heatingController = TextEditingController();
  final TextEditingController coolingController = TextEditingController();
  final TextEditingController securityController = TextEditingController();
  final TextEditingController viewController = TextEditingController();
  final TextEditingController orientationController = TextEditingController();
  final TextEditingController yearBuiltController = TextEditingController();
  



  // Dropdown options
  final List<String> furnishingTypes = [
    'Fully Furnished',
    'Semi Furnished',
    'Unfurnished',
  ];

  final List<String> heatingTypes = [
    'Central Heating',
    'Individual Heating',
    'Fireplace',
    'Electric Heating',
    'Gas Heating',
    'None',
  ];

  final List<String> coolingTypes = [
    'Central AC',
    'Split AC',
    'Window AC',
    'Ceiling Fans',
    'None',
  ];

  final List<String> securityTypes = [
    'Gated Community',
    'Security Guard',
    'CCTV',
    'Alarm System',
    'None',
  ];

  final List<String> viewTypes = [
    'Sea View',
    'Mountain View',
    'City View',
    'Garden View',
    'Street View',
  ];

  final List<String> orientationTypes = [
    'North',
    'South',
    'East',
    'West',
    'North-East',
    'North-West',
    'South-East',
    'South-West',
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
    'G',
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
    balconyController.text = _listingInputController.balcony.value > 0
        ? _listingInputController.balcony.value.toString()
        : '';
    furnishingController.text = _listingInputController.furnishing.value;
    heatingController.text = _listingInputController.heating.value;
    coolingController.text = _listingInputController.cooling.value;
    viewController.text = _listingInputController.view.value;
    orientationController.text = _listingInputController.orientation.value;
    yearBuiltController.text = _listingInputController.yearBuilt.value > 0
        ? _listingInputController.yearBuilt.value.toString()
        : '';

    balconyController.addListener(() {
      _listingInputController.balcony.value =
          int.tryParse(balconyController.text) ?? 0;
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
    yearBuiltController.addListener(() {
      _listingInputController.yearBuilt.value =
          int.tryParse(yearBuiltController.text) ?? 0;
    });
  }

  @override
  void dispose() {
    // Dispose all controllers
    balconyController.dispose();
    furnishingController.dispose();
    heatingController.dispose();
    coolingController.dispose();
    securityController.dispose();
    viewController.dispose();
    orientationController.dispose();
    yearBuiltController.dispose();
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

          // 6. Year Built - Moderate importance for villa quality
          BuildInput(
            title: 'Year Built',
            label: 'Year the property was built',
            textController: yearBuiltController,
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

    

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? subDarkColor.withOpacity(0.3)
                  : Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Get.isDarkMode ? Colors.green[800]! : Colors.green[200]!,
              ),
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
