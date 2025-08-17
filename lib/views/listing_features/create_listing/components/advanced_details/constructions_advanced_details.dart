import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/widgets/build_input_with_options/build_input_with_options.dart';
import 'package:samsar/widgets/build_input/build_input.dart';
import 'package:samsar/widgets/color_picker_field/color_picker_field.dart';

class ConstructionsAdvancedDetails extends StatefulWidget {
  const ConstructionsAdvancedDetails({super.key});

  @override
  State<ConstructionsAdvancedDetails> createState() => _ConstructionsAdvancedDetailsState();
}

class _ConstructionsAdvancedDetailsState extends State<ConstructionsAdvancedDetails> {
  // Get the ListingInputController instance
  late final ListingInputController _listingInputController;
  
  // Controllers for construction vehicle-specific fields
  final TextEditingController bodyTypeController = TextEditingController();
  final TextEditingController driveTypeController = TextEditingController();
  final TextEditingController fuelTypeController = TextEditingController();
  final TextEditingController transmissionTypeController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController operatingWeightController = TextEditingController();
  final TextEditingController bucketCapacityController = TextEditingController();
  final TextEditingController liftingCapacityController = TextEditingController();
  final TextEditingController reachController = TextEditingController();
  final TextEditingController workingHoursController = TextEditingController();
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
    operatingWeightController.addListener(() {
      _listingInputController.operatingWeight.value = operatingWeightController.text;
    });
    bucketCapacityController.addListener(() {
      _listingInputController.bucketCapacity.value = bucketCapacityController.text;
    });
    liftingCapacityController.addListener(() {
      _listingInputController.liftingCapacity.value = liftingCapacityController.text;
    });
    reachController.addListener(() {
      _listingInputController.reach.value = reachController.text;
    });
    workingHoursController.addListener(() {
      _listingInputController.workingHours.value = workingHoursController.text;
    });
  }

  @override
  void dispose() {
    // Dispose all controllers
    bodyTypeController.dispose();
    driveTypeController.dispose();
    fuelTypeController.dispose();
    transmissionTypeController.dispose();
    colorController.dispose();
    operatingWeightController.dispose();
    bucketCapacityController.dispose();
    liftingCapacityController.dispose();
    reachController.dispose();
    workingHoursController.dispose();
    
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
    
  }

  @override
  Widget build(BuildContext context) {
    final List<String> bodyTypes = [
      'excavator'.tr, 'bulldozer'.tr, 'loader'.tr, 'backhoe'.tr, 'crane'.tr, 
      'dump_truck'.tr, 'grader'.tr, 'roller'.tr, 'compactor'.tr, 'forklift'.tr,
      'skid_steer'.tr, 'trencher'.tr, 'paver'.tr, 'concrete_mixer'.tr, 'drill_rig'.tr
    ];
    
    final List<String> driveTypes = [
      'tracked'.tr, 'wheeled'.tr, 'crawler'.tr, 'rubber_tired'.tr
    ];
    
    final List<String> fuelTypes = [
      'diesel'.tr, 'electric'.tr, 'hybrid'.tr, 'hydraulic'.tr
    ];
    
    final List<String> transmissionTypes = [
      'manual'.tr, 'automatic'.tr, 'hydrostatic'.tr, 'powershift'.tr
    ];


    final ThemeData theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Construction Equipment Specifications Section
          Text(
            'construction_specifications'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),

          // Operating Weight
          BuildInput(
            title: 'operating_weight'.tr,
            label: 'enter_operating_weight_kg'.tr,
            textController: operatingWeightController,
            keyboardType: TextInputType.number,
          ),
          
          const SizedBox(height: 16),

          // Bucket Capacity
          BuildInput(
            title: 'bucket_capacity'.tr,
            label: 'enter_bucket_capacity_m3'.tr,
            textController: bucketCapacityController,
            keyboardType: TextInputType.number,
          ),
          
          const SizedBox(height: 16),

          // Lifting Capacity
          BuildInput(
            title: 'lifting_capacity'.tr,
            label: 'enter_lifting_capacity_kg'.tr,
            textController: liftingCapacityController,
            keyboardType: TextInputType.number,
          ),
          
          const SizedBox(height: 16),

          // Reach
          BuildInput(
            title: 'reach'.tr,
            label: 'enter_reach_m'.tr,
            textController: reachController,
            keyboardType: TextInputType.number,
          ),
          
          const SizedBox(height: 16),

          // Working Hours
          BuildInput(
            title: 'working_hours'.tr,
            label: 'enter_working_hours'.tr,
            textController: workingHoursController,
            keyboardType: TextInputType.number,
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
                Icon(Icons.construction, color: blueColor, size: 24),
                const SizedBox(height: 8),
                Text(
                  'construction_vehicle_specifications'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: blueColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'construction_vehicle_specifications_info'.tr,
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
