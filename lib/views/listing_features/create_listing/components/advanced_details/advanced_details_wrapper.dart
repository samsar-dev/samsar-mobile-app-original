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

  const AdvancedDetailsWrapper({
    super.key,
    required this.category,
    this.subCategory,
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
        print('✅ AdvancedDetailsWrapper: Found existing controller');
      } else {
        print('🚨 AdvancedDetailsWrapper: Controller not registered, creating permanent instance');
        _listingInputController = Get.put(ListingInputController(), permanent: true);
      }
    } catch (e) {
      print('🚨 AdvancedDetailsWrapper: Error accessing controller: $e');
      _listingInputController = Get.put(ListingInputController(), permanent: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryUpper = widget.category.toUpperCase();
    final subCategoryUpper = widget.subCategory?.toUpperCase() ?? '';

    if (categoryUpper == 'VEHICLES') {
      switch (subCategoryUpper) {
        case 'CARS':
          return CarsAdvancedDetails();
        case 'MOTORCYCLES':
          return MotorcyclesAdvancedDetails();
        case 'PASSENGER_VEHICLES':
        case 'PASSENGERS':
        case 'BUS':
        case 'MINIVAN':
        case 'VAN':
        case 'MICROBUS':
        case 'COACH':
        case 'SHUTTLE':
          return PassengersAdvancedDetails();
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
          return CommercialsAdvancedDetails();
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
          return ConstructionsAdvancedDetails();
        default:
          return _buildPlaceholder(context, 'Vehicle Advanced Details');
      }
    } else if (categoryUpper == 'REAL_ESTATE') {
      switch (subCategoryUpper) {
        case 'STORE':
          return StoreAdvancedDetails();
        case 'APARTMENT':
          return ApartmentsAdvancedDetails();
        case 'HOUSE':
          return HousesAdvancedDetails();
        case 'LAND':
          return LandAdvancedDetails();
        case 'OFFICE':
          return OfficesAdvancedDetails();
        case 'VILLA':
          return VillaAdvancedDetails();
        default:
          return _buildPlaceholder(context, 'Real Estate Advanced Details');
      }
    } else {
      return _buildPlaceholder(context, 'Unknown Category');
    }
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
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
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
