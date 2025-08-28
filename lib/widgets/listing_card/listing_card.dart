import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/views/listing_features/listing_detail/listing_detail.dart';
import 'package:samsar/controllers/listing/favourite_listing_controller.dart';

// Utility function to shorten long subcategory names for display
String shortenSubcategory(String subcategory) {
  const shortNames = {
    'CONSTRUCTION_VEHICLES': 'Construction',
    'COMMERCIAL_TRANSPORT': 'Commercial',
    'PASSENGER_VEHICLES': 'Passenger',
    'MOTORCYCLES': 'Motorcycles',
    'CARS': 'Cars',
  };
  return shortNames[subcategory] ?? subcategory;
}

// ignore: must_be_immutable
class ListingCard extends StatelessWidget {
  final String title;
  final ImageProvider imageUrl;
  final String description;
  final String subCategory;
  final String listingAction;
  final int price;
  final String? fuelType;
  final dynamic year;
  final String? transmission;
  final String? mileage;
  final String listingId;
  final int? bedrooms;
  final int? bathrooms;
  final int? yearBuilt;
  final int? totalArea;
  bool isDarkTheme;
  ListingCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.listingAction,
    required this.subCategory,
    required this.price,
    this.fuelType,
    this.year,
    this.transmission,
    this.mileage,
    required this.listingId,
    this.bedrooms,
    this.bathrooms,
    this.yearBuilt,
    this.totalArea,
    this.isDarkTheme = false,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Get.to(() => ListingDetail(listingId: listingId));
      },
      child: SizedBox(
        width: double.infinity,
        height: screenHeight * 0.25,
        child: Card(
          color: whiteColor,
          elevation: 4,
          child: Row(
            children: [
              Hero(
                tag: "listing_picture_${listingId}",
                child: imageSection(
                  context,
                  screenWidth,
                  screenHeight,
                  imageUrl,
                  subCategory,
                  listingAction,
                ),
              ),
              Expanded(
                child: detailSection(
                  context,
                  screenWidth,
                  screenHeight,
                  title,
                  description,
                  price,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageSection(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    ImageProvider imageUrl,
    String subCategory,
    String listingAction,
  ) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.03),
      child: Stack(
        children: [
          Container(
            width: screenWidth * 0.37,
            height: screenHeight * 0.2,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(18.0),
              child: Image(image: imageUrl, fit: BoxFit.cover),
            ),
          ),
          
          // Save/Favorite Button
          Positioned(
            top: 8,
            right: 8,
            child: GetBuilder<FavouriteListingController>(
              init: FavouriteListingController(),
              builder: (favouriteController) => GestureDetector(
                onTap: () {
                  if (favouriteController.isFavourite(listingId)) {
                    favouriteController.removeFromFavourites(listingId);
                  } else {
                    favouriteController.addToFavourites(listingId);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    favouriteController.isFavourite(listingId)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: favouriteController.isFavourite(listingId)
                        ? Colors.blue
                        : Colors.grey[600],
                    size: 20,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: screenHeight * 0.17,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTag(shortenSubcategory(subCategory), Colors.white, Colors.black),
                const SizedBox(width: 4),
                _buildTag(listingAction, Colors.blue, Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget detailSection(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    String title,
    String description,
    int price,
  ) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.02),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: blackColor,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.04,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6),

          Text(
            description,
            style: TextStyle(
              fontSize: screenWidth * 0.032,
              color: Colors.black87,
            ),
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          infoGrid(screenWidth),

          const SizedBox(height: 8),

          Text(
            "\$${price}",
            style: TextStyle(
              color: blueColor,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.04,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(fontSize: 10, color: textColor)),
    );
  }

  Widget _infoTag(String info, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: blueColor, size: 16),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            info,
            style: TextStyle(
              color: blackColor,
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget infoGrid(double screenWidth) {
    // Check if this is a real estate listing
    bool isRealEstate = subCategory.toLowerCase().contains('apartment') ||
        subCategory.toLowerCase().contains('house') ||
        subCategory.toLowerCase().contains('villa') ||
        subCategory.toLowerCase().contains('office') ||
        subCategory.toLowerCase().contains('land') ||
        subCategory.toLowerCase().contains('store') ||
        subCategory.toLowerCase().contains('commercial');

    List<Widget> infoItems = [];

    if (isRealEstate) {
      // Real estate info display
      print('🏠 [LISTING CARD DEBUG] Real estate detected for: $title');
      print('  - subCategory: $subCategory');
      print('  - totalArea: $totalArea');
      print('  - yearBuilt: $yearBuilt');
      print('  - bedrooms: $bedrooms');
      print('  - bathrooms: $bathrooms');
      
      if (totalArea != null && totalArea! > 0) {
        print('  - Adding area tag: ${totalArea} m²');
        infoItems.add(_infoTag('${totalArea} m²', Icons.square_foot));
      }
      
      // Only show yearBuilt for apartments, houses, and villas
      final showYearBuilt = subCategory.toLowerCase().contains('apartment') ||
                           subCategory.toLowerCase().contains('house') ||
                           subCategory.toLowerCase().contains('villa');
      
      if (showYearBuilt && yearBuilt != null && yearBuilt! > 0) {
        print('  - Adding year built tag: Built ${yearBuilt}');
        infoItems.add(_infoTag('Built ${yearBuilt}', Icons.calendar_month));
      } else if (showYearBuilt) {
        print('  - yearBuilt is null or 0, not showing year built tag');
      } else {
        print('  - Not showing yearBuilt for subcategory: $subCategory');
      }
      if (bedrooms != null && bedrooms! > 0) {
        infoItems.add(_infoTag('${bedrooms} bed', Icons.bed));
      }
      if (bathrooms != null && bathrooms! > 0) {
        infoItems.add(_infoTag('${bathrooms} bath', Icons.bathtub));
      }
    } else {
      // Vehicle info display
      if (fuelType != null && fuelType!.isNotEmpty) {
        infoItems.add(_infoTag(fuelType!, Icons.gas_meter));
      }
      if (year != null) {
        infoItems.add(_infoTag(year.toString(), Icons.calendar_month));
      }
      if (transmission != null && transmission!.isNotEmpty) {
        infoItems.add(_infoTag(transmission!, Icons.settings));
      }
      if (mileage != null && mileage!.isNotEmpty) {
        infoItems.add(_infoTag(mileage!, Icons.rocket));
      }
    }

    // If no specific info available, show minimal info
    if (infoItems.isEmpty) {
      if (year != null) {
        infoItems.add(_infoTag(year.toString(), Icons.calendar_month));
      }
    }

    // Split the list into chunks of 2
    List<Widget> rows = [];
    for (int i = 0; i < infoItems.length; i += 2) {
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Expanded(flex: 1, child: infoItems[i]),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: i + 1 < infoItems.length
                    ? infoItems[i + 1]
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      );
    }

    return Column(children: rows);
  }
}
