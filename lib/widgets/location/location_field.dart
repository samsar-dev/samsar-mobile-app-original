import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/controllers/features/location_controller.dart';
import 'package:samsar/controllers/listing/listing_input_controller.dart';
import 'package:samsar/models/location/city_model.dart';
import 'package:samsar/widgets/location/location_picker.dart';

class LocationField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final bool isRequired;
  final bool showValidationError;
  final VoidCallback? onLocationChanged;

  const LocationField({
    super.key,
    this.label,
    this.hintText,
    this.isRequired = true,
    this.showValidationError = false,
    this.onLocationChanged,
  });

  @override
  State<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  final LocationController _locationController = Get.put(LocationController());
  final ListingInputController _listingController =
      Get.find<ListingInputController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Text(
                    widget.label!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  if (widget.isRequired)
                    const Text(
                      ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),

          // Location Field
          Obx(
            () => GestureDetector(
              onTap: _showLocationPicker,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        widget.showValidationError &&
                            _listingController.location.value.isEmpty
                        ? Colors.red
                        : Colors.grey.shade300,
                    width:
                        widget.showValidationError &&
                            _listingController.location.value.isEmpty
                        ? 2
                        : 1,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: _listingController.location.value.isNotEmpty
                          ? Colors.blue
                          : Colors.grey.shade500,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _listingController.location.value.isNotEmpty
                            ? _locationController.formattedLocation
                            : widget.hintText ?? 'select_location'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          color: _listingController.location.value.isNotEmpty
                              ? Colors.black87
                              : Colors.grey.shade500,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.grey.shade500),
                  ],
                ),
              ),
            ),
          ),

          // Error Message
          if (widget.showValidationError &&
              _listingController.location.value.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'please_select_location'.tr,
                style: TextStyle(color: Colors.red.shade600, fontSize: 14),
              ),
            ),

          // Current Location Info
          Obx(() {
            if (_locationController.errorMessage.value.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber,
                      color: Colors.orange.shade600,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _locationController.errorMessage.value,
                        style: TextStyle(
                          color: Colors.orange.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LocationPicker(
        initialLocation: _listingController.location.value,
        onLocationSelected: (LocationSearchResult location) {
          _updateLocation(location);
        },
      ),
    );
  }

  void _updateLocation(LocationSearchResult location) {
    // Update listing controller with location data
    _listingController.location.value = location.displayName;
    _listingController.latitude.value = location.lat.toString();
    _listingController.longitude.value = location.lon.toString();

    // Update location controller
    _locationController.selectLocation(location);

    // Trigger callback if provided
    widget.onLocationChanged?.call();

    print('📍 Location updated: ${location.displayName}');
    print('🌍 Coordinates: ${location.lat}, ${location.lon}');
  }
}

class LocationDisplayWidget extends StatelessWidget {
  final String location;
  final String? latitude;
  final String? longitude;
  final bool showCoordinates;

  const LocationDisplayWidget({
    super.key,
    required this.location,
    this.latitude,
    this.longitude,
    this.showCoordinates = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.blue.shade600, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  location,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
            ],
          ),
          if (showCoordinates && latitude != null && longitude != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 26),
              child: Text(
                'Lat: $latitude, Lng: $longitude',
                style: TextStyle(fontSize: 12, color: Colors.blue.shade600),
              ),
            ),
        ],
      ),
    );
  }
}
