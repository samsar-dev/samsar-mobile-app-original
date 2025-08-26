import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/utils/location_display_utils.dart';
import 'package:samsar/widgets/app_button/app_button.dart';

class UserListingCard extends StatelessWidget {
  final bool isFavourite;
  final String imageUrl;
  final String title;
  final String price;
  final String location;
  final String date;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const UserListingCard({
    super.key,
    this.isFavourite = false,
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.location,
    required this.date,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: whiteColor,

        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              imageSection(screenHeight, screenWidth, imageUrl),

              SizedBox(width: screenWidth * 0.035),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    detailSection(
                      title,
                      price,
                      location,
                      date,
                      screenHeight,
                      screenWidth,
                    ),

                    SizedBox(height: screenHeight * 0.015),

                    // Conditionally render action buttons
                    if (!isFavourite) actionButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageSection(
    double screenHeight,
    double screenWidth,
    String imageUrl,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Image.network(
        imageUrl,
        width: screenWidth * 0.4,
        height: screenHeight * 0.18,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget actionButtons() {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            widthSize: 1,
            heightSize: 0.06,
            buttonColor: blueColor,
            text: "edit".tr,
            textColor: whiteColor,
            textSize: 14,
            onPressed: onEdit,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AppButton(
            widthSize: 1,
            heightSize: 0.06,
            buttonColor: Colors.red,
            text: "delete".tr,
            textColor: whiteColor,
            textSize: 14,
            onPressed: onDelete,
          ),
        ),
      ],
    );
  }

  Widget detailSection(
    String title,
    String price,
    String location,
    String date,
    double screenHeight,
    double screenWidth,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.04,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: screenHeight * 0.004),
        Text(
          "\$$price",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        SizedBox(height: screenHeight * 0.004),
        locationBadge(Icons.location_pin, location),
        SizedBox(height: screenHeight * 0.004),
        Text(date, style: TextStyle(color: greyColor, fontSize: 14)),
      ],
    );
  }

  Widget locationBadge(IconData icon, String location) {
    return Row(
      children: [
        Icon(icon, color: greyColor, size: 18),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            LocationDisplayUtils.formatLocationForDisplay(location),
            style: TextStyle(color: greyColor, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
