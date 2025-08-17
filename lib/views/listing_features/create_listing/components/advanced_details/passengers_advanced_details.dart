import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/widgets/build_input_with_options/build_input_with_options.dart';
import 'package:samsar/widgets/build_input/build_input.dart';
import 'package:samsar/widgets/color_picker_field/color_picker_field.dart';

class PassengersAdvancedDetails extends StatefulWidget {
  const PassengersAdvancedDetails({super.key});

  @override
  State<PassengersAdvancedDetails> createState() => _PassengersAdvancedDetailsState();
}

class _PassengersAdvancedDetailsState extends State<PassengersAdvancedDetails> {
  // Get the ListingInputController instance
  late final ListingInputController _listingInputController;
  
  // Controllers for passenger vehicle-specific fields
  final TextEditingController bodyTypeController = TextEditingController();
  final TextEditingController driveTypeController = TextEditingController();
  final TextEditingController fuelTypeController = TextEditingController();
  final TextEditingController transmissionTypeController = TextEditingController();
  final TextEditingController horsepowerController = TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController previousOwnersController = TextEditingController();
  final TextEditingController warrantyController = TextEditingController();
  final TextEditingController accidentalController = TextEditingController();
  final TextEditingController serviceHistoryController = TextEditingController();
  final TextEditingController importStatusController = TextEditingController();
  final TextEditingController registrationExpiryController = TextEditingController();
  final TextEditingController engineSizeController = TextEditingController();
  final TextEditingController seatingCapacityController = TextEditingController();
  final TextEditingController doorsController = TextEditingController();
  final TextEditingController airConditioningController = TextEditingController();
  final TextEditingController entertainmentSystemController = TextEditingController();
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
    transmissionTypeController.text = _listingInputController.transmissionType.value;
    horsepowerController.text = _listingInputController.horsepower.value.toString();
    mileageController.text = _listingInputController.mileage.value;
    previousOwnersController.text = _listingInputController.previousOwners.value.toString();
    warrantyController.text = _listingInputController.warranty.value;
    accidentalController.text = _listingInputController.accidental.value;
    serviceHistoryController.text = _listingInputController.serviceHistory.value;
    importStatusController.text = _listingInputController.importStatus.value;
    registrationExpiryController.text = _listingInputController.registrationExpiry.value;
    engineSizeController.text = _listingInputController.engineSize.value;
    colorController.text = _listingInputController.exteriorColor.value;

