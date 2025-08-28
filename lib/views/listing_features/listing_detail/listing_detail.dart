import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/individual_listing_detail_controller.dart';
import 'package:samsar/controllers/chat/chat_controller.dart';
import 'package:samsar/services/chat/chat_service.dart';
import 'package:samsar/models/chat/conversation_model.dart';
import 'package:samsar/utils/location_display_utils.dart';
import 'package:samsar/utils/date_utils.dart';
import 'package:samsar/widgets/animated_input_wrapper/animated_input_wrapper.dart';
import 'package:samsar/widgets/app_button/app_button.dart';
import 'package:samsar/widgets/custom_snackbar/custom_snackbar.dart';
import 'package:samsar/widgets/image_slider/image_slider.dart';
import 'package:samsar/views/chats/chat_view.dart';

class ListingDetail extends StatefulWidget {
  final String listingId;
  const ListingDetail({super.key, required this.listingId});

  @override
  State<ListingDetail> createState() => _ListingDetailState();
}

class _ListingDetailState extends State<ListingDetail> {
  final IndividualListingDetailController _detailController = Get.put(
    IndividualListingDetailController(),
  );

  @override
  void initState() {
    super.initState();
    print('🔍 [LISTING DETAIL DEBUG] Fetching details for listingId: ${widget.listingId}');
    _detailController.fetchListingDetail(widget.listingId);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: whiteColor,
      body: Obx(() {
        if (_detailController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (_detailController.listingDetail.value == null) {
          return Center(child: Text('no_data_for_listing'.tr));
        }

        final listing = _detailController.listingDetail.value!.data;

        // 🔍 COMPREHENSIVE DEBUGGING FOR LISTING DETAIL
        print('🔍 [LISTING DETAIL DEBUG] Loaded listing data:');
        print('🔍 [LISTING DETAIL DEBUG] Title: ${listing?.title}');
        print('🔍 [LISTING DETAIL DEBUG] Price: ${listing?.price}');
        print('🔍 [LISTING DETAIL DEBUG] Location: ${listing?.location}');
        print('🔍 [LISTING DETAIL DEBUG] Raw details object: ${listing?.details}');
        print('🔍 [LISTING DETAIL DEBUG] Vehicle details structure:');
        print('  - Make: ${listing?.make} (ROOT LEVEL)');
        print('  - Model: ${listing?.model} (ROOT LEVEL)');
        print('  - Year: ${listing?.year} (ROOT LEVEL)');
        print('  - FuelType: ${listing?.fuelType} (ROOT LEVEL)');
        print('  - Transmission: ${listing?.transmissionType} (ROOT LEVEL)');
        print('  - Mileage: ${listing?.mileage} (ROOT LEVEL)');
        print('  - Color: ${listing?.color} (ROOT LEVEL)');
        print('  - Condition: ${listing?.condition} (ROOT LEVEL)');
        print('  - Horsepower: ${listing?.details?.vehicles?.horsepower} (NESTED)');
        print('  - DriveType: ${listing?.details?.vehicles?.driveType} (NESTED)');
        print('  - BodyType: ${listing?.details?.vehicles?.bodyType} (NESTED)');
        print('🔍 [LISTING DETAIL DEBUG] ================');

        final String smartDate = SmartDateUtils.getSmartDateDisplayFromString(listing?.createdAt?.toString());

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageSlider(
                imageUrls: listing!.images,
                listingId: listing.id ?? "NA",
              ),
              SizedBox(height: screenHeight * 0.01),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Listing ID Display
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: blueColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: blueColor, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.tag, color: blueColor, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'ID: ${listing.displayId ?? listing.id ?? ""}',
                            style: TextStyle(
                              color: blueColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      listing.title ?? "NA",
                      style: TextStyle(
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.055,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      "\$${listing.price}",
                      style: TextStyle(
                        color: blueColor,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    // Seller Type Display
                    if (listing.sellerType != null &&
                        listing.sellerType!.isNotEmpty)
                      Container(
                        margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: listing.sellerType == 'owner'
                              ? Colors.green.withOpacity(0.1)
                              : listing.sellerType == 'broker'
                              ? Colors.orange.withOpacity(0.1)
                              : Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: listing.sellerType == 'owner'
                                ? Colors.green
                                : listing.sellerType == 'broker'
                                ? Colors.orange
                                : Colors.blue,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              listing.sellerType == 'owner'
                                  ? Icons.person
                                  : listing.sellerType == 'broker'
                                  ? Icons.real_estate_agent
                                  : Icons.business,
                              color: listing.sellerType == 'owner'
                                  ? Colors.green
                                  : listing.sellerType == 'broker'
                                  ? Colors.orange
                                  : Colors.blue,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              _formatSellerType(listing.sellerType!),
                              style: TextStyle(
                                color: listing.sellerType == 'owner'
                                    ? Colors.green
                                    : listing.sellerType == 'broker'
                                    ? Colors.orange
                                    : Colors.blue,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Row(
                      children: [
                        Icon(Icons.location_pin, color: greyColor, size: 18),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            LocationDisplayUtils.formatLocationForDisplay(listing.location),
                            style: TextStyle(color: greyColor, fontSize: 14),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    AnimatedInputWrapper(
                      delayMilliseconds: 100,
                      child: DetailSectionCard(
                        title: "Description",
                        useTwoColumns: false,
                        items: [
                          IconLabelPair(
                            Icons.description,
                            listing.description ?? "NA",
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Essential Details - Vehicle or Real Estate
                    AnimatedInputWrapper(
                      delayMilliseconds: 200,
                      child: DetailSectionCard(
                        title: "Essential Details",
                        items: [
                          // Vehicle fields
                          if (listing.make != null && listing.make!.isNotEmpty)
                            IconLabelPair(
                              FontAwesomeIcons.car,
                              "Make: ${listing.make!}",
                            ),
                          if (listing.model != null && listing.model!.isNotEmpty)
                            IconLabelPair(
                              FontAwesomeIcons.carSide,
                              "Model: ${listing.model!}",
                            ),
                          if (listing.year != null)
                            IconLabelPair(
                              FontAwesomeIcons.calendar,
                              "Year: ${listing.year!.toString()}",
                            ),
                          if (listing.transmissionType != null && listing.transmissionType!.isNotEmpty)
                            IconLabelPair(
                              FontAwesomeIcons.gear,
                              "Transmission: ${listing.transmissionType!}",
                            ),
                          if (listing.mileage != null && listing.mileage! >= 0)
                            IconLabelPair(
                              Icons.speed,
                              "Mileage: ${listing.mileage} KM",
                            ),
                          if (listing.fuelType != null && listing.fuelType!.isNotEmpty)
                            IconLabelPair(
                              Icons.local_gas_station,
                              "Fuel Type: ${listing.fuelType!}",
                            ),
                          // CRITICAL FIX: Use root-level bodyType field
                          if (listing.bodyType != null && listing.bodyType!.isNotEmpty)
                            IconLabelPair(
                              Icons.sports_motorsports,
                              "Body Type: ${listing.bodyType!}",
                            ),
                          if (listing.engineSize != null && listing.engineSize! > 0)
                            IconLabelPair(
                              Icons.settings,
                              "Engine Size: ${listing.engineSize!.toStringAsFixed(1)}L",
                            ),
                          if (listing.details?.vehicles?.driveType != null && listing.details!.vehicles!.driveType!.isNotEmpty)
                            IconLabelPair(
                              Icons.all_inclusive,
                              "Drive Type: ${listing.details!.vehicles!.driveType!}",
                            ),
                          // Add accidental field
                          if (listing.accidental != null && listing.accidental!.isNotEmpty)
                            IconLabelPair(
                              Icons.warning,
                              "Accident History: ${listing.accidental!}",
                            ),
                          
                          // Real Estate fields from root level (saved as separate columns)
                          if (listing.totalArea != null && listing.totalArea! > 0)
                            IconLabelPair(
                              Icons.square_foot,
                              "Area: ${listing.totalArea} m²",
                            ),
                          if (listing.details?.realEstate?.bedrooms != null && listing.details!.realEstate!.bedrooms! > 0)
                            IconLabelPair(
                              Icons.bed,
                              "Bedrooms: ${listing.details!.realEstate!.bedrooms}",
                            ),
                          if (listing.details?.realEstate?.bathrooms != null && listing.details!.realEstate!.bathrooms! > 0)
                            IconLabelPair(
                              Icons.bathtub,
                              "Bathrooms: ${listing.details!.realEstate!.bathrooms}",
                            ),
                          if (listing.floor != null)
                            IconLabelPair(
                              Icons.layers,
                              "Floor: ${listing.floor}",
                            ),
                          if (listing.totalFloors != null && listing.totalFloors! > 0)
                            IconLabelPair(
                              Icons.apartment,
                              "Total Floors: ${listing.totalFloors}",
                            ),
                          if (listing.yearBuilt != null && listing.yearBuilt! > 0)
                            IconLabelPair(
                              Icons.calendar_today,
                              "Year Built: ${listing.yearBuilt}",
                            ),
                          if (listing.furnishing != null && listing.furnishing!.isNotEmpty)
                            IconLabelPair(
                              Icons.chair,
                              "Furnishing: ${listing.furnishing}",
                            ),
                          if (listing.details?.realEstate?.facing != null && listing.details!.realEstate!.facing!.isNotEmpty)
                            IconLabelPair(
                              Icons.explore,
                              "Facing: ${listing.details!.realEstate!.facing}",
                            ),
                          if (listing.details?.realEstate?.balconies != null && listing.details!.realEstate!.balconies! > 0)
                            IconLabelPair(
                              Icons.balcony,
                              "Balconies: ${listing.details!.realEstate!.balconies}",
                            ),
                          if (listing.details?.realEstate?.parking != null && listing.details!.realEstate!.parking!.isNotEmpty)
                            IconLabelPair(
                              Icons.local_parking,
                              "Parking: ${listing.details!.realEstate!.parking}",
                            ),
                          
                          // Add listingAction field
                          if (listing.listingAction != null && listing.listingAction!.isNotEmpty)
                            IconLabelPair(
                              Icons.sell,
                              "Listing Type: ${_formatListingAction(listing.listingAction!)}",
                            ),
                        ].where((item) => true).toList(),
                      ),
                    ),

                    SizedBox(height: 16),

                    // CRITICAL FIX: Improved color display with proper fallback
                    if (listing.color != null && listing.color!.isNotEmpty && listing.color != '#000000')
                      AnimatedInputWrapper(
                        delayMilliseconds: 300,
                        child: DetailSectionCard(
                          title: "Colors",
                          items: [
                            IconLabelPair(
                              Icons.palette,
                              "Exterior Color",
                              colorHex: listing.color ?? listing.details?.vehicles?.color,
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 16),

                    if (listing.details?.vehicles?.horsepower != null && listing.details!.vehicles!.horsepower! > 0)
                      AnimatedInputWrapper(
                        delayMilliseconds: 400,
                        child: DetailSectionCard(
                          title: "Performance",
                          items: [
                            IconLabelPair(
                              Icons.flash_on,
                              "${listing.details!.vehicles!.horsepower} HP",
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 16),

                    AnimatedInputWrapper(
                      delayMilliseconds: 500,
                      child: DetailSectionCard(
                        title: "Condition and Ownership",
                        items: [
                          if (listing.condition != null && listing.condition!.isNotEmpty)
                            IconLabelPair(
                              Icons.tune,
                              "Condition: ${listing.condition}",
                            ),
                          // CRITICAL FIX: Add accidental field
                          if (listing.details?.vehicles?.accidentFree != null)
                            IconLabelPair(
                              Icons.warning,
                              "Accident Free: ${listing.details!.vehicles!.accidentFree! ? 'Yes' : 'No'}",
                            ),
                          if (listing.details?.vehicles?.previousOwners != null)
                            IconLabelPair(
                              Icons.person,
                              "Previous owners: ${listing.details!.vehicles!.previousOwners}",
                            ),
                          if (listing.details?.vehicles?.warranty != null && listing.details!.vehicles!.warranty!.isNotEmpty)
                            IconLabelPair(
                              Icons.verified_user,
                              "Warranty: ${listing.details!.vehicles!.warranty}",
                            ),
                          if (listing.details?.vehicles?.importStatus != null && listing.details!.vehicles!.importStatus!.isNotEmpty)
                            IconLabelPair(
                              Icons.flight_land,
                              "Import Status: ${listing.details!.vehicles!.importStatus}",
                            ),
                          if (listing.details?.vehicles?.customsCleared != null)
                            IconLabelPair(
                              Icons.gavel,
                              "Customs Cleared: ${listing.details!.vehicles!.customsCleared! ? 'Yes' : 'No'}",
                            ),
                        ].where((item) => true).toList(),
                        useTwoColumns: false,
                      ),
                    ),

                    SizedBox(height: 16),

                    // Only show Airbags & Breaking section if any airbag data exists
                    if ((listing.details?.vehicles?.frontAirbags == true) ||
                        (listing.details?.vehicles?.sideAirbags == true) ||
                        (listing.details?.vehicles?.curtainAirbags == true) ||
                        (listing.details?.vehicles?.kneeAirbags == true) ||
                        (listing.details?.vehicles?.automaticEmergencyBraking == true))
                      AnimatedInputWrapper(
                        delayMilliseconds: 600,
                        child: DetailSectionCard(
                          title: "Airbags & Breaking",
                          items: [
                            if (listing.details?.vehicles?.frontAirbags == true)
                              IconLabelPair(
                                Icons.directions_car,
                                "Front airbags: Present",
                              ),
                            if (listing.details?.vehicles?.sideAirbags == true)
                              IconLabelPair(
                                Icons.airline_seat_recline_extra,
                                "Side airbags: Present",
                              ),
                            if (listing.details?.vehicles?.curtainAirbags == true)
                              IconLabelPair(
                                Icons.window,
                                "Curtain airbags: Present",
                              ),
                            if (listing.details?.vehicles?.kneeAirbags == true)
                              IconLabelPair(
                                Icons.accessibility_new,
                                "Knee airbags: Present",
                              ),
                            if (listing.details?.vehicles?.automaticEmergencyBraking == true)
                              IconLabelPair(
                                Icons.gpp_maybe,
                                "Automatic Emergency breaking: Present",
                              ),
                          ].where((item) => true).toList(),
                        ),
                      ),

                    SizedBox(height: 16),

                    // Only show Assist & Controls section if any control data exists
                    if ((listing.details?.vehicles?.cruiseControl == true) ||
                        (listing.details?.vehicles?.adaptiveCruiseControl == true) ||
                        (listing.details?.vehicles?.laneDepartureWarning == true) ||
                        (listing.details?.vehicles?.laneKeepAssist == true) ||
                        (listing.details?.vehicles?.navigationSystem != null && listing.details!.vehicles!.navigationSystem!.isNotEmpty) ||
                        (listing.details?.vehicles?.roofType != null && listing.details!.vehicles!.roofType!.isNotEmpty))
                      AnimatedInputWrapper(
                        delayMilliseconds: 700,
                        child: DetailSectionCard(
                          title: "Assist & Controls",
                          items: [
                            if (listing.details?.vehicles?.cruiseControl == true)
                              IconLabelPair(
                                Icons.speed,
                                "Cruise control: Present",
                              ),
                            if (listing.details?.vehicles?.adaptiveCruiseControl == true)
                              IconLabelPair(
                                Icons.radar,
                                "AdaptiveCruise control: Present",
                              ),
                            if (listing.details?.vehicles?.laneDepartureWarning == true)
                              IconLabelPair(
                                Icons.swap_calls,
                                "Lane departure warning: Present",
                              ),
                            if (listing.details?.vehicles?.laneKeepAssist == true)
                              IconLabelPair(
                                Icons.center_focus_strong,
                                "Lane keep assist: Present",
                              ),
                            if (listing.details?.vehicles?.navigationSystem != null && listing.details!.vehicles!.navigationSystem!.isNotEmpty)
                              IconLabelPair(
                                Icons.navigation,
                                "Navigation system: ${listing.details!.vehicles!.navigationSystem}",
                              ),
                            if (listing.details?.vehicles?.roofType != null && listing.details!.vehicles!.roofType!.isNotEmpty)
                              IconLabelPair(
                                Icons.roofing,
                                listing.details!.vehicles!.roofType!,
                              ),
                          ].where((item) => true).toList(),
                        ),
                      ),

                    SizedBox(height: 16),

                    // Only show Additional Info section if any additional data exists
                    if ((listing.details?.vehicles?.serviceHistory != null && listing.details!.vehicles!.serviceHistory.isNotEmpty) ||
                        (listing.details?.vehicles?.serviceHistoryDetails != null && listing.details!.vehicles!.serviceHistoryDetails!.isNotEmpty) ||
                        (listing.details?.vehicles?.additionalNotes != null && listing.details!.vehicles!.additionalNotes!.isNotEmpty) ||
                        (listing.details?.vehicles?.registrationExpiry != null && listing.details!.vehicles!.registrationExpiry!.isNotEmpty))
                      AnimatedInputWrapper(
                        delayMilliseconds: 800,
                        child: DetailSectionCard(
                          title: "Additional Info",
                          items: [
                            if (listing.details?.vehicles?.serviceHistory != null && listing.details!.vehicles!.serviceHistory.isNotEmpty)
                              IconLabelPair(
                                Icons.build,
                                "Service history: [Available]",
                              ),
                            if (listing.details?.vehicles?.serviceHistoryDetails != null && listing.details!.vehicles!.serviceHistoryDetails!.isNotEmpty)
                              IconLabelPair(
                                Icons.description,
                                "Service history notes: ${listing.details!.vehicles!.serviceHistoryDetails}",
                              ),
                            if (listing.details?.vehicles?.additionalNotes != null && listing.details!.vehicles!.additionalNotes!.isNotEmpty)
                              IconLabelPair(
                                Icons.note_alt_outlined,
                                "Additional notes: ${listing.details!.vehicles!.additionalNotes}",
                              ),
                            if (listing.details?.vehicles?.registrationExpiry != null && listing.details!.vehicles!.registrationExpiry!.isNotEmpty)
                              IconLabelPair(
                                Icons.calendar_month,
                                "Registration expiry: ${listing.details!.vehicles!.registrationExpiry}",
                              ),
                          ].where((item) => true).toList(),
                        ),
                      ),

                    SizedBox(height: 16),

                    // Features & Extras section - display all features from the features array
                    if (listing.details?.vehicles?.features != null && listing.details!.vehicles!.features.isNotEmpty)
                      AnimatedInputWrapper(
                        delayMilliseconds: 850,
                        child: DetailSectionCard(
                          title: "Features & Extras",
                          items: [
                            // Display all features from the features array
                            ...listing.details!.vehicles!.features.map((feature) => 
                              IconLabelPair(
                                Icons.check_circle,
                                feature,
                              )
                            ).toList(),
                          ],
                        ),
                      ),

                    // Real Estate Features & Extras section
                    if (listing.details?.realEstate?.features != null && listing.details!.realEstate!.features!.isNotEmpty)
                      AnimatedInputWrapper(
                        delayMilliseconds: 850,
                        child: DetailSectionCard(
                          title: "Features & Extras",
                          items: [
                            // Display all real estate features
                            ...listing.details!.realEstate!.features!.map((feature) => 
                              IconLabelPair(
                                Icons.check_circle,
                                feature,
                              )
                            ).toList(),
                          ],
                        ),
                      ),

                    SizedBox(height: 16),

                    // Real Estate Additional Details section
                    if ((listing.details?.realEstate?.garden != null && listing.details!.realEstate!.garden!.isNotEmpty) ||
                        (listing.details?.realEstate?.pool != null && listing.details!.realEstate!.pool!.isNotEmpty) ||
                        (listing.details?.realEstate?.plotSize != null && listing.details!.realEstate!.plotSize! > 0) ||
                        (listing.details?.realEstate?.officeType != null && listing.details!.realEstate!.officeType!.isNotEmpty) ||
                        (listing.details?.realEstate?.zoning != null && listing.details!.realEstate!.zoning!.isNotEmpty) ||
                        (listing.details?.realEstate?.roadAccess != null && listing.details!.realEstate!.roadAccess!.isNotEmpty) ||
                        (listing.details?.realEstate?.heating != null && listing.details!.realEstate!.heating!.isNotEmpty) ||
                        (listing.details?.realEstate?.cooling != null && listing.details!.realEstate!.cooling!.isNotEmpty) ||
                        (listing.details?.realEstate?.view != null && listing.details!.realEstate!.view!.isNotEmpty) ||
                        (listing.details?.realEstate?.energyRating != null && listing.details!.realEstate!.energyRating!.isNotEmpty))
                      AnimatedInputWrapper(
                        delayMilliseconds: 855,
                        child: DetailSectionCard(
                          title: "Property Features",
                          items: [
                            if (listing.details?.realEstate?.garden != null && listing.details!.realEstate!.garden!.isNotEmpty)
                              IconLabelPair(
                                Icons.grass,
                                "Garden: ${listing.details!.realEstate!.garden}",
                              ),
                            if (listing.details?.realEstate?.pool != null && listing.details!.realEstate!.pool!.isNotEmpty)
                              IconLabelPair(
                                Icons.pool,
                                "Pool: ${listing.details!.realEstate!.pool}",
                              ),
                            if (listing.details?.realEstate?.plotSize != null && listing.details!.realEstate!.plotSize! > 0)
                              IconLabelPair(
                                Icons.landscape,
                                "Plot Size: ${listing.details!.realEstate!.plotSize} m²",
                              ),
                            if (listing.details?.realEstate?.officeType != null && listing.details!.realEstate!.officeType!.isNotEmpty)
                              IconLabelPair(
                                Icons.business,
                                "Office Type: ${listing.details!.realEstate!.officeType}",
                              ),
                            if (listing.details?.realEstate?.zoning != null && listing.details!.realEstate!.zoning!.isNotEmpty)
                              IconLabelPair(
                                Icons.location_city,
                                "Zoning: ${listing.details!.realEstate!.zoning}",
                              ),
                            if (listing.details?.realEstate?.roadAccess != null && listing.details!.realEstate!.roadAccess!.isNotEmpty)
                              IconLabelPair(
                                Icons.directions,
                                "Road Access: ${listing.details!.realEstate!.roadAccess}",
                              ),
                            if (listing.details?.realEstate?.heating != null && listing.details!.realEstate!.heating!.isNotEmpty)
                              IconLabelPair(
                                Icons.thermostat,
                                "Heating: ${listing.details!.realEstate!.heating}",
                              ),
                            if (listing.details?.realEstate?.cooling != null && listing.details!.realEstate!.cooling!.isNotEmpty)
                              IconLabelPair(
                                Icons.ac_unit,
                                "Cooling: ${listing.details!.realEstate!.cooling}",
                              ),
                            if (listing.details?.realEstate?.view != null && listing.details!.realEstate!.view!.isNotEmpty)
                              IconLabelPair(
                                Icons.visibility,
                                "View: ${listing.details!.realEstate!.view}",
                              ),
                            if (listing.details?.realEstate?.energyRating != null && listing.details!.realEstate!.energyRating!.isNotEmpty)
                              IconLabelPair(
                                Icons.energy_savings_leaf,
                                "Energy Rating: ${listing.details!.realEstate!.energyRating}",
                              ),
                          ].where((item) => true).toList(),
                        ),
                      ),

                    SizedBox(height: 16),

                    // Safety Features section
                    if ((listing.details?.vehicles?.abs == true) ||
                        (listing.details?.vehicles?.tractionControl == true) ||
                        (listing.details?.vehicles?.laneAssist == true) ||
                        (listing.details?.vehicles?.airbags != null && listing.details!.vehicles!.airbags! > 0))
                      AnimatedInputWrapper(
                        delayMilliseconds: 860,
                        child: DetailSectionCard(
                          title: "Safety Features",
                          items: [
                            if (listing.details?.vehicles?.abs == true)
                              IconLabelPair(
                                Icons.security,
                                "ABS: Present",
                              ),
                            if (listing.details?.vehicles?.tractionControl == true)
                              IconLabelPair(
                                Icons.control_camera,
                                "Traction Control: Present",
                              ),
                            if (listing.details?.vehicles?.laneAssist == true)
                              IconLabelPair(
                                Icons.assistant_direction,
                                "Lane Assist: Present",
                              ),
                            if (listing.details?.vehicles?.airbags != null && listing.details!.vehicles!.airbags! > 0)
                              IconLabelPair(
                                Icons.airline_seat_legroom_extra,
                                "Airbags: ${listing.details!.vehicles!.airbags}",
                              ),
                          ].where((item) => true).toList(),
                        ),
                      ),

                    SizedBox(height: 16),

                    AnimatedInputWrapper(
                      delayMilliseconds: 900,
                      child: sellerInfo(
                        screenHeight,
                        screenWidth,
                        listing.seller?.profilePicture ??
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGDSuK3gg8gojbS1BjnbA4NLTjMg_hELJbpQ&s",
                        listing.seller?.username ?? "",
                        smartDate,
                      ),
                    ),

                    SizedBox(height: 18),

                    Align(
                      alignment: Alignment.center,
                      child: AppButton(
                        widthSize: 0.75,
                        heightSize: 0.08,
                        buttonColor: blueColor,
                        text: "Contact Seller",
                        textColor: whiteColor,
                        onPressed: () async {
                          final sellerId = listing.seller?.id;
                          if (sellerId == null) {
                            showCustomSnackbar("Seller not found", true);
                            return;
                          }

                          // Check if user is trying to message themselves
                          try {
                            final storage = FlutterSecureStorage();
                            final userData = await storage.read(key: "samsar_user_data");
                            if (userData != null) {
                              final json = jsonDecode(userData);
                              final currentUserId = json['data']?['user']?['id'];
                              if (currentUserId == sellerId) {
                                showCustomSnackbar("You cannot message yourself", true);
                                return;
                              }
                            }
                          } catch (e) {
                            print('Warning: Could not check user ID: $e');
                          }

                          try {
                            // Get or create chat controller with proper dependency injection
                            ChatController chatController;
                            if (Get.isRegistered<ChatController>()) {
                              chatController = Get.find<ChatController>();
                            } else {
                              // Initialize ChatService if not registered
                              ChatService chatService;
                              if (Get.isRegistered<ChatService>()) {
                                chatService = Get.find<ChatService>();
                              } else {
                                // Create properly configured Dio instance with authentication
                                final dio = Dio(BaseOptions(
                                  connectTimeout: const Duration(seconds: 10),
                                  receiveTimeout: const Duration(seconds: 10),
                                  headers: {
                                    "Content-Type": "application/json",
                                    "Accept": "application/json",
                                  },
                                ));
                                
                                // Add authentication token if available
                                try {
                                  final storage = FlutterSecureStorage();
                                  final userData = await storage.read(key: "samsar_user_data");
                                  if (userData != null) {
                                    final json = jsonDecode(userData);
                                    final token = json['data']?['tokens']?['accessToken'];
                                    if (token != null) {
                                      dio.options.headers['Authorization'] = 'Bearer $token';
                                    }
                                  }
                                } catch (e) {
                                  print('Warning: Could not add auth token to ChatService: $e');
                                }
                                
                                chatService = Get.put(ChatService(dio));
                              }
                              chatController = Get.put(ChatController(chatService: chatService));
                            }
                            
                            // Get or create conversation with seller using correct API format
                            Conversation? conversation;
                            try {
                              // Try to find existing conversation first
                              await chatController.fetchConversations();
                              conversation = chatController.conversations.firstWhereOrNull(
                                (conv) => conv.participants.any((user) => user.id == sellerId),
                              );
                              
                              // If no existing conversation, create new one with correct format
                              if (conversation == null) {
                                conversation = await chatController.chatService.createConversation(
                                  participantIds: [sellerId],
                                );
                                chatController.conversations.insert(0, conversation);
                              }
                            } catch (e) {
                              print("Error creating/finding conversation: $e");
                              conversation = null;
                            }
                            
                            if (conversation != null) {
                              // Navigate to chat screen
                              Get.to(() => ChatView(conversation: conversation!));
                            } else {
                              showCustomSnackbar("Unable to start chat", true);
                            }
                          } catch (e) {
                            print("Error starting chat: $e");
                            showCustomSnackbar("Unable to start chat", true);
                          }
                        },
                      ),
                    ),

                    SizedBox(height: 22),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget sellerInfo(
    double screenHeight,
    double screenWidth,
    String sellerImage,
    String sellerName,
    String listingDate,
  ) {
    return Card(
      color: whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Seller Information",
              style: TextStyle(
                color: blueColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(sellerImage),
                ),
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                      sellerName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: blackColor,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.003),
                    Text(
                      "${'posted'.tr} $listingDate",
                      style: TextStyle(fontSize: 14, color: greyColor),
                    ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatListingAction(String action) {
    switch (action.toUpperCase()) {
      case 'SALE':
        return 'For Sale';
      case 'RENT':
        return 'For Rent';
      case 'SEARCHING':
        return 'Searching';
      default:
        return action;
    }
  }

  String _formatSellerType(String sellerType) {
    switch (sellerType.toLowerCase()) {
      case 'owner':
        return 'ad_owner'.tr;
      case 'broker':
        return 'broker'.tr;
      case 'business':
      case 'business_firm':
        return 'business_firm'.tr;
      default:
        // For any other value, display it as-is with proper formatting
        return sellerType.split('_').map((word) => 
          word[0].toUpperCase() + word.substring(1).toLowerCase()
        ).join(' ');
    }
  }
}

class DetailSectionCard extends StatelessWidget {
  final String title;
  final List<IconLabelPair> items;
  final bool useTwoColumns;

  const DetailSectionCard({
    super.key,
    required this.title,
    required this.items,
    this.useTwoColumns = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      color: whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: blackColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            ..._buildContent(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContent() {
    if (useTwoColumns) {
      return List.generate((items.length / 2).ceil(), (index) {
        final first = items[index * 2];
        final second = (index * 2 + 1 < items.length)
            ? items[index * 2 + 1]
            : null;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: [
              Expanded(child: _buildIconLabel(first)),
              const SizedBox(width: 16),
              Expanded(
                child: second != null
                    ? _buildIconLabel(second)
                    : const SizedBox(),
              ),
            ],
          ),
        );
      });
    } else {
      return items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: _buildIconLabel(item),
            ),
          )
          .toList();
    }
  }

  Widget _buildIconLabel(IconLabelPair pair) {
    // Check if this is a color field
    final isColorField = pair.label.toLowerCase().contains('color');
    Color? color;
    String displayText = pair.label;

    // If it's a color field and has a color code
    if (isColorField) {
      // Extract color hex from the label text if not provided directly
      final hexCode = pair.colorHex ?? pair.label.split(':').last.trim();

      try {
        // Handle hex codes with or without #
        String hex = hexCode.startsWith('#') ? hexCode : '#$hexCode';
        hex = hex.replaceAll('#', '').trim();

        // Handle 3-digit hex codes (expand to 6 digits)
        if (hex.length == 3) {
          hex = '${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}';
        }

        // Handle 6 or 8 digit hex codes
        if (hex.length == 6 || hex.length == 8) {
          color = Color(int.parse('FF$hex', radix: 16));
          // Update display text to remove the hex code if it was in the label
          if (pair.colorHex == null) {
            displayText = '${pair.label.split(':').first}: ';
          }
        }
      } catch (e) {
        // If parsing fails, just show the text as is
        debugPrint('Error parsing color: $e');
      }
    }

    return Row(
      children: [
        FaIcon(pair.icon, color: blueColor, size: 18),
        const SizedBox(width: 6),
        if (color != null) ...[
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            displayText,
            style: TextStyle(color: blackColor, fontSize: 14),
          ),
        ),
      ],
    );
  }

}

class IconLabelPair {
  final IconData icon;
  final String label;
  final String? colorHex;

  IconLabelPair(this.icon, this.label, {this.colorHex});
}
