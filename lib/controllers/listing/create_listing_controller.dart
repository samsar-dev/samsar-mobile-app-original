import 'package:get/get.dart';
import 'package:samsar/controllers/auth/auth_controller.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/models/listing/create_listing/create_vehicle_listing.dart';
import 'package:samsar/models/listing/create_listing/create_real_estate_listing.dart';
import 'package:samsar/models/listing/vehicle_model.dart' as car_listing;
import 'package:samsar/models/listing/real_estate_model.dart'
    as real_estate_listing;
import 'package:samsar/services/listing/create_listing_service.dart';
import 'package:samsar/widgets/custom_snackbar/custom_snackbar.dart';
import 'package:samsar/widgets/loading_dialog/loading_dialog.dart';
import 'package:samsar/models/api_response.dart';

class CreateListingController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  RxBool isCreating = false.obs;

  Future<void> createCarListingController(
    car_listing.VehicleModel carModelDetails,
  ) async {
    try {
      isCreating.value = true;
      loadingDialog('Creating listing...');



      if (carModelDetails.details.json.containsKey('vehicles')) {
        final vehiclesData =
            carModelDetails.details.json['vehicles'] as Map<String, dynamic>?;
        if (vehiclesData != null) {
        } else {
        }
      } else {
      }

      final token = await _authController.getAccessToken();

      final ApiResponse<CreateCarListing> result = await CreateListingService()
          .createCarListingService(token!, carModelDetails);

      Get.back(); // close loading dialog

      if (result.isSuccess) {
        CreateCarListing response = result.successResponse!;
        showCustomSnackbar("Listing created successfully!", false);

        // Clear the form data after successful creation
        final listingController = Get.find<ListingInputController>();
        listingController.clearDataAfterSubmission();

        // Navigate back to home or listings page
        Get.offAllNamed('/'); // Navigate to home and clear navigation stack
      } else {
        showCustomSnackbar(
          "Failed to create listing: ${result.apiError?.errorResponse?.error?.message ?? result.apiError?.fastifyErrorResponse?.message ?? "Failed to create listing"}",
          true,
        );
      }
    } catch (e) {
      Get.back(); // close loading dialog
      showCustomSnackbar("Error creating listing: $e", true);
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> createRealEstateListingController(
    real_estate_listing.RealEstateModel realEstateDetails,
  ) async {
    try {
      isCreating.value = true;
      loadingDialog('Creating real estate listing...');

      final token = await _authController.getAccessToken();

      final ApiResponse<CreateRealEstateListing> result =
          await CreateListingService().createRealEstateListingService(
            token!,
            realEstateDetails,
          );

      Get.back(); // close loading dialog

      if (result.isSuccess) {
        showCustomSnackbar("Real estate listing created successfully!", false);

        final listingController = Get.find<ListingInputController>();
        listingController.clearDataAfterSubmission();

        Get.offAllNamed('/');
      } else {
        showCustomSnackbar(
          result.apiError?.errorResponse?.error?.message ??
              result.apiError?.fastifyErrorResponse?.message ??
              "Failed to create real estate listing",
          true,
        );
      }
    } catch (e) {
      Get.back();
      showCustomSnackbar("Unexpected error: $e", true);
    } finally {
      isCreating.value = false;
    }
  }

  // Commercial Vehicle Controller for VANS, BUSES, TRACTORS
  Future<void> createCommercialVehicleController(
    CommercialVehicleModel commercialDetails,
  ) async {
    try {
      isCreating.value = true;
      loadingDialog('Creating commercial vehicle listing...');


      final token = await _authController.getAccessToken();

      final result = await CreateListingService()
          .createCommercialVehicleService(token!, commercialDetails);

      Get.back(); // close loading dialog

      if (result.isSuccess) {
        CreateCarListing response = result.successResponse!;
        showCustomSnackbar(
          "Commercial vehicle listing created successfully!",
          false,
        );

        // Clear the form data after successful creation
        final listingController = Get.find<ListingInputController>();
        listingController.clearDataAfterSubmission();

        // Navigate back to home or listings page
        Get.offAllNamed('/'); // Navigate to home and clear navigation stack
      } else {
        showCustomSnackbar(
          result.apiError?.errorResponse?.error?.message ??
              result.apiError?.fastifyErrorResponse?.message ??
              "Failed to create commercial vehicle listing",
          true,
        );
      }
    } catch (e) {
      Get.back();
      showCustomSnackbar("Unexpected error: $e", true);
    } finally {
      isCreating.value = false;
    }
  }
}
