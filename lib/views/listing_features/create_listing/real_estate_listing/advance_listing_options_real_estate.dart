import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/views/listing_features/create_listing/components/review_listing.dart';
import 'package:samsar/widgets/animated_input_wrapper/animated_input_wrapper.dart';
import 'package:samsar/widgets/app_button/app_button.dart';
import 'package:samsar/widgets/build_input/build_input.dart';
import 'package:samsar/widgets/build_input_with_options/build_input_with_options.dart';


class AdvanceListingOptionsRealEstate extends StatefulWidget {
  const AdvanceListingOptionsRealEstate({super.key});

  @override
  State<AdvanceListingOptionsRealEstate> createState() => _AdvanceListingOptionsRealEstateState();
}

class _AdvanceListingOptionsRealEstateState extends State<AdvanceListingOptionsRealEstate> {
  int currentStep = 0;

  final ListingInputController _listingInputController = Get.find<ListingInputController>();

  // Climate & Energy
  final TextEditingController heatingController = TextEditingController();
  final TextEditingController coolingController = TextEditingController();
  final TextEditingController energyFeaturesController = TextEditingController();
  final TextEditingController energyRatingController = TextEditingController();
  final TextEditingController waterSystemController = TextEditingController(); 
  final TextEditingController sewerSystemController = TextEditingController();
  final TextEditingController utilitiesController = TextEditingController();


  // Structure & Layout
  final TextEditingController basementController = TextEditingController();
  final TextEditingController basementFeaturesController = TextEditingController();
  final TextEditingController atticController = TextEditingController();
  final TextEditingController constructionTypeController = TextEditingController();
  final TextEditingController noOfStoriesController = TextEditingController();
  final TextEditingController foundationTypeController = TextEditingController();
  final TextEditingController exteriorFeaturesController = TextEditingController();
  


  // Interior Features
  final TextEditingController floortingTypesController = TextEditingController();
  final TextEditingController windowFeaturesController = TextEditingController();
  final TextEditingController kitchenFeaturesController = TextEditingController();
  final TextEditingController bathroomFeaturesController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController smartHomeFeaturesController = TextEditingController();
  final TextEditingController securityFeaturesController = TextEditingController();
  final TextEditingController furnishedController = TextEditingController();
  final TextEditingController includedAppliancesController = TextEditingController();
  final TextEditingController accessiblityFeaturesController = TextEditingController();
  final TextEditingController storageFeaturesController = TextEditingController();


  // Living Space Details
  final TextEditingController livingAreaController = TextEditingController();
  final TextEditingController halfBathroomsController = TextEditingController();

  // Parking & Roof
  final TextEditingController roofTypeController = TextEditingController();
  final TextEditingController roofAgeController = TextEditingController();
  final TextEditingController parkingController = TextEditingController();
  final TextEditingController parkingSpacesController = TextEditingController();


