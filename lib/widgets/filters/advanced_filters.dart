import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/controllers/features/filter_controller.dart';
import 'package:samsar/controllers/features/theme_controller.dart';
import 'package:samsar/services/vehicle_service.dart';

class AdvancedFilters extends StatelessWidget {
  final VoidCallback onFiltersChanged;
  final String? selectedCategory; // 'vehicles' or 'real_estate'
  final String?
  selectedSubcategory; // specific subcategory like 'cars', 'apartments', etc.

  const AdvancedFilters({
    super.key,
    required this.onFiltersChanged,
    this.selectedCategory,
    this.selectedSubcategory,
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

    return Obx(
      () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeController.isDarkMode.value
              ? Colors.grey[850]
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.tune,
                  color: themeController.isDarkMode.value
                      ? Colors.blue[400]
                      : Colors.blue[600],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'advanced_filters'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
                const Spacer(),
                if (filterController.hasActiveFilters)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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

            // Category and subcategory specific filters
            if (selectedCategory != null) ...[
              _buildCategorySpecificFilters(filterController, themeController),
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
        ),
      ),
    );
  }

  Widget _buildSubcategorySection(
    FilterController filterController,
    ThemeController themeController,
  ) {
    // Remove subcategory selection from advanced filters
    return const SizedBox.shrink();
  }

