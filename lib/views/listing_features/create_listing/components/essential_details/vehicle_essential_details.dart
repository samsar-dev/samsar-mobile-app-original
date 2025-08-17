import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/features/location_controller.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/controllers/features/theme_controller.dart';
import 'package:samsar/data/vehicle/cars_brands.dart';
import 'package:samsar/widgets/build_input/build_input.dart';
import 'package:samsar/widgets/select_type/select_type.dart';
import 'package:samsar/widgets/build_input_with_options/build_input_with_options.dart';
import 'package:samsar/widgets/build_multi_line_input/build_multi_line_input.dart';
import 'package:samsar/widgets/location/location_field.dart';

class VehicleEssentialDetails extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool showValidation;
  final ValueChanged<bool> onValidationChanged;

  const VehicleEssentialDetails({
    super.key,
    required this.formKey,
    required this.showValidation,
    required this.onValidationChanged,
  });

  @override
  State<VehicleEssentialDetails> createState() => _VehicleEssentialDetailsState();
}

class _VehicleEssentialDetailsState extends State<VehicleEssentialDetails> {
  final LocationController _locationController = Get.put(LocationController());
  late final ListingInputController _listingInputController;
  late final ThemeController _themeController;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController makeController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();
  
  // Vehicle type selection
  String selectedVehicleType = "";
  int selectedIndex = -1;
  
  // Image picker
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();
  
  // Model options based on selected make
  List<String> modelOptions = [];
  
  // Vehicle types with translation keys for backend mapping and professional icons
  final List<Map<String, dynamic>> vehicleTypeData = [
    {'key': 'cars', 'title': 'cars'.tr, 'icon': Icons.directions_car_filled},
    {'key': 'motorcycles', 'title': 'motorcycles'.tr, 'icon': Icons.two_wheeler},
    {'key': 'passenger_vehicles', 'title': 'passenger_vehicles'.tr, 'icon': Icons.airport_shuttle},
    {'key': 'commercial_transport', 'title': 'commercial_transport'.tr, 'icon': Icons.local_shipping_outlined},
    {'key': 'construction_vehicles', 'title': 'construction_vehicles'.tr, 'icon': Icons.engineering},
  ];
  
  // Generate SelectTypeItem list for UI
  late final List<SelectTypeItem> vehicleTypes;

  @override
  void initState() {
    super.initState();
    _themeController = Get.put(ThemeController());
    
    // BULLETPROOF CONTROLLER ACCESS
    try {
      if (Get.isRegistered<ListingInputController>()) {
        _listingInputController = Get.find<ListingInputController>();
        print('✅ VehicleEssentialDetails: Found existing controller');
      } else {
        print('🚨 VehicleEssentialDetails: Controller not registered, creating permanent instance');
        _listingInputController = Get.put(ListingInputController(), permanent: true);
      }
    } catch (e) {
      print('🚨 VehicleEssentialDetails: Error accessing controller: $e');
      _listingInputController = Get.put(ListingInputController(), permanent: true);
    }
    
    vehicleTypes = vehicleTypeData.map((data) => 
      SelectTypeItem(title: data['title'], icon: data['icon'])
    ).toList();
    
    print('🚀 VehicleEssentialDetails initState() called');
    print('📊 Controller state at init:');
    print('   📝 mainCategory: "${_listingInputController.mainCategory.value}"');
    print('   🚗 subCategory: "${_listingInputController.subCategory.value}"');
    print('   🖼️ images count: ${_listingInputController.listingImage.value.length}');
    print('   📋 title: "${_listingInputController.title.value}"');
    print('   💰 price: "${_listingInputController.price.value}"');
    print('   📍 location: "${_listingInputController.location.value}"');
    print('   📝 description: "${_listingInputController.description.value}"');
    print('   🚗 make: "${_listingInputController.make.value}"');
    print('   🚗 model: "${_listingInputController.model.value}"');
    print('   🚗 year: "${_listingInputController.year.value}"');
    
    // 🔄 LOAD EXISTING DATA: Pre-populate fields when returning from review
    _loadExistingData();
    
    // Add listeners for validation
    _addValidationListeners();
    
    // Listen to make controller changes to update model options
    makeController.addListener(_updateModelOptions);
    
    // Debug controller changes
    ever(_listingInputController.title, (value) {
      print('🔄 VehicleEssentialDetails: title changed to "$value"');
    });
    ever(_listingInputController.price, (value) {
      print('🔄 VehicleEssentialDetails: price changed to "$value"');
    });
    ever(_listingInputController.location, (value) {
      print('🔄 VehicleEssentialDetails: location changed to "$value"');
    });
  }
  
