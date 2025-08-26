import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/widgets/build_input_with_options/build_input_with_options.dart';
import 'package:samsar/widgets/build_input/build_input.dart';


class PassengersAdvancedDetails extends StatefulWidget {
  const PassengersAdvancedDetails({super.key});

  @override
  State<PassengersAdvancedDetails> createState() =>
      _PassengersAdvancedDetailsState();
}

class _PassengersAdvancedDetailsState extends State<PassengersAdvancedDetails> {
  // Get the ListingInputController instance
  late final ListingInputController _listingInputController;

  // Controllers for passenger vehicle-specific fields
  final TextEditingController bodyTypeController = TextEditingController();
  final TextEditingController fuelTypeController = TextEditingController();
  final TextEditingController transmissionTypeController =
      TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController accidentalController = TextEditingController();
  final TextEditingController seatingCapacityController =
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
    fuelTypeController.text = _listingInputController.fuelType.value;
    transmissionTypeController.text =
        _listingInputController.transmissionType.value;
    mileageController.text = (_listingInputController.mileage.value.isNotEmpty && 
        _listingInputController.mileage.value != "0")
        ? _listingInputController.mileage.value
        : '';
    accidentalController.text = _listingInputController.accidental.value;
    seatingCapacityController.text =
        _listingInputController.seatingCapacity.value;

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
    bodyTypeController.addListener(
      () => _listingInputController.bodyType.value = bodyTypeController.text,
    );
    fuelTypeController.addListener(
      () => _listingInputController.fuelType.value = fuelTypeController.text,
    );
    transmissionTypeController.addListener(
      () => _listingInputController.transmissionType.value =
          transmissionTypeController.text,
    );
    mileageController.addListener(
      () => _listingInputController.mileage.value = mileageController.text,
    );
    accidentalController.addListener(
      () =>
          _listingInputController.accidental.value = accidentalController.text,
    );
    seatingCapacityController.addListener(
      () => _listingInputController.seatingCapacity.value =
          seatingCapacityController.text,
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    bodyTypeController.dispose();
    fuelTypeController.dispose();
    transmissionTypeController.dispose();
    mileageController.dispose();
    accidentalController.dispose();
    seatingCapacityController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final List<String> bodyTypes = [
      'minivan'.tr,
      'van'.tr,
      'microbus'.tr,
      'bus'.tr,
      'coach'.tr,
      'shuttle'.tr,
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
  

    final List<String> accidentalOptions = ['yes'.tr, 'no'.tr];

  

    final List<String> seatingCapacityOptions = [
      '7',
      '8',
      '9',
      '12',
      '14',
      '16',
      '20',
      '25',
      '30',
      '40',
      '50+',
    ];

      final ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Passenger Vehicle Specifications Section
          Text(
            'passenger_specifications'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),

          // Seating Capacity Dropdown
          BuildInputWithOptions(
            title: 'seating_capacity'.tr,
            controller: seatingCapacityController,
            options: seatingCapacityOptions,
          ),

          const SizedBox(height: 16),

          // Accident History Dropdown
          BuildInputWithOptions(
            title: 'accidental'.tr,
            controller: accidentalController,
            options: accidentalOptions,
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
                Icon(Icons.directions_bus, color: blueColor, size: 24),
                const SizedBox(height: 8),
                Text(
                  'passenger_vehicle_specifications'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: blueColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'passenger_vehicle_specifications_info'.tr,
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
