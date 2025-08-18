import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/views/listing_features/listing_detail/listing_detail.dart';

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
  bool isDarkTheme;
  ListingCard(
    {
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
      this.isDarkTheme = false,
    }
  );

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
                  child: imageSection(context, screenWidth, screenHeight,
                      imageUrl, subCategory, listingAction)),
              Expanded(
                child: detailSection(context, screenWidth, screenHeight,
                    title, description, price),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget imageSection(
    BuildContext context, double screenWidth, double screenHeight, ImageProvider imageUrl, String subCategory, String listingAction) {
    return Padding(
      padding:  EdgeInsets.all(screenWidth * 0.03),
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
              child: Image(
                image: imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned(
            top: screenHeight * 0.17,
            left: screenWidth * 0.15,
            child: Row(
              children: [
                _buildTag(subCategory, Colors.white, Colors.black),
                const SizedBox(width: 4),
                _buildTag(listingAction, Colors.blue, Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget detailSection(BuildContext context, double screenWidth, double screenHeight, String title, String description, int price) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.02),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, 
            style: TextStyle(
              color: blackColor,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.04
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 6,),

          Text(description, 
            style: TextStyle(
               fontSize: screenWidth * 0.032,
               color: Colors.black87,
            ),
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8,),

          infoGrid(screenWidth),

          const SizedBox(height: 8,),

          Text("\$${price}", 
            style: TextStyle(
              color: blueColor,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth * 0.04
            ),
          )
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
      child: Text(
        text,
        style: TextStyle(fontSize: 10, color: textColor),
      ),
    );
  }

  Widget _infoTag(String info, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: blueColor, size: 16,),
        const SizedBox(width: 3,),
        Flexible(
          child: Text(info, 
            style: TextStyle(
              color: blackColor,
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }

  Widget infoGrid(double screenWidth) {
  // Extract year from title if not available in year field
  String getDisplayYear() {
    if (year != null) return year.toString();
    
    // Try to extract year from title
    final titleText = title;
    final yearRegex = RegExp(r'\b(19|20)\d{2}\b');
    final match = yearRegex.firstMatch(titleText);
    if (match != null) {
      return match.group(0) ?? 'Unknown';
    }
    return 'Unknown';
  }
  
  // Get meaningful fuel type
  String getDisplayFuelType() {
    if (fuelType != null && fuelType!.isNotEmpty) return fuelType!;
    // Default based on vehicle category
    if (subCategory.toLowerCase().contains('car')) return 'Gasoline';
    return 'Unknown';
  }
  
  // Get meaningful transmission
  String getDisplayTransmission() {
    if (transmission != null && transmission!.isNotEmpty) return transmission!;
    return 'Manual'; // Most common default
  }
  
  // Get meaningful mileage/distance info
  String getDisplayMileage() {
    if (mileage != null && mileage!.isNotEmpty) return mileage!;
    return 'Contact seller'; // More helpful than N/A
  }
  
  final infoItems = [
    _infoTag(getDisplayFuelType(), Icons.gas_meter),
    _infoTag(getDisplayYear(), Icons.calendar_month),
    _infoTag(getDisplayTransmission(), Icons.settings),
    _infoTag(getDisplayMileage(), Icons.rocket),
  ];

  // Split the list into chunks of 2
  List<Widget> rows = [];
  for (int i = 0; i < infoItems.length; i += 2) {
    rows.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: infoItems[i]
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: i + 1 < infoItems.length ? infoItems[i + 1] : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  return Column(children: rows);
}

}