import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/views/listing_features/create_listing/vehicle_listing/features_and_extras.dart';
import 'package:samsar/widgets/animated_input_wrapper/animated_input_wrapper.dart';
import 'package:samsar/widgets/app_button/app_button.dart';
import 'package:samsar/widgets/build_input/build_input.dart';
import 'package:samsar/widgets/build_input_with_options/build_input_with_options.dart';
import 'package:samsar/widgets/color_picker_field/color_picker_field.dart';
import 'package:samsar/widgets/label/label.dart';

class AdvanceListingOptions extends StatefulWidget {
  final bool isVehicle;
  const AdvanceListingOptions({super.key, required this.isVehicle});

  @override
  State<AdvanceListingOptions> createState() => _AdvanceListingOptionsState();
}

class _AdvanceListingOptionsState extends State<AdvanceListingOptions> {
  int currentStep = 0;

  final TextEditingController bodyTypeController = TextEditingController();
  final TextEditingController driveTypeController = TextEditingController();
  final TextEditingController fuelTypeController = TextEditingController();
  final TextEditingController transmissionTypeController = TextEditingController();

  final TextEditingController horsePowerController = TextEditingController();
  final TextEditingController mileageController = TextEditingController();

  final TextEditingController serviceHistoryController = TextEditingController();
  final TextEditingController isAccidentalController = TextEditingController();
  final TextEditingController warrantyController = TextEditingController();
  final TextEditingController previousOwnersController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();

  final TextEditingController importStatusController = TextEditingController();
  final TextEditingController registerationController = TextEditingController();

  Color exteriorColor = Colors.white;

  final ListingInputController _listingInputController = Get.find<ListingInputController>();