  Widget _buildListingTypeSection(
    FilterController filterController,
    ThemeController themeController,
  ) {
    final listingTypes = ['for_sale', 'for_rent'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'listing_type'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: themeController.isDarkMode.value
                ? Colors.white
                : Colors.black87,
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (type == 'for_sale'
                            ? Colors.green[600]
                            : Colors.red[600])
                      : (themeController.isDarkMode.value
                            ? Colors.grey[700]
                            : Colors.grey[200]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? (type == 'for_sale'
                              ? Colors.green[600]!
                              : Colors.red[600]!)
                        : (themeController.isDarkMode.value
                              ? Colors.grey[600]!
                              : Colors.grey[300]!),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      type == 'for_sale' ? Icons.monetization_on : Icons.key,
                      color: isSelected
                          ? Colors.white
                          : (themeController.isDarkMode.value
                                ? Colors.grey[300]
                                : Colors.grey[600]),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      type.tr,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (themeController.isDarkMode.value
                                  ? Colors.grey[300]
                                  : Colors.grey[700]),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ));
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationPriceSection(
    FilterController filterController,
    ThemeController themeController,
  ) {
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
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () =>
                    _showLocationPicker(filterController, themeController),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: themeController.isDarkMode.value
                        ? Colors.grey[700]
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: themeController.isDarkMode.value
                          ? Colors.grey[600]!
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: themeController.isDarkMode.value
                            ? Colors.grey[300]
                            : Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          filterController.selectedCity.value.isEmpty
                              ? 'all_locations'.tr
                              : filterController.getTranslatedCity(
                                  filterController.selectedCity.value,
                                ),
                          style: TextStyle(
                            fontSize: 14,
                            color: themeController.isDarkMode.value
                                ? Colors.white
                                : Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: themeController.isDarkMode.value
                            ? Colors.grey[300]
                            : Colors.grey[600],
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
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () =>
                    _showPricePicker(filterController, themeController),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: themeController.isDarkMode.value
                        ? Colors.grey[700]
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: themeController.isDarkMode.value
                          ? Colors.grey[600]!
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: 16,
                        color: themeController.isDarkMode.value
                            ? Colors.grey[300]
                            : Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getPriceRangeText(filterController),
                          style: TextStyle(
                            fontSize: 14,
                            color: themeController.isDarkMode.value
                                ? Colors.white
                                : Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: themeController.isDarkMode.value
                            ? Colors.grey[300]
                            : Colors.grey[600],
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

  Widget _buildYearSection(
    FilterController filterController,
    ThemeController themeController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'year'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: themeController.isDarkMode.value
                ? Colors.white
                : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showYearPicker(filterController, themeController),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: themeController.isDarkMode.value
                  ? Colors.grey[700]
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: themeController.isDarkMode.value
                    ? Colors.grey[600]!
                    : Colors.grey[300]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: themeController.isDarkMode.value
                      ? Colors.grey[300]
                      : Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    filterController.selectedYear.value?.toString() ??
                        'any_year'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: themeController.isDarkMode.value
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: themeController.isDarkMode.value
                      ? Colors.grey[300]
                      : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSortSection(
    FilterController filterController,
    ThemeController themeController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'sort_by'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: themeController.isDarkMode.value
                ? Colors.white
                : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showSortPicker(filterController, themeController),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: themeController.isDarkMode.value
                  ? Colors.grey[700]
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: themeController.isDarkMode.value
                    ? Colors.grey[600]!
                    : Colors.grey[300]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.sort,
                  size: 16,
                  color: themeController.isDarkMode.value
                      ? Colors.grey[300]
                      : Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    filterController.selectedSort.value.isEmpty
                        ? 'newest_first'.tr
                        : filterController.getTranslatedSortOption(
                            filterController.selectedSort.value,
                          ),
                    style: TextStyle(
                      fontSize: 14,
                      color: themeController.isDarkMode.value
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: themeController.isDarkMode.value
                      ? Colors.grey[300]
                      : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getPriceRangeText(FilterController filterController) {
    if (filterController.minPrice.value != null &&
        filterController.maxPrice.value != null) {
      return '${filterController.minPrice.value!.toInt()} - ${filterController.maxPrice.value!.toInt()}';
    } else if (filterController.minPrice.value != null) {
      return '${'from'.tr} ${filterController.minPrice.value!.toInt()}';
    } else if (filterController.maxPrice.value != null) {
      return '${'up_to'.tr} ${filterController.maxPrice.value!.toInt()}';
    }
    return 'any_price'.tr;
  }

  void _showLocationPicker(
    FilterController filterController,
    ThemeController themeController,
  ) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeController.isDarkMode.value
              ? Colors.grey[850]
              : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'select_location'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeController.isDarkMode.value
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // All locations option
            ListTile(
              leading: const Icon(Icons.public),
              title: Text('all_locations'.tr),
              onTap: () {
                filterController.selectedCity.value = '';
                Get.back();
                onFiltersChanged();
              },
            ),

            const Divider(),

            // Cities list
            ...filterController.cities.map(
              (city) => ListTile(
                leading: const Icon(Icons.location_city),
                title: Text(filterController.getTranslatedCity(city)),
                trailing: filterController.selectedCity.value == city
                    ? Icon(Icons.check, color: Colors.blue[600])
                    : null,
                onTap: () {
                  filterController.selectedCity.value = city;
                  Get.back();
                  onFiltersChanged();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPricePicker(
    FilterController filterController,
    ThemeController themeController,
  ) {
    double minPrice = filterController.minPrice.value ?? 0;
    double maxPrice = filterController.maxPrice.value ?? 1000000;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: themeController.isDarkMode.value
                ? Colors.grey[850]
                : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'price_range'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                '${'min_price'.tr}: ${minPrice.toInt()}',
                style: TextStyle(
                  color: themeController.isDarkMode.value
                      ? Colors.grey[300]
                      : Colors.grey[700],
                ),
              ),
              Slider(
                value: minPrice,
                min: 0,
                max: 1000000,
                divisions: 100,
                onChanged: (value) {
                  setState(() {
                    minPrice = value;
                    if (minPrice > maxPrice) {
                      maxPrice = minPrice;
                    }
                  });
                },
              ),

              const SizedBox(height: 16),

              Text(
                '${'max_price'.tr}: ${maxPrice.toInt()}',
                style: TextStyle(
                  color: themeController.isDarkMode.value
                      ? Colors.grey[300]
                      : Colors.grey[700],
                ),
              ),
              Slider(
                value: maxPrice,
                min: 0,
                max: 1000000,
                divisions: 100,
                onChanged: (value) {
                  setState(() {
                    maxPrice = value;
                    if (maxPrice < minPrice) {
                      minPrice = maxPrice;
                    }
                  });
                },
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        filterController.minPrice.value = null;
                        filterController.maxPrice.value = null;
                        Get.back();
                        onFiltersChanged();
                      },
                      child: Text('clear'.tr),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        filterController.minPrice.value = minPrice > 0
                            ? minPrice
                            : null;
                        filterController.maxPrice.value = maxPrice < 1000000
                            ? maxPrice
                            : null;
                        Get.back();
                        onFiltersChanged();
                      },
                      child: Text('apply'.tr),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showYearPicker(
    FilterController filterController,
    ThemeController themeController,
  ) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeController.isDarkMode.value
              ? Colors.grey[850]
              : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'select_year'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeController.isDarkMode.value
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Any year option
            ListTile(
              leading: const Icon(Icons.all_inclusive),
              title: Text('any_year'.tr),
              trailing: filterController.selectedYear.value == null
                  ? Icon(Icons.check, color: Colors.blue[600])
                  : null,
              onTap: () {
                filterController.selectedYear.value = null;
                Get.back();
                onFiltersChanged();
              },
            ),

            const Divider(),

            // Years list in a scrollable container
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: filterController.years.length,
                itemBuilder: (context, index) {
                  final year = filterController.years[index];
                  return ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: Text(year.toString()),
                    trailing: filterController.selectedYear.value == year
                        ? Icon(Icons.check, color: Colors.blue[600])
                        : null,
                    onTap: () {
                      filterController.selectedYear.value = year;
                      Get.back();
                      onFiltersChanged();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortPicker(
    FilterController filterController,
    ThemeController themeController,
  ) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeController.isDarkMode.value
              ? Colors.grey[850]
              : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'sort_by'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeController.isDarkMode.value
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            ...filterController.sortOptions.map(
              (sortOption) => ListTile(
                leading: Icon(_getSortIcon(sortOption)),
                title: Text(
                  filterController.getTranslatedSortOption(sortOption),
                ),
                trailing: filterController.selectedSort.value == sortOption
                    ? Icon(Icons.check, color: Colors.blue[600])
                    : null,
                onTap: () {
                  filterController.selectedSort.value = sortOption;
                  Get.back();
                  onFiltersChanged();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSortIcon(String sortOption) {
    switch (sortOption) {
      case 'newest_first':
        return Icons.schedule;
      case 'price_high_to_low':
        return Icons.trending_down;
      case 'price_low_to_high':
        return Icons.trending_up;
      case 'location_a_to_z':
        return Icons.sort_by_alpha;
      case 'location_z_to_a':
        return Icons.sort_by_alpha;
      case 'distance_nearest_first':
        return Icons.near_me;
      default:
        return Icons.sort;
    }
  }

  Widget _buildCategorySpecificFilters(
    FilterController filterController,
    ThemeController themeController,
  ) {
    if (selectedCategory == 'vehicles') {
      return _buildVehicleFilters(filterController, themeController);
    } else if (selectedCategory == 'real_estate') {
      return _buildRealEstateFilters(filterController, themeController);
    }
    return const SizedBox.shrink();
  }

  Widget _buildVehicleFilters(
    FilterController filterController,
    ThemeController themeController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'vehicle_filters'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: themeController.isDarkMode.value
                ? Colors.white
                : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        // Fuel Type Filter
        _buildFilterChips(
          title: 'fuel_type'.tr,
          options: ['BENZIN', 'DIESEL', 'ELECTRIC', 'HYBRID'],
          selectedValue: filterController.selectedFuelType,
          themeController: themeController,
        ),
        const SizedBox(height: 12),

        // Transmission Filter
        _buildFilterChips(
          title: 'transmission'.tr,
          options: ['MANUAL', 'AUTOMATIC'],
          selectedValue: filterController.selectedTransmission,
          themeController: themeController,
        ),
        const SizedBox(height: 12),

        // Body Type Filter (for cars)
        if (selectedSubcategory == 'CARS') ...[
          _buildFilterChips(
            title: 'body_type'.tr,
            options: ['SEDAN', 'SUV', 'HATCHBACK', 'COUPE'],
            selectedValue: filterController.selectedBodyType,
            themeController: themeController,
          ),
          const SizedBox(height: 12),
        ],

        // Condition Filter
        _buildFilterChips(
          title: 'condition'.tr,
          options: [
            'NEW',
            'USED_LIKE_NEW',
            'USED_GOOD',
            'USED_FAIR',
          ],
          selectedValue: filterController.selectedCondition,
          themeController: themeController,
        ),
        const SizedBox(height: 12),

        // Make Filter
        _buildMakeDropdownFilter(filterController, themeController),
        const SizedBox(height: 12),

        // Model Filter (shown only if make is selected)
        if (filterController.selectedMake.value.isNotEmpty) ...[
          _buildModelDropdownFilter(filterController, themeController),
          const SizedBox(height: 12),
        ],

        // Mileage Filter
        _buildMileageFilter(filterController, themeController),
      ],
    );
  }

  Widget _buildRealEstateFilters(
    FilterController filterController,
    ThemeController themeController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'property_filters'.tr,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: themeController.isDarkMode.value
                ? Colors.white
                : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        // Bedrooms Filter
        _buildNumberFilter(
          title: 'bedrooms'.tr,
          selectedValue: filterController.selectedBedrooms,
          options: [1, 2, 3, 4, 5],
          themeController: themeController,
        ),
        const SizedBox(height: 12),

        // Bathrooms Filter
        _buildNumberFilter(
          title: 'bathrooms'.tr,
          selectedValue: filterController.selectedBathrooms,
          options: [1, 2, 3, 4],
          themeController: themeController,
        ),
        const SizedBox(height: 12),

        // Furnishing Filter
        _buildFilterChips(
          title: 'furnishing'.tr,
          options: [
            'FULLY_FURNISHED',
            'SEMI_FURNISHED',
            'UNFURNISHED',
          ],
          selectedValue: filterController.selectedFurnishing,
          themeController: themeController,
        ),
        const SizedBox(height: 12),

        // Parking Filter
        _buildFilterChips(
          title: 'parking'.tr,
          options: ['NO_PARKING', '1_CAR', '2_CARS', '3_PLUS_CARS'],
          selectedValue: filterController.selectedParking,
          themeController: themeController,
        ),
        const SizedBox(height: 12),

        // Area Filter
        _buildAreaFilter(filterController, themeController),
        const SizedBox(height: 12),

        // Property Condition Filter
        _buildFilterChips(
          title: 'Property Condition',
          options: ['NEW', 'RENOVATED', 'NEEDS_RENOVATION'],
          selectedValue: filterController.selectedCondition,
          themeController: themeController,
        ),
        const SizedBox(height: 12),

        // Year Built Filter
        _buildYearBuiltFilter(filterController, themeController),
        const SizedBox(height: 12),

        // Floor Filter
        _buildNumberFilter(
          title: 'Floor',
          selectedValue: filterController.selectedFloor,
          options: [1, 2, 3, 4, 5, 10, 15, 20],
          themeController: themeController,
        ),
        const SizedBox(height: 12),

        // Seller Type Filter
        _buildFilterChips(
          title: 'Seller Type',
          options: ['BROKER', 'OWNER', 'BUSINESS_FIRM'],
          selectedValue: filterController.selectedSellerType,
          themeController: themeController,
        ),
      ],
    );
  }

  Widget _buildFilterChips({
    required String title,
    required List<String> options,
    required RxString selectedValue,
    required ThemeController themeController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: themeController.isDarkMode.value
                ? Colors.grey[300]
                : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((option) {
              final isSelected = selectedValue.value == option;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    selectedValue.value = isSelected ? '' : option;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue[600]
                          : (themeController.isDarkMode.value
                                ? Colors.grey[800]
                                : Colors.grey[100]),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Colors.blue[600]!
                            : (themeController.isDarkMode.value
                                  ? Colors.grey[700]!
                                  : Colors.grey[300]!),
                      ),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (themeController.isDarkMode.value
                                  ? Colors.grey[300]
                                  : Colors.grey[700]),
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberFilter({
    required String title,
    required RxnInt selectedValue,
    required List<int> options,
    required ThemeController themeController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: themeController.isDarkMode.value
                ? Colors.grey[300]
                : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((number) {
              final isSelected = selectedValue.value == number;
              return Container(
                width: 60,
                margin: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    selectedValue.value = isSelected ? null : number;
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue[600]
                          : (themeController.isDarkMode.value
                                ? Colors.grey[800]
                                : Colors.grey[100]),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? Colors.blue[600]!
                            : (themeController.isDarkMode.value
                                  ? Colors.grey[700]!
                                  : Colors.grey[300]!),
                      ),
                    ),
                    child: Text(
                      '$number${number == options.last ? '+' : ''}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (themeController.isDarkMode.value
                                  ? Colors.grey[300]
                                  : Colors.grey[700]),
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildAreaFilter(
    FilterController filterController,
    ThemeController themeController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Area (sqft)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: themeController.isDarkMode.value
                ? Colors.grey[300]
                : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _showAreaPicker(filterController, themeController),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: themeController.isDarkMode.value
                  ? Colors.grey[800]
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: themeController.isDarkMode.value
                    ? Colors.grey[600]!
                    : Colors.grey[300]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.square_foot,
                  size: 16,
                  color: themeController.isDarkMode.value
                      ? Colors.grey[300]
                      : Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() {
                    final minArea = filterController.selectedMinArea.value;
                    final maxArea = filterController.selectedMaxArea.value;
                    String text = 'Any area';
                    if (minArea != null || maxArea != null) {
                      if (minArea != null && maxArea != null) {
                        text = '${minArea.toInt()}-${maxArea.toInt()} sqft';
                      } else if (minArea != null) {
                        text = '${minArea.toInt()}+ sqft';
                      } else {
                        text = 'Up to ${maxArea!.toInt()} sqft';
                      }
                    }
                    return Text(
                      text,
                      style: TextStyle(
                        fontSize: 14,
                        color: themeController.isDarkMode.value
                            ? Colors.white
                            : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    );
                  }),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: themeController.isDarkMode.value
                      ? Colors.grey[300]
                      : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildYearBuiltFilter(
    FilterController filterController,
    ThemeController themeController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Year Built',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: themeController.isDarkMode.value
                ? Colors.grey[300]
                : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _showYearBuiltPicker(filterController, themeController),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: themeController.isDarkMode.value
                  ? Colors.grey[800]
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: themeController.isDarkMode.value
                    ? Colors.grey[600]!
                    : Colors.grey[300]!,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: themeController.isDarkMode.value
                      ? Colors.grey[300]
                      : Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() {
                    final yearBuilt = filterController.selectedYearBuilt.value;
                    return Text(
                      yearBuilt != null ? 'Built in $yearBuilt' : 'Any year',
                      style: TextStyle(
                        fontSize: 14,
                        color: themeController.isDarkMode.value
                            ? Colors.white
                            : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    );
                  }),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: themeController.isDarkMode.value
                      ? Colors.grey[300]
                      : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAreaPicker(FilterController filterController, ThemeController themeController) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeController.isDarkMode.value ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Area Range',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeController.isDarkMode.value ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ...['Any area', '500-1000 sqft', '1000-2000 sqft', '2000-3000 sqft', '3000+ sqft'].map((area) {
              return ListTile(
                title: Text(
                  area,
                  style: TextStyle(
                    color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  if (area == 'Any area') {
                    filterController.selectedMinArea.value = null;
                    filterController.selectedMaxArea.value = null;
                  } else if (area == '500-1000 sqft') {
                    filterController.selectedMinArea.value = 500;
                    filterController.selectedMaxArea.value = 1000;
                  } else if (area == '1000-2000 sqft') {
                    filterController.selectedMinArea.value = 1000;
                    filterController.selectedMaxArea.value = 2000;
                  } else if (area == '2000-3000 sqft') {
                    filterController.selectedMinArea.value = 2000;
                    filterController.selectedMaxArea.value = 3000;
                  } else if (area == '3000+ sqft') {
                    filterController.selectedMinArea.value = 3000;
                    filterController.selectedMaxArea.value = null;
                  }
                  Get.back();
                  onFiltersChanged();
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showYearBuiltPicker(FilterController filterController, ThemeController themeController) {
    final currentYear = DateTime.now().year;
    final years = List.generate(currentYear - 1950 + 1, (index) => currentYear - index);
    
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeController.isDarkMode.value ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Year Built',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeController.isDarkMode.value ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: ListView(
                children: [
                  ListTile(
                    title: Text(
                      'Any year',
                      style: TextStyle(
                        color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                      ),
                    ),
                    onTap: () {
                      filterController.selectedYearBuilt.value = null;
                      Get.back();
                      onFiltersChanged();
                    },
                  ),
                  ...years.take(20).map((year) {
                    return ListTile(
                      title: Text(
                        year.toString(),
                        style: TextStyle(
                          color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                        ),
                      ),
                      onTap: () {
                        filterController.selectedYearBuilt.value = year;
                        Get.back();
                        onFiltersChanged();
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMakeDropdownFilter(FilterController filterController, ThemeController themeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'make'.tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: themeController.isDarkMode.value
                ? Colors.white
                : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showMakeSelector(filterController, themeController),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: themeController.isDarkMode.value
                    ? Colors.grey[600]!
                    : Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  filterController.selectedMake.value.isNotEmpty
                      ? filterController.selectedMake.value
                      : 'choose_make'.tr,
                  style: TextStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black87,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModelDropdownFilter(FilterController filterController, ThemeController themeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'model'.tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: themeController.isDarkMode.value
                ? Colors.white
                : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: filterController.selectedMake.value.isNotEmpty
              ? () => _showModelSelector(filterController, themeController)
              : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: themeController.isDarkMode.value
                    ? Colors.grey[600]!
                    : Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  filterController.selectedModel.value.isNotEmpty
                      ? filterController.selectedModel.value
                      : filterController.selectedMake.value.isEmpty
                          ? 'select_make_first'.tr
                          : 'choose_model'.tr,
                  style: TextStyle(
                    color: filterController.selectedMake.value.isEmpty
                        ? Colors.grey
                        : (themeController.isDarkMode.value
                            ? Colors.white
                            : Colors.black87),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: filterController.selectedMake.value.isEmpty
                      ? Colors.grey
                      : (themeController.isDarkMode.value
                          ? Colors.white
                          : Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMileageFilter(FilterController filterController, ThemeController themeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'max_mileage'.tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: themeController.isDarkMode.value
                ? Colors.white
                : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showMileagePicker(filterController, themeController),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: themeController.isDarkMode.value
                    ? Colors.grey[600]!
                    : Colors.grey[300]!,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  filterController.selectedMaxMileage.value != null
                      ? '${filterController.selectedMaxMileage.value!.toStringAsFixed(0)} km'
                      : 'any_mileage'.tr,
                  style: TextStyle(
                    color: themeController.isDarkMode.value
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black87,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showMileagePicker(FilterController filterController, ThemeController themeController) {
    final mileageOptions = [
      {'label': 'any_mileage'.tr, 'value': null},
      {'label': 'Under 10,000 km', 'value': 10000},
      {'label': 'Under 25,000 km', 'value': 25000},
      {'label': 'Under 50,000 km', 'value': 50000},
      {'label': 'Under 75,000 km', 'value': 75000},
      {'label': 'Under 100,000 km', 'value': 100000},
      {'label': 'Under 150,000 km', 'value': 150000},
      {'label': 'Under 200,000 km', 'value': 200000},
    ];

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: themeController.isDarkMode.value ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'select_max_mileage'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeController.isDarkMode.value ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ...mileageOptions.map((option) {
              return ListTile(
                title: Text(
                  option['label'] as String,
                  style: TextStyle(
                    color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () {
                  filterController.selectedMaxMileage.value = option['value'] as int?;
                  Get.back();
                  onFiltersChanged();
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showMakeSelector(FilterController filterController, ThemeController themeController) async {
    if (selectedSubcategory == null) return;
    
    try {
      final makes = await VehicleService.getMakes(selectedSubcategory!.toUpperCase());
      
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: themeController.isDarkMode.value ? Colors.grey[900] : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'choose_make'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: ListView(
                  children: [
                    ListTile(
                      title: Text(
                        'any_make'.tr,
                        style: TextStyle(
                          color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                        ),
                      ),
                      onTap: () {
                        filterController.selectedMake.value = '';
                        filterController.selectedModel.value = '';
                        Get.back();
                        onFiltersChanged();
                      },
                    ),
                    ...makes.map((make) {
                      return ListTile(
                        title: Text(
                          make,
                          style: TextStyle(
                            color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                          ),
                        ),
                        onTap: () {
                          filterController.selectedMake.value = make;
                          filterController.selectedModel.value = '';
                          Get.back();
                          onFiltersChanged();
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print('Error loading makes: $e');
    }
  }

  void _showModelSelector(FilterController filterController, ThemeController themeController) async {
    if (selectedSubcategory == null || filterController.selectedMake.value.isEmpty) return;
    
    try {
      final models = await VehicleService.getModels(
        filterController.selectedMake.value, 
        selectedSubcategory!.toUpperCase()
      );
      
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: themeController.isDarkMode.value ? Colors.grey[900] : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'choose_model'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: ListView(
                  children: [
                    ListTile(
                      title: Text(
                        'any_model'.tr,
                        style: TextStyle(
                          color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                        ),
                      ),
                      onTap: () {
                        filterController.selectedModel.value = '';
                        Get.back();
                        onFiltersChanged();
                      },
                    ),
                    ...models.map((model) {
                      return ListTile(
                        title: Text(
                          model,
                          style: TextStyle(
                            color: themeController.isDarkMode.value ? Colors.white : Colors.black,
                          ),
                        ),
                        onTap: () {
                          filterController.selectedModel.value = model;
                          Get.back();
                          onFiltersChanged();
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print('Error loading models: $e');
    }
  }
}
