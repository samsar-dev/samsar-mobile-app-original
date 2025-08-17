import 'package:flutter/material.dart';
import 'package:samsar/views/listing_features/create_listing/components/essential_details/vehicle_essential_details.dart';
import 'package:samsar/views/listing_features/create_listing/components/essential_details/real_estate_essential_details.dart';

class EssentialDetailsWrapper extends StatelessWidget {
  final String category;
  final GlobalKey<FormState> formKey;
  final bool showValidation;
  final ValueChanged<bool> onValidationChanged;

  const EssentialDetailsWrapper({
    super.key,
    required this.category,
    required this.formKey,
    required this.showValidation,
    required this.onValidationChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (category) {
      case 'vehicles':
        return VehicleEssentialDetails(
          formKey: formKey,
          showValidation: showValidation,
          onValidationChanged: onValidationChanged,
        );
      case 'real_estate':
        return RealEstateEssentialDetails(
          formKey: formKey,
          showValidation: showValidation,
          onValidationChanged: onValidationChanged,
        );
      default:
        return Center(
          child: Text('Unknown category: $category'),
        );
    }
  }
}