  @override
  void initState() {
    super.initState();
    
    // Initialize colors from controller values
    if (_listingInputController.exteriorColor.value.isNotEmpty) {
      try {
        final exteriorHex = _listingInputController.exteriorColor.value.replaceAll('#', '');
        exteriorColor = Color(int.parse('FF$exteriorHex', radix: 16));
      } catch (e) {
        print('Error parsing exterior color: $e');
        exteriorColor = Colors.white;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: Text('advanced_options'.tr, style: TextStyle(color: blackColor, fontWeight: FontWeight.bold)),
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

              _listingInputController.setAdvanceDetails(
                bodyType: bodyTypeController.text,
                driveType: driveTypeController.text,
                fuelType: fuelTypeController.text,
                transmissionType: transmissionTypeController.text,
                horsepower: int.tryParse(horsePowerController.text) ?? 0,
                mileage: mileageController.text,
                serviceHistory: serviceHistoryController.text,
                accidental: isAccidentalController.text,
                warranty: warrantyController.text,
                previousOwners: int.tryParse(previousOwnersController.text) ?? 0,
                condition: conditionController.text,
                importStatus: importStatusController.text,
                registrationExpiry: registerationController.text,
                exteriorColor: _listingInputController.exteriorColor.value,
              );

              Get.to(FeaturesAndExtras());
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
                    text: "Next",
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
              title: const Text("Basic Info"),
              isActive: currentStep >= 0,
              state: currentStep > 0 ? StepState.complete : StepState.indexed,
              content: basicInfo(screenHeight, screenWidth),
            ),
            Step(
              title: const Text("Engine & Performance"),
              isActive: currentStep >= 1,
              state: currentStep > 1 ? StepState.complete : StepState.indexed,
              content: engineAndPerformance(screenHeight, screenWidth),
            ),
            Step(
              title: const Text("Condition & History"),
              isActive: currentStep >= 2,
              state: currentStep > 2 ? StepState.complete : StepState.indexed,
              content: conditionAndHistory(screenHeight, screenWidth),
            ),
            Step(
              title: const Text("Legal & Documents"),
              isActive: currentStep >= 3,
              state: currentStep > 3 ? StepState.complete : StepState.indexed,
              content: legalAndDocumentation(screenHeight, screenWidth),
            ),
            Step(
              title: const Text("Color & Appearance"),
              isActive: currentStep >= 4,
              state: currentStep == 4 ? StepState.editing : StepState.indexed,
              content: colorAndAppearance(screenHeight, screenWidth),
            ),
          ],
        ),
      ),
    );
  }

  Widget basicInfo(double screenHeight, double screenWidth) {
    return Container(
      color: whiteColor,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("Basic info", style: TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.08
              ),),
            ),
          ),

          SizedBox(height: screenHeight * 0.02,),

          AnimatedInputWrapper(
            delayMilliseconds: 0,
            child: BuildInputWithOptions(
              title: "Body Type", 
              // label: "Select body type", 
              controller: bodyTypeController, 
              options: [
                "SEDAN",
                "SUV",
                "COUPE",
                "CONVERTIBLE",
                "WAGON",
                "HATCHBACK",
                "PICKUP",
                "VAN",
                "MINIVAN",
                "CROSSOVER"
                "SPORTS CAR"
                "LUXURY"
              ]),
          ),

          SizedBox(height: screenHeight * 0.01),

           AnimatedInputWrapper(
             delayMilliseconds: 100,
             child: BuildInputWithOptions(
              title: "Drive Type", 
              // label: "Select Drive type", 
              controller: driveTypeController, 
              options: [
                "FWD",
                "RWD",
                "AWD",
                "Four WD"
              ]),
           ),

            SizedBox(height: screenHeight * 0.01),

            AnimatedInputWrapper(
              delayMilliseconds: 200,
              child: BuildInputWithOptions(
                title: "Fuel Type", 
                // label: "Enter your fuel type", 
                controller: fuelTypeController, 
                options: [
                  "Gasoline",
                  "Diesel",
                  "Electric",
                  "Hybrid",
                  "Plug in hybrid",
                  "Lpg",
                  "Cng",
                  "Other"
                ]),
            ),

            SizedBox(height: screenHeight * 0.01),

            AnimatedInputWrapper(
              delayMilliseconds: 300,
              child: BuildInputWithOptions(
                title: "Transmission Type", 
                // label: "Vehicle transmission", 
                controller: transmissionTypeController, 
                options: [
                  "Automatic",
                  "Manual",
                  "Automatic/Manual",
                  "Other"
                ]),
            ),
        ],
      ),
    );
  }

  Widget engineAndPerformance(double screenHeight, double screenWidth) {
    return SingleChildScrollView(
      child: Container(
        color: whiteColor,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text("Engine and Performance", style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.06
                ),),
              ),
            ),
      
            SizedBox(height: screenHeight * 0.02,),
            AnimatedInputWrapper(
              delayMilliseconds: 0,
              child: BuildInput(
                title: "Horsepower", 
                label: "Enter horse power", 
                textController: horsePowerController
              )
            ),
      
            SizedBox(height: screenHeight * 0.02,),
            AnimatedInputWrapper(
              delayMilliseconds: 100,
              child: BuildInput(
                title: "Mileage", 
                label: "Mileage of your vehicle", 
                textController: mileageController
              )
            ),
      
          ],
        ),
      ),
    );
  }

  Widget conditionAndHistory(double screenHeight, double screenWidth) {
    return SingleChildScrollView(
      child: Container(
        color: whiteColor,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text("Condition and History", style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.06
                ),),
              ),
            ),
      
            SizedBox(height: screenHeight * 0.02,),
      
            AnimatedInputWrapper(
              delayMilliseconds: 0,
              child: BuildInputWithOptions(
                title: "Service history", 
                // label: "Select service history", 
                controller: serviceHistoryController, 
                options: [
                  "FULL",
                  "PARTIAL",
                  "NONE"
                ])
            ),
      
            SizedBox(height: screenHeight * 0.02,),
            AnimatedInputWrapper(
              delayMilliseconds: 100,
              child: BuildInputWithOptions(
                title: "Accidental", 
                // label: "Is your vehicle accidental", 
                controller: isAccidentalController, 
                options: [
                  "Accidental",
                  "Not accident"
                ]),
            ),
      
            SizedBox(height: screenHeight * 0.02,),
            AnimatedInputWrapper(
              delayMilliseconds: 200,
              child: BuildInputWithOptions(
                title: "Warranty", 
                // label: "How many warranty is left", 
                controller: warrantyController, 
                options: [
                  "YES",
                  "NO"
                ]),
            ),
      
            SizedBox(height: screenHeight * 0.02,),
            AnimatedInputWrapper(
              delayMilliseconds: 300,
              child: BuildInput(
                title: "Previous owners", 
                label: "No of Previous owners", 
                textController: previousOwnersController
              )
            ),
      
            SizedBox(height: screenHeight * 0.02,),
            AnimatedInputWrapper(
              delayMilliseconds: 400,
              child: BuildInputWithOptions(
                title: "Condition",
                // label:  "Vehicle Condition", 
                controller: conditionController, 
                options: [
                  "New",
                  "Like new",
                  "Excellent",
                  "Good",
                  "Fair",
                  "Poor",
                  "Salvage"
                ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget legalAndDocumentation(double screenHeight, double screenWidth) {
    return Container(
      color: whiteColor,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("Legal and Documentation", style: TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.06
              ),),
            ),
          ),
    
          SizedBox(height: screenHeight * 0.02,),

          AnimatedInputWrapper(
            delayMilliseconds: 0,
            child: BuildInputWithOptions(
              title: "Import status", 
              // label: "Select import status", 
              controller: importStatusController, 
              options: [
                "Imported",
                "Local"
              ]),
          ),

          SizedBox(height: screenHeight * 0.02,),
          AnimatedInputWrapper(
            delayMilliseconds: 100,
            child: BuildInput(
              title: "Registeration Expiry", 
              label: "Enter registeration number", 
              textController: registerationController)
          ),
        ],
      ),
    );
  }

  Widget colorAndAppearance(double screenHeight, double screenWidth) {
    return Container(
      color: whiteColor,
      child: Column(
        children: [
           Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("Color and Appearance", style: TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.06
              ),),
            ),
          ),
    
          SizedBox(height: screenHeight * 0.02,),

          AnimatedInputWrapper(
            delayMilliseconds: 0,
            child: buildColorInput("Exterior color", exteriorColor, (color) {
              setState(() {
                exteriorColor = color;
                // Convert Color to hex string for controller
                _listingInputController.exteriorColor.value = '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
              });
            })
          ),
                
          SizedBox(height: screenHeight * 0.02),

        ],
      ),
    );
  }

  Widget featuresAndExtras(double screenHeight, double screenWidth) {
    return Container(
      color: whiteColor,
      child: Column(
        children: [
           Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text("Features and Extras", style: TextStyle(
                color: blackColor,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.06
              ),),
            ),
          ),
    
          SizedBox(height: screenHeight * 0.02,),
        ],
      )
    );
  }



  Widget buildColorInput(String title, Color selectedColor, Function(Color) onColorChanged) {
    return Column(
      children: [
        Label(labelText: title),
        const SizedBox(height: 3,),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ColorPickerField(
            initialColor: selectedColor,
            onColorChanged: onColorChanged,
          ),
        ),
      ],
    );
  }
}

