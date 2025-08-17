import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';

class StoresFeatures extends StatefulWidget {
  const StoresFeatures({super.key});

  @override
  State<StoresFeatures> createState() => _StoresFeaturesState();
}

class _StoresFeaturesState extends State<StoresFeatures> {
  late final ListingInputController _listingInputController;

  final Map<String, bool> _features = {
    'street_front': false,
    'display_windows': false,
    'storage_room': false,
    'customer_parking': false,
    'air_conditioning': false,
    'security_system': false,
    'loading_dock': false,
    'office_space': false,
    'restroom': false,
    'generator': false,
    'internet_ready': false,
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
              'store_features'.tr,
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
            ),
          ],
        ),
      ),
    );
  }
}
