import 'package:get/get.dart';
import 'package:samsar/controllers/auth/auth_controller.dart';
import 'package:samsar/models/listing/favourite_listing/add_favourite_listing.dart';
import 'package:samsar/models/listing/favourite_listing/favourite_model.dart';
import 'package:samsar/models/listing/favourite_listing/get_favourite_llisting.dart';
import 'package:samsar/models/listing/favourite_listing/remove_favourite_listing.dart';
import 'package:samsar/services/listing/favourite_listing_service.dart';

class FavouriteListingController extends GetxController {
  final FavouriteListingService _service = FavouriteListingService();
  final AuthController _authController = Get.put(AuthController());

  var isLoading = false.obs;
  var favouriteListings = <FavoriteModel>[].obs;
  var errorMessage = ''.obs;

  Future<void> fetchFavourites() async {
    isLoading.value = true;
    errorMessage.value = '';

    final token = await _authController.getAccessToken();

    final response = await _service.getFavouriteListingService(token!);

    if (response.successResponse != null) {
      final data = GetFavouriteListingSuccessResponse.fromJson(
        response.successResponse!,
      );
      favouriteListings.value = data.data?.favorites ?? [];
    } else {
      errorMessage.value = response.apiError?.message ?? 'Something went wrong';
    }

    isLoading.value = false;
  }

  Future<void> addToFavourites(String listingId) async {
    print('🔄 Adding to favourites: $listingId');
    
    errorMessage.value = '';

    final token = await _authController.getAccessToken();
    if (token == null) {
      errorMessage.value = 'Authentication required';
      print('❌ No auth token available');
      return;
    }

    final response = await _service.addFavouriteListingService(
      token: token,
      listingId: listingId,
    );

    if (response.successResponse != null) {
      final added = AddFavouriteListing.fromJson(response.successResponse!);
      if (added.data != null) {
        print('✅ Successfully added to favourites');
        await fetchFavourites(); // Refresh the list
      }
    } else {
      errorMessage.value =
          response.apiError?.message ?? 'Failed to add to favourites';
      print('❌ Failed to add to favourites: ${errorMessage.value}');
    }
  }

  Future<void> removeFromFavourites(String listingId) async {
    print('🔄 Removing from favourites: $listingId');
    
    // Optimistically remove from UI first
    favouriteListings.removeWhere((item) => item.id == listingId);
    
    errorMessage.value = '';

    final token = await _authController.getAccessToken();
    if (token == null) {
      errorMessage.value = 'Authentication required';
      print('❌ No auth token available');
      return;
    }

    final response = await _service.removeFavouriteListingService(
      token: token,
      listingId: listingId,
    );

    if (response.successResponse != null) {
      final removed = RemoveFavouriteListing.fromJson(
        response.successResponse!,
      );
      if (removed.success == true) {
        print('✅ Successfully removed from favourites');
        // Already removed optimistically, no need to do anything
      } else {
        print('❌ Remove operation failed, refreshing list');
        await fetchFavourites(); // Restore if failed
      }
    } else {
      errorMessage.value =
          response.apiError?.message ?? 'Failed to remove from favourites';
      print('❌ Failed to remove from favourites: ${errorMessage.value}');
      await fetchFavourites(); // Restore if failed
    }
  }

  bool isFavourite(String listingId) {
    return favouriteListings.any((item) => item.id == listingId);
  }
}