    // Initialize selectedColor from controller if a color is already set
    if (_listingInputController.exteriorColor.value.isNotEmpty) {
      try {
        final colorString =
            _listingInputController.exteriorColor.value.replaceAll('#', '');
        if (colorString.length >= 6) {
          selectedColor = Color(int.parse('FF${colorString.substring(0, 6)}', radix: 16));
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
      _listingInputController.transmissionType.value = transmissionTypeController.text;
    });
    horsepowerController.addListener(() {
      _listingInputController.horsepower.value = int.tryParse(horsepowerController.text) ?? 0;
    });
    mileageController.addListener(() {
      _listingInputController.mileage.value = mileageController.text;
    });
    previousOwnersController.addListener(() {
      _listingInputController.previousOwners.value = int.tryParse(previousOwnersController.text) ?? 0;
    });
    warrantyController.addListener(() {
      _listingInputController.warranty.value = warrantyController.text;
    });
    accidentalController.addListener(() {
      _listingInputController.accidental.value = accidentalController.text;
    });
    serviceHistoryController.addListener(() {
      _listingInputController.serviceHistory.value = serviceHistoryController.text;
    });
    importStatusController.addListener(() {
      _listingInputController.importStatus.value = importStatusController.text;
    });
    registrationExpiryController.addListener(() {
      _listingInputController.registrationExpiry.value = registrationExpiryController.text;
    });
    engineSizeController.addListener(() {
      _listingInputController.engineSize.value = engineSizeController.text;
    });
    seatingCapacityController.addListener(() {
      _listingInputController.seatingCapacity.value = seatingCapacityController.text;
    });
    doorsController.addListener(() {
      _listingInputController.doors.value = doorsController.text;
    });
    airConditioningController.addListener(() {
      _listingInputController.airConditioning.value = airConditioningController.text;
    });
    entertainmentSystemController.addListener(() {
      _listingInputController.entertainmentSystem.value = entertainmentSystemController.text;
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
    colorController.dispose();
    previousOwnersController.dispose();
    warrantyController.dispose();
    accidentalController.dispose();
    serviceHistoryController.dispose();
    importStatusController.dispose();
    registrationExpiryController.dispose();
    engineSizeController.dispose();
    seatingCapacityController.dispose();
    doorsController.dispose();
    airConditioningController.dispose();
    entertainmentSystemController.dispose();
    
    super.dispose();
  }

  // Method to show date picker for registration expiry
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    
    if (picked != null) {
      registrationExpiryController.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> bodyTypes = [
      'minivan'.tr, 'van'.tr, 'microbus'.tr, 'bus'.tr, 'coach'.tr, 'shuttle'.tr
    ];
    
    final List<String> driveTypes = [
      'front_wheel_drive'.tr, 'rear_wheel_drive'.tr, 'all_wheel_drive'.tr, 'four_wheel_drive'.tr
    ];
    
    final List<String> fuelTypes = [
      'petrol'.tr, 'diesel'.tr, 'electric'.tr, 'hybrid'.tr, 'cng'.tr, 'lpg'.tr
    ];
    
    final List<String> transmissionTypes = [
      'manual'.tr, 'automatic'.tr, 'automatic_manual'.tr
    ];
    final List<String> warrantyOptions = [
      'yes'.tr, 'no'.tr
    ];

    final List<String> accidentalOptions = [
      'yes'.tr, 'no'.tr
    ];

    final List<String> serviceHistoryOptions = [
      'available'.tr, 'not_available'.tr
    ];

    final List<String> importStatusOptions = [
      'gcc_specs'.tr, 'american_specs'.tr, 'european_specs'.tr, 'japanese_specs'.tr, 'canadian_specs'.tr, 'korean_specs'.tr, 'other'.tr
    ];

    final List<String> seatingCapacityOptions = [
      '7', '8', '9', '12', '14', '16', '20', '25', '30', '40', '50+'
    ];

    final List<String> doorsOptions = [
      '2', '3', '4', '5'
    ];

    final List<String> airConditioningOptions = [
      'front_ac'.tr, 'rear_ac'.tr, 'dual_zone_ac'.tr, 'no_ac'.tr
    ];

    final List<String> entertainmentSystemOptions = [
      'basic_radio'.tr, 'cd_player'.tr, 'dvd_player'.tr, 'touchscreen'.tr, 'premium_sound'.tr, 'none'.tr
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

          // Number of Doors Dropdown
          BuildInputWithOptions(
            title: 'doors'.tr,
            controller: doorsController,
            options: doorsOptions,
          ),
          
          const SizedBox(height: 16),

          // Air Conditioning Dropdown
          BuildInputWithOptions(
            title: 'air_conditioning'.tr,
            controller: airConditioningController,
            options: airConditioningOptions,
          ),
          
          const SizedBox(height: 16),

          // Entertainment System Dropdown
          BuildInputWithOptions(
            title: 'entertainment_system'.tr,
            controller: entertainmentSystemController,
            options: entertainmentSystemOptions,
          ),
          
          const SizedBox(height: 8),
          
          // Previous Owners
          BuildInput(
            title: 'previous_owners'.tr,
            label: 'enter_previous_owners'.tr,
            textController: previousOwnersController,
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
          
          // Service History Dropdown
          BuildInputWithOptions(
            title: 'service_history'.tr,
            controller: serviceHistoryController,
            options: serviceHistoryOptions,
          ),
          
          const SizedBox(height: 16),
          
          // Import Status Dropdown
          BuildInputWithOptions(
            title: 'import_status'.tr,
            controller: importStatusController,
            options: importStatusOptions,
          ),
          
          const SizedBox(height: 16),
          
          // Registration Expiry Date Picker
          GestureDetector(
            onTap: () => _selectDate(context),
            child: BuildInput(
              title: 'registration_expiry'.tr,
              label: 'select_registration_expiry'.tr,
              textController: registrationExpiryController,
            ),
          ),
          
          const SizedBox(height: 24),

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
          
          const SizedBox(height: 16),
          
          // Engine Size Text Field
          BuildInput(
            title: 'engine_size'.tr,
            label: 'enter_engine_size'.tr,
            textController: engineSizeController,
            keyboardType: TextInputType.text,
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
          
          // Exterior Color Picker
          Text(
            'color'.tr,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: blackColor),
          ),
          const SizedBox(height: 8),
          ColorPickerField(
            onColorChanged: (color) {
              setState(() {
                selectedColor = color;
                String colorHex = '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
                colorController.text = colorHex;
                // Update the listing input controller
                _listingInputController.exteriorColor.value = colorHex;
              });
            },
            initialColor: selectedColor,
          ),
          
          const SizedBox(height: 20),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? subDarkColor.withOpacity(0.3) : Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Get.isDarkMode ? Colors.blueGrey[800]! : Colors.blue[200]!),
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
