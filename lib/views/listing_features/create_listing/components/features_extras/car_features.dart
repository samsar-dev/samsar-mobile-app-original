import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/widgets/build_input/build_input.dart';

class CarFeatures extends StatefulWidget {
  const CarFeatures({super.key});

  @override
  State<CarFeatures> createState() => _CarFeaturesState();
}

class _CarFeaturesState extends State<CarFeatures> {
  late final ListingInputController _listingInputController;
  final TextEditingController airbagsCountController = TextEditingController();

  final Map<String, bool> _features = {
    'abs': false,
    'traction_control': false,
    'lane_assist': false,
    'blind_spot_monitor': false,
    'parking_sensor': false,
    'rear_camera': false,
    '360_camera': false,
    'cruise_control': false,
    'led_headlights': false,
    'fog_lights': false,
    'bluetooth': false,
    'apple_carplay': false,
    'android_auto': false,
    'wireless_charging': false,
    'usb_ports': false,
    'sunroof': false,
    'panoramic_roof': false,
    'heated_seats': false,
    'cooled_seats': false,
    'leather_seats': false,
    'electric_seats': false,
    'central_locking': false,
    'power_steering': false,
    'immobilizer': false,
    'alarm_system': false,
  };

  @override
  void initState() {
    super.initState();
    // Ensure controller is registered before accessing it
    if (Get.isRegistered<ListingInputController>()) {
      _listingInputController = Get.find<ListingInputController>();
    } else {
      _listingInputController = Get.put(ListingInputController());
    }
    _loadExistingFeatures();
    if (_listingInputController.noOfAirbags.value > 0) {
      airbagsCountController.text = _listingInputController.noOfAirbags.value.toString();
    }
    airbagsCountController.addListener(() {
      _listingInputController.noOfAirbags.value = int.tryParse(airbagsCountController.text) ?? 0;
    });
  }

  @override
  void dispose() {
    airbagsCountController.dispose();
    super.dispose();
  }

  void _loadExistingFeatures() {
    if (_listingInputController.selectedFeatures.isNotEmpty) {
      for (String feature in _listingInputController.selectedFeatures) {
        if (_features.containsKey(feature)) {
          setState(() {
            _features[feature] = true;
          });
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'car_features_title'.tr,
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'select_available_features'.tr,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            _buildAirbagsSection(),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _features.length,
              itemBuilder: (context, index) {
                final feature = _features.keys.elementAt(index);
                final isSelected = _features[feature]!;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      final isSelected = !_features[feature]!;
                      _features[feature] = isSelected;
                      if (isSelected) {
                        _listingInputController.selectedFeatures.add(feature);
                      } else {
                        _listingInputController.selectedFeatures.remove(feature);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                      border: Border.all(
                        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        feature.tr,
                        style: TextStyle(
                          color: isSelected ? Colors.white : blackColor,
                          fontWeight: FontWeight.w500,
                          fontSize: screenWidth * 0.035,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAirbagsSection() {
    return Obx(() {
      final hasAirbags = _listingInputController.selectedFeatures.contains('airbags');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeatureToggle('airbags'.tr, hasAirbags, (value) {
            if (value) {
              _listingInputController.selectedFeatures.add('airbags');
            } else {
              _listingInputController.selectedFeatures.remove('airbags');
              _listingInputController.noOfAirbags.value = 0;
              airbagsCountController.clear();
            }
          }),
          if (hasAirbags)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8),
              child: BuildInput(
                title: 'number_of_airbags'.tr,
                label: 'enter_number_of_airbags'.tr,
                textController: airbagsCountController,
                keyboardType: TextInputType.number,
              ),
            ),
        ],
      );
    });
  }

  Widget _buildFeatureToggle(String title, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
