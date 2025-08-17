import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/connectivity/connectivity_controller.dart';
import 'package:samsar/views/home/home_view.dart';


class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {


  final ConnectivityController _connectivityController = Get.put(ConnectivityController());

  @override
  void initState() {
    super.initState();

    _connectivityController.checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {

        if (_connectivityController.isChecking.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if(_connectivityController.isConnected.value) {

          Future.delayed(Duration(seconds: 1), () {
            // Always go to HomeView first - authentication will be handled per feature
            Get.offAll(HomeView());
          });



          return Center(
            child: CircularProgressIndicator(
              // backgroundColor: blueColor,
            ),
          );

        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No internet connection'),
                ElevatedButton(
                  onPressed: () {
                    _connectivityController.checkConnectivity(); 
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: blueColor
                  ),
                  child: Text('Retry', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: whiteColor
                  ),),
                ),
              ],
            ),
          );
        }
      })
    );
  }
}