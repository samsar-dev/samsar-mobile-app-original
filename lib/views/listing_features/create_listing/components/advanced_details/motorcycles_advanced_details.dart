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
  State<MotorcyclesAdvancedDetails> createState() =>
      _MotorcyclesAdvancedDetailsState();
}

class _MotorcyclesAdvancedDetailsState
    extends State<MotorcyclesAdvancedDetails> {
  // Get the ListingInputController instance
  late final ListingInputController _listingInputController;

  // Controllers for motorcycle-specific fields
  final TextEditingController bodyTypeController = TextEditingController();
  final TextEditingController fuelTypeController = TextEditingController();
  final TextEditingController transmissionTypeController =
      TextEditingController();
  final TextEditingController engineSizeController = TextEditingController();
  final TextEditingController mileageController = TextEditingController();

  // Condition and History
  final TextEditingController previousOwnersController =
      TextEditingController();
  final TextEditingController accidentalController = TextEditingController();
  final TextEditingController serviceHistoryController =
      TextEditingController();

  // Legal and Documentation
  final TextEditingController importStatusController = TextEditingController();

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

    // Initialize controllers with proper data loading
    _loadExistingData();

    // Add listeners
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

    previousOwnersController.addListener(() {
      _listingInputController.previousOwners.value =
          int.tryParse(previousOwnersController.text) ?? 0;
    });
    accidentalController.addListener(
      () =>
          _listingInputController.accidental.value = accidentalController.text,
    );
    serviceHistoryController.addListener(
      () => _listingInputController.serviceHistory.value =
          serviceHistoryController.text,
    );
    importStatusController.addListener(
      () => _listingInputController.importStatus.value =
          importStatusController.text,
    );
    engineSizeController.addListener(
      () =>
          _listingInputController.engineSize.value = engineSizeController.text,
    );
    
    // Add color controller listener
    colorController.addListener(() {
      if (colorController.text.isNotEmpty) {
        _listingInputController.exteriorColor.value = colorController.text;
      }
    });
  }
  
  void _loadExistingData() {
    print('🔄 MotorcyclesAdvancedDetails: Loading existing data');
    
    // Load basic fields
    bodyTypeController.text = _listingInputController.bodyType.value;
    fuelTypeController.text = _listingInputController.fuelType.value;
    transmissionTypeController.text = _listingInputController.transmissionType.value;
    engineSizeController.text = _listingInputController.engineSize.value;
    
    // CRITICAL FIX: Load mileage even if it's "0" - only skip if truly empty
    if (_listingInputController.mileage.value.isNotEmpty) {
      mileageController.text = _listingInputController.mileage.value;
      print('✅ Mileage loaded: "${mileageController.text}"');
    }
    
    // CRITICAL FIX: Load previous owners even if it's 0 - only skip if truly unset
    if (_listingInputController.previousOwners.value >= 0) {
      previousOwnersController.text = _listingInputController.previousOwners.value.toString();
      print('✅ Previous owners loaded: "${previousOwnersController.text}"');
    }
    
    // Load other fields
    accidentalController.text = _listingInputController.accidental.value;
    serviceHistoryController.text = _listingInputController.serviceHistory.value;
    importStatusController.text = _listingInputController.importStatus.value;
    
    // CRITICAL FIX: Load color properly
    if (_listingInputController.exteriorColor.value.isNotEmpty && 
        _listingInputController.exteriorColor.value != '#000000') {
      colorController.text = _listingInputController.exteriorColor.value;
      try {
        String hex = _listingInputController.exteriorColor.value.replaceAll('#', '');
        if (hex.length == 6) {
          hex = 'FF' + hex;
        }
        selectedColor = Color(int.parse(hex, radix: 16));
        print('✅ Color loaded: "${colorController.text}"');
      } catch (e) {
        print('❌ Error parsing color: $e');
        selectedColor = Colors.grey;
      }
    }
    
    print('📊 MotorcyclesAdvancedDetails data loaded:');
    print('   🏍️ Body Type: "${bodyTypeController.text}"');
    print('   ⛽ Fuel Type: "${fuelTypeController.text}"');
    print('   🔄 Transmission: "${transmissionTypeController.text}"');
    print('   📏 Engine Size: "${engineSizeController.text}"');
    print('   📊 Mileage: "${mileageController.text}"');
    print('   👥 Previous Owners: "${previousOwnersController.text}"');
    print('   🎨 Color: "${colorController.text}"');
  }

  @override
  void dispose() {
    bodyTypeController.dispose();
    mileageController.dispose();
    transmissionTypeController.dispose();
    engineSizeController.dispose();

    // Dispose condition and history controllers
    previousOwnersController.dispose();
    accidentalController.dispose();
    serviceHistoryController.dispose();
    importStatusController.dispose();
    colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> bodyTypes = [
      'sport'.tr,
      'cruiser'.tr,
      'touring'.tr,
      'standard'.tr,
      'dirt_bike'.tr,
      'scooter'.tr,
      'adventure'.tr,
      'cafe_racer'.tr,
    ];

    final List<String> fuelTypes = ['benzin'.tr, 'electric'.tr, 'hybrid'.tr];

    final List<String> transmissionTypes = [
      'manual'.tr,
      'automatic'.tr,
    ];

    final List<String> accidentalOptions = ['yes'.tr, 'no'.tr];
    final List<String> historyOptions = [
      'full_service_history'.tr,
      'partial_service_history'.tr,
      'no_service_history'.tr,
    ];
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
                String colorHex =
                    '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
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

          // Accident History - CRITICAL for Syrian buyers
          BuildInputWithOptions(
            title: 'accidental'.tr,
            controller: accidentalController,
            options: accidentalOptions,
          ),

          // Previous Owners - Important trust factor
          BuildInput(
            title: 'previous_owners'.tr,
            label: 'number_of_owners'.tr,
            textController: previousOwnersController,
            keyboardType: TextInputType.number,
          ),

          // Import Status - Important for Syrian market
          BuildInputWithOptions(
            title: 'import_status'.tr,
            controller: importStatusController,
            options: importStatuses,
          ),

          // Service History - Important for maintenance assessment
          BuildInputWithOptions(
            title: 'service_history'.tr,
            controller: serviceHistoryController,
            options: historyOptions,
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
                  style: TextStyle(color: Colors.red[700], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
