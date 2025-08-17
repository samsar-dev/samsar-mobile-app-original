import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/views/listing_features/create_listing/components/review_listing.dart';
import 'package:samsar/widgets/animated_input_wrapper/animated_input_wrapper.dart' show AnimatedInputWrapper;
import 'package:samsar/widgets/app_button/app_button.dart';

class FeaturesAndExtras extends StatefulWidget {
  const FeaturesAndExtras({super.key});

  @override
  State<FeaturesAndExtras> createState() => _FeaturesAndExtrasState();
}

class _FeaturesAndExtrasState extends State<FeaturesAndExtras> {
  int currentStep = 0;

  final ListingInputController _listingInputController = Get.find<ListingInputController>();

  //Safety and Assistance
  final TextEditingController airbagsCountController = TextEditingController();

  bool isAbsAvailable = false;
  bool isTractoionControl = false;
  bool isLaneAssist = false;
  bool isBlindSpotMonitor = false;
  bool isEmergencyBraking = false;
  bool isAdaptiveCruiseControl = false;
  bool isLaneDepartureWarning = false;
  bool isFatigueWarningSystem = false;
  bool isIsofix = false;
  bool isEmergencyCallSystem = false;
  bool isSpeedLimited = false;
  bool isTirePressureMonitoring = false;
  bool isParkingSensor = false;
  bool isRearCamera = false;
  bool isThreeSixtyCamera = false;
  bool isNightVision = false;
  bool isTrafficSignRecognition = false;

  //driver assistanc
  bool crusiseControl = false;
  bool automaticHighBeam = false;
  bool lightSensor = false;
  bool hillStartAssis = false;
  bool parkingAssisOrSelfParking = false;

  //lighting
  bool isLedHeadlights = false;
  bool isAdaptiveHeadlights = false;
  bool isFogLights = false;
  bool isDaytimeRunningLights = false;
  bool isAmbientLighting = false;

  //entertainement and connectivity
  bool isBluetooth = false;
  bool isAppleCarPlay = false;
  bool isAndroidAuto = false;
  bool isPremiumSoundSystem = false;
  bool isWirelessCharging = false;
  bool isUsbPorts = false;
  bool isOnboardComputer = false;
  bool isDabOrFmRadio = false;
  bool isWifiHotspot = false;
  bool isIntegratedStreaming = false;
  bool isRearSeatEntertainment = false;

  //miscllenious
  bool isCentralLocking = false;
  bool isImmobilizer = false;
  bool isAlarmSystem = false;
  bool isPowerSteering = false;
  bool isSummerTires = false;





