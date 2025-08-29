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
  final TextEditingController transmissionTypeController =
      TextEditingController();

  final TextEditingController horsePowerController = TextEditingController();
  final TextEditingController mileageController = TextEditingController();

  final TextEditingController serviceHistoryController =
      TextEditingController();
  final TextEditingController isAccidentalController = TextEditingController();
  final TextEditingController warrantyController = TextEditingController();
  final TextEditingController previousOwnersController =
      TextEditingController();
  final TextEditingController conditionController = TextEditingController();

  final TextEditingController importStatusController = TextEditingController();
  final TextEditingController registerationController = TextEditingController();

  Color exteriorColor = Colors.white;

  final ListingInputController _listingInputController =
      Get.find<ListingInputController>();

  @override
  void initState() {
    super.initState();

    // Initialize colors from controller values
    if (_listingInputController.exteriorColor.value.isNotEmpty) {
      try {
        final exteriorHex = _listingInputController.exteriorColor.value
            .replaceAll('#', '');
        exteriorColor = Color(int.parse('FF$exteriorHex', radix: 16));
      } catch (e) {
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
        title: Text(
          'advanced_options'.tr,
          style: TextStyle(color: blackColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(
            context,
          ).colorScheme.copyWith(primary: blueColor, surface: whiteColor),
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
                previousOwners:
                    int.tryParse(previousOwnersController.text) ?? 0,
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
                    text: 'nextButton'.tr,
                    textColor: whiteColor,
                    onPressed: details.onStepContinue!,
                  ),
                  const SizedBox(width: 12),
                  if (currentStep > 0)
                    AppButton(
                      widthSize: 0.35,
                      heightSize: 0.06,
                      buttonColor: purpleColor,
                      text: 'back'.tr,
                      textColor: whiteColor,
                      onPressed: details.onStepCancel!,
                    ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: Text('basic_info'.tr),
              isActive: currentStep >= 0,
              state: currentStep > 0 ? StepState.complete : StepState.indexed,
              content: basicInfo(screenHeight, screenWidth),
            ),
            Step(
              title: Text('engine_and_performance'.tr),
              isActive: currentStep >= 1,
              state: currentStep > 1 ? StepState.complete : StepState.indexed,
              content: engineAndPerformance(screenHeight, screenWidth),
            ),
            Step(
              title: Text('condition_and_history'.tr),
              isActive: currentStep >= 2,
              state: currentStep > 2 ? StepState.complete : StepState.indexed,
              content: conditionAndHistory(screenHeight, screenWidth),
            ),
            Step(
              title: Text('legal_and_documents'.tr),
              isActive: currentStep >= 3,
              state: currentStep > 3 ? StepState.complete : StepState.indexed,
              content: legalAndDocumentation(screenHeight, screenWidth),
            ),
            Step(
              title: Text('color_and_appearance'.tr),
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
              child: Text(
                'basic_info'.tr,
                style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.08,
                ),
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.02),

          AnimatedInputWrapper(
            delayMilliseconds: 0,
            child: BuildInputWithOptions(
              title: 'body_type'.tr,
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
                    "LUXURY",
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.01),

          AnimatedInputWrapper(
            delayMilliseconds: 100,
            child: BuildInputWithOptions(
              title: 'drive_type'.tr,
              // label: "Select Drive type",
              controller: driveTypeController,
              options: ["FWD", "RWD", "AWD", "Four WD"],
            ),
          ),

          SizedBox(height: screenHeight * 0.01),

          AnimatedInputWrapper(
            delayMilliseconds: 200,
            child: BuildInputWithOptions(
              title: 'fuel_type'.tr,
              // label: "Enter your fuel type",
              controller: fuelTypeController,
              options: [
                "Gasoline",
                "Diesel",
                "Electric",
                "Hybrid",
                "Plug in hybrid",
                "Gasoline",
                "Other",
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.01),

          AnimatedInputWrapper(
            delayMilliseconds: 300,
            child: BuildInputWithOptions(
              title: 'transmissionType'.tr,
              // label: "Vehicle transmission",
              controller: transmissionTypeController,
              options: ["Automatic", "Manual", "Automatic/Manual", "Other"],
            ),
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
                child: Text(
                  'engine_and_performance_title'.tr,
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.06,
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
            AnimatedInputWrapper(
              delayMilliseconds: 0,
              child: BuildInput(
                title: 'horsepower'.tr,
                label: 'enter_horsepower'.tr,
                textController: horsePowerController,
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
            AnimatedInputWrapper(
              delayMilliseconds: 100,
              child: BuildInput(
                title: 'mileage'.tr,
                label: 'mileage_of_vehicle'.tr,
                textController: mileageController,
              ),
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
                child: Text(
                  'condition_and_history_title'.tr,
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.06,
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            AnimatedInputWrapper(
              delayMilliseconds: 0,
              child: BuildInputWithOptions(
                title: 'service_history'.tr,
                // label: "Select service history",
                controller: serviceHistoryController,
                options: ["FULL", "PARTIAL", "NONE"],
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
            AnimatedInputWrapper(
              delayMilliseconds: 100,
              child: BuildInputWithOptions(
                title: 'accidental'.tr,
                // label: "Is your vehicle accidental",
                controller: isAccidentalController,
                options: ["Accidental", "Not accident"],
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
            AnimatedInputWrapper(
              delayMilliseconds: 200,
              child: BuildInputWithOptions(
                title: 'warranty'.tr,
                // label: "How many warranty is left",
                controller: warrantyController,
                options: ["YES", "NO"],
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
            AnimatedInputWrapper(
              delayMilliseconds: 300,
              child: BuildInput(
                title: 'previous_owners'.tr,
                label: 'no_of_previous_owners'.tr,
                textController: previousOwnersController,
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
            AnimatedInputWrapper(
              delayMilliseconds: 400,
              child: BuildInputWithOptions(
                title: 'condition'.tr,
                // label:  "Vehicle Condition",
                controller: conditionController,
                options: [
                  "New",
                  "Like new",
                  "Excellent",
                  "Good",
                  "Fair",
                  "Poor",
                  "Salvage",
                ],
              ),
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
              child: Text(
                'legal_and_documentation_title'.tr,
                style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.06,
                ),
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.02),

          AnimatedInputWrapper(
            delayMilliseconds: 0,
            child: BuildInputWithOptions(
              title: 'import_status'.tr,
              // label: "Select import status",
              controller: importStatusController,
              options: ["Imported", "Local"],
            ),
          ),

          SizedBox(height: screenHeight * 0.02),
          AnimatedInputWrapper(
            delayMilliseconds: 100,
            child: BuildInput(
              title: 'registration_expiry'.tr,
              label: 'enter_registration_number'.tr,
              textController: registerationController,
            ),
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
              child: Text(
                'color_and_appearance_title'.tr,
                style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.06,
                ),
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.02),

          AnimatedInputWrapper(
            delayMilliseconds: 0,
            child: buildColorInput('exterior_color'.tr, exteriorColor, (color) {
              setState(() {
                exteriorColor = color;
                // Convert Color to hex string for controller
                _listingInputController.exteriorColor.value =
                    '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
              });
            }),
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
              child: Text(
                'features_and_extras_title'.tr,
                style: TextStyle(
                  color: blackColor,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.06,
                ),
              ),
            ),
          ),

          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }

  Widget buildColorInput(
    String title,
    Color selectedColor,
    Function(Color) onColorChanged,
  ) {
    return Column(
      children: [
        Label(labelText: title),
        const SizedBox(height: 3),

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
