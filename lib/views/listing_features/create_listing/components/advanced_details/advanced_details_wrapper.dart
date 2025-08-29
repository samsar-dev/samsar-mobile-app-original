import 'package:flutter/material.dart';
import 'package:samsar/views/listing_features/create_listing/components/advanced_details/cars_advanced_details.dart';
import 'package:samsar/views/listing_features/create_listing/components/advanced_details/motorcycles_advanced_details.dart';
import 'package:samsar/views/listing_features/create_listing/components/advanced_details/passengers_advanced_details.dart';
import 'package:samsar/views/listing_features/create_listing/components/advanced_details/commercials_advanced_details.dart';
import 'package:samsar/views/listing_features/create_listing/components/advanced_details/constructions_advanced_details.dart';
import 'package:get/get.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/views/listing_features/create_listing/components/advanced_details/apartments_advanced_details.dart';
import 'package:samsar/views/listing_features/create_listing/components/advanced_details/houses_advanced_details.dart';
import 'package:samsar/views/listing_features/create_listing/components/advanced_details/land_advanced_details.dart';
import 'package:samsar/views/listing_features/create_listing/components/advanced_details/offices_advanced_details.dart';
import 'package:samsar/views/listing_features/create_listing/components/advanced_details/store_advanced_details.dart';
import 'package:samsar/views/listing_features/create_listing/components/advanced_details/villa_advanced_details.dart';

class AdvancedDetailsWrapper extends StatefulWidget {
  final String category;
  final String? subCategory; // For vehicles: 'cars', 'motorcycles'
  final int currentStep;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const AdvancedDetailsWrapper({
    super.key,
    required this.category,
    this.subCategory,
    required this.currentStep,
    this.onNext,
    this.onPrevious,
  });

  @override
  State<AdvancedDetailsWrapper> createState() => _AdvancedDetailsWrapperState();
}

class _AdvancedDetailsWrapperState extends State<AdvancedDetailsWrapper> {
  late final ListingInputController _listingInputController;

  @override
  void initState() {
    super.initState();
    // BULLETPROOF CONTROLLER ACCESS - Handle all edge cases
    try {
      if (Get.isRegistered<ListingInputController>()) {
        _listingInputController = Get.find<ListingInputController>();
      } else {
        _listingInputController = Get.put(
          ListingInputController(),
          permanent: true,
        );
      }
    } catch (e) {
      _listingInputController = Get.put(
        ListingInputController(),
        permanent: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryUpper = widget.category.toUpperCase();
    final subCategoryUpper = widget.subCategory?.toUpperCase() ?? '';

    Widget formContent;

    if (categoryUpper == 'VEHICLES') {
      switch (subCategoryUpper) {
        case 'CARS':
          formContent = CarsAdvancedDetails();
          break;
        case 'MOTORCYCLES':
          formContent = MotorcyclesAdvancedDetails();
          break;
        case 'PASSENGER_VEHICLES':
        case 'PASSENGERS':
        case 'BUS':
        case 'MINIVAN':
        case 'VAN':
        case 'MICROBUS':
        case 'COACH':
        case 'SHUTTLE':
          formContent = PassengersAdvancedDetails();
          break;
        case 'COMMERCIAL_TRANSPORT':
        case 'COMMERCIALS':
        case 'COMMERCIAL':
        case 'PICKUP':
        case 'TRAILER':
        case 'SEMI_TRAILER':
        case 'FLATBED':
        case 'REFRIGERATED':
        case 'TANKER':
        case 'CRANE':
        case 'TOW_TRUCK':
        case 'DELIVERY_VAN':
        case 'CARGO_VAN':
        case 'BOX_TRUCK':
        case 'DUMP_TRUCK':
        case 'FIRE_TRUCK':
        case 'AMBULANCE':
          formContent = CommercialsAdvancedDetails();
          break;
        case 'CONSTRUCTION_VEHICLES':
        case 'CONSTRUCTIONS':
        case 'CONSTRUCTION':
        case 'EXCAVATOR':
        case 'BULLDOZER':
        case 'LOADER':
        case 'BACKHOE':
        case 'GRADER':
        case 'ROLLER':
        case 'COMPACTOR':
        case 'FORKLIFT':
        case 'SKID_STEER':
        case 'TRENCHER':
        case 'PAVER':
        case 'CONCRETE_MIXER':
        case 'DRILL_RIG':
          formContent = ConstructionsAdvancedDetails();
          break;
        default:
          formContent = _buildPlaceholder(context, 'Vehicle Advanced Details');
      }
    } else if (categoryUpper == 'REAL_ESTATE') {
      switch (subCategoryUpper) {
        case 'STORE':
          formContent = StoreAdvancedDetails();
          break;
        case 'APARTMENT':
          formContent = ApartmentsAdvancedDetails();
          break;
        case 'HOUSE':
          formContent = HousesAdvancedDetails();
          break;
        case 'LAND':
          formContent = LandAdvancedDetails();
          break;
        case 'OFFICE':
          formContent = OfficesAdvancedDetails();
          break;
        case 'VILLA':
          formContent = VillaAdvancedDetails();
          break;
        default:
          formContent = _buildPlaceholder(
            context,
            'Real Estate Advanced Details',
          );
      }
    } else {
      formContent = _buildPlaceholder(context, 'Unknown Category');
    }

    return Column(
      children: [
        formContent,
        // Navigation buttons at the bottom of form content
        _buildNavigationButtons(context),
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context, String title) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Advanced Details",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.06,
            ),
          ),
          SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Icon(Icons.settings, size: 50, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Please select a vehicle type in Step 1 to see relevant advanced details",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.currentStep > 0 && widget.onPrevious != null)
            _buildButton(
              width: screenWidth * 0.35,
              color: Colors.grey[300]!,
              textColor: Colors.black,
              text: 'previous'.tr,
              onPressed: widget.onPrevious!,
            )
          else
            SizedBox(width: screenWidth * 0.35),

          if (widget.onNext != null)
            _buildButton(
              width: screenWidth * 0.35,
              color: Colors.blue,
              textColor: Colors.white,
              text: widget.currentStep == 2 ? 'review'.tr : 'next'.tr,
              onPressed: widget.onNext!,
            ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required double width,
    required Color color,
    required Color textColor,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: width,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
