import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';

class OfficesFeatures extends StatefulWidget {
  @override
  _OfficesFeaturesState createState() => _OfficesFeaturesState();
}

class _OfficesFeaturesState extends State<OfficesFeatures> {
  late final ListingInputController _listingInputController;

  // Essential features for offices in Syrian market
  final Map<String, bool> _features = {
    'elevator': false,
    'parking': false,
    'reception_area': false,
    'meeting_rooms': false,
    'air_conditioning': false,
    'central_heating': false,
    'internet_ready': false,
    'security_system': false,
    'generator': false,
    'kitchen_area': false,
    'storage_room': false,
    'disabled_access': false,
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'office_features'.tr,
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
            ),
          ],
        ),
      ),
    );
  }
}
