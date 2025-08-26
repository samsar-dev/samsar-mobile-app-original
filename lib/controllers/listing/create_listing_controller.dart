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

      print("\n🎯 === CREATE LISTING CONTROLLER START ===");
      print("🚀 CREATE LISTING CONTROLLER CALLED");
      print("📊 RECEIVED CAR MODEL DETAILS:");
      print("  Type: ${carModelDetails.runtimeType}");
      print("  Title: '${carModelDetails.title}'");
      print("  Description: '${carModelDetails.description}'");
      print("  Price: ${carModelDetails.price}");
      print("  Main Category: '${carModelDetails.mainCategory}'");
      print("  Sub Category: '${carModelDetails.subCategory}'");
      print("  Location: '${carModelDetails.location}'");
      print("  Latitude: ${carModelDetails.latitude}");
      print("  Longitude: ${carModelDetails.longitude}");
      print("  Condition: '${carModelDetails.condition}'");
      print("  Listing Action: '${carModelDetails.listingAction}'");
      print("  Seller Type: '${carModelDetails.sellerType}'");
      print("  Images count: ${carModelDetails.listingImage.length}");
      print("  Images paths: ${carModelDetails.listingImage}");

      print("\n🔍 ANALYZING DETAILS OBJECT:");
      print("  Details type: ${carModelDetails.details.runtimeType}");
      print("  Details.json type: ${carModelDetails.details.json.runtimeType}");
      print(
        "  Details.json keys: ${carModelDetails.details.json.keys.toList()}",
      );
      print("  Details.json content: ${carModelDetails.details.json}");

      if (carModelDetails.details.json.containsKey('vehicles')) {
        final vehiclesData =
            carModelDetails.details.json['vehicles'] as Map<String, dynamic>?;
        if (vehiclesData != null) {
          print("\n🚗 VEHICLE SPECIFIC DATA FOUND:");
          print("  vehicleType: '${vehiclesData['vehicleType']}'");
          print("  make: '${vehiclesData['make']}'");
          print("  model: '${vehiclesData['model']}'");
          print("  year: '${vehiclesData['year']}'");
          print("  mileage: '${vehiclesData['mileage']}'");
          print("  horsepower: '${vehiclesData['horsepower']}'");
          print("  transmission: '${vehiclesData['transmission']}'");
          print("  fuelType: '${vehiclesData['fuelType']}'");
          print("  exteriorColor: '${vehiclesData['exteriorColor']}'");
          print("  bodyType: '${vehiclesData['bodyType']}'");
          print("  driveType: '${vehiclesData['driveType']}'");
          print("  accidentFree: '${vehiclesData['accidentFree']}'");
          print("  features: '${vehiclesData['features']}'");
        } else {
          print("  ❌ vehicles data is null!");
        }
      } else {
        print("  ❌ No 'vehicles' key found in details.json!");
      }

      final token = await _authController.getAccessToken();
      print("🔑 Auth token: ${token != null ? 'Present' : 'Missing'}");

      final ApiResponse<CreateCarListing> result = await CreateListingService()
          .createCarListingService(token!, carModelDetails);

      Get.back(); // close loading dialog

      if (result.isSuccess) {
        CreateCarListing response = result.successResponse!;
        showCustomSnackbar("Listing created successfully!", false);

        // Clear the form data after successful creation
        final listingController = Get.find<ListingInputController>();
        print("🔄 Clearing form data...");
        listingController.clearDataAfterSubmission();
        print("✅ Form data cleared.");

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
      print("❌ Error creating car listing: $e");
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

      print("=== CREATE COMMERCIAL VEHICLE CONTROLLER ===");
      print("Commercial Vehicle Details: $commercialDetails");
      print("Title: ${commercialDetails.title}");
      print("Description: ${commercialDetails.description}");
      print("Price: ${commercialDetails.price}");
      print("Main Category: ${commercialDetails.mainCategory}");
      print("Sub Category: ${commercialDetails.subCategory}");
      print("Vehicle Subtype: ${commercialDetails.vehicleSubtype}");
      print("Location: ${commercialDetails.location}");
      print("Latitude: ${commercialDetails.latitude}");
      print("Longitude: ${commercialDetails.longitude}");
      print("Condition: ${commercialDetails.condition}");
      print("Listing Action: ${commercialDetails.listingAction}");
      print("Images count: ${commercialDetails.listingImage.length}");
      print("Details: ${commercialDetails.details}");

      final token = await _authController.getAccessToken();
      print("Auth token: ${token != null ? 'Present' : 'Missing'}");

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
