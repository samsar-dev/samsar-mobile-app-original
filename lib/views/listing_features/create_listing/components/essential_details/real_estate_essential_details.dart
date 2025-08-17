import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/features/location_controller.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/controllers/features/theme_controller.dart';
import 'package:samsar/widgets/build_input/build_input.dart';
import 'package:samsar/widgets/select_type/select_type.dart';

import 'package:samsar/widgets/build_multi_line_input/build_multi_line_input.dart';
import 'package:samsar/widgets/location/location_field.dart';

class RealEstateEssentialDetails extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final bool showValidation;
  final ValueChanged<bool> onValidationChanged;

  const RealEstateEssentialDetails({
    super.key,
    required this.formKey,
    required this.showValidation,
    required this.onValidationChanged,
  });

  @override
  State<RealEstateEssentialDetails> createState() => _RealEstateEssentialDetailsState();
}

class _RealEstateEssentialDetailsState extends State<RealEstateEssentialDetails> {
  // Note: ListingInputController will be accessed from parent wrapper
  final LocationController _locationController = Get.put(LocationController());
  late final ListingInputController _listingInputController;
  late final ThemeController _themeController;
  
  // Form controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  late TextEditingController locationController;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController bedroomsController = TextEditingController();
  final TextEditingController bathroomsController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  
  // Property condition
  String selectedCondition = "";
  
  // Property type selection
  String selectedPropertyType = "";
  int selectedIndex = -1;
  
  // Image picker
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();
  
  // Property types with professional icons
  final List<SelectTypeItem> propertyTypes = [
    SelectTypeItem(title: 'apartment'.tr, icon: Icons.apartment_outlined),
    SelectTypeItem(title: 'house'.tr, icon: Icons.home_outlined),
    SelectTypeItem(title: 'villa'.tr, icon: Icons.villa_outlined),
    SelectTypeItem(title: 'office'.tr, icon: Icons.business_center_outlined),
    SelectTypeItem(title: 'land'.tr, icon: Icons.terrain_outlined),
    SelectTypeItem(title: 'store'.tr, icon: Icons.storefront_outlined),
  ];

  // Listing action options - map display values to backend values
  final Map<String, String> listingActions = {
    'to_sale': 'for_sale'.tr,
    'to_rent': 'for_rent'.tr,
    'search': 'searching'.tr,
  };
  final TextEditingController listingActionController = TextEditingController();
  
  // Property condition options
  final List<Map<String, String>> conditionOptions = [
    {'key': 'new', 'title': 'property_condition_new'.tr},
    {'key': 'renovated', 'title': 'property_condition_renovated'.tr},
    {'key': 'needs_renovation', 'title': 'property_condition_needs_renovation'.tr},
  ];

  @override
  void initState() {
    super.initState();
    _themeController = Get.put(ThemeController());
    
    // BULLETPROOF CONTROLLER ACCESS
    try {
      if (Get.isRegistered<ListingInputController>()) {
        _listingInputController = Get.find<ListingInputController>();
        print('✅ RealEstateEssentialDetails: Found existing controller');
      } else {
        print('🚨 RealEstateEssentialDetails: Controller not registered, creating permanent instance');
        _listingInputController = Get.put(ListingInputController(), permanent: true);
      }
    } catch (e) {
      print('🚨 RealEstateEssentialDetails: Error accessing controller: $e');
      _listingInputController = Get.put(ListingInputController(), permanent: true);
    }
    
    locationController = TextEditingController(text: _locationController.address.value);
    
    print('🏠 RealEstateEssentialDetails initState() called');
    print('📊 Controller state at init:');
    print('   📝 mainCategory: "${_listingInputController.mainCategory.value}"');
    print('   🏢 subCategory: "${_listingInputController.subCategory.value}"');
    print('   🖼️ images count: ${_listingInputController.listingImage.length}');
    print('   📋 title: "${_listingInputController.title.value}"');
    print('   💰 price: "${_listingInputController.price.value}"');
    print('   📍 location: "${_listingInputController.location.value}"');
    print('   📝 description: "${_listingInputController.description.value}"');
    
    // 🔄 LOAD EXISTING DATA: Pre-populate fields when returning from review
    _loadExistingData();
    
    // Add listeners for validation
    _addValidationListeners();
    
    // Debug controller changes
    ever(_listingInputController.title, (value) {
      print('🔄 RealEstateEssentialDetails: title changed to "$value"');
    });
    ever(_listingInputController.price, (value) {
      print('🔄 RealEstateEssentialDetails: price changed to "$value"');
    });
    ever(_listingInputController.location, (value) {
      print('🔄 RealEstateEssentialDetails: location changed to "$value"');
    });
  }
  
