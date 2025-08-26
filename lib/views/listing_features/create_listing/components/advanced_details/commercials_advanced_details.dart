import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/widgets/build_input_with_options/build_input_with_options.dart';
import 'package:samsar/widgets/build_input/build_input.dart';

class CommercialsAdvancedDetails extends StatefulWidget {
  const CommercialsAdvancedDetails({super.key});

  @override
  State<CommercialsAdvancedDetails> createState() =>
      _CommercialsAdvancedDetailsState();
}

class _CommercialsAdvancedDetailsState
    extends State<CommercialsAdvancedDetails> {
  // Get the ListingInputController instance
  late final ListingInputController _listingInputController;

  // Controllers for commercial vehicle-specific fields
  final TextEditingController bodyTypeController = TextEditingController();
  final TextEditingController driveTypeController = TextEditingController();
  final TextEditingController fuelTypeController = TextEditingController();
  final TextEditingController transmissionTypeController =
      TextEditingController();
  final TextEditingController horsepowerController = TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController warrantyController = TextEditingController();
  final TextEditingController accidentalController = TextEditingController();
  final TextEditingController payloadCapacityController =
      TextEditingController();
  final TextEditingController towingCapacityController =
      TextEditingController();


  Color selectedColor = Colors.grey;

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
    bodyTypeController.text = _listingInputController.bodyType.value;
    driveTypeController.text = _listingInputController.driveType.value;
    fuelTypeController.text = _listingInputController.fuelType.value;
    transmissionTypeController.text =
        _listingInputController.transmissionType.value;
    horsepowerController.text = _listingInputController.horsepower.value > 0
        ? _listingInputController.horsepower.value.toString()
        : '';
    mileageController.text = (_listingInputController.mileage.value.isNotEmpty && 
        _listingInputController.mileage.value != "0")
        ? _listingInputController.mileage.value
        : '';
    warrantyController.text = _listingInputController.warranty.value;
    accidentalController.text = _listingInputController.accidental.value;

    // Initialize selectedColor from controller if a color is already set
    if (_listingInputController.exteriorColor.value.isNotEmpty) {
      try {
        final colorString = _listingInputController.exteriorColor.value
            .replaceAll('#', '');
        if (colorString.length >= 6) {
          selectedColor = Color(
            int.parse('FF${colorString.substring(0, 6)}', radix: 16),
          );
        }
      } catch (e) {
        print('Error parsing color: $e');
        selectedColor = Colors.grey; // Fallback
      }
    }

    // Add listeners to update the main controller when text changes
    bodyTypeController.addListener(() {
      _listingInputController.bodyType.value = bodyTypeController.text;
    });
    driveTypeController.addListener(() {
      _listingInputController.driveType.value = driveTypeController.text;
    });
    fuelTypeController.addListener(() {
      _listingInputController.fuelType.value = fuelTypeController.text;
    });
    transmissionTypeController.addListener(() {
      _listingInputController.transmissionType.value =
          transmissionTypeController.text;
    });
    horsepowerController.addListener(() {
      _listingInputController.horsepower.value =
          int.tryParse(horsepowerController.text) ?? 0;
    });
    mileageController.addListener(() {
      _listingInputController.mileage.value = mileageController.text;
    });
    warrantyController.addListener(() {
      _listingInputController.warranty.value = warrantyController.text;
    });
    accidentalController.addListener(() {
      _listingInputController.accidental.value = accidentalController.text;
    });
    
    payloadCapacityController.addListener(() {
      _listingInputController.payloadCapacity.value =
          payloadCapacityController.text;
    });
    towingCapacityController.addListener(() {
      _listingInputController.towingCapacity.value =
          towingCapacityController.text;
    });

  }

  @override
  void dispose() {
    // Dispose all text editing controllers
    bodyTypeController.dispose();
    driveTypeController.dispose();
    fuelTypeController.dispose();
    transmissionTypeController.dispose();
    horsepowerController.dispose();
    mileageController.dispose();
    warrantyController.dispose();
    accidentalController.dispose();
    payloadCapacityController.dispose();
    towingCapacityController.dispose();


    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    final List<String> bodyTypes = [
      'truck'.tr,
      'van'.tr,
      'pickup'.tr,
      'trailer'.tr,
      'semi_trailer'.tr,
      'flatbed'.tr,
      'refrigerated'.tr,
      'tanker'.tr,
      'crane'.tr,
      'tow_truck'.tr,
      'delivery_van'.tr,
      'cargo_van'.tr,
      'box_truck'.tr,
      'dump_truck'.tr,
      'fire_truck'.tr,
      'ambulance'.tr,
    ];

    final List<String> driveTypes = [
      'front_wheel_drive'.tr,
      'rear_wheel_drive'.tr,
      'all_wheel_drive'.tr,
      'four_wheel_drive'.tr,
    ];

    final List<String> fuelTypes = [
      'benzin'.tr,
      'diesel'.tr,
      'electric'.tr,
      'hybrid'.tr,
      'gasoline'.tr,
      'other'.tr,
    ];

    final List<String> transmissionTypes = [
      'manual'.tr,
      'automatic'.tr,
    ];

    final List<String> warrantyOptions = ['yes'.tr, 'no'.tr];

    final List<String> accidentalOptions = ['yes'.tr, 'no'.tr];

   


    final ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Commercial Vehicle Specifications Section
          Text(
            'commercial_specifications'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),

          // Payload Capacity
          BuildInput(
            title: 'payload_capacity'.tr,
            label: 'enter_payload_capacity_kg'.tr,
            textController: payloadCapacityController,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 16),

          // Towing Capacity
          BuildInput(
            title: 'towing_capacity'.tr,
            label: 'enter_towing_capacity_kg'.tr,
            textController: towingCapacityController,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 16),

        


          // Warranty Dropdown
          BuildInputWithOptions(
            title: 'warranty'.tr,
            controller: warrantyController,
            options: warrantyOptions,
          ),

          const SizedBox(height: 16),

          // Accident History Dropdown
          BuildInputWithOptions(
            title: 'accidental'.tr,
            controller: accidentalController,
            options: accidentalOptions,
          ),

          const SizedBox(height: 16),
 
        

          // Engine and Performance Section
          Text(
            'engine_and_performance'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),

          // Horsepower Text Field
          BuildInput(
            title: 'horsepower'.tr,
            label: 'enter_horsepower'.tr,
            textController: horsepowerController,
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 24),

          // Vehicle Specifications Section
          Text(
            'vehicle_specifications'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),

          // Body Type Dropdown
          BuildInputWithOptions(
            title: 'body_type'.tr,
            controller: bodyTypeController,
            options: bodyTypes,
          ),

          const SizedBox(height: 16),

          // Drive Type Dropdown
          BuildInputWithOptions(
            title: 'drive_type'.tr,
            controller: driveTypeController,
            options: driveTypes,
          ),

          const SizedBox(height: 16),

          // Fuel Type Dropdown
          BuildInputWithOptions(
            title: 'fuel_type'.tr,
            controller: fuelTypeController,
            options: fuelTypes,
          ),

          const SizedBox(height: 16),

          // Transmission Type Dropdown
          BuildInputWithOptions(
            title: 'transmission'.tr,
            controller: transmissionTypeController,
            options: transmissionTypes,
          ),

          const SizedBox(height: 16),

          // Mileage Text Field
          BuildInput(
            title: 'mileage'.tr,
            label: 'enter_mileage'.tr,
            textController: mileageController,
          ),

          const SizedBox(height: 16),

         

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? subDarkColor.withOpacity(0.3)
                  : Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Get.isDarkMode
                    ? Colors.blueGrey[800]!
                    : Colors.blue[200]!,
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.local_shipping, color: blueColor, size: 24),
                const SizedBox(height: 8),
                Text(
                  'commercial_vehicle_specifications'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: blueColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'commercial_vehicle_specifications_info'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Get.isDarkMode ? greyColor : Colors.blue[700],
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
