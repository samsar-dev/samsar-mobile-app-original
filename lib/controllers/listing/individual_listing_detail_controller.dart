import 'package:get/get.dart';
import 'package:samsar/models/listing/individual_listing_detail_model.dart';
import 'package:samsar/services/listing/individual_listing_services.dart';

class IndividualListingDetailController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  Rxn<IndividualListingDetailModel> listingDetail =
      Rxn<IndividualListingDetailModel>();

  final _service = IndividualListingServices();

  Future<void> fetchListingDetail(String listingId) async {
    try {
      isLoading.value = true;
      final response = await _service.individualListingDetailService(listingId);
      
      // Debug ALL available fields
      final data = response.successResponse?['data'];
      if (data != null) {
        
        // Check nested vehicle details
        final vehicles = data['details']?['vehicles'];
        if (vehicles != null) {
        }
      }
      
      if (response.isSuccess) {
        try {
          listingDetail.value = IndividualListingDetailModel.fromJson(
            response.successResponse!,
          );
        } catch (e) {
          hasError.value = true;
          errorMessage.value = "Parsing error: $e";
        }
      } else {
        hasError.value = true;
        errorMessage.value = response.message;
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = "Network error: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
