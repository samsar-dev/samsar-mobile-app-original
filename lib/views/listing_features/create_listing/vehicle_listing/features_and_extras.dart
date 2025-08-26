import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/views/listing_features/create_listing/components/review_listing.dart';
import 'package:samsar/views/listing_features/create_listing/components/features_extras/features_wrapper.dart';

class FeaturesAndExtras extends StatefulWidget {
  const FeaturesAndExtras({super.key});

  @override
  State<FeaturesAndExtras> createState() => _FeaturesAndExtrasState();
}

class _FeaturesAndExtrasState extends State<FeaturesAndExtras> {
  late final ListingInputController _listingInputController;

  @override
  void initState() {
    super.initState();
    // Get the controller instance
    if (Get.isRegistered<ListingInputController>()) {
      _listingInputController = Get.find<ListingInputController>();
    } else {
      _listingInputController = Get.put(
        ListingInputController(),
        permanent: true,
      );
    }

    // Clear subcategory-specific features to ensure clean state for current subcategory
    _listingInputController.clearSubcategorySpecificFeatures(_listingInputController.subCategory.value);

    print('🚀 FeaturesAndExtras initState() called');
    print('📊 Controller state at features screen:');
    print(
      '   📝 Main Category: "${_listingInputController.mainCategory.value}"',
    );
    print('   🚗 Sub Category: "${_listingInputController.subCategory.value}"');
    print('   📝 Title: "${_listingInputController.title.value}"');
    print('   💰 Price: ${_listingInputController.price.value}');
    print('   🚗 Make: "${_listingInputController.make.value}"');
    print('   🚗 Model: "${_listingInputController.model.value}"');
    print('   🖼️ Images: ${_listingInputController.listingImage.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Text(
          "Features and Extras",
          style: TextStyle(color: blackColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FeaturesWrapper(
          category: _listingInputController.mainCategory.value,
          subCategory: _listingInputController.subCategory.value,
          currentStep: 0, // Single step for features
          onNext: () {
            print('🚀 Features completed, navigating to review...');

            // Debug controller state before navigation
            print('📊 Controller state before review navigation:');
            print('   📝 Title: "${_listingInputController.title.value}"');
            print('   💰 Price: ${_listingInputController.price.value}');
            print('   🚗 Make: "${_listingInputController.make.value}"');
            print('   🚗 Model: "${_listingInputController.model.value}"');
            print(
              '   🖼️ Images: ${_listingInputController.listingImage.length}',
            );
            print(
              '   🎯 Features: ${_listingInputController.selectedFeatures.length}',
            );

            // Navigate to review screen
            Get.to(
              ReviewListing(
                isVehicle: true,
                imageUrls: _listingInputController.listingImage.toList(),
              ),
            );
          },
          onPrevious: () {
            Get.back(); // Go back to previous step
          },
        ),
      ),
    );
  }
}
