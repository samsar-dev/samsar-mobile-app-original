import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/controllers/listing/favourite_listing_controller.dart';

// ignore: must_be_immutable
class ImageSlider extends StatefulWidget {
  final List<String> imageUrls;
  final String listingId;
  bool isEditable;
  ImageSlider({
    super.key,
    required this.imageUrls,
    this.isEditable = false,
    required this.listingId,
  });

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final FavouriteListingController _favouriteListingController = Get.put(
    FavouriteListingController(),
  );

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.4,

      child: Stack(
        children: [
          imageSection(widget.imageUrls, screenHeight),

          Positioned(
            top: screenHeight * 0.07,
            left: 0,
            right: 0,
            child: _navButtons(screenWidth, screenHeight),
          ),
        ],
      ),
    );
  }

  Widget imageSection(List<String> images, double screenHeight) {
    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.45,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image(image: NetworkImage(images[index]), fit: BoxFit.cover);
        },
      ),
    );
  }

  Widget _navButtons(double screenWidth, double screenHeight) {
    return SizedBox(
      width: double.infinity,
      height: screenHeight * 0.05,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
            ),

            Obx(() {
              final isFav = _favouriteListingController.isFavourite(
                widget.listingId,
              );
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  onPressed: () async {
                    if (isFav) {
                      await _favouriteListingController.removeFromFavourites(
                        widget.listingId,
                      );
                    } else {
                      await _favouriteListingController.addToFavourites(
                        widget.listingId,
                      );
                    }
                  },
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.white,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