  void _loadExistingData() {
    print('🔄 _loadExistingData() called');
    print('📊 BEFORE loading - Controller state:');
    print('   📝 mainCategory: "${_listingInputController.mainCategory.value}"');
    print('   🚗 subCategory: "${_listingInputController.subCategory.value}"');
    print('   🖼️ images: ${_listingInputController.listingImage.value}');
    print('   📋 title: "${_listingInputController.title.value}"');
    print('   🏭 make: "${_listingInputController.make.value}"');
    print('   🚙 model: "${_listingInputController.model.value}"');
    
    // 🔄 Load existing data from shared controller
    if (_listingInputController.title.value.isNotEmpty) {
      titleController.text = _listingInputController.title.value;
      print('✅ Title loaded: "${titleController.text}"');
    }
    if (_listingInputController.price.value > 0) {
      priceController.text = _listingInputController.price.value.toString();
      print('✅ Price loaded: "${priceController.text}"');
    }
    if (_listingInputController.location.value.isNotEmpty) {
      print('✅ Location loaded: "${_listingInputController.location.value}"');
    }
    if (_listingInputController.description.value.isNotEmpty) {
      descriptionController.text = _listingInputController.description.value;
      print('✅ Description loaded: "${descriptionController.text}"');
    }
    if (_listingInputController.condition.value.isNotEmpty) {
      conditionController.text = _listingInputController.condition.value;
      print('✅ Condition loaded: "${conditionController.text}"');
    }
    if (_listingInputController.make.value.isNotEmpty) {
      makeController.text = _listingInputController.make.value;
      print('✅ Make loaded: "${makeController.text}"');
    }
    if (_listingInputController.model.value.isNotEmpty) {
      modelController.text = _listingInputController.model.value;
      print('✅ Model loaded: "${modelController.text}"');
    }
    if (_listingInputController.year.value > 0) {
      yearController.text = _listingInputController.year.value.toString();
      print('✅ Year loaded: "${yearController.text}"');
    }
    
    // 🚗 CRITICAL FIX: Load vehicle type from subCategory (not mainCategory)
    print('🚗 Attempting to load vehicle type from subCategory...');
    if (_listingInputController.subCategory.value.isNotEmpty) {
      final subCategory = _listingInputController.subCategory.value.toUpperCase();
      print('🚗 Found subCategory: "$subCategory"');
      
      // Map subcategory to vehicle type display name
      String vehicleTypeDisplay = '';
      switch (subCategory) {
        case 'CARS':
          vehicleTypeDisplay = 'cars'.tr;
          _listingInputController.subCategory.value = 'CARS';
          break;
        case 'MOTORCYCLES':
          vehicleTypeDisplay = 'motorcycles'.tr;
          _listingInputController.subCategory.value = 'MOTORCYCLES';
          break;
        case 'PASSENGER_VEHICLES':
          vehicleTypeDisplay = 'passenger_vehicles'.tr;
          _listingInputController.subCategory.value = 'PASSENGER_VEHICLES';
          break;
        case 'COMMERCIAL_TRANSPORT':
          vehicleTypeDisplay = 'commercial_transport'.tr;
          _listingInputController.subCategory.value = 'COMMERCIAL_TRANSPORT';
          break;
        case 'CONSTRUCTION_VEHICLES':
          vehicleTypeDisplay = 'construction_vehicles'.tr;
          _listingInputController.subCategory.value = 'CONSTRUCTION_VEHICLES';
          break;
        default:
          print('❌ Unknown subCategory: "$subCategory"');
      }
      
      if (vehicleTypeDisplay.isNotEmpty) {
        selectedVehicleType = vehicleTypeDisplay;
        final index = vehicleTypes.indexWhere(
          (type) => type.title == vehicleTypeDisplay
        );
        if (index != -1) {
          selectedIndex = index;
          print('✅ Vehicle type restored: $vehicleTypeDisplay (index: $index)');
        } else {
          print('❌ Vehicle type index not found for: $vehicleTypeDisplay');
        }
      }
    } else {
      print('❌ No subCategory found in controller');
    }
    
    // 🖼️ CRITICAL FIX: Load existing images
    print('🖼️ Attempting to load existing images...');
    final existingImages = _listingInputController.listingImage.value;
    print('🖼️ Controller has ${existingImages.length} image paths: $existingImages');
    
    if (existingImages.isNotEmpty) {
      _images.clear();
      for (String imagePath in existingImages) {
        _images.add(XFile(imagePath));
        print('🖼️ Added image: $imagePath');
      }
      print('✅ Images restored: ${_images.length} images loaded');
    } else {
      print('❌ No images found in controller');
    }
    
    print('📊 AFTER loading - Local state:');
    print('   🚗 selectedVehicleType: "$selectedVehicleType"');
    print('   📍 selectedIndex: $selectedIndex');
    print('   🖼️ _images count: ${_images.length}');
  }

