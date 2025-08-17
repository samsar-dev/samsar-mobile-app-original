import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/widgets/build_input_with_options/build_input_with_options.dart';
import 'package:samsar/widgets/build_input/build_input.dart';

class ApartmentsAdvancedDetails extends StatefulWidget {
  const ApartmentsAdvancedDetails({super.key});

  @override
  State<ApartmentsAdvancedDetails> createState() =>
      _ApartmentsAdvancedDetailsState();
}

class _ApartmentsAdvancedDetailsState extends State<ApartmentsAdvancedDetails> {
  late final ListingInputController _listingInputController;


  final TextEditingController furnishingController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController totalFloorsController = TextEditingController();
  final TextEditingController parkingController = TextEditingController();
  final TextEditingController yearBuiltController = TextEditingController();
  final TextEditingController facingController = TextEditingController();
  final TextEditingController balconiesController = TextEditingController();

  final List<String> furnishingTypes = [
    'Fully Furnished',
    'Semi Furnished',
    'Unfurnished'
  ];
  final List<String> facingOptions = [
    'North',
    'South',
    'East',
    'West',
    'North-East',
    'North-West',
    'South-East',
    'South-West'
  ];
  final List<String> parkingOptions = [
    'No Parking',
    '1 Car',
    '2 Cars',
    '3+ Cars',
    'Covered Parking',
    'Open Parking'
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


    furnishingController.text = _listingInputController.furnishing.value;
    floorController.text = _listingInputController.floor.value.toString();
    totalFloorsController.text = _listingInputController.totalFloors.value.toString();
    parkingController.text = _listingInputController.parking.value;
    yearBuiltController.text = _listingInputController.yearBuilt.value.toString();
    facingController.text = _listingInputController.facing.value;
    balconiesController.text = _listingInputController.balconies.value.toString();


    furnishingController.addListener(() {
      _listingInputController.furnishing.value = furnishingController.text;
    });
    floorController.addListener(() {
      _listingInputController.floor.value = int.tryParse(floorController.text) ?? 0;
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
    facingController.addListener(() {
      _listingInputController.facing.value = facingController.text;
    });
    balconiesController.addListener(() {
      _listingInputController.balconies.value = int.tryParse(balconiesController.text) ?? 0;
    });
  }

  @override
  void dispose() {

    furnishingController.dispose();
    floorController.dispose();
    totalFloorsController.dispose();
    parkingController.dispose();
    yearBuiltController.dispose();
    facingController.dispose();
    balconiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MOST ESSENTIAL - Basic Apartment Info (Syrian renters/buyers check first)
          Text(
            'apartment_essentials'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),

          // 1. Floor Number - CRITICAL for Syrian market (elevator concerns, views)
          BuildInput(
            title: 'Floor Number',
            label: 'Which floor is the property on?',
            textController: floorController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          
          // 2. Total Floors - Important context for floor number
          BuildInput(
            title: 'Total Floors',
            label: 'Total floors in the building',
            textController: totalFloorsController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          
          // 3. Parking - ESSENTIAL in Syrian cities (limited parking)
          BuildInputWithOptions(
            title: 'Parking',
            controller: parkingController,
            options: parkingOptions,
          ),
          const SizedBox(height: 16),
          
          // 4. Furnishing - HIGH priority for Syrian renters
          BuildInputWithOptions(
            title: 'Furnishing',
            controller: furnishingController,
            options: furnishingTypes,
          ),
          
          const SizedBox(height: 24),

          // HIGH PRIORITY - Location & Orientation
          Text(
            'location_details'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          
          // 5. Facing Direction - Important for sunlight/heat in Syria
          BuildInputWithOptions(
            title: 'Facing Direction',
            controller: facingController,
            options: facingOptions,
          ),
          const SizedBox(height: 16),
          
          // 6. Number of Balconies - Important for Syrian lifestyle
          BuildInput(
            title: 'Number of Balconies',
            label: 'How many balconies?',
            textController: balconiesController,
            keyboardType: TextInputType.number,
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
          
          // 7. Year Built - Moderate importance for building quality
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
