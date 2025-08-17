import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/widgets/build_input_with_options/build_input_with_options.dart';
import 'package:samsar/widgets/build_input/build_input.dart';
import 'package:samsar/widgets/color_picker_field/color_picker_field.dart';

class MotorcyclesAdvancedDetails extends StatefulWidget {
  const MotorcyclesAdvancedDetails({super.key});

  @override
  State<MotorcyclesAdvancedDetails> createState() => _MotorcyclesAdvancedDetailsState();
}

class _MotorcyclesAdvancedDetailsState extends State<MotorcyclesAdvancedDetails> {
  // Get the ListingInputController instance
  late final ListingInputController _listingInputController;
  
  // Controllers for motorcycle-specific fields
  final TextEditingController bodyTypeController = TextEditingController();
  final TextEditingController fuelTypeController = TextEditingController();
  final TextEditingController transmissionTypeController = TextEditingController();
  final TextEditingController engineSizeController = TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController horsepowerController = TextEditingController();

  // Condition and History
  final TextEditingController previousOwnersController = TextEditingController();
  final TextEditingController warrantyController = TextEditingController();
  final TextEditingController accidentalController = TextEditingController();
  final TextEditingController serviceHistoryController = TextEditingController();

  // Legal and Documentation
  final TextEditingController importStatusController = TextEditingController();
  final TextEditingController registrationExpiryController = TextEditingController();

  // Color
  final TextEditingController colorController = TextEditingController();
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

    // Initialize controllers
    bodyTypeController.text = _listingInputController.bodyType.value;
    fuelTypeController.text = _listingInputController.fuelType.value;
    transmissionTypeController.text = _listingInputController.transmissionType.value;
    mileageController.text = _listingInputController.mileage.value.toString();
    horsepowerController.text = _listingInputController.horsepower.value.toString();
    previousOwnersController.text = _listingInputController.previousOwners.value.toString();
    warrantyController.text = _listingInputController.warranty.value;
    accidentalController.text = _listingInputController.accidental.value;
    serviceHistoryController.text = _listingInputController.serviceHistory.value;
    importStatusController.text = _listingInputController.importStatus.value;
    registrationExpiryController.text = _listingInputController.registrationExpiry.value;
    engineSizeController.text = _listingInputController.engineSize.value;

