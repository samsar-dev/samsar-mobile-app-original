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
    
    errorMessage.value = '';

    final token = await _authController.getAccessToken();
    if (token == null) {
      errorMessage.value = 'Authentication required';
      return;
    }

    final response = await _service.addFavouriteListingService(
      token: token,
      listingId: listingId,
    );

    if (response.successResponse != null) {
      final added = AddFavouriteListing.fromJson(response.successResponse!);
      if (added.data != null) {
        await fetchFavourites(); // Refresh the list
      }
    } else {
      errorMessage.value =
          response.apiError?.message ?? 'Failed to add to favourites';
    }
  }

  Future<void> removeFromFavourites(String listingId) async {
    
    // Optimistically remove from UI first
    favouriteListings.removeWhere((item) => item.id == listingId);
    
    errorMessage.value = '';

    final token = await _authController.getAccessToken();
    if (token == null) {
      errorMessage.value = 'Authentication required';
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
        // Already removed optimistically, no need to do anything
      } else {
        await fetchFavourites(); // Restore if failed
      }
    } else {
      errorMessage.value =
          response.apiError?.message ?? 'Failed to remove from favourites';
      await fetchFavourites(); // Restore if failed
    }
  }

  bool isFavourite(String listingId) {
    return favouriteListings.any((item) => item.id == listingId);
  }
}