  void _addValidationListeners() {
    titleController.addListener(() {
      // Always call setState when showValidation is true to update hasError condition
      if (widget.showValidation) setState(() {});
      // 🔄 SYNC: Update controller with current value
      _listingInputController.title.value = titleController.text;
    });
    makeController.addListener(() {
      // Always call setState when showValidation is true to update hasError condition
      if (widget.showValidation) setState(() {});
      // 🔄 SYNC: Update controller with current value
      _listingInputController.make.value = makeController.text;
    });
    modelController.addListener(() {
      // Always call setState when showValidation is true to update hasError condition
      if (widget.showValidation) setState(() {});
      // 🔄 SYNC: Update controller with current value
      _listingInputController.model.value = modelController.text;
    });
    yearController.addListener(() {
      // Always call setState when showValidation is true to update hasError condition
      if (widget.showValidation) setState(() {});
      // 🔄 SYNC: Update controller with current value
      if (yearController.text.isNotEmpty) {
        _listingInputController.year.value = int.tryParse(yearController.text) ?? 0;
      }
    });
    priceController.addListener(() {
      // Always call setState when showValidation is true to update hasError condition
      if (widget.showValidation) setState(() {});
      // 🔄 SYNC: Update controller with current value
      if (priceController.text.isNotEmpty) {
        _listingInputController.price.value = int.tryParse(priceController.text) ?? 0;
      }
    });
    descriptionController.addListener(() {
      // Always call setState when showValidation is true to update hasError condition
      if (widget.showValidation) setState(() {});
      // 🔄 SYNC: Update controller with current value
      _listingInputController.description.value = descriptionController.text;
    });
    conditionController.addListener(() {
      _listingInputController.condition.value = conditionController.text;
      if (widget.showValidation) {
        widget.onValidationChanged(validateForm());
      }
    });
  }

  void _updateModelOptions() {
    final selectedMake = makeController.text;
    if (selectedMake.isNotEmpty && VehicleData.makeToModels.containsKey(selectedMake)) {
      setState(() {
        modelOptions = VehicleData.makeToModels[selectedMake]!;
        // Clear model selection if make changes
        if (modelController.text.isNotEmpty && 
            !modelOptions.contains(modelController.text)) {
          modelController.clear();
        }
      });
    } else {
      setState(() {
        modelOptions = [];
        modelController.clear();
      });
    }
  }