    // Add listeners
    bodyTypeController.addListener(() => _listingInputController.bodyType.value = bodyTypeController.text);
    fuelTypeController.addListener(() => _listingInputController.fuelType.value = fuelTypeController.text);
    transmissionTypeController.addListener(() => _listingInputController.transmissionType.value = transmissionTypeController.text);
    mileageController.addListener(() => _listingInputController.mileage.value = mileageController.text);
    horsepowerController.addListener(() {
      _listingInputController.horsepower.value = int.tryParse(horsepowerController.text) ?? 0;
    });
    previousOwnersController.addListener(() {
      _listingInputController.previousOwners.value = int.tryParse(previousOwnersController.text) ?? 0;
    });
    warrantyController.addListener(() => _listingInputController.warranty.value = warrantyController.text);
    accidentalController.addListener(() => _listingInputController.accidental.value = accidentalController.text);
    serviceHistoryController.addListener(() => _listingInputController.serviceHistory.value = serviceHistoryController.text);
    importStatusController.addListener(() => _listingInputController.importStatus.value = importStatusController.text);
    registrationExpiryController.addListener(() => _listingInputController.registrationExpiry.value = registrationExpiryController.text);
    engineSizeController.addListener(() => _listingInputController.engineSize.value = engineSizeController.text);
  }

  @override
  void dispose() {
    bodyTypeController.dispose();
    fuelTypeController.dispose();
    transmissionTypeController.dispose();
    engineSizeController.dispose();
    horsepowerController.dispose();

    // Dispose condition and history controllers
    previousOwnersController.dispose();
    warrantyController.dispose();
    accidentalController.dispose();
    serviceHistoryController.dispose();
    importStatusController.dispose();
    registrationExpiryController.dispose();
    colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final List<String> bodyTypes = [
      'sport'.tr, 'cruiser'.tr, 'touring'.tr, 'standard'.tr, 'dirt_bike'.tr, 'scooter'.tr, 'adventure'.tr, 'cafe_racer'.tr
    ];
    
    final List<String> fuelTypes = [
      'petrol'.tr, 'electric'.tr, 'hybrid'.tr
    ];
    
    final List<String> transmissionTypes = [
      'manual'.tr, 'automatic'.tr, 'automatic_manual'.tr
    ];

    final List<String> warrantyOptions = ['yes'.tr, 'no'.tr];
    final List<String> historyOptions = ['full_service_history'.tr, 'partial_service_history'.tr, 'no_service_history'.tr];
    final List<String> importStatuses = ['local'.tr, 'imported'.tr];

    final double screenWidth = MediaQuery.of(context).size.width;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MOST ESSENTIAL - Motorcycle Specifications (Syrian buyers check first)
          Text(
            'motorcycle_specifications'.tr,
            style: TextStyle(
              color: blackColor,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.06,
            ),
          ),
          SizedBox(height: 16),
          
          // 1. Engine Size - CRITICAL for Syrian motorcycle market (CC rating)
          BuildInput(
            title: 'engine_size'.tr,
            label: 'engine_size'.tr,
            textController: engineSizeController,
            keyboardType: TextInputType.number,
          ),
          
          // 2. Fuel Type - ESSENTIAL for Syrian market (fuel availability)
          BuildInputWithOptions(
            title: 'fuel_type'.tr,
            controller: fuelTypeController,
            options: fuelTypes,
          ),
          
          // 3. Body Type - Important for usage (sport, cruiser, etc.)
          BuildInputWithOptions(
            title: 'body_type'.tr,
            controller: bodyTypeController,
            options: bodyTypes,
          ),
          
          // 4. Transmission - Important for Syrian riders
          BuildInputWithOptions(
            title: 'transmission'.tr,
            controller: transmissionTypeController,
            options: transmissionTypes,
          ),
          
          // 5. Mileage - Critical for used motorcycle evaluation
          BuildInput(
            title: 'mileage_km'.tr,
            label: 'vehicle_mileage'.tr,
            textController: mileageController,
          ),
          
          // 6. Color - Important for resale value
          const SizedBox(height: 16),
          Text(
            'color'.tr,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
          
          const SizedBox(height: 24),

          // HIGH PRIORITY - Motorcycle History & Condition
          Text(
            'condition'.tr,
            style: TextStyle(
              color: blackColor,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05,
            ),
          ),
          SizedBox(height: 16),

          // 7. Accident History - CRITICAL for Syrian buyers
          BuildInputWithOptions(
            title: 'accidental'.tr,
            controller: accidentalController,
            options: warrantyOptions, // Yes/No
          ),

          // 8. Previous Owners - Important trust factor
          BuildInput(
            title: 'previous_owners'.tr,
            label: 'number_of_owners'.tr,
            textController: previousOwnersController,
            keyboardType: TextInputType.number,
          ),

          // 9. Import Status - Important for Syrian market
          BuildInputWithOptions(
            title: 'import_status'.tr,
            controller: importStatusController,
            options: importStatuses,
          ),

          // 10. Service History - Important for maintenance assessment
          BuildInputWithOptions(
            title: 'service_history'.tr,
            controller: serviceHistoryController,
            options: historyOptions,
          ),
          
          const SizedBox(height: 24),

          // MEDIUM PRIORITY - Performance Details
          Text(
            'performance'.tr,
            style: TextStyle(
              color: blackColor,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05,
            ),
          ),
          SizedBox(height: 16),
          
          // 11. Horsepower - Moderate importance
          BuildInput(
            title: 'horsepower'.tr,
            label: 'horsepower_hp'.tr,
            textController: horsepowerController,
            keyboardType: TextInputType.number,
          ),
          
          const SizedBox(height: 24),

          // LOWER PRIORITY - Documentation & Legal
          Text(
            'documentation'.tr,
            style: TextStyle(
              color: blackColor,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.05,
            ),
          ),
          SizedBox(height: 16),

          // 12. Registration Expiry - Administrative
          BuildInput(
            title: 'registration_expiry_date'.tr,
            label: 'dd_mm_yyyy'.tr,
            textController: registrationExpiryController,
            keyboardType: TextInputType.datetime,
          ),

          // 13. Warranty - Least important for used motorcycles
          BuildInputWithOptions(
            title: 'warranty'.tr,
            controller: warrantyController,
            options: warrantyOptions,
          ),
          
          SizedBox(height: 20),
          
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Column(
              children: [
                Icon(Icons.motorcycle, color: Colors.red[600], size: 24),
                SizedBox(height: 8),
                Text(
                  'motorcycle_specifications'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[800],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'motorcycle_specifications_info'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red[700],
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
