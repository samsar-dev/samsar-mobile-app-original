import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/auth/auth_controller.dart';
import 'package:samsar/controllers/listing/user_listings_controller.dart';
import 'package:samsar/models/listing/listing_response.dart';
import 'package:samsar/views/listing_features/create_listing/create_listing_view.dart';
import 'package:samsar/views/listing_features/edit_listing/edit_listing_view.dart';
import 'package:samsar/widgets/animated_input_wrapper/animated_input_wrapper.dart';
import 'package:samsar/widgets/listing_card/listing_card.dart';

class MyListings extends StatelessWidget {
  MyListings({super.key});

  final AuthController _authController = Get.put(AuthController());
  final UserListingsController _userListingsController = Get.put(UserListingsController());

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: whiteColor,

      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Text(
          "my_listings".tr,
          style: TextStyle(color: blackColor, fontWeight: FontWeight.w400),
        ),
      ),

      body: Obx(() {
        if (_authController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_authController.user.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("login_to_view".tr),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to login screen
                    Get.offAllNamed('/login');
                  },
                  child: Text('go_to_login'.tr),
                ),
              ],
            ),
          );
        }

        // Show user listings using the controller
        return Obx(() {
          if (_userListingsController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_userListingsController.hasError.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    _userListingsController.errorMessage.value,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _userListingsController.refreshListings(),
                    child: Text('retry'.tr),
                  ),
                ],
              ),
            );
          }

          if (!_userListingsController.hasListings) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.list_alt, size: 64, color: greyColor),
                  const SizedBox(height: 16),
                  Text("no_listings".tr, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(() => const CreateListingView())?.then((_) {
                        // Refresh listings when returning from create screen
                        _userListingsController.refreshListings();
                      });
                    },
                    child: Text("create_first_listing".tr),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _userListingsController.refreshListings(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _userListingsController.userListings.length,
              itemBuilder: (context, index) {
                final listing = _userListingsController.userListings[index];
                return AnimatedInputWrapper(
                  delayMilliseconds: 100 * index,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Stack(
                      children: [
                        ListingCard(
                          title: listing.title ?? 'No Title',
                          imageUrl: listing.images.isNotEmpty
                              ? NetworkImage(listing.images.first)
                              : const AssetImage('lib/assets/error_car_mascot.png') as ImageProvider,
                          description: listing.description ?? 'No Description',
                          subCategory: listing.subCategory ?? 'Unknown',
                          listingAction: listing.listingAction ?? 'SALE',
                          price: listing.price ?? 0,
                          fuelType: listing.fuelType,
                          year: listing.year,
                          transmission: listing.transmission,
                          mileage: listing.mileage?.toString(),
                          listingId: listing.id ?? '',
                        ),
                        // Add edit button
                        Positioned(
                          top: 8,
                          right: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                              onPressed: () {
                                _navigateToEditListing(context, listing);
                              },
                            ),
                          ),
                        ),
                        // Add delete button
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.white, size: 20),
                              onPressed: () {
                                _showDeleteConfirmation(context, listing.id ?? '', listing.title ?? 'listing');
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });

      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const CreateListingView())?.then((_) {
            // Refresh listings when returning from create screen
            _userListingsController.refreshListings();
          });
        },
        backgroundColor: blueColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _navigateToEditListing(BuildContext context, Item listing) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditListingView(listing: listing),
      ),
    ).then((result) {
      // Refresh listings when returning from edit screen
      if (result == true) {
        _userListingsController.refreshListings();
      }
    });
  }

  void _showDeleteConfirmation(BuildContext context, String listingId, String listingTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('delete_listing'.tr),
          content: Text('are_you_sure_delete'.tr.replaceAll('{title}', listingTitle)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('cancel'.tr),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _userListingsController.deleteListing(listingId);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('delete'.tr),
            ),
          ],
        );
      },
    );
  }
}
