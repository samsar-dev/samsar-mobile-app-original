import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/views/listing_features/create_listing/components/features_extras/car_features.dart';
import 'package:samsar/views/listing_features/create_listing/components/features_extras/motorcycle_features.dart';
import 'package:samsar/views/listing_features/create_listing/components/features_extras/passengers_features.dart';
import 'package:samsar/views/listing_features/create_listing/components/features_extras/commercials_features.dart';
import 'package:samsar/views/listing_features/create_listing/components/features_extras/constructions_features.dart';
// Real estate features
import 'package:samsar/views/listing_features/create_listing/components/features_extras/apartments_features.dart';
import 'package:samsar/views/listing_features/create_listing/components/features_extras/houses_features.dart';
import 'package:samsar/views/listing_features/create_listing/components/features_extras/villas_features.dart';
import 'package:samsar/views/listing_features/create_listing/components/features_extras/offices_features.dart';
import 'package:samsar/views/listing_features/create_listing/components/features_extras/land_features.dart';
import 'package:samsar/views/listing_features/create_listing/components/features_extras/stores_features.dart';
 

class FeaturesWrapper extends StatelessWidget {
  final String category;
  final String? subCategory; // For vehicles and real estate subcategories

  const FeaturesWrapper({super.key, 
    required this.category,
    this.subCategory,
  });

  @override
  Widget build(BuildContext context) {
    final categoryUpper = category.toUpperCase();
    final subCategoryUpper = subCategory?.toUpperCase() ?? '';
    
    if (categoryUpper == 'VEHICLES') {
      switch (subCategoryUpper) {
        case 'CARS':
          return CarFeatures();
        case 'MOTORCYCLES':
          return MotorcycleFeatures();
        case 'PASSENGER_VEHICLES':
          return PassengersFeatures();
        case 'COMMERCIAL_TRANSPORT':
          return CommercialsFeatures();
        case 'CONSTRUCTION_VEHICLES':
          return ConstructionsFeatures();
        default:
          return _buildPlaceholder(context, 'vehicle_features_extras'.tr);
      }
    } else if (categoryUpper == 'REAL_ESTATE') {
      switch (subCategoryUpper) {
        case 'APARTMENT':
          return ApartmentsFeatures();
        case 'HOUSE':
          return HousesFeatures();
        case 'VILLA':
          return VillasFeatures();
        case 'OFFICE':
          return OfficesFeatures();
        case 'LAND':
          return LandFeatures();
        case 'STORE':
          return StoresFeatures();
        default:
          return _buildPlaceholder(context, 'real_estate_features_extras'.tr);
      }
    } else {
      return Center(
        child: Text('unknown_category'.tr + ': $category'),
      );
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
            "features_extras".tr,
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
                Icon(Icons.star, size: 50, color: Colors.grey[400]),
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
                  "select_vehicle_type_step1".tr,
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
