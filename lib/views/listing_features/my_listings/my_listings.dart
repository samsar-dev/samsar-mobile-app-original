import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/auth/auth_controller.dart';
import 'package:samsar/views/listing_features/create_listing/create_listing_view.dart';

// TODO: Uncomment these imports when User model is updated with listings
// import 'package:samsar/widgets/animated_input_wrapper/animated_input_wrapper.dart';
// import 'package:samsar/widgets/user_listing_card.dart/user_listing_card.dart';

class MyListings extends StatelessWidget {
  MyListings({super.key});

  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: whiteColor,

      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Text("my_listings".tr, style: TextStyle(
          color: blackColor,
          fontWeight: FontWeight.w400
        ),),
      ),

      body: Obx(() {
        if (_authController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
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

        // TODO: Replace with actual user listings once the User model is updated
        // For now, we'll show a message that the user hasn't listed anything
        // When the User model is updated with a listings property, we can use:
        // final userListings = _authController.user.value?.listings ?? [];
        
        // For now, show an empty list message
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "no_listings".tr,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Navigate to create listing screen
                  Get.to(() => const CreateListingView());
                },
                child: Text("create_first_listing".tr),
              ),
            ],
          ),
        );
        
        /* 
        // This is how it will work once the User model has a listings property:
        if (userListings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("no_listings".tr),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to create listing screen
                  },
                  child: Text("create_first_listing".tr),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: userListings.length,
          itemBuilder: (context, index) {
            final listing = userListings[index];
            return AnimatedInputWrapper(
              delayMilliseconds: 100 * index,
              child: UserListingCard(listing: listing)
            );
          },
        );
        */
      }),
    );
  }
}