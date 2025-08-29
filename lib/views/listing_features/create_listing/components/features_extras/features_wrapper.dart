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
  final int currentStep;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const FeaturesWrapper({
    super.key,
    required this.category,
    this.subCategory,
    required this.currentStep,
    this.onNext,
    this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final categoryUpper = category.toUpperCase();
    final subCategoryUpper = subCategory?.toUpperCase() ?? '';


    Widget formContent;

    if (categoryUpper == 'VEHICLES') {
      
      // Handle empty subcategory for vehicles - default to CARS
      String effectiveSubCategory = subCategoryUpper.isEmpty ? 'CARS' : subCategoryUpper;
      
      switch (effectiveSubCategory) {
        case 'CARS':
          formContent = CarFeatures();
          break;
        case 'MOTORCYCLES':
          formContent = MotorcycleFeatures();
          break;
        case 'PASSENGER_VEHICLES':
          formContent = PassengersFeatures();
          break;
        case 'COMMERCIAL_TRANSPORT':
          formContent = CommercialsFeatures();
          break;
        case 'CONSTRUCTION_VEHICLES':
          formContent = ConstructionsFeatures();
          break;
        default:
          formContent = _buildPlaceholder(
            context,
            'vehicle_features_extras'.tr,
          );
      }
    } else if (categoryUpper == 'REAL_ESTATE') {
      
      // Handle empty subcategory for real estate - default to APARTMENT
      String effectiveSubCategory = subCategoryUpper.isEmpty ? 'APARTMENT' : subCategoryUpper;
      
      switch (effectiveSubCategory) {
        case 'APARTMENT':
          formContent = ApartmentsFeatures();
          break;
        case 'HOUSE':
          formContent = HousesFeatures();
          break;
        case 'VILLA':
          formContent = VillasFeatures();
          break;
        case 'OFFICE':
          formContent = OfficesFeatures();
          break;
        case 'LAND':
          formContent = LandFeatures();
          break;
        case 'STORE':
          formContent = StoresFeatures();
          break;
        default:
          formContent = _buildPlaceholder(
            context,
            'real_estate_features_extras'.tr,
          );
      }
    } else {
      formContent = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 50, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'unknown_category'.tr + ': $category',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
            SizedBox(height: 8),
            Text(
              'Please select a valid category in step 1',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(child: formContent),
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
          if (currentStep > 0 && onPrevious != null)
            _buildButton(
              width: screenWidth * 0.35,
              color: Colors.grey[300]!,
              textColor: Colors.black,
              text: 'previous'.tr,
              onPressed: onPrevious!,
            )
          else
            SizedBox(width: screenWidth * 0.35),

          if (onNext != null)
            _buildButton(
              width: screenWidth * 0.35,
              color: Colors.blue,
              textColor: Colors.white,
              text: currentStep == 2 ? 'review'.tr : 'next'.tr,
              onPressed: onNext!,
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