  void _loadExistingData() {
    // 🔄 Load existing data from shared controller
    if (_listingInputController.title.value.isNotEmpty) {
      titleController.text = _listingInputController.title.value;
    }
    if (_listingInputController.price.value > 0) {
      priceController.text = _listingInputController.price.value.toString();
    }
    if (_listingInputController.location.value.isNotEmpty) {
      locationController.text = _listingInputController.location.value;
    }
    if (_listingInputController.description.value.isNotEmpty) {
      descriptionController.text = _listingInputController.description.value;
    }
    
    // Load property type if saved (using mainCategory for property type)
    if (_listingInputController.mainCategory.value.isNotEmpty) {
      selectedPropertyType = _listingInputController.mainCategory.value;
      // Ensure main category is in UPPERCASE for backend
      _listingInputController.mainCategory.value = selectedPropertyType.toUpperCase();
      
      // Define the keys in the same order as the propertyTypes list
      final propertyTypeKeys = ['APARTMENT', 'HOUSE', 'VILLA', 'OFFICE', 'LAND', 'STORE'];
      final index = propertyTypeKeys.indexWhere((key) => key == selectedPropertyType.toUpperCase());

      if (index != -1) {
        selectedIndex = index;
        // The selectedPropertyType from the controller is correct, just ensure the UI is updated
        // The `propertyTypes` list already uses .tr, so the UI will be translated correctly
      }
    }
    
    // Load subCategory for listing action (For Sale/For Rent)
    if (_listingInputController.subCategory.value.isNotEmpty) {
      // Ensure listing action is in UPPERCASE for backend
      final action = _listingInputController.subCategory.value.toUpperCase();
      _listingInputController.subCategory.value = action;
      // Set display value with proper case
      listingActionController.text = action == 'FOR_SALE' ? 'for_sale'.tr : 'for_rent'.tr;
    }
    
    // Load property condition if saved
    if (_listingInputController.condition.value.isNotEmpty) {
      selectedCondition = _listingInputController.condition.value;
    }
  }
  