  //community and extras
  final TextEditingController communityFeaturesController = TextEditingController();
  final TextEditingController hoaFeaturesController = TextEditingController();
  final TextEditingController landscapingController = TextEditingController();
  final TextEditingController outdoorFeaturesController = TextEditingController();
  final TextEditingController petFriendlyController = TextEditingController();



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
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  AppButton(
                    widthSize: 0.35,
                    heightSize: 0.06,
                    buttonColor: blueColor,
                    text: currentStep == 5 ? "Review" : "Next",
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
          onStepContinue: () {
            if (currentStep < 5) {
              setState(() => currentStep++);
            } else {
              Get.to(ReviewListing(
                isVehicle: false,
                imageUrls: _listingInputController.listingImage.toList(),
              ));
            }
          },
          onStepCancel: () {
            if (currentStep > 0) setState(() => currentStep--);
          },
          onStepTapped: (index) => setState(() => currentStep = index),
          steps: [
            Step(
              title: Text('climate_and_energy'.tr),
              isActive: currentStep >= 0,
              state: currentStep > 0 ? StepState.complete : StepState.indexed,
              content: climateAndEnergy(screenHeight, screenWidth),
            ),
            Step(
              title: Text('structure_and_layout'.tr),
              isActive: currentStep >= 1,
              state: currentStep > 1 ? StepState.complete : StepState.indexed,
              content: structureAndLayout(screenHeight, screenWidth),
            ),
            Step(
              title: Text('interior_features'.tr),
              isActive: currentStep >= 2,
              state: currentStep > 2 ? StepState.complete : StepState.indexed,
              content: interiorFeatures(screenHeight, screenWidth),
            ),
            Step(
              title: Text('living_space'.tr),
              isActive: currentStep >= 3,
              state: currentStep > 3 ? StepState.complete : StepState.indexed,
              content: livingSpaceDetails(screenHeight, screenWidth),
            ),
            Step(
              title: Text('parking_and_roof'.tr),
              isActive: currentStep >= 4,
              state: currentStep == 4 ? StepState.editing : StepState.indexed,
              content: parkingAndRoof(screenHeight, screenWidth),
            ),

            Step(
              title: Text('community_and_extras'.tr),
              isActive: currentStep >= 5,
              state: currentStep == 5 ? StepState.editing : StepState.indexed,
              content: communityAndExtras(screenHeight, screenWidth),
            ),
          ],
        ),
      ),
    );
  }   

 Widget climateAndEnergy(double screenHeight, double screenWidth) {
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
                    'climate_and_energy'.tr,
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
                  title: "Heating", 
                  // label: "Heating options", 
                  controller: heatingController, 
                  options: [
                    "CENTRAL",
                    "FORCED AIR",
                    "RADIANT",
                    "HEAT PUMP",
                    "BASEBOARD"
                    "GEOTHERMAL",
                    "Electric Baseboard",
                    "WOOD STOVE",
                    "PELLETE STOVE",
                  ]),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 100,
                child: BuildInputWithOptions(
                  title: "Cooling", 
                  // label: "Cooling options", 
                  controller: coolingController, 
                  options: [
                   "CENTRAL",
                   "WINDOW",
                   "SPLIT",
                   "EVAPORATIVE",
                   "GEOTHERMAL",
                   "NONE"
                  ]),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 200,
                child: BuildInputWithOptions(
                  title: "Energy Features", 
                  // label: "Energy Features Available", 
                  controller: energyFeaturesController, 
                  options: [
                    "SOLAR PANELS",
                    "SOLAR WATER HEATER",
                    "DOUBLE GLAZED WINDOWS",
                    "TRIPLE GLAZED WINDOWS",
                    "TANKLESS WATER HEATER",
                    "SMART THERMOSTAT",
                    "ENERGY MONITORING",
                  ]),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 300,
                child: BuildInputWithOptions(
                  title: "Energy Rating", 
                  // label: "Rating of your property", 
                  controller: energyRatingController, 
                  options: [
                    "A PLUS",
                    "A",
                    "B",
                    "C",
                    "D",
                    "E",
                    "F",
                    "G",
                    "UNKNOWN"
                  ]),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 400,
                child: BuildInputWithOptions(
                  title: "Water System",
                  controller: waterSystemController,
                  options: [
                    "MUNCIPAL",
                    "WELL",
                    "SHARED WELL",
                    "CISTERN"
                  ],
                ),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 400,
                child: BuildInputWithOptions(
                  title: "Sewer System",
                  controller: sewerSystemController,
                  options: [
                    "MUNCIPAL",
                    "SEPTIC",
                    "OTHER",
                  ],
                ),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 400,
                child: BuildInputWithOptions(
                  title: "Utilities",
                  controller: utilitiesController,
                  options: [
                    "ELECTRICITY",
                    "NATURAL GAS",
                    "PROPANE",
                    "FIBER INTERNET",
                    "CABEL",
                    "PHONE"
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget structureAndLayout(double screenHeight, double screenWidth) {
      return SingleChildScrollView(
        child: Container(
          color: whiteColor,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text('structure_and_layout'.tr, style: TextStyle(
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
                  title: "Basement Type", 
                  // label: "Select basement type", 
                  controller: basementController, 
                  options: [
                    "FINISHED",
                    "UNFINISHED",
                    "PARTIAL",
                    "WALOUT",
                    "NONE"
                  ]),
              ),
        
              AnimatedInputWrapper(
                delayMilliseconds: 100,
                child: BuildInputWithOptions(
                  title: "Basement Features", 
                  // label: "Select basement features", 
                  controller: basementFeaturesController, 
                  options: [
                    "BATHROOM",
                    "KITCHEN",
                    "BEDROOM",
                    "SEPRATE ENTERANCE",
                    "WET BAR",
                    "WORKSHOP",
                    "STORAGE"
                  ]),
              ),
        
              AnimatedInputWrapper(
                delayMilliseconds: 200,
                child: BuildInputWithOptions(
                  title: "Attic", 
                  // label: "Select attic type", 
                  controller: atticController, 
                  options: [
                    "FINISHED",
                    "UNFINISHED",
                    "NONE"
                  ]),
              ),
        
              AnimatedInputWrapper(
                delayMilliseconds: 300,
                child: BuildInputWithOptions(
                  title: "Construction Type", 
                  // label: "Select construction type", 
                  controller: constructionTypeController, 
                  options: [
                    "BRICK",
                    "WOOD",
                    "CONCERETE",
                    "STEEL FRAME",
                    "STONEWORK",
                    "STUCCO",
                    "VINYL",
                    "OTHER"
                  ]),
              ),
        
              AnimatedInputWrapper(
                delayMilliseconds: 400,
                child: BuildInputWithOptions(
                  title: "Number of Stories", 
                  // label: "Select number of stories", 
                  controller: noOfStoriesController, 
                  options: [
                    "1",
                    "2",
                    "3",
                    "4",
                    "5+",
                  ]),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 500,
                child: BuildInputWithOptions(
                  title: "Foundation Type", 
                  // label: "Select number of stories", 
                  controller: foundationTypeController, 
                  options: [
                    "CONCRETE",
                    "CRAWL SPACE",
                    "SLAB",
                    "PIER",
                    "STONE",
                    "OTHER"
                  ]),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 600,
                child: BuildInputWithOptions(
                  title: "Exterior Features", 
                  // label: "Select number of stories", 
                  controller: exteriorFeaturesController, 
                  options: [
                    "PORCH",
                    "COVERED PATIO",
                    "DECK",
                    "BALCONY",
                    "FENCE",
                    "SECURITY GATES",
                    "OUTDOOR KITCHEN",
                    "FIREPIT"
                  ]),
              ),
            ],
          ),
        ),
      );
    }


    Widget interiorFeatures(double screenHeight, double screenWidth) {
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
                    'interior_features'.tr,
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
                  title: "Flooring Types", 
                  // label: "Select flooring type", 
                  controller: floortingTypesController, 
                  options: [
                    "HARDWOOD",
                    "ENGINEERED WOOD",
                    "LAMINATE",
                    "TILE",
                    "CARPET",
                    "VINYL",
                    "STONE",
                    "CONCRETE",
                    "BAMBOO",
                    "CORK"
                  ]),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 100,
                child: BuildInputWithOptions(
                  title: "Window Features", 
                  // label: "Select window features", 
                  controller: windowFeaturesController, 
                  options: [
                    "BAY WINDOWS",
                    "SKYLIGHTS",
                    "GARDEN WINDOW",
                    "DOUBLE PANE",
                    "TRIPLE PANE",
                    "LOW E",
                    "TINTED",
                    "SOUNDPROOF"
                  ]),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 200,
                child: BuildInputWithOptions(
                  title: "Kitchen Features", 
                  // label: "Select kitchen features", 
                  controller: kitchenFeaturesController, 
                  options: [
                    "ISLAND",
                    "PANTARY",
                    "GRANITE CABINATARY",
                    "STAINLESS APPLIANCES",
                    "GAS STOVE",
                    "DOUBLE OVEN",
                    "WINE STORAGE",
                    "BUTLER PANTRY",
                    "BREAKFAST NOOK"
                  ]),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 300,
                child: BuildInputWithOptions(
                  title: "Bathroom Features", 
                  // label: "Select bathroom features", 
                  controller: bathroomFeaturesController, 
                  options: [
                    "DUAL VANITIES",
                    "SEPRATE SHOWER",
                    "SOAKING TUB",
                    "JET TUB",
                    "STEAM SHOWER",
                    "BIDET",
                    "HEATED FLOORS"
                  ]),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 400,
                child: BuildInputWithOptions(
                  title: "Condition", 
                  // label: "Select property condition", 
                  controller: conditionController, 
                  options: [
                    "NEW",
                    "EXCELLENT",
                    "GOOD",
                    "FAIR",
                    "NEEDS WORK",
                    "Ready to Move",
                  ]),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 500,
                child: BuildInputWithOptions(
                  title: "Smart Home Features", 
                  // label: "Select property condition", 
                  controller: smartHomeFeaturesController, 
                  options: [
                    "THERMOSTAT",
                    "LIGHTING",
                    "SECURITY",
                    "DOORBELL",
                    "LOCKS",
                    "IRRIGATION",
                    "ENTERTAINMENT",
                    "VOICE CONTROL"
                  ]),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 600,
                child: BuildInputWithOptions(
                  title: "Security Features", 
                  // label: "Select property condition", 
                  controller: securityFeaturesController, 
                  options: [
                    "ALARMS",
                    "CAMERAS",
                    "GATED COMMUNITY",
                    "SECURITY SERVICE",
                    "SMART LOCKS",
                    "INTERCOM",
                    "SAFEROOM"
                  ]),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 700,
                child: BuildInputWithOptions(
                  title: "Funrnished", 
                  // label: "Select property condition", 
                  controller: furnishedController, 
                  options: [
                    "FULLY",
                    "PARTIALLY",
                    "UNFURNISHED"
                  ]),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 800,
                child: BuildInputWithOptions(
                  title: "Included Appliances", 
                  // label: "Select property condition", 
                  controller: includedAppliancesController, 
                  options: [
                    "REFRIGIRATOR",
                    "DISHWASHER",
                    "OVEN",
                    "MICROWAVE",
                    "WASHER",
                    "DRYER",
                    "WATER HEATER",
                    "WATER SOFTNER"
                  ]),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 900,
                child: BuildInputWithOptions(
                  title: "Accessiblity Features", 
                  // label: "Select property condition", 
                  controller: accessiblityFeaturesController, 
                  options: [
                    "WHEELCHAIR",
                    "NO STEPS",
                    "WIDE HALLWAYS",
                    "ELEVATOR",
                    "STAIR LIFT",
                    "FIRST FLOOR BEDROOM",
                    "MODIFIED BATHROOM"
                  ]),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 1000,
                child: BuildInputWithOptions(
                  title: "Storage Features", 
                  // label: "Select property condition", 
                  controller: storageFeaturesController, 
                  options: [
                    "ATTIC",
                    "BASEEMNT",
                    "SHED",
                    "GARAGE",
                    "WORKSHOP",
                    "BUILTIN",
                    "MUD ROOM"
                  ]),
              ),
            ],
          ),
        ),
      );
    }


    Widget livingSpaceDetails(double screenHeight, double screenWidth) {
      return SingleChildScrollView(
        child: Container(
          color: whiteColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  "Living Space Details",
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.08,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              AnimatedInputWrapper(
                delayMilliseconds: 0,
                child: BuildInput(
                  title: "Living Area",
                  label: "Enter living area (in sq.ft)",
                  textController: livingAreaController,
                ),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 100,
                child: BuildInput(
                  title: "Half Bathrooms",
                  label: "Enter number of half bathrooms",
                  textController: halfBathroomsController,
                ),
              ),

              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      );
    }


    Widget parkingAndRoof(double screenHeight, double screenWidth) {
      return SingleChildScrollView(
        child: Container(
          color: whiteColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  'parking_and_roof'.tr,
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.08,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              AnimatedInputWrapper(
                delayMilliseconds: 0,
                child: BuildInputWithOptions(
                  title: "Roof Type",
                  // label: "Select roof type",
                  controller: roofTypeController,
                  options: [
                    "ASPHALT SHINGLE",
                    "METAL ROOF",
                    "TILE CLAY",
                    "SLATE",
                    "FLAT",
                    "GREEN ROOF",
                    "SOLAR"
                  ],
                ),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 200,
                child: BuildInput(
                  title: "Roof Age",
                  label: "Enter number of roof age",
                  textController: roofAgeController,
                ),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 100,
                child: BuildInputWithOptions(
                  title: "Parking",
                  // label: "Select parking type",
                  controller: parkingController,
                  options: [
                    "ATTACHED GARAGE",
                    "DETACHED GARAGE",
                    "CARPORAT",
                    "STREET",
                    "NONE"
                  ],
                ),
              ),

              AnimatedInputWrapper(
                delayMilliseconds: 200,
                child: BuildInput(
                  title: "Parking Spaces",
                  label: "Enter number of parking spaces",
                  textController: parkingSpacesController,
                ),
              ),

              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      );
    }  


  Widget communityAndExtras(double screenHeight, double screenWidth) {
    return SingleChildScrollView(
      child: Container(
        color: whiteColor,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  'community_and_extras'.tr,
                  style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.08,
                  ),
                ),
              ),

            SizedBox(height: screenHeight * 0.02),

            AnimatedInputWrapper(
              delayMilliseconds: 100,
              child: BuildInputWithOptions(
                title: "Community Features",
                // label: "Select parking type",
                controller: communityFeaturesController,
                options: [
                  "POOL",
                  "CLUBHOUSE",
                  "GYM",
                  "TENNIS",
                  "PLAYGROUND",
                  "PARK",
                  "LAKE",
                  "TRAILS",
                  "GOLF COURSE",
                ],
              ),
            ),

            AnimatedInputWrapper(
              delayMilliseconds: 200,
              child: BuildInputWithOptions(
                title: "HOA Features",
                // label: "Select parking type",
                controller: hoaFeaturesController,
                options: [
                  "LANDSCAPING",
                  "SNOWREMOVAL",
                  "TRASH",
                  "SECURITY",
                  "COMMON AREAS",
                  "INSURANCE"
                ],
              ),
            ),

            AnimatedInputWrapper(
              delayMilliseconds: 300,
              child: BuildInputWithOptions(
                title: "HOA Features",
                // label: "Select parking type",
                controller: hoaFeaturesController,
                options: [
                  "LANDSCAPING",
                  "SNOWREMOVAL",
                  "TRASH",
                  "SECURITY",
                  "COMMON AREAS",
                  "INSURANCE"
                ],
              ),
            ),

            AnimatedInputWrapper(
              delayMilliseconds: 400,
              child: BuildInputWithOptions(
                title: "Outdoor Features",
                // label: "Select parking type",
                controller: outdoorFeaturesController,
                options: [
                  "POOL",
                  "SPA",
                  "TENNIS",
                  "GARDEN",
                  "SPRINKLERS",
                  "POND",
                  "GREENHOUSE",
                  "RV PARKING",
                  "WORKSHOP",
                  "BARN"
                ],
              ),
            ),

            AnimatedInputWrapper(
              delayMilliseconds: 500,
              child: BuildInputWithOptions(
                title: "Pet Friendly",
                // label: "Select parking type",
                controller: petFriendlyController,
                options: [
                  "DOG RUN",
                  "PET DOOR",
                  "FENCED YARD",
                  "CAT DOOR",
                  "PET WASH STATION"
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

