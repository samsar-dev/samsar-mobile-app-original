import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/controllers/features/filter_controller.dart';
import 'package:samsar/controllers/features/theme_controller.dart';

class AdvancedFilters extends StatelessWidget {
  final VoidCallback onFiltersChanged;
  final String? selectedCategory; // 'vehicles' or 'real_estate'
  
  const AdvancedFilters({
    super.key,
    required this.onFiltersChanged,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final FilterController filterController = Get.find<FilterController>();
    late final ThemeController themeController;
    try {
      themeController = Get.find<ThemeController>();
    } catch (e) {
      themeController = Get.put(ThemeController());
    }
    
    return Obx(() => Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeController.isDarkMode.value ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.tune,
                color: themeController.isDarkMode.value ? Colors.blue[400] : Colors.blue[600],
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'advanced_filters'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: themeController.isDarkMode.value ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
              if (filterController.hasActiveFilters)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${filterController.activeFilterCount}',
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Category-specific subcategory filter
          if (selectedCategory != null) ...[
            _buildSubcategorySection(filterController, themeController),
            const SizedBox(height: 16),
          ],
          
          // Listing Type (For Sale/For Rent)
          _buildListingTypeSection(filterController, themeController),
          const SizedBox(height: 16),
          
          // Location & Price (Enhanced)
          _buildLocationPriceSection(filterController, themeController),
          const SizedBox(height: 16),
          
          // Year Filter
          _buildYearSection(filterController, themeController),
          const SizedBox(height: 16),
          
          // Sort Options
          _buildSortSection(filterController, themeController),
          const SizedBox(height: 20),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    filterController.resetFilters();
                    onFiltersChanged();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.clear_all, size: 18),
                      const SizedBox(width: 8),
                      Text('clear_all'.tr),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    onFiltersChanged();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check, size: 18),
                      const SizedBox(width: 8),
                      Text('apply_filters'.tr),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildSubcategorySection(FilterController filterController, ThemeController themeController) {
    List<String> subcategories = [];
    
    if (selectedCategory == 'vehicles') {
      subcategories = ['cars', 'motorcycles', 'passengers', 'constructions'];
    } else if (selectedCategory == 'real_estate') {
      subcategories = ['apartment', 'house', 'villa', 'office', 'store', 'land'];
    }
    
    if (subcategories.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'subcategory'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: themeController.isDarkMode.value ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: subcategories.map((subcat) {
            final isSelected = filterController.selectedSubcategory.value == subcat;
            return GestureDetector(
              onTap: () {
                filterController.selectedSubcategory.value = isSelected ? '' : subcat;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Colors.blue[600] 
                      : (themeController.isDarkMode.value ? Colors.grey[700] : Colors.grey[200]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected 
                        ? Colors.blue[600]! 
                        : (themeController.isDarkMode.value ? Colors.grey[600]! : Colors.grey[300]!),
                  ),
                ),
                child: Text(
                  subcat.tr,
                  style: TextStyle(
                    color: isSelected 
                        ? Colors.white 
                        : (themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[700]),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildListingTypeSection(FilterController filterController, ThemeController themeController) {
    final listingTypes = ['for_sale', 'for_rent'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'listing_type'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: themeController.isDarkMode.value ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: listingTypes.map((type) {
            final isSelected = filterController.selectedListingType.value == type;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  filterController.selectedListingType.value = isSelected ? '' : type;
                },
                child: Container(
                  margin: EdgeInsets.only(right: type == 'for_sale' ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? (type == 'for_sale' ? Colors.green[600] : Colors.red[600])
                        : (themeController.isDarkMode.value ? Colors.grey[700] : Colors.grey[200]),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected 
                          ? (type == 'for_sale' ? Colors.green[600]! : Colors.red[600]!)
                          : (themeController.isDarkMode.value ? Colors.grey[600]! : Colors.grey[300]!),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        type == 'for_sale' ? Icons.monetization_on : Icons.key,
                        color: isSelected 
                            ? Colors.white 
                            : (themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[600]),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        type.tr,
                        style: TextStyle(
                          color: isSelected 
                              ? Colors.white 
                              : (themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[700]),
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationPriceSection(FilterController filterController, ThemeController themeController) {
    return Row(
      children: [
        // Location
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'location'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: themeController.isDarkMode.value ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showLocationPicker(filterController, themeController),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: themeController.isDarkMode.value ? Colors.grey[700] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: themeController.isDarkMode.value ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          filterController.selectedCity.value.isEmpty 
                              ? 'all_locations'.tr 
                              : filterController.getTranslatedCity(filterController.selectedCity.value),
                          style: TextStyle(
                            fontSize: 14,
                            color: themeController.isDarkMode.value ? Colors.white : Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Price Range
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'price_range'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: themeController.isDarkMode.value ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showPricePicker(filterController, themeController),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: themeController.isDarkMode.value ? Colors.grey[700] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: themeController.isDarkMode.value ? Colors.grey[600]! : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: 16,
                        color: themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getPriceRangeText(filterController),
                          style: TextStyle(
                            fontSize: 14,
                            color: themeController.isDarkMode.value ? Colors.white : Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildYearSection(FilterController filterController, ThemeController themeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'year'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: themeController.isDarkMode.value ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showYearPicker(filterController, themeController),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: themeController.isDarkMode.value ? Colors.grey[700] : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: themeController.isDarkMode.value ? Colors.grey[600]! : Colors.grey[300]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    filterController.selectedYear.value?.toString() ?? 'any_year'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: themeController.isDarkMode.value ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSortSection(FilterController filterController, ThemeController themeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'sort_by'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: themeController.isDarkMode.value ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showSortPicker(filterController, themeController),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: themeController.isDarkMode.value ? Colors.grey[700] : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: themeController.isDarkMode.value ? Colors.grey[600]! : Colors.grey[300]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.sort,
                  size: 16,
                  color: themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    filterController.selectedSort.value.isEmpty 
                        ? 'newest_first'.tr 
                        : filterController.getTranslatedSortOption(filterController.selectedSort.value),
                    style: TextStyle(
                      fontSize: 14,
                      color: themeController.isDarkMode.value ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getPriceRangeText(FilterController filterController) {
    if (filterController.minPrice.value != null && filterController.maxPrice.value != null) {
      return '${filterController.minPrice.value!.toInt()} - ${filterController.maxPrice.value!.toInt()}';
    } else if (filterController.minPrice.value != null) {
      return '${'from'.tr} ${filterController.minPrice.value!.toInt()}';
    } else if (filterController.maxPrice.value != null) {
      return '${'up_to'.tr} ${filterController.maxPrice.value!.toInt()}';
    }
    return 'any_price'.tr;
  }

  void _showLocationPicker(FilterController filterController, ThemeController themeController) {
    // Implementation similar to SimpleFilters but with more options
  }

  void _showPricePicker(FilterController filterController, ThemeController themeController) {
    // Implementation similar to SimpleFilters but with more granular controls
  }

  void _showYearPicker(FilterController filterController, ThemeController themeController) {
    // Year picker implementation
  }

  void _showSortPicker(FilterController filterController, ThemeController themeController) {
    // Sort picker implementation
  }
}
