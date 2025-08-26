import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:samsar/controllers/vehicle_controller.dart';
import 'package:samsar/views/listing_features/create_listing/components/essential_details/vehicle_essential_details.dart';
import 'package:samsar/views/listing_features/create_listing/components/essential_details/real_estate_essential_details.dart';

class EssentialDetailsWrapper extends StatelessWidget {
  final String category;
  final GlobalKey<FormState> formKey;
  final bool showValidation;
  final ValueChanged<bool> onValidationChanged;
  final int currentStep;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  const EssentialDetailsWrapper({
    super.key,
    required this.category,
    required this.formKey,
    required this.showValidation,
    required this.onValidationChanged,
    required this.currentStep,
    this.onNext,
    this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    Widget formContent;

    switch (category) {
      case 'vehicles':
        formContent = ChangeNotifierProvider(
          key: ValueKey('vehicle_controller_provider_$category'),
          create: (context) => VehicleController(),
          child: VehicleEssentialDetails(
            key: ValueKey('vehicle_essential_details_$category'),
            formKey: formKey,
            showValidation: showValidation,
            onValidationChanged: onValidationChanged,
          ),
        );
        break;
      case 'real_estate':
        formContent = RealEstateEssentialDetails(
          key: ValueKey('real_estate_essential_details_$category'),
          formKey: formKey,
          showValidation: showValidation,
          onValidationChanged: onValidationChanged,
        );
        break;
      default:
        formContent = Center(
          child: Text('unknown_category_message'.tr + ': $category'),
        );
    }

    return Column(
      children: [
        formContent,
        // Navigation buttons at the bottom of form content
        _buildNavigationButtons(context),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentStep > 0 && onPrevious != null)
            _buildButton(
              width: screenWidth * 0.35,
              color: Colors.grey[300]!,
              textColor: Colors.black,
              text: 'previous'.tr,
              onPressed: onPrevious!,
            )
          else
            SizedBox(width: screenWidth * 0.35),

          if (onNext != null)
            _buildButton(
              width: screenWidth * 0.35,
              color: Colors.blue,
              textColor: Colors.white,
              text: currentStep == 2 ? 'review'.tr : 'next'.tr,
              onPressed: onNext!,
            ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required double width,
    required Color color,
    required Color textColor,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: width,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

}
