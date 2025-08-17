import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';

class MotorcycleFeatures extends StatefulWidget {
  const MotorcycleFeatures({super.key});

  @override
  State<MotorcycleFeatures> createState() => _MotorcycleFeaturesState();
}

class _MotorcycleFeaturesState extends State<MotorcycleFeatures> {
  late final ListingInputController _listingInputController;

  final Map<String, bool> _features = {
    'abs': false,
    'traction_control': false,
    'stability_control': false,
    'wheelie_control': false,
    'launch_control': false,
    'cruise_control': false,
    'quick_shifter': false,
    'slipper_clutch': false,
    'riding_modes': false,
    'suspension_adjustment': false,
    'electronic_suspension': false,
    'led_headlights': false,
    'adaptive_headlights': false,
    'daytime_running_lights': false,
    'hazard_lights': false,
    'turn_signals': false,
    'brake_light': false,
    'digital_display': false,
    'analog_gauges': false,
    'gps_navigation': false,
    'bluetooth': false,
    'usb_charging': false,
    '12v_socket': false,
    'phone_mount': false,
    'windscreen': false,
    'adjustable_windscreen': false,
    'hand_guards': false,
    'knee_grips': false,
    'seat_heating': false,
    'grip_heating': false,
    'storage_compartment': false,
    'side_boxes': false,
    'top_box': false,
    'tank_bag': false,
    'crash_bars': false,
    'engine_guard': false,
    'skid_plate': false,
    'chain_guard': false,
    'immobilizer': false,
    'alarm_system': false,
    'disc_lock': false,
    'chain_lock': false,
    'gps_tracker': false,
    'kick_starter': false,
    'electric_starter': false,
    'center_stand': false,
    'side_stand': false,
    'maintenance_stand': false,
    'tool_kit': false,
    'puncture_kit': false,
    'first_aid_kit': false,
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
  }

  void _loadExistingFeatures() {
    // Load existing features from the controller
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'motorcycle_features_title'.tr, // Changed to a translation key
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
                color: blackColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'select_available_features'.tr,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                          feature.tr, // Use translation key
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? Colors.white : blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