  @override
  Widget build(BuildContext context) {

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(

      backgroundColor: whiteColor,

      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Text("Features and Extras", style: TextStyle(color: blackColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),

      body: Theme(
         data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: blueColor,
                surface: whiteColor,
              ),
        ),
        child: Stepper(
          type: StepperType.vertical,
          currentStep: currentStep,
           onStepContinue: () {
            if (currentStep < 4) {
              setState(() => currentStep++);
            } else {

              _listingInputController.featuresAndExtras(
                noOfAirbags: int.tryParse(airbagsCountController.text) ?? 0,
                abs: isAbsAvailable,
                tractionControl: isTractoionControl,
                laneAssist: isLaneAssist,
                isBlindSpotMonitor: isBlindSpotMonitor,
                isEmergencyBraking: isEmergencyBraking,
                isAdaptiveCruiseControl: isAdaptiveCruiseControl,
                isLaneDepartureWarning: isLaneDepartureWarning,
                isFatigueWarningSystem: isFatigueWarningSystem,
                isIsofix: isIsofix,
                isEmergencyCallSystem: isEmergencyCallSystem,
                isSpeedLimited: isSpeedLimited,
                isTirePressureMonitoring: isTirePressureMonitoring,
                parkingSensor: isParkingSensor,
                isRearCamera: isRearCamera,
                isThreeSixtyCamera: isThreeSixtyCamera,
                isTrafficSignRecognition: isTrafficSignRecognition,

                cruiseControl: crusiseControl,
                automaticHighBeam: automaticHighBeam,
                lightSensor: lightSensor,
                hillStartAssist: hillStartAssis,
                parkingAssistOrSelfParking: parkingAssisOrSelfParking,

                isLedHeadlights: isLedHeadlights,
                isAdaptiveHeadlights: isAdaptiveHeadlights,
                isFogLights: isFogLights,
                isDaytimeRunningLights: isDaytimeRunningLights,
                isAmbientLighting: isAmbientLighting,

                isBluetooth: isBluetooth,
                isAppleCarPlay: isAppleCarPlay,
                isAndroidAuto: isAndroidAuto,
                isPremiumSoundSystem: isPremiumSoundSystem,
                isWirelessCharging: isWirelessCharging,
                isUsbPorts: isUsbPorts,
                isOnboardComputer: isOnboardComputer,
                isDabOrFmRadio: isDabOrFmRadio,
                isWifiHotspot: isWifiHotspot,
                isIntegratedStreaming: isIntegratedStreaming,
                isRearSeatEntertainment: isRearSeatEntertainment,

                isCentralLocking: isCentralLocking,
                isImmobilizer: isImmobilizer,
                isAlarmSystem: isAlarmSystem,
                isPowerSteering: isPowerSteering,
                isSummerTires: isSummerTires,
              );

              
              Get.to(ReviewListing(
                isVehicle: true,
                imageUrls: _listingInputController.listingImage.toList(),
              ));
            }
          },
          onStepCancel: () {
            if (currentStep > 0) setState(() => currentStep--);
          },
          onStepTapped: (index) => setState(() => currentStep = index),
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  AppButton(
                    widthSize: 0.35,
                    heightSize: 0.06,
                    buttonColor: blueColor,
                    text: currentStep == 4 ? "Review" : "Next",
                    textColor: whiteColor,
                    onPressed: details.onStepContinue!,
                  ),
                  const SizedBox(width: 12),
                  if (currentStep > 0)
                    AppButton(
                      widthSize: 0.35,
                      heightSize: 0.06,
                      buttonColor: purpleColor,
                      text: "Back",
                      textColor: whiteColor,
                      onPressed: details.onStepCancel!,
                    ),
                ],
              ),
            );
          },
          steps: [
            Step(
               title: const Text("Safety and Assistance"),
               isActive:  currentStep >= 0,
               state: currentStep > 0 ? StepState.complete : StepState.indexed,
               content: safetyAndAssistance(screenHeight, screenWidth)
            ),

            Step(
               title: const Text("Driver Assistance"),
               isActive:  currentStep >= 1,
               state: currentStep > 1 ? StepState.complete : StepState.indexed,
               content: driverAssistance(screenHeight, screenWidth)
            ),

            Step(
               title: const Text("Lighting"),
               isActive:  currentStep >= 2,
               state: currentStep > 2 ? StepState.complete : StepState.indexed,
               content: lighting(screenHeight, screenWidth)
            ),

            Step(
               title: const Text("Entertainemnt and Connectivity"),
               isActive:  currentStep >= 3,
               state: currentStep > 3 ? StepState.complete : StepState.indexed,
               content: entertainmentAndConnectivity(screenHeight, screenWidth)
            ),

            Step(
               title: const Text("Miscellaneous"),
               isActive:  currentStep >= 4,
               state: currentStep > 4 ? StepState.complete : StepState.indexed,
               content: miscellaneous(screenHeight, screenWidth)
            ),
          ],
        ),
      ),
    );
  }

 Widget safetyAndAssistance(double screenHeight, double screenWidth) {
    return Container(
      color: whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Safety and Assistance",
              style: TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.06,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),

          AnimatedInputWrapper(
            delayMilliseconds: 0,
            child: airBagsInput(),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 100,
            child: switchInput("ABS", isAbsAvailable, (val) {
              setState(() => isAbsAvailable = val);
              _listingInputController.abs.value = val;
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 150,
            child: switchInput("Traction Control", isTractoionControl, (val) {
              setState(() => isTractoionControl = val);
              _listingInputController.tractionControl.value = val;
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 200,
            child: switchInput("Lane Assist", isLaneAssist, (val) {
              setState(() => isLaneAssist = val);
              _listingInputController.laneAssist.value = val;
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 250,
            child: switchInput("Blind Spot Monitor", isBlindSpotMonitor, (val) {
              setState(() => isBlindSpotMonitor = val);
              _listingInputController.isBlindSpotMonitor.value = val;
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 300,
            child: switchInput("Emergency Braking", isEmergencyBraking, (val) {
              setState(() => isEmergencyBraking = val);
              _listingInputController.isEmergencyBraking.value = val;
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 350,
            child: switchInput("Adaptive Cruise Control", isAdaptiveCruiseControl, (val) {
              setState(() => isAdaptiveCruiseControl = val);
              _listingInputController.isAdaptiveCruiseControl.value = val;
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 400,
            child: switchInput("Lane Departure Warning", isLaneDepartureWarning, (val) {
              setState(() => isLaneDepartureWarning = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 450,
            child: switchInput("Fatigue Warning System", isFatigueWarningSystem, (val) {
              setState(() => isFatigueWarningSystem = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 500,
            child: switchInput("ISOFIX (Child Seat Mount)", isIsofix, (val) {
              setState(() => isIsofix = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 550,
            child: switchInput("Emergency Call System", isEmergencyCallSystem, (val) {
              setState(() => isEmergencyCallSystem = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 600,
            child: switchInput("Speed Limiter", isSpeedLimited, (val) {
              setState(() => isSpeedLimited = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 650,
            child: switchInput("Tire Pressure Monitoring System", isTirePressureMonitoring, (val) {
              setState(() => isTirePressureMonitoring = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 700,
            child: switchInput("Parking Sensor", isParkingSensor, (val) {
              setState(() => isParkingSensor = val);
              _listingInputController.parkingSensor.value = val;
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 750,
            child: switchInput("Rear Camera", isRearCamera, (val) {
              setState(() => isRearCamera = val);
              _listingInputController.isRearCamera.value = val;
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 800,
            child: switchInput("360° Camera", isThreeSixtyCamera, (val) {
              setState(() => isThreeSixtyCamera = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 850,
            child: switchInput("Night Vision", isNightVision, (val) {
              setState(() => isNightVision = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 900,
            child: switchInput("Traffic Sign Recognition", isTrafficSignRecognition, (val) {
              setState(() => isTrafficSignRecognition = val);
            }),
          ),
        ],
      ),
    );
  }


  Widget driverAssistance(double screenHeight, double screenWidth) {
    return Container(
      color: whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Driver Assistance",
              style: TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.06,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),

          AnimatedInputWrapper(
            delayMilliseconds: 0,
            child: switchInput("Cruise Control", crusiseControl, (val) {
              setState(() => crusiseControl = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 100,
            child: switchInput("Automatic High Beam", automaticHighBeam, (val) {
              setState(() => automaticHighBeam = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 200,
            child: switchInput("Light Sensor", lightSensor, (val) {
              setState(() => lightSensor = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 300,
            child: switchInput("Hill Start Assist", hillStartAssis, (val) {
              setState(() => hillStartAssis = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 400,
            child: switchInput("Parking Assist / Self Parking", parkingAssisOrSelfParking, (val) {
              setState(() => parkingAssisOrSelfParking = val);
            }),
          ),
        ],
      ),
    );
  }


  Widget lighting(double screenHeight, double screenWidth) {
    return Container(
      color: whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Lighting Features",
              style: TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.06,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),

          AnimatedInputWrapper(
            delayMilliseconds: 0,
            child: switchInput("LED Headlights", isLedHeadlights, (val) {
              setState(() => isLedHeadlights = val);
              _listingInputController.isLedHeadlights.value = val;
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 100,
            child: switchInput("Adaptive Headlights", isAdaptiveHeadlights, (val) {
              setState(() => isAdaptiveHeadlights = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 200,
            child: switchInput("Fog Lights", isFogLights, (val) {
              setState(() => isFogLights = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 300,
            child: switchInput("Daytime Running Lights", isDaytimeRunningLights, (val) {
              setState(() => isDaytimeRunningLights = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 400,
            child: switchInput("Ambient Lighting", isAmbientLighting, (val) {
              setState(() => isAmbientLighting = val);
            }),
          ),
        ],
      ),
    );
  }


  Widget entertainmentAndConnectivity(double screenHeight, double screenWidth) {
    return Container(
      color: whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Entertainment & Connectivity",
              style: TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.06,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),

          AnimatedInputWrapper(
            delayMilliseconds: 0,
            child: switchInput("Bluetooth", isBluetooth, (val) {
              setState(() => isBluetooth = val);
              _listingInputController.isBluetooth.value = val;
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 100,
            child: switchInput("Apple CarPlay", isAppleCarPlay, (val) {
              setState(() => isAppleCarPlay = val);
              _listingInputController.isAppleCarPlay.value = val;
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 200,
            child: switchInput("Android Auto", isAndroidAuto, (val) {
              setState(() => isAndroidAuto = val);
              _listingInputController.isAndroidAuto.value = val;
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 300,
            child: switchInput("Premium Sound System", isPremiumSoundSystem, (val) {
              setState(() => isPremiumSoundSystem = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 400,
            child: switchInput("Wireless Charging", isWirelessCharging, (val) {
              setState(() => isWirelessCharging = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 500,
            child: switchInput("USB Ports", isUsbPorts, (val) {
              setState(() => isUsbPorts = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 600,
            child: switchInput("Onboard Computer", isOnboardComputer, (val) {
              setState(() => isOnboardComputer = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 700,
            child: switchInput("DAB / FM Radio", isDabOrFmRadio, (val) {
              setState(() => isDabOrFmRadio = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 800,
            child: switchInput("Wi-Fi Hotspot", isWifiHotspot, (val) {
              setState(() => isWifiHotspot = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 900,
            child: switchInput("Integrated Streaming Services", isIntegratedStreaming, (val) {
              setState(() => isIntegratedStreaming = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 1000,
            child: switchInput("Rear Seat Entertainment", isRearSeatEntertainment, (val) {
              setState(() => isRearSeatEntertainment = val);
            }),
          ),
        ],
      ),
    );
  }


  Widget miscellaneous(double screenHeight, double screenWidth) {
    return Container(
      color: whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "Miscellaneous",
              style: TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.06,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),

          AnimatedInputWrapper(
            delayMilliseconds: 0,
            child: switchInput("Central Locking", isCentralLocking, (val) {
              setState(() => isCentralLocking = val);
              _listingInputController.isCentralLocking.value = val;
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 100,
            child: switchInput("Immobilizer", isImmobilizer, (val) {
              setState(() => isImmobilizer = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 200,
            child: switchInput("Alarm System", isAlarmSystem, (val) {
              setState(() => isAlarmSystem = val);
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 300,
            child: switchInput("Power Steering", isPowerSteering, (val) {
              setState(() => isPowerSteering = val);
              _listingInputController.isPowerSteering.value = val;
            }),
          ),

          AnimatedInputWrapper(
            delayMilliseconds: 400,
            child: switchInput("Summer Tires", isSummerTires, (val) {
              setState(() => isSummerTires = val);
            }),
          ),
        ],
      ),
    );
  }


 Widget switchInput(String title, bool value, ValueChanged<bool> onChanged) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    ),
  );
}



  Widget airBagsInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            final bool airbagsEnabled = _listingInputController.selectedFeatures.contains('airbags');
            return Column(
              children: [
                SwitchListTile(
                  title: const Text("Airbags"),
                  value: airbagsEnabled,
                  onChanged: (value) {
                    setState(() {
                      if (value) {
                        _listingInputController.selectedFeatures.add('airbags');
                      } else {
                        _listingInputController.selectedFeatures.remove('airbags');
                        airbagsCountController.clear();
                        _listingInputController.noOfAirbags.value = 0;
                      }
                    });
                  },
                ),
                if (airbagsEnabled)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                    child: TextField(
                      controller: airbagsCountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Number of Airbags",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        _listingInputController.noOfAirbags.value = int.tryParse(value) ?? 0;
                      },
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}