import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/favourite_listing_controller.dart';
import 'package:samsar/views/listing_features/listing_detail/listing_detail.dart';
import 'package:samsar/widgets/animated_input_wrapper/animated_input_wrapper.dart';
import 'package:samsar/widgets/listing_card/listing_card.dart'; 

class FavouriteListings extends StatefulWidget {
  const FavouriteListings({super.key});

  @override
  State<FavouriteListings> createState() => _FavouriteListingsState();
}

class _FavouriteListingsState extends State<FavouriteListings> {
  final FavouriteListingController _favouriteListingController = Get.put(FavouriteListingController());

  @override
  void initState() {
    super.initState();
    _favouriteListingController.fetchFavourites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        title: Text(
          "favourites".tr,
          style: TextStyle(
            color: blackColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (_favouriteListingController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_favouriteListingController.favouriteListings.isEmpty) {
            return Center(child: Text("no_favourites_yet".tr));
          }

          return ListView.builder(
            itemCount: _favouriteListingController.favouriteListings.length,
            itemBuilder: (context, index) {
              final item = _favouriteListingController.favouriteListings[index];

              return AnimatedInputWrapper(
                delayMilliseconds: index * 100,
                child: GestureDetector(
                  onTap: () {
                    Get.to(ListingDetail(listingId: item.id ?? ""));
                  },
                  child: ListingCard(
                    title: item.title ?? "no_title".tr,
                    imageUrl: item.images.isNotEmpty
                        ? NetworkImage(item.images[0])
                        : carError as ImageProvider,
                    description: item.description ?? '',
                    listingAction: item.listingAction ?? '',
                    subCategory: item.category?.subCategory ?? '',
                    listingId: item.id ?? 'NA',
                    price: item.price ?? 0,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