  void _addValidationListeners() {
    titleController.addListener(() {
      // Always call setState when showValidation is true to update hasError condition
      if (widget.showValidation) setState(() {});
      // SYNC: Update controller with current value
      _listingInputController.title.value = titleController.text;
    });
    listingActionController.addListener(() {
      if (widget.showValidation) setState(() {});
      // SYNC: Update controller with current value (if needed)
    });
    priceController.addListener(() {
      // Always call setState when showValidation is true to update hasError condition
      if (widget.showValidation) setState(() {});
      // SYNC: Update controller with current value
      if (priceController.text.isNotEmpty) {
        _listingInputController.price.value = int.tryParse(priceController.text) ?? 0;
      }
    });
    locationController.addListener(() {
      if (widget.showValidation) setState(() {});
      // SYNC: Update controller with current value
      _listingInputController.location.value = locationController.text;
    });
    bedroomsController.addListener(() {
      if (widget.showValidation) setState(() {});
      // SYNC: Update controller with current value (if needed for real estate)
    });
    bathroomsController.addListener(() {
      if (widget.showValidation) setState(() {});
      // SYNC: Update controller with current value (if needed for real estate)
    });
    areaController.addListener(() {
      if (widget.showValidation) setState(() {});
      // SYNC: Update controller with current value (if needed for real estate)
    });
    descriptionController.addListener(() {
      if (widget.showValidation) setState(() {});
      // SYNC: Update controller with current value
      _listingInputController.description.value = descriptionController.text;
    });
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
      final List<XFile> pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        setState(() {
          int remainingSlots = 20 - _images.length;
          _images.addAll(pickedFiles.take(remainingSlots));
        });
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  bool validateForm() {
    widget.onValidationChanged(true);
    
    bool isValid = widget.formKey.currentState?.validate() ?? false;
    bool listingActionSelected = listingActionController.text.isNotEmpty;
    
    if (!isValid || !listingActionSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('fill_required_fields'.tr),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    
    if (selectedIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('select_property_type'.tr),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    
    if (_images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('add_at_least_one_image'.tr),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    
    return true;
  }

  // Helper methods for dynamic field visibility


  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    bedroomsController.dispose();
    bathroomsController.dispose();
    areaController.dispose();
    listingActionController.dispose();
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
                          colors: [Colors.deepOrange.shade600, Colors.orange.shade700],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepOrange.withOpacity(0.4),
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
                              Icons.home_work_rounded,
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
            
            
            TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 600),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: SelectType(
                      items: propertyTypes,
                      selectedIndex: selectedIndex,
                      onItemSelected: (index) {
                        setState(() {
                          selectedIndex = index;
                          selectedPropertyType = propertyTypes[index].title;
                          // Save property type to controller immediately
                          _listingInputController.mainCategory.value = selectedPropertyType.toUpperCase();
                        });
                        print('🏠 Property type selected: $selectedPropertyType');
                        print('📝 Updated mainCategory to: ${_listingInputController.mainCategory.value}');
                      },
                      hasError: widget.showValidation && selectedIndex == -1,
                    ),
                  ),
                );
              },
            ),
            
           
            
            // Modern Listing Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "listing_action".tr,
                    style: TextStyle(
                      color: _themeController.isDarkMode.value ? Colors.white : blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  SizedBox(height: 12),
                  Obx(() {
                    final listingAction = _listingInputController.listingAction.value;
                    return Column(
                      children: [
                        Row(
                          children: [
                            // For Sale Button - Enhanced
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _listingInputController.listingAction.value = 'FOR_SALE';
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 18),
                                  decoration: BoxDecoration(
                                    gradient: listingAction == 'FOR_SALE'
                                        ? LinearGradient(
                                            colors: [Colors.green.shade500, Colors.green.shade700],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          )
                                        : null,
                                    color: listingAction == 'FOR_SALE'
                                        ? null
                                        : Colors.green.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.green.shade600,
                                      width: 2.5,
                                    ),
                                    boxShadow: listingAction == 'FOR_SALE'
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
                                        color: listingAction == 'FOR_SALE'
                                            ? Colors.white
                                            : Colors.green.shade700,
                                        size: 22,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'for_sale'.tr,
                                        style: TextStyle(
                                          color: listingAction == 'FOR_SALE'
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
                            SizedBox(width: 12),
                            // For Rent Button - Enhanced
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _listingInputController.listingAction.value = 'FOR_RENT';
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 18),
                                  decoration: BoxDecoration(
                                    gradient: listingAction == 'FOR_RENT'
                                        ? LinearGradient(
                                            colors: [Colors.red.shade500, Colors.red.shade700],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          )
                                        : null,
                                    color: listingAction == 'FOR_RENT'
                                        ? null
                                        : Colors.red.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Colors.red.shade600,
                                      width: 2.5,
                                    ),
                                    boxShadow: listingAction == 'FOR_RENT'
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
                                        color: listingAction == 'FOR_RENT'
                                            ? Colors.white
                                            : Colors.red.shade700,
                                        size: 22,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'for_rent'.tr,
                                        style: TextStyle(
                                          color: listingAction == 'FOR_RENT'
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
                      ],
                    );
                  }),
                  SizedBox(height: 12),
                  // Searching Button
                  Obx(() {
                    final listingAction = _listingInputController.listingAction.value;
                    return GestureDetector(
                      onTap: () {
                        _listingInputController.listingAction.value = 'SEARCHING';
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        decoration: BoxDecoration(
                          gradient: listingAction == 'SEARCHING'
                              ? LinearGradient(
                                  colors: [Colors.blue.shade500, Colors.blue.shade700],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                )
                              : null,
                          color: listingAction == 'SEARCHING'
                              ? null
                              : Colors.blue.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.blue.shade600,
                            width: 2.5,
                          ),
                          boxShadow: listingAction == 'SEARCHING'
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
                              color: listingAction == 'SEARCHING'
                                  ? Colors.white
                                  : Colors.blue.shade700,
                              size: 22,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'searching'.tr,
                              style: TextStyle(
                                color: listingAction == 'SEARCHING'
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
                    );
                  }),
                  Obx(() {
                    final listingAction = _listingInputController.listingAction.value;
                    return widget.showValidation && listingAction.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "select_listing_action".tr,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : SizedBox.shrink();
                  }),
                ],
              ),
            ),
            SizedBox(height: 24),
             SizedBox(height: 32),
            
            TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 400),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: BuildInput(
                      title: "title".tr, 
                      label: "title".tr, 
                      textController: titleController,
                      validator: (value) {
                        if(value!.isEmpty) {
                          return "title_required".tr;
                        }
                        return null;
                      },
                      hasError: widget.showValidation && titleController.text.trim().isEmpty,
                    ),
                  ),
                );
              },
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
                      hintText: "select_seller_type".tr,
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
            
          
            
            Obx(() {
              final location = _listingInputController.location.value;
              return LocationField(
                label: "location".tr,
                hintText: "select_property_location".tr,
                isRequired: true,
                showValidationError: widget.showValidation && location.trim().isEmpty,
                onLocationChanged: () {
                  // Update local controller when location changes
                  locationController.text = location;
                },
              );
            }),

             
            
            // Property Condition Dropdown - Hide for Land category
            Obx(() {
              final propertyType = _listingInputController.mainCategory.value.toLowerCase();
              final shouldShowCondition = propertyType != 'land';
              return shouldShowCondition
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            value: selectedCondition.isEmpty ? null : selectedCondition,
                            decoration: InputDecoration(
                              hintText: "select_property_condition".tr,
                              hintStyle: TextStyle(
                                color: _themeController.isDarkMode.value ? Colors.grey[400] : Colors.grey[600],
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: widget.showValidation && selectedCondition.isEmpty 
                                      ? Colors.red 
                                      : (_themeController.isDarkMode.value ? Colors.grey[600]! : Colors.grey),
                                  width: widget.showValidation && selectedCondition.isEmpty 
                                      ? 2.0 
                                      : 1.0,
                                ),
                              ),
                              fillColor: _themeController.isDarkMode.value ? Colors.grey[800] : Colors.white,
                              filled: true,
                            ),
                            items: conditionOptions.map((condition) {
                              return DropdownMenuItem(
                                value: condition['key'],
                                child: Text(
                                  condition['title']!,
                                  style: TextStyle(
                                    color: _themeController.isDarkMode.value ? Colors.white : Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedCondition = value;
                                });
                                _listingInputController.condition.value = value;
                                print('🏗️ Property condition selected: $value');
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "field_is_required".tr;
                              }
                              return null;
                            },
                          ),
                          if (widget.showValidation && selectedCondition.isEmpty)
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
                          SizedBox(height: 16),
                        ],
                      ),
                    )
                  : SizedBox.shrink();
            }),
            
            // Show bedrooms and bathrooms only for Apartment and House
            Obx(() {
              final propertyType = _listingInputController.mainCategory.value.toLowerCase();
              final shouldShow = propertyType == 'apartment' || propertyType == 'house';
              return shouldShow
                  ? Container(
                      child: Column(
                        children: [
                          BuildInput(
                            title: "bedrooms".tr,
                            label: "number_of_bedrooms".tr,
                            textController: bedroomsController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "bedrooms_required".tr;
                              }
                              return null;
                            },
                            hasError: widget.showValidation &&
                                bedroomsController.text.trim().isEmpty,
                          ),
                          BuildInput(
                            title: "bathrooms".tr,
                            label: "number_of_bathrooms".tr,
                            textController: bathroomsController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "bathrooms_required".tr;
                              }
                              return null;
                            },
                            hasError: widget.showValidation &&
                                bathroomsController.text.trim().isEmpty,
                          ),
                        ],
                      ),
                    )
                  : SizedBox.shrink();
            }),
            
            Obx(() {
              final propertyType = _listingInputController.mainCategory.value.toLowerCase();
              String areaTitle;
              String areaLabel;
              
              switch (propertyType) {
                case 'land':
                  areaTitle = 'land_area_sqft'.tr;
                  areaLabel = 'land_area_description'.tr;
                  break;
                case 'office':
                  areaTitle = 'office_space_sqft'.tr;
                  areaLabel = 'office_space_description'.tr;
                  break;
                case 'apartment':
                case 'house':
                default:
                  areaTitle = 'area_sqft'.tr;
                  areaLabel = 'property_area_description'.tr;
                  break;
              }
              
              return BuildInput( 
              title: areaTitle, 
              label: areaLabel, 
              textController: areaController,
              validator: (value) {
                if(value!.isEmpty) {
                  return "area_required".tr;
                }
                return null;
              },
              hasError: widget.showValidation && areaController.text.trim().isEmpty,
            );
            }), 

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
                        return "price_required".tr;
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
                  return "description_required".tr;
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
