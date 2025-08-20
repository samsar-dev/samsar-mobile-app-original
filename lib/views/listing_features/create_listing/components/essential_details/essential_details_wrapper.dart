import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final int selectedIndex;
  final ValueChanged<int>? onCategorySelected;

  const EssentialDetailsWrapper({
    super.key,
    required this.category,
    required this.formKey,
    required this.showValidation,
    required this.onValidationChanged,
    required this.currentStep,
    this.onNext,
    this.onPrevious,
    required this.selectedIndex,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    Widget formContent;
    
    switch (category) {
      case 'vehicles':
        formContent = VehicleEssentialDetails(
          formKey: formKey,
          showValidation: showValidation,
          onValidationChanged: onValidationChanged,
        );
        break;
      case 'real_estate':
        formContent = RealEstateEssentialDetails(
          formKey: formKey,
          showValidation: showValidation,
          onValidationChanged: onValidationChanged,
        );
        break;
      default:
        formContent = Center(
          child: Text('Unknown category: $category'),
        );
    }

    return Column(
      children: [
        // Category selection tabs - only show on first step, scrollable with content
        _buildCategoryTabs(context),
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
              text: 'Previous',
              onPressed: onPrevious!,
            )
          else
            SizedBox(width: screenWidth * 0.35),
          
          if (onNext != null)
            _buildButton(
              width: screenWidth * 0.35,
              color: Colors.blue,
              textColor: Colors.white,
              text: currentStep == 2 ? 'Review' : 'Next',
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context) {
    final List<String> tabs = ['vehicles', 'real_estate'];
    
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(tabs.length, (index) {
          bool isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: onCategorySelected != null ? () => onCategorySelected!(index) : null,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    tabs[index].tr,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
