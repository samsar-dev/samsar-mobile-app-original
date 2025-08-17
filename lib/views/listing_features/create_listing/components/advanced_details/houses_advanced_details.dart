import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/widgets/build_input_with_options/build_input_with_options.dart';
import 'package:samsar/widgets/build_input/build_input.dart';

class HousesAdvancedDetails extends StatefulWidget {
  const HousesAdvancedDetails({super.key});

  @override
  State<HousesAdvancedDetails> createState() => _HousesAdvancedDetailsState();
}

class _HousesAdvancedDetailsState extends State<HousesAdvancedDetails> {
  late final ListingInputController _listingInputController;


  final TextEditingController furnishingController = TextEditingController();
  final TextEditingController totalFloorsController = TextEditingController();
  final TextEditingController parkingController = TextEditingController();
  final TextEditingController yearBuiltController = TextEditingController();
  final TextEditingController gardenController = TextEditingController();
  final TextEditingController poolController = TextEditingController();

  final List<String> furnishingTypes = [
    'Fully Furnished',
    'Semi Furnished',
    'Unfurnished'
  ];
  final List<String> parkingOptions = [
    'No Parking',
    '1 Car',
    '2 Cars',
    '3+ Cars',
    'Covered Parking',
    'Open Parking'
  ];
  final List<String> gardenOptions = ['Yes', 'No'];
  final List<String> poolOptions = ['Yes', 'No'];

  @override
  void initState() {
    super.initState();
    // Ensure controller is registered before accessing it
    if (Get.isRegistered<ListingInputController>()) {
      _listingInputController = Get.find<ListingInputController>();
    } else {
      _listingInputController = Get.put(ListingInputController());
    }


    furnishingController.text = _listingInputController.furnishing.value;
    totalFloorsController.text = _listingInputController.totalFloors.value.toString();
    parkingController.text = _listingInputController.parking.value;
    yearBuiltController.text = _listingInputController.yearBuilt.value.toString();
    gardenController.text = _listingInputController.garden.value;
    poolController.text = _listingInputController.pool.value;


    furnishingController.addListener(() {
      _listingInputController.furnishing.value = furnishingController.text;
    });
    totalFloorsController.addListener(() {
      _listingInputController.totalFloors.value = int.tryParse(totalFloorsController.text) ?? 0;
    });
    parkingController.addListener(() {
      _listingInputController.parking.value = parkingController.text;
    });
    yearBuiltController.addListener(() {
      _listingInputController.yearBuilt.value = int.tryParse(yearBuiltController.text) ?? 0;
    });
    gardenController.addListener(() {
      _listingInputController.garden.value = gardenController.text;
    });
    poolController.addListener(() {
      _listingInputController.pool.value = poolController.text;
    });
  }

  @override
  void dispose() {

    furnishingController.dispose();
    totalFloorsController.dispose();
    parkingController.dispose();
    yearBuiltController.dispose();
    gardenController.dispose();
    poolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MOST ESSENTIAL - House Basics (Syrian families check first)
          Text(
            'house_essentials'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),

          // 1. Parking - CRITICAL for Syrian houses (car security)
          BuildInputWithOptions(
            title: 'Parking',
            controller: parkingController,
            options: parkingOptions,
          ),
          const SizedBox(height: 16),
          
          // 2. Total Floors - Important for family size planning
          BuildInput(
            title: 'Total Floors',
            label: 'Total floors in the building',
            textController: totalFloorsController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          
          // 3. Furnishing - HIGH priority for Syrian renters
          BuildInputWithOptions(
            title: 'Furnishing',
            controller: furnishingController,
            options: furnishingTypes,
          ),
          
          const SizedBox(height: 24),

          // HIGH PRIORITY - Outdoor Features (Important for Syrian lifestyle)
          Text(
            'outdoor_features'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          
          // 4. Garden - Very important for Syrian families
          BuildInputWithOptions(
            title: 'Garden',
            controller: gardenController,
            options: gardenOptions,
          ),
          const SizedBox(height: 16),
          
          // 5. Pool - Desirable but not essential
          BuildInputWithOptions(
            title: 'Pool',
            controller: poolController,
            options: poolOptions,
          ),
          
          const SizedBox(height: 24),

          // LOWER PRIORITY - Building Information
          Text(
            'building_info'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          
          // 6. Year Built - Moderate importance for building quality
          BuildInput(
            title: 'Year Built',
            label: 'Year the property was built',
            textController: yearBuiltController,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
