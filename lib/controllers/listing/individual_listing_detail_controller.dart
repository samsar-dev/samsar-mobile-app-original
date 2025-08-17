import 'package:get/get.dart';
import 'package:samsar/models/listing/individual_listing_detail_model.dart';
import 'package:samsar/services/listing/individual_listing_services.dart';

class IndividualListingDetailController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  Rxn<IndividualListingDetailModel> listingDetail = Rxn<IndividualListingDetailModel>();

  Future<void> fetchListingDetail(String id) async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';

    final response = await IndividualListingServices().individualListingDetailService(id);


    if (response.isSuccess) {
      try {
        listingDetail.value = IndividualListingDetailModel.fromJson(response.successResponse!);
      } catch (e) {
        hasError.value = true;
        errorMessage.value = "Parsing error.";
      }
    } else {
      hasError.value = true;
      errorMessage.value = response.message;
    }

    isLoading.value = false;
  }
}
