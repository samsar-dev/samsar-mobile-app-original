import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/views/listing_features/listing_detail/listing_detail.dart';
import 'package:samsar/controllers/listing/favourite_listing_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

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
  final String listingId;
  final String? location;
  bool isDarkTheme;
  ListingCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.listingAction,
    required this.subCategory,
    required this.price,
    required this.listingId,
    this.location,
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

          // Location section
          if (location != null && location!.isNotEmpty)
            GestureDetector(
              onTap: () => _openMaps(location!),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.grey[600],
                    size: screenWidth * 0.035,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      location!,
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

          if (location != null && location!.isNotEmpty)
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


  Widget infoGrid(double screenWidth) {
    // Return empty container - no technical details shown
    return const SizedBox.shrink();
  }

  // Function to open maps based on platform
  Future<void> _openMaps(String location) async {
    try {
      final encodedLocation = Uri.encodeComponent(location);
      
      // Create URLs for different platforms
      final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$encodedLocation';
      final appleMapsUrl = 'https://maps.apple.com/?q=$encodedLocation';
      
      Uri uri;
      
      // Choose appropriate maps app based on platform
      if (Platform.isIOS) {
        // Try Apple Maps first on iOS
        uri = Uri.parse(appleMapsUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return;
        }
      }
      
      // Fallback to Google Maps (works on both platforms)
      uri = Uri.parse(googleMapsUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // If all else fails, show a snackbar
        Get.snackbar(
          'Error',
          'Could not open maps application',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open maps: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
