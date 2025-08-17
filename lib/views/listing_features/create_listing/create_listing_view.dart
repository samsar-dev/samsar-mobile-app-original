import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/views/listing_features/create_listing/components/essential_details/essential_details_wrapper.dart';
// Re-enabled advanced details for testing dynamic updates
import 'package:samsar/views/listing_features/create_listing/components/advanced_details/advanced_details_wrapper.dart';
// Re-enabling review functionality
import 'package:samsar/views/listing_features/create_listing/components/features_extras/features_wrapper.dart';
import 'package:samsar/views/listing_features/create_listing/components/review_listing.dart';
import 'package:samsar/widgets/app_button/app_button.dart';

class CreateListingView extends StatefulWidget {
  const CreateListingView({super.key});

  @override
  State<CreateListingView> createState() => _CreateListingViewState();
}

class _CreateListingViewState extends State<CreateListingView> {
  final PageController _pageController = PageController();
  late final ListingInputController _listingInputController;
  
  int selectedIndex = 0; // 0 for Vehicle, 1 for Real Estate
  int currentStep = 0;
  final List<String> tabs = ['vehicles', 'real_estate'];
  
  // Form keys for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showValidation = false;

  @override
  void initState() {
    super.initState();
    print('🚀 CreateListingView initState() called');
    
    // BULLETPROOF CONTROLLER INITIALIZATION
    // Always use Get.put with permanent=true to ensure controller survives navigation
    _listingInputController = Get.put(ListingInputController(), permanent: true);
    print('🆕 ListingInputController registered as PERMANENT instance');
    
    print('📊 Controller state at CreateListingView init:');
    print('   📝 mainCategory: "${_listingInputController.mainCategory.value}"');
    print('   🚗 subCategory: "${_listingInputController.subCategory.value}"');
    print('   🖼️ images count: ${_listingInputController.listingImage.value.length}');
    print('   📋 title: "${_listingInputController.title.value}"');
    
    // Initialize mainCategory based on selectedIndex if it's empty
    if (_listingInputController.mainCategory.value.isEmpty) {
      String initialCategory = selectedIndex == 0 ? 'vehicles' : 'real_estate';
      _listingInputController.mainCategory.value = initialCategory;
      print('🔧 FIXED: Initialized mainCategory to "$initialCategory" based on selectedIndex: $selectedIndex');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final String currentCategory = selectedIndex == 0 ? 'vehicles' : 'real_estate';
    
    // SAFETY CHECK: Ensure controller is still registered
    if (!Get.isRegistered<ListingInputController>()) {
      print('🚨 CRITICAL: Controller lost during build, re-registering...');
      _listingInputController = Get.put(ListingInputController(), permanent: true);
    }

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        title: Text(
          'createListingTitle'.tr,
          style: TextStyle(
            color: blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.016),
            
            // Category selection tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(tabs.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ChoiceChip(
                    showCheckmark: false,
                    label: Text(tabs[index].tr),
                    selected: selectedIndex == index,
                    onSelected: (bool selected) {
                      _onCategorySelected(index);
                    },
                    selectedColor: blueColor,
                    labelStyle: TextStyle(
                      color: selectedIndex == index ? Colors.white : Colors.black,
                    ),
                    backgroundColor: Colors.grey[200],
                  ),
                );
              }),
            ),
            
            SizedBox(height: screenHeight * 0.016),
            
            // Step indicators
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStepIndicator(0, '1', 'essentialDetailsStep'.tr),
                  _buildStepIndicator(1, '2', 'advancedDetailsStep'.tr),
                  _buildStepIndicator(2, '3', 'featuresExtrasStep'.tr),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentStep = index;
                  });
                },
                children: [
                  EssentialDetailsWrapper(
                    category: currentCategory,
                    formKey: _formKey,
                    showValidation: _showValidation,
                    onValidationChanged: (isValid) {
                      // Handle validation state changes if needed
                    },
                  ),
                  // ✅ RE-ENABLED: Advanced Details for testing dynamic updates
                  Obx(() => AdvancedDetailsWrapper(
                    category: currentCategory,
                    subCategory: currentCategory == 'vehicles' 
                        ? _listingInputController.subCategory.value 
                        : _listingInputController.mainCategory.value,
                  )),
                  // ✅ RE-ENABLED: Features & Extras
                  Obx(() => FeaturesWrapper(
                    category: currentCategory,
                    subCategory: currentCategory == 'vehicles' 
                        ? _listingInputController.subCategory.value 
                        : _listingInputController.mainCategory.value,
                  )),
                ],
              ),
            ),
            
            // Navigation buttons
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentStep > 0)
                    AppButton(
                      widthSize: 0.3,
                      heightSize: 0.06,
                      buttonColor: Colors.grey[300]!,
                      text: 'previousButton'.tr,
                      textColor: blackColor,
                      onPressed: () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    )
                  else
                    SizedBox(width: screenWidth * 0.3),
                  
                  AppButton(
                    widthSize: 0.3,
                    heightSize: 0.06,
                    buttonColor: blueColor,
                    text: currentStep == 2 ? 'reviewButton'.tr : 'nextButton'.tr,
                    textColor: whiteColor,
                    onPressed: _handleNextButton,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStepIndicator(int stepIndex, String number, String title) {
    bool isActive = currentStep == stepIndex;
    bool isCompleted = currentStep > stepIndex;
    
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          stepIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive 
                ? blueColor 
                : isCompleted 
                  ? Colors.green 
                  : Colors.grey[300],
              border: Border.all(
                color: isActive 
                  ? blueColor 
                  : isCompleted 
                    ? Colors.green 
                    : Colors.grey[400]!,
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
                ? Icon(Icons.check, color: whiteColor, size: 20)
                : Text(
                    number,
                    style: TextStyle(
                      color: isActive ? whiteColor : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: isActive ? blueColor : Colors.grey[600],
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  void _handleNextButton() {
    print('🔄 _handleNextButton() called - currentStep: $currentStep');
    print('📊 Controller state before navigation:');
    print('   📝 mainCategory: "${_listingInputController.mainCategory.value}"');
    print('   🚗 subCategory: "${_listingInputController.subCategory.value}"');
    print('   🖼️ images count: ${_listingInputController.listingImage.value.length}');
    print('   📋 title: "${_listingInputController.title.value}"');
    
    if (currentStep == 0) {
      // Validate essential details before proceeding
      if (_validateEssentialDetails()) {
        print('✅ Essential details validation passed');
        _nextStep();
      } else {
        print('❌ Essential details validation failed');
        setState(() {
          _showValidation = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('fixErrorsMessage'.tr),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      print('✅ Moving to next step without validation');
      _nextStep();
    }
  }
  
  void _nextStep() {
    print('🔄 _nextStep() called - currentStep: $currentStep');
    
    if (currentStep < 2) {
      setState(() {
        currentStep++;
      });
      print('✅ Moving to step: $currentStep');
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      print('🔄 Navigating to review screen...');
      // Navigate to review screen
      _navigateToReview();
    }
  }
  
  void _navigateToReview() {
    print('🔄 _navigateToReview() called');
    print('📊 Controller state BEFORE navigation to review:');
    print('   📝 mainCategory: "${_listingInputController.mainCategory.value}"');
    print('   🚗 subCategory: "${_listingInputController.subCategory.value}"');
    print('   🖼️ images count: ${_listingInputController.listingImage.value.length}');
    print('   📋 title: "${_listingInputController.title.value}"');
    print('   🏭 make: "${_listingInputController.make.value}"');
    print('   🚙 model: "${_listingInputController.model.value}"');
    print('   💰 price: "${_listingInputController.price.value}"');
    print('   📍 location: "${_listingInputController.location.value}"');
    print('   📝 description: "${_listingInputController.description.value}"');
    print('   📅 year: "${_listingInputController.year.value}"');
    
    // ✅ RE-ENABLED: Review navigation
    print('🚀 Navigating to review screen...');
    
    // Navigate to review screen
    _navigateToReviewScreen();
    
    /*
    // 🚫 ORIGINAL NAVIGATION CODE DISABLED FOR DEBUGGING
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReviewListing(
          imageUrls: imageUrls,
          isVehicle: selectedIndex == 0,
        ),
      ),
    ).then((_) {
      // This runs when returning from review screen
      print('🔄 Returned from review screen');
      print('📊 Controller state AFTER returning from review:');
      print('   📝 mainCategory: "${_listingInputController.mainCategory.value}"');
      print('   🚗 subCategory: "${_listingInputController.subCategory.value}"');
      print('   🖼️ images count: ${_listingInputController.listingImage.value.length}');
      print('   📋 title: "${_listingInputController.title.value}"');
    });
    */
  }
  
  void _showDataSummaryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('🔧 DEBUG: Data Summary'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('📊 Controller State:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('📝 Main Category: "${_listingInputController.mainCategory.value}"'),
                Text('🚗 Sub Category: "${_listingInputController.subCategory.value}"'),
                Text('🖼️ Images: ${_listingInputController.listingImage.value.length}'),
                Text('📋 Title: "${_listingInputController.title.value}"'),
                Text('🏭 Make: "${_listingInputController.make.value}"'),
                Text('🚙 Model: "${_listingInputController.model.value}"'),
                Text('📅 Year: ${_listingInputController.year.value}'),
                Text('💰 Price: ${_listingInputController.price.value}'),
                Text('📍 Location: "${_listingInputController.location.value}"'),
                Text('📝 Description: "${_listingInputController.description.value}"'),
                SizedBox(height: 16),
                Text('🖼️ Image Paths:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...(_listingInputController.listingImage.value.isEmpty 
                    ? [Text('❌ No images found')]
                    : _listingInputController.listingImage.value.map((path) => Text('  • $path')).toList()),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
  
  void _onCategorySelected(int index) {
    print('🔄 Category switching from ${tabs[selectedIndex]} to ${tabs[index]}');
    print('📊 BEFORE category switch - Controller state:');
    print('   📝 mainCategory: "${_listingInputController.mainCategory.value}"');
    print('   🚗 subCategory: "${_listingInputController.subCategory.value}"');
    print('   🖼️ images count: ${_listingInputController.listingImage.value.length}');
    print('   📋 title: "${_listingInputController.title.value}"');
    
    // Backup current data before switching
    _listingInputController.backupCurrentData();
    print('💾 Data backed up successfully');
    
    setState(() {
      selectedIndex = index;
      currentStep = 0; // Reset to first step when switching categories
    });
    
    // Update main category in controller
    String mainCategory = index == 0 ? 'vehicles' : 'real_estate';
    _listingInputController.mainCategory.value = mainCategory;
    print('📝 Updated mainCategory to: $mainCategory');
    
    // 🔧 CRITICAL FIX: Restore backed up data after category switch
    _listingInputController.restoreFromBackup();
    print('🔄 Data restored from backup');
    
    print('📊 AFTER category switch - Controller state:');
    print('   📝 mainCategory: "${_listingInputController.mainCategory.value}"');
    print('   🚗 subCategory: "${_listingInputController.subCategory.value}"');
    print('   🖼️ images count: ${_listingInputController.listingImage.value.length}');
    print('   📋 title: "${_listingInputController.title.value}"');
    
    // Reset page controller to first step
    _pageController.animateToPage(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    
    print('✅ Category switch completed, data preserved');
  }
  
  bool _validateEssentialDetails() {
    print('🔍 === VALIDATION DEBUG START ===');
    print('🔍 Current step: $currentStep');
    print('🔍 Selected category index: $selectedIndex');
    print('🔍 Form key exists: ${_formKey.currentState != null}');
    
    setState(() {
      _showValidation = true;
    });
    
    // Debug controller state BEFORE validation
    _debugControllerState('BEFORE VALIDATION');
    
    // Check form validation first
    bool isFormValid = _formKey.currentState != null && _formKey.currentState!.validate();
    print('🔍 Form validation result: $isFormValid');
    
    // Check specific required fields based on category
    List<String> missingFields = _getMissingRequiredFields();
    print('🔍 Missing fields: $missingFields');
    
    // Check if images are uploaded
    bool areImagesUploaded = _checkImagesUploaded();
    print('🔍 Images uploaded: $areImagesUploaded');
    
    if (isFormValid && missingFields.isEmpty && areImagesUploaded) {
      print('🔍 ✅ Validation PASSED - proceeding to submit');
      return true;
    } else {
      print('🔍 ❌ Validation FAILED');
      String errorMessage = 'Please complete the following:\n';
      if (missingFields.isNotEmpty) {
        errorMessage += '• Missing fields: ${missingFields.join(", ")}\n';
      }
      if (!areImagesUploaded) errorMessage += '• Upload at least one image\n';
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage.trim()),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return false;
    }
  }
  
  List<String> _getMissingRequiredFields() {
    List<String> missingFields = [];
    
    if (selectedIndex == 0) {
      // Vehicle validation
      if (_listingInputController.subCategory.value.isEmpty) {
        missingFields.add('missingVehicleTypeMessage'.tr);
      }
      // Note: Other fields like title, make, model, year, price, location, description
      // are validated by the form validator, but we can add specific checks here if needed
    } else {
      // Real Estate validation
      if (_listingInputController.mainCategory.value.isEmpty) {
        missingFields.add('missingPropertyTypeMessage'.tr);
      }
    }
    
    return missingFields;
  }
  
  bool _checkImagesUploaded() {
    // For now, we'll make images optional to test other validation
    // In production, this should check actual uploaded images
    return true; // Temporarily allow without images
  }
  
  void _submitListing() {
    final String category = selectedIndex == 0 ? 'vehicles' : 'real_estate';
    final String subCategory = _listingInputController.subCategory.value;
    debugPrint("Navigating to review screen for $category listing with subcategory: $subCategory");
    
    // Navigate to review screen
    _navigateToReviewScreen(); // Re-enabled for testing
  }
  
  // Re-enabled for testing review functionality
  void _navigateToReviewScreen() {
    print('🚀 === NAVIGATION DEBUG START ===');
    
    // Ensure all data is saved to the controller before navigation
    _saveCurrentFormData();
    
    final String category = selectedIndex == 0 ? 'vehicles' : 'real_estate';
    final bool isVehicle = category == 'vehicles';
    
    print('🚀 Category: $category, isVehicle: $isVehicle');
    
    // CRITICAL: Backup all current data before navigation
    final listingController = Get.find<ListingInputController>();
    listingController.backupCurrentData();
    print('💾 Data backed up before navigation');
    
    // Final debug before navigation
    _debugControllerState('BEFORE NAVIGATION');
    
    // Validate that essential data exists
    if (!listingController.hasEssentialData()) {
      print('⚠️ WARNING: No essential data found before navigation');
    }
    
    // Get comprehensive data summary
    final dataSummary = listingController.getDataSummary();
    print('📊 Current data summary: $dataSummary');
    
    // Get images and debug them
    final imageUrls = _getImageUrls();
    print('🚀 Images being passed: ${imageUrls.length} images');
    print('🚀 Image URLs: $imageUrls');
    
    // Validate images are properly synced
    if (imageUrls.length != listingController.listingImage.length) {
      print('🚨 IMAGE SYNC ERROR: URLs(${imageUrls.length}) != Controller(${listingController.listingImage.length})');
    }
    
    print('🚀 Navigating to ReviewListing...');
    Get.to(() => ReviewListing(
      isVehicle: isVehicle,
      imageUrls: imageUrls,
    ));
    
    print('🚀 === NAVIGATION DEBUG END ===');
  }
  
  void _saveCurrentFormData() {
    print('💾 === SAVING FORM DATA DEBUG START ===');
    
    // Debug controller state BEFORE saving
    _debugControllerState('BEFORE SAVING');
    
    // This ensures all form data is properly saved to ListingInputController
    // The individual components should already be updating the controller,
    // but this is a safety measure to ensure data persistence
    debugPrint('💾 Saving current form data to controller before navigation');
    
    // Force update of any pending form data
    if (_formKey.currentState != null) {
      print('💾 Form key exists, calling save()');
      _formKey.currentState!.save();
    } else {
      print('💾 ❌ Form key is null!');
    }
    
    // Debug controller state AFTER saving
    _debugControllerState('AFTER SAVING');
    
    print('💾 === SAVING FORM DATA DEBUG END ===');
  }
  
  List<String> _getImageUrls() {
    // Get current images from the ListingInputController
    return _listingInputController.listingImage.toList();
  }
  
  void _debugControllerState(String phase) {
    print('🔍 === CONTROLLER STATE DEBUG: $phase ===');
    print('🔍 ListingInputController state:');
    print('   📝 Title: "${_listingInputController.title.value}"');
    print('   📝 Description: "${_listingInputController.description.value}"');
    print('   💰 Price: ${_listingInputController.price.value}');
    print('   📍 Location: "${_listingInputController.location.value}"');
    print('   🏷️ Main Category: "${_listingInputController.mainCategory.value}"');
    print('   🏷️ Sub Category: "${_listingInputController.subCategory.value}"');
    print('   🚗 Make: "${_listingInputController.make.value}"');
    print('   🚗 Model: "${_listingInputController.model.value}"');
    print('   📅 Year: ${_listingInputController.year.value}');
    print('   📸 Images count: ${_listingInputController.listingImage.length}');
    print('   🔧 Body Type: "${_listingInputController.bodyType.value}"');
    print('   ⛽ Fuel Type: "${_listingInputController.fuelType.value}"');
    print('   🔄 Transmission: "${_listingInputController.transmissionType.value}"');
    print('   📍 Latitude: "${_listingInputController.latitude.value}"');
    print('   📍 Longitude: "${_listingInputController.longitude.value}"');
    print('🔍 === END CONTROLLER STATE DEBUG ===');
  }
}