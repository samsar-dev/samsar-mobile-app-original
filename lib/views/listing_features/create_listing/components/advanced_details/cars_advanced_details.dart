import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/widgets/build_input_with_options/build_input_with_options.dart';
import 'package:samsar/widgets/build_input/build_input.dart';
import 'package:samsar/widgets/color_picker_field/color_picker_field.dart';

class CarsAdvancedDetails extends StatefulWidget {
  const CarsAdvancedDetails({super.key});

  @override
  State<CarsAdvancedDetails> createState() => _CarsAdvancedDetailsState();
}

class _CarsAdvancedDetailsState extends State<CarsAdvancedDetails> {
  // Get the ListingInputController instance
  late final ListingInputController _listingInputController;
  
  // Controllers for car-specific fields
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
      print('🔧 Body Type updated: ${bodyTypeController.text}');
    });
    
    driveTypeController.addListener(() {
      _listingInputController.driveType.value = driveTypeController.text;
      print('🔧 Drive Type updated: ${driveTypeController.text}');
    });
    
    fuelTypeController.addListener(() {
      _listingInputController.fuelType.value = fuelTypeController.text;
      print('⛽ Fuel Type updated: ${fuelTypeController.text}');
    });
    
    transmissionTypeController.addListener(() {
      _listingInputController.transmissionType.value = transmissionTypeController.text;
      print('🔄 Transmission updated: ${transmissionTypeController.text}');
    });

    horsepowerController.addListener(() => _listingInputController.horsepower.value = int.tryParse(horsepowerController.text) ?? 0);
    print('🐎 Horsepower updated: ${horsepowerController.text}');
    
    mileageController.addListener(() {
      _listingInputController.mileage.value = mileageController.text;
      print('📏 Mileage updated: ${mileageController.text}');
    });
    
    previousOwnersController.addListener(() {
      _listingInputController.previousOwners.value = int.tryParse(previousOwnersController.text) ?? 0;
      print('👥 Previous Owners updated: ${previousOwnersController.text}');
    });
    
    warrantyController.addListener(() {
      _listingInputController.warranty.value = warrantyController.text;
      print('🛡️ Warranty updated: ${warrantyController.text}');
    });
    
    accidentalController.addListener(() {
      _listingInputController.accidental.value = accidentalController.text;
      print('🚗 Accident history updated: ${accidentalController.text}');
    });
    
    serviceHistoryController.addListener(() {
      _listingInputController.serviceHistory.value = serviceHistoryController.text;
      print('📋 Service history updated: ${serviceHistoryController.text}');
    });
    
    importStatusController.addListener(() {
      _listingInputController.importStatus.value = importStatusController.text;
      print('🌍 Import status updated: ${importStatusController.text}');
    });
    
    registrationExpiryController.addListener(() {
      _listingInputController.registrationExpiry.value = registrationExpiryController.text;
      print('📅 Registration expiry updated: ${registrationExpiryController.text}');
    });
    
    engineSizeController.addListener(() {
      _listingInputController.engineSize.value = engineSizeController.text;
      print('🔧 Engine size updated: ${engineSizeController.text}');
    });
  }

  // Options for dropdowns
  final List<String> bodyTypes = [
    'Sedan', 'Hatchback', 'SUV', 'Coupe', 'Convertible', 'Wagon', 'Crossover'
  ];
  
  final List<String> driveTypes = [
    'Front-wheel drive (FWD)', 'Rear-wheel drive (RWD)', 'All-wheel drive (AWD)', '4-wheel drive (4WD)'
  ];
  
  final List<String> fuelTypes = [
    'Petrol', 'Diesel', 'Electric', 'Hybrid', 'CNG', 'LPG'
  ];
  
  final List<String> transmissionTypes = [
    'Manual', 'Automatic', 'Automatic/Manual'
  ];
  
  final List<String> warrantyOptions = [
    'Manufacturer Warranty', 'Extended Warranty', 'No Warranty'
  ];
  
  final List<String> accidentalOptions = [
    'No Accidents', 'Minor Damage', 'Major Damage', 'Salvage Title'
  ];
  
  final List<String> serviceHistoryOptions = [
    'Full Service History', 'Partial Service History', 'No Service History'
  ];
  
  final List<String> importStatusOptions = [
    'Local', 'GCC', 'European', 'American', 'Japanese', 'Other'
  ];

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
    
    // Dispose new advanced details controllers
    previousOwnersController.dispose();
    warrantyController.dispose();
    accidentalController.dispose();
    serviceHistoryController.dispose();
    importStatusController.dispose();
    registrationExpiryController.dispose();
    
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
      'sedan'.tr, 'suv'.tr, 'hatchback'.tr, 'coupe'.tr, 'convertible'.tr, 'wagon'.tr, 'minivan'.tr
    ];
    
    final List<String> driveTypes = [
      'front_wheel_drive'.tr, 'rear_wheel_drive'.tr, 'all_wheel_drive'.tr, 'four_wheel_drive'.tr
    ];
    
    final List<String> fuelTypes = [
      'petrol'.tr, 'diesel'.tr, 'electric'.tr, 'hybrid'.tr, 'cng'.tr, 'lpg'.tr
    ];
    
    final List<String> transmissionTypes = [
      'manual'.tr, 'automatic'.tr, 'continuously_variable'.tr, 'semi_automatic'.tr
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

    final ThemeData theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // MOST ESSENTIAL - Vehicle Specifications (Syrian buyers check first)
          Text(
            'vehicle_specifications'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          
          // 1. Fuel Type - CRITICAL for Syrian market (fuel availability/cost)
          BuildInputWithOptions(
            title: 'fuel_type'.tr,
            controller: fuelTypeController,
            options: fuelTypes,
          ),
          
          const SizedBox(height: 16),
          
          // 2. Transmission - ESSENTIAL for Syrian drivers
          BuildInputWithOptions(
            title: 'transmission'.tr,
            controller: transmissionTypeController,
            options: transmissionTypes,
          ),
          
          const SizedBox(height: 16),
          
          // 3. Body Type - Important for family/usage needs
          BuildInputWithOptions(
            title: 'body_type'.tr,
            controller: bodyTypeController,
            options: bodyTypes,
          ),
          
          const SizedBox(height: 16),
          
          // 4. Mileage - Critical for used car evaluation
          BuildInput(
            title: 'mileage'.tr,
            label: 'enter_mileage'.tr,
            textController: mileageController,
          ),
          
          const SizedBox(height: 16),
          
          // 5. Color - Important for resale value
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
          
          const SizedBox(height: 24),

          // HIGH PRIORITY - Vehicle History & Condition
          Text(
            'condition'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          
          // 6. Accident History - CRITICAL for Syrian buyers
          BuildInputWithOptions(
            title: 'accidental'.tr,
            controller: accidentalController,
            options: accidentalOptions,
          ),
          
          const SizedBox(height: 16),
          
          // 7. Previous Owners - Important trust factor
          BuildInput(
            title: 'previous_owners'.tr,
            label: 'enter_previous_owners'.tr,
            textController: previousOwnersController,
          ),
          
          const SizedBox(height: 16),
          
          // 8. Import Status - ESSENTIAL for Syrian market (GCC vs others)
          BuildInputWithOptions(
            title: 'import_status'.tr,
            controller: importStatusController,
            options: importStatusOptions,
          ),
          
          const SizedBox(height: 16),
          
          // 9. Service History - Important for maintenance assessment
          BuildInputWithOptions(
            title: 'service_history'.tr,
            controller: serviceHistoryController,
            options: serviceHistoryOptions,
          ),
          
          const SizedBox(height: 24),

          // MEDIUM PRIORITY - Engine and Performance
          Text(
            'engine_and_performance'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),

          // 10. Engine Size - Moderate importance
          BuildInput(
            title: 'engine_size'.tr,
            label: 'enter_engine_size'.tr,
            textController: engineSizeController,
            keyboardType: TextInputType.text,
          ),
          
          const SizedBox(height: 16),
          
          // 11. Drive Type - Less critical for Syrian roads
          BuildInputWithOptions(
            title: 'drive_type'.tr,
            controller: driveTypeController,
            options: driveTypes,
          ),
          
          const SizedBox(height: 16),

          // 12. Horsepower - Nice to have
          BuildInput(
            title: 'horsepower'.tr,
            label: 'enter_horsepower'.tr,
            textController: horsepowerController,
            keyboardType: TextInputType.number,
          ),
          
          const SizedBox(height: 24),
          
          // LOWER PRIORITY - Documentation & Legal
          Text(
            'documentation'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          
          // 13. Registration Expiry - Administrative
          GestureDetector(
            onTap: () => _selectDate(context),
            child: BuildInput(
              title: 'registration_expiry'.tr,
              label: 'select_registration_expiry'.tr,
              textController: registrationExpiryController,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 14. Warranty - Least important for used cars
          BuildInputWithOptions(
            title: 'warranty'.tr,
            controller: warrantyController,
            options: warrantyOptions,
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
                Icon(Icons.info, color: blueColor, size: 24),
                const SizedBox(height: 8),
                Text(
                  'car_specifications'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: blueColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'car_specifications_info'.tr,
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
