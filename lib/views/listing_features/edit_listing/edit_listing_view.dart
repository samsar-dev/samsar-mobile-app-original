import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/models/listing/listing_response.dart';
import 'package:samsar/views/listing_features/create_listing/create_listing_view.dart';

class EditListingView extends StatefulWidget {
  final Item listing;
  
  const EditListingView({super.key, required this.listing});

  @override
  State<EditListingView> createState() => _EditListingViewState();
}

class _EditListingViewState extends State<EditListingView> {
  late final ListingInputController _listingInputController;

  @override
  void initState() {
    super.initState();

    // Get existing controller or create new one
    if (Get.isRegistered<ListingInputController>()) {
      _listingInputController = Get.find<ListingInputController>();
      _listingInputController.clearAllData();
    } else {
      _listingInputController = Get.put(
        ListingInputController(),
        permanent: true,
      );
    }

    // Populate controller with existing listing data AFTER clearing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _populateControllerWithListingData();
    });
  }

  void _populateControllerWithListingData() {
    final listing = widget.listing;
    
    
    // Basic fields
    _listingInputController.title.value = listing.title ?? '';
    _listingInputController.description.value = listing.description ?? '';
    _listingInputController.price.value = listing.price ?? 0;
    _listingInputController.location.value = listing.location ?? '';
    _listingInputController.mainCategory.value = listing.mainCategory ?? '';
    _listingInputController.subCategory.value = listing.subCategory ?? '';
    _listingInputController.listingAction.value = listing.listingAction ?? 'SALE';
    
    // Set sellerType to default if not available (since it's not in Item model)
    _listingInputController.sellerType.value = 'owner'; // Default value
    
    // Vehicle fields
    if (listing.make != null) {
      _listingInputController.make.value = listing.make!;
    }
    if (listing.model != null) {
      _listingInputController.model.value = listing.model!;
    }
    if (listing.year != null) _listingInputController.year.value = listing.year!;
    if (listing.fuelType != null) _listingInputController.fuelType.value = listing.fuelType!;
    if (listing.transmission != null) _listingInputController.transmissionType.value = listing.transmission!;
    if (listing.mileage != null) _listingInputController.mileage.value = listing.mileage.toString();
    if (listing.color != null) _listingInputController.exteriorColor.value = listing.color!;
    if (listing.condition != null) _listingInputController.condition.value = listing.condition!;
    
    // Real estate fields
    if (listing.bedrooms != null) _listingInputController.bedrooms.value = listing.bedrooms!;
    if (listing.bathrooms != null) _listingInputController.bathrooms.value = listing.bathrooms!;
    if (listing.yearBuilt != null) _listingInputController.yearBuilt.value = listing.yearBuilt!;
    if (listing.size != null) _listingInputController.totalArea.value = int.tryParse(listing.size!) ?? 0;
    
    // Images - ensure proper assignment
    if (listing.images.isNotEmpty) {
      _listingInputController.listingImage.assignAll(listing.images);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return CreateListingView();
  }
}
