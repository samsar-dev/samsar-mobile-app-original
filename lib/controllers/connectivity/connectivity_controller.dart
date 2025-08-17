import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  var isConnected = false.obs;
  var isChecking = true.obs; // New observable to track loading

  @override
  void onInit() {
    super.onInit();
    
    checkConnectivity(); // Sets isChecking to false once done

    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      _updateConnectivity(result.first);
    });
  }

  Future<void> checkConnectivity() async {
    isChecking.value = true;

    try {
      List<ConnectivityResult> result = await Connectivity().checkConnectivity();
      _updateConnectivity(result.isNotEmpty ? result.first : ConnectivityResult.none);
    } finally {
      isChecking.value = false;
    }
  }

  void _updateConnectivity(ConnectivityResult result) {
    isConnected.value = result != ConnectivityResult.none;
  }
}
