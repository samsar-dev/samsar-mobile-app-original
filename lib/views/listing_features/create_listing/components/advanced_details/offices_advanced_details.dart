import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/widgets/build_input_with_options/build_input_with_options.dart';
import 'package:samsar/widgets/build_input/build_input.dart';

class OfficesAdvancedDetails extends StatefulWidget {
  const OfficesAdvancedDetails({super.key});

  @override
  State<OfficesAdvancedDetails> createState() => _OfficesAdvancedDetailsState();
}

class _OfficesAdvancedDetailsState extends State<OfficesAdvancedDetails> {
  late final ListingInputController _listingInputController;

  final TextEditingController officeTypeController = TextEditingController();
  final TextEditingController furnishingController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController parkingController = TextEditingController();
  final TextEditingController meetingRoomsController = TextEditingController();

  final List<String> officeTypes = ['Shared', 'Private', 'Coworking'];
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

  @override
  void initState() {
    super.initState();
    // Ensure controller is registered before accessing it
    if (Get.isRegistered<ListingInputController>()) {
      _listingInputController = Get.find<ListingInputController>();
    } else {
      _listingInputController = Get.put(ListingInputController());
    }

    officeTypeController.text = _listingInputController.officeType.value;
    furnishingController.text = _listingInputController.furnishing.value;
    floorController.text = _listingInputController.floor.value.toString();
    parkingController.text = _listingInputController.parking.value;
    meetingRoomsController.text = _listingInputController.meetingRooms.value.toString();

    officeTypeController.addListener(() {
      _listingInputController.officeType.value = officeTypeController.text;
    });
    furnishingController.addListener(() {
      _listingInputController.furnishing.value = furnishingController.text;
    });
    floorController.addListener(() {
      _listingInputController.floor.value = int.tryParse(floorController.text) ?? 0;
    });
    parkingController.addListener(() {
      _listingInputController.parking.value = parkingController.text;
    });
    meetingRoomsController.addListener(() {
      _listingInputController.meetingRooms.value = int.tryParse(meetingRoomsController.text) ?? 0;
    });
  }

  @override
  void dispose() {
    officeTypeController.dispose();
    furnishingController.dispose();
    floorController.dispose();
    parkingController.dispose();
    meetingRoomsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MOST ESSENTIAL - Office Basics (Syrian businesses check first)
          Text(
            'office_essentials'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),

          // 1. Office Type - CRITICAL for Syrian business needs
          BuildInputWithOptions(
            title: 'Office Type',
            controller: officeTypeController,
            options: officeTypes,
          ),

          const SizedBox(height: 16),
          
          // 2. Parking - ESSENTIAL for Syrian commercial areas
          BuildInputWithOptions(
            title: 'Parking',
            controller: parkingController,
            options: parkingOptions,
          ),
          const SizedBox(height: 16),
          
          // 3. Floor Number - Important for accessibility and prestige
          BuildInput(
            title: 'Floor Number',
            label: 'Which floor is the office on?',
            textController: floorController,
            keyboardType: TextInputType.number,
          ),
          
          const SizedBox(height: 24),

          // HIGH PRIORITY - Office Features
          Text(
            'office_features'.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          
          // 4. Furnishing - HIGH priority for Syrian businesses
          BuildInputWithOptions(
            title: 'Furnishing',
            controller: furnishingController,
            options: furnishingTypes,
          ),
          const SizedBox(height: 16),
          
          // 5. Meeting Rooms - Important for business operations
          BuildInput(
            title: 'Meeting Rooms',
            label: 'Number of meeting rooms',
            textController: meetingRoomsController,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
