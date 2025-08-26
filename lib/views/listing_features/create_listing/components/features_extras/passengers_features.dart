import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';

class PassengersFeatures extends StatefulWidget {
  const PassengersFeatures({super.key});

  @override
  State<PassengersFeatures> createState() => _PassengersFeaturesState();
}

class _PassengersFeaturesState extends State<PassengersFeatures> {
  late final ListingInputController _listingInputController;

  final Map<String, bool> _features = {
    // Safety features (actually matter for buying decisions)
    'abs_brakes': false,
    'airbags': false,
    
    // Comfort features (factory-installed, hard to retrofit)
    'backup_camera': false,
    'sunroof': false,
    'leather_seats': false,
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
    // Load existing features from controller
    if (_listingInputController.selectedFeatures.isNotEmpty) {
      for (final feature in _listingInputController.selectedFeatures) {
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'passenger_vehicle_features'.tr,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'select_available_features'.tr,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 24),

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
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
                          _listingInputController.selectedFeatures.remove(
                            feature,
                          );
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300]!,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          feature.tr,
                          style: const TextStyle(fontSize: 16),
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
