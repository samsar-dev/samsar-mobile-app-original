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
      print(' [DETAIL CONTROLLER DEBUG] Fetching listing: $listingId');
      final response = await _service.individualListingDetailService(listingId);
      print(' [DETAIL CONTROLLER DEBUG] Raw API response: $response');
      print(' [DETAIL CONTROLLER DEBUG] Response success: ${response.isSuccess}');
      print(' [DETAIL CONTROLLER DEBUG] Response data: ${response.successResponse}');
      
      // Debug ALL available fields
      final data = response.successResponse?['data'];
      if (data != null) {
        print(' [DETAIL CONTROLLER DEBUG] Available root fields: ${data.keys.toList()}');
        print(' [DETAIL CONTROLLER DEBUG] sellerType: ${data['sellerType']}');
        print(' [DETAIL CONTROLLER DEBUG] listingAction: ${data['listingAction']}');
        print(' [DETAIL CONTROLLER DEBUG] transmission: ${data['transmission']}');
        print(' [DETAIL CONTROLLER DEBUG] exteriorColor: ${data['exteriorColor']}');
        
        // Check nested vehicle details
        final vehicles = data['details']?['vehicles'];
        if (vehicles != null) {
          print(' [DETAIL CONTROLLER DEBUG] Vehicle nested fields: ${vehicles.keys.toList()}');
          print(' [DETAIL CONTROLLER DEBUG] Vehicle transmission: ${vehicles['transmission']}');
          print(' [DETAIL CONTROLLER DEBUG] Vehicle transmissionType: ${vehicles['transmissionType']}');
          print(' [DETAIL CONTROLLER DEBUG] Vehicle bodyType: ${vehicles['bodyType']}');
          print(' [DETAIL CONTROLLER DEBUG] Vehicle engineSize: ${vehicles['engineSize']}');
          print(' [DETAIL CONTROLLER DEBUG] Vehicle accidentFree: ${vehicles['accidentFree']}');
        }
      }
      
      if (response.isSuccess) {
        try {
          listingDetail.value = IndividualListingDetailModel.fromJson(
            response.successResponse!,
          );
          print(' [DETAIL CONTROLLER DEBUG] Parsed listing successfully');
          print(' [DETAIL CONTROLLER DEBUG] Listing title: ${listingDetail.value?.data?.title}');
          print(' [DETAIL CONTROLLER DEBUG] Vehicle details: ${listingDetail.value?.data?.details?.vehicles}');
        } catch (e) {
          print(' [DETAIL CONTROLLER DEBUG] Parsing error: $e');
          hasError.value = true;
          errorMessage.value = "Parsing error: $e";
        }
      } else {
        print(' [DETAIL CONTROLLER DEBUG] API error: ${response.message}');
        hasError.value = true;
        errorMessage.value = response.message;
      }
    } catch (e) {
      print(' [DETAIL CONTROLLER DEBUG] Exception: $e');
      hasError.value = true;
      errorMessage.value = "Network error: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