  Future<void> _pickImage() async {
    if (_images.length >= 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('max_20_images_allowed'.tr),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      print('🖼️ _pickImage() called');
      print('🖼️ Current images count: ${_images.length}');
      
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        print('🖼️ User picked ${pickedFiles.length} new images');
        
        setState(() {
          // Add new images but don't exceed 20 total
          int remainingSlots = 20 - _images.length;
          List<XFile> newImages = pickedFiles.take(remainingSlots).toList();
          _images.addAll(newImages);
          
          // CRITICAL FIX: Update the ListingInputController with image paths
          List<String> imagePaths = _images.map((image) => image.path).toList();
          _listingInputController.listingImage.value = imagePaths;
          
          print('✅ Images added: ${newImages.length}, Total: ${_images.length}');
          print('✅ Controller updated with ${imagePaths.length} image paths');
          print('🖼️ Image paths: $imagePaths');
        });
      } else {
        print('❌ No images were picked');
      }
    } catch (e) {
      print('❌ Error picking images: $e');
      debugPrint('Error picking images: $e');
    }
  }

  bool validateForm() {
    widget.onValidationChanged(true);
    
    bool isValid = widget.formKey.currentState?.validate() ?? false;
    bool makeSelected = makeController.text.isNotEmpty;
    bool modelSelected = modelController.text.isNotEmpty;
    bool yearSelected = yearController.text.isNotEmpty;
    bool conditionSelected = conditionController.text.isNotEmpty;
    
    if (!isValid || !makeSelected || !modelSelected || !yearSelected || !conditionSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('fill_all_fields_prompt'.tr),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    
    if (selectedIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('select_vehicle_type_prompt'.tr),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('add_at_least_one_image_prompt'.tr),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    
    return true;
  }

  void _onVehicleTypeSelected(int index) {
    setState(() {
      selectedIndex = index;
      selectedVehicleType = vehicleTypes[index].title;
      
      // 🔧 CRITICAL FIX: Use translation key instead of translated text for backend
      String translationKey = vehicleTypeData[index]['key'];
      _listingInputController.subCategory.value = translationKey.replaceAll(' ', '_').toUpperCase();
      
      print('🚗 Vehicle type selected: $selectedVehicleType (Display)');
      print('🔑 Translation key used: $translationKey');
      print('📊 Controller subCategory updated to: ${_listingInputController.subCategory.value}');
      
      // Validate form after selection
      bool isValid = validateForm();
      widget.onValidationChanged(isValid);
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    makeController.dispose();
    modelController.dispose();
    yearController.dispose();
    priceController.dispose();

    descriptionController.dispose();
    conditionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Obx(() => SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          TweenAnimationBuilder<double>(
            duration: Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.9 + (0.1 * value),
                child: Opacity(
                  opacity: value,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo.shade600, Colors.blue.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.withOpacity(0.4),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.directions_car_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          "essential_details".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.055,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 16),
          
          SelectType(
            items: vehicleTypes,
            selectedIndex: selectedIndex,
            onItemSelected: _onVehicleTypeSelected,
            hasError: widget.showValidation && selectedIndex == -1,
          ),
          
          SizedBox(height: 24),
          
          // Modern Listing Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.purple.shade400, Colors.purple.shade600],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.sell_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "listing_action".tr,
                      style: TextStyle(
                        color: _themeController.isDarkMode.value ? Colors.white : blackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.05,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Obx(() => Column(
                  children: [
                    Row(
                      children: [
                        // For Sale Button (Green) - Enhanced
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _listingInputController.listingAction.value = 'FOR_SALE';
                              print('🚗 Vehicle listing action set to: FOR_SALE');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                gradient: _listingInputController.listingAction.value == 'FOR_SALE'
                                    ? LinearGradient(
                                        colors: [Colors.green.shade500, Colors.green.shade700],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      )
                                    : null,
                                color: _listingInputController.listingAction.value == 'FOR_SALE'
                                    ? null
                                    : Colors.green.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.green.shade600,
                                  width: 2.5,
                                ),
                                boxShadow: _listingInputController.listingAction.value == 'FOR_SALE'
                                    ? [
                                        BoxShadow(
                                          color: Colors.green.withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.monetization_on,
                                    color: _listingInputController.listingAction.value == 'FOR_SALE'
                                        ? Colors.white
                                        : Colors.green.shade700,
                                    size: 22,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'to_sale'.tr,
                                    style: TextStyle(
                                      color: _listingInputController.listingAction.value == 'FOR_SALE'
                                          ? Colors.white
                                          : Colors.green.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        // For Rent Button (Red) - Enhanced
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _listingInputController.listingAction.value = 'FOR_RENT';
                              print('🚗 Vehicle listing action set to: FOR_RENT');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                gradient: _listingInputController.listingAction.value == 'FOR_RENT'
                                    ? LinearGradient(
                                        colors: [Colors.red.shade500, Colors.red.shade700],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      )
                                    : null,
                                color: _listingInputController.listingAction.value == 'FOR_RENT'
                                    ? null
                                    : Colors.red.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.red.shade600,
                                  width: 2.5,
                                ),
                                boxShadow: _listingInputController.listingAction.value == 'FOR_RENT'
                                    ? [
                                        BoxShadow(
                                          color: Colors.red.withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.key,
                                    color: _listingInputController.listingAction.value == 'FOR_RENT'
                                        ? Colors.white
                                        : Colors.red.shade700,
                                    size: 22,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'to_rent'.tr,
                                    style: TextStyle(
                                      color: _listingInputController.listingAction.value == 'FOR_RENT'
                                          ? Colors.white
                                          : Colors.red.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    // Searching Button (Blue) - Enhanced
                    GestureDetector(
                      onTap: () {
                        _listingInputController.listingAction.value = 'SEARCHING';
                        print('🚗 Vehicle listing action set to: SEARCHING');
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          gradient: _listingInputController.listingAction.value == 'SEARCHING'
                              ? LinearGradient(
                                  colors: [Colors.blue.shade500, Colors.blue.shade700],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                )
                              : null,
                          color: _listingInputController.listingAction.value == 'SEARCHING'
                              ? null
                              : Colors.blue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.blue.shade600,
                            width: 2.5,
                          ),
                          boxShadow: _listingInputController.listingAction.value == 'SEARCHING'
                              ? [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_outlined,
                              color: _listingInputController.listingAction.value == 'SEARCHING'
                                  ? Colors.white
                                  : Colors.blue.shade700,
                              size: 22,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'search'.tr,
                              style: TextStyle(
                                color: _listingInputController.listingAction.value == 'SEARCHING'
                                    ? Colors.white
                                    : Colors.blue.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
                if (widget.showValidation && _listingInputController.listingAction.value.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "select_listing_action".tr,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          SizedBox(height: 32),
          
          BuildInput(
            title: "title".tr, 
            label: "title".tr, 
            textController: titleController,
            validator: (value) {
              if(value!.isEmpty) {
                return "title_is_required".tr;
              }
              return null;
            },
            hasError: widget.showValidation && titleController.text.trim().isEmpty,
          ),
          
          BuildInputWithOptions(
            title: "make".tr,
            controller: makeController,
            options: VehicleData.makes,
            hasError: widget.showValidation && makeController.text.trim().isEmpty,
          ),
          
          BuildInputWithOptions(
            title: "model".tr,
            controller: modelController,
            options: modelOptions.isNotEmpty ? modelOptions : ["select_make_first".tr],
            hasError: widget.showValidation && modelController.text.trim().isEmpty,
          ),
          
          BuildInputWithOptions(
            title: "year".tr,
            controller: yearController,
            options: List<String>.generate(
              DateTime.now().year - 1989, (i) => (DateTime.now().year - i).toString()),
            hasError: widget.showValidation && yearController.text.trim().isEmpty,
          ),
          
          const SizedBox(height: 16.0),
          
          BuildInputWithOptions(
            title: "condition".tr,
            controller: conditionController,
            options: ['new'.tr, 'used'.tr, 'reconditioned'.tr],
            hasError: widget.showValidation && conditionController.text.trim().isEmpty,
          ),
          
          // Seller Type Dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => DropdownButtonFormField<String>(
                  value: _listingInputController.sellerType.value.isEmpty 
                      ? null 
                      : _listingInputController.sellerType.value,
                  decoration: InputDecoration(
                    hintText: "sellerTypeHint".tr,
                    hintStyle: TextStyle(
                      color: _themeController.isDarkMode.value ? Colors.grey[400] : Colors.grey[600],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: widget.showValidation && _listingInputController.sellerType.value.isEmpty 
                            ? Colors.red 
                            : (_themeController.isDarkMode.value ? Colors.grey[600]! : Colors.grey),
                        width: widget.showValidation && _listingInputController.sellerType.value.isEmpty 
                            ? 2.0 
                            : 1.0,
                      ),
                    ),
                    fillColor: _themeController.isDarkMode.value ? Colors.grey[800] : Colors.white,
                    filled: true,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'owner', 
                      child: Text(
                        'owner'.tr,
                        style: TextStyle(
                          color: _themeController.isDarkMode.value ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'broker', 
                      child: Text(
                        'broker'.tr,
                        style: TextStyle(
                          color: _themeController.isDarkMode.value ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'business_firm', 
                      child: Text(
                        'business_firm'.tr,
                        style: TextStyle(
                          color: _themeController.isDarkMode.value ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      _listingInputController.sellerType.value = value;
                      print('🏢 Seller type selected: $value');
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "field_is_required".tr;
                    }
                    return null;
                  },
                )),
                if (widget.showValidation && _listingInputController.sellerType.value.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "field_is_required".tr,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          LocationField(
            label: "location".tr,
            showValidationError: widget.showValidation && _listingInputController.location.value.trim().isEmpty,
          ),
          
          const SizedBox(height: 16.0),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\u0660-\u0669]')),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "price_is_required".tr;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "price".tr,
                    labelStyle: TextStyle(
                      color: _themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[700],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: widget.showValidation && priceController.text.trim().isEmpty 
                            ? Colors.red 
                            : (_themeController.isDarkMode.value ? Colors.grey[600]! : Colors.grey),
                        width: widget.showValidation && priceController.text.trim().isEmpty ? 2.0 : 1.0,
                      ),
                    ),
                    fillColor: _themeController.isDarkMode.value ? Colors.grey[800] : Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: widget.showValidation && priceController.text.trim().isEmpty ? Colors.red : blueColor,
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          BuildMultilineInput(
            title: "description".tr, 
            label: "description".tr, 
            controller: descriptionController,
            validator: (value) {
              if(value == null || value.trim().isEmpty) {
                return "description_is_required".tr;
              }
              return null;
            },
            hasError: widget.showValidation && descriptionController.text.trim().isEmpty,
          ),
          
          SizedBox(height: 24),
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _themeController.isDarkMode.value ? Colors.grey[800] : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _themeController.isDarkMode.value ? Colors.grey[600]! : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.photo_camera_outlined,
                  color: Colors.purple.shade700,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  "add_pictures".tr,
                  style: TextStyle(
                    color: _themeController.isDarkMode.value ? Colors.purple[300] : Colors.purple.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.048,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          
          // Image picker section
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(
                color: _themeController.isDarkMode.value ? Colors.grey[600]! : Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _images.isEmpty 
              ? GestureDetector(
                  onTap: _pickImage,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate, 
                        size: 50, 
                        color: _themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[400],
                      ),
                      SizedBox(height: 8),
                      Text(
                        "tap_to_add_images".tr, 
                        style: TextStyle(
                          color: _themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[600],
                        ),
                      ),
                      Text(
                        "max_20_images".tr, 
                        style: TextStyle(
                          color: _themeController.isDarkMode.value ? Colors.grey[400] : Colors.grey[500], 
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _images.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _images.length) {
                      return GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _themeController.isDarkMode.value ? Colors.grey[600]! : Colors.grey[300]!,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.add, 
                            color: _themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[400],
                          ),
                        ),
                      );
                    }
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(File(_images[index].path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _images.removeAt(index);
                                
                                // CRITICAL FIX: Update the ListingInputController when removing images
                                List<String> imagePaths = _images.map((image) => image.path).toList();
                                _listingInputController.listingImage.value = imagePaths;
                                
                                print('🖼️ Image removed, Total: ${_images.length}');
                                print('🖼️ Controller updated with ${imagePaths.length} image paths');
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.close, color: Colors.white, size: 16),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
          ),
        ],
        ),
      ),
    ));
  }
}
