import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/controllers/features/filter_controller.dart';
import 'package:samsar/controllers/features/theme_controller.dart';

class SimpleFilters extends StatelessWidget {
  final VoidCallback onFiltersChanged;

  const SimpleFilters({super.key, required this.onFiltersChanged});

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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeController.isDarkMode.value
              ? Colors.grey[800]
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'quick_filters'.tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeController.isDarkMode.value
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),

            // Filter Row
            Row(
              children: [
                // Location Filter
                Expanded(
                  flex: 1,
                  child: _buildFilterDropdown(
                    context: context,
                    title: 'location'.tr,
                    value: filterController.selectedCity.value.isEmpty
                        ? 'all_locations'.tr
                        : filterController.getTranslatedCity(
                            filterController.selectedCity.value,
                          ),
                    icon: Icons.location_on,
                    onTap: () => _showLocationFilter(
                      context,
                      filterController,
                      themeController,
                    ),
                    themeController: themeController,
                  ),
                ),
                const SizedBox(width: 8),

                // Price Filter
                Expanded(
                  flex: 1,
                  child: _buildFilterDropdown(
                    context: context,
                    title: 'price'.tr,
                    value: _getPriceRangeText(filterController),
                    icon: Icons.attach_money,
                    onTap: () => _showPriceFilter(
                      context,
                      filterController,
                      themeController,
                    ),
                    themeController: themeController,
                  ),
                ),
                const SizedBox(width: 8),

                // Sort Filter
                Expanded(
                  flex: 1,
                  child: _buildFilterDropdown(
                    context: context,
                    title: 'sort'.tr,
                    value: filterController.selectedSort.value.isEmpty
                        ? 'newest_first'.tr
                        : filterController.getTranslatedSortOption(
                            filterController.selectedSort.value,
                          ),
                    icon: Icons.sort,
                    onTap: () => _showSortFilter(
                      context,
                      filterController,
                      themeController,
                    ),
                    themeController: themeController,
                  ),
                ),
              ],
            ),

            // Clear filters button if any filters are active
            if (filterController.hasActiveFilters)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(
                  child: TextButton.icon(
                    onPressed: () {
                      filterController.resetFilters();
                      onFiltersChanged();
                    },
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: Text('clear_filters'.tr),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDropdown({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    required ThemeController themeController,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: themeController.isDarkMode.value
                      ? Colors.grey[300]
                      : Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      color: themeController.isDarkMode.value
                          ? Colors.grey[300]
                          : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 14,
                  color: themeController.isDarkMode.value
                      ? Colors.grey[300]
                      : Colors.grey[600],
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: themeController.isDarkMode.value
                    ? Colors.white
                    : Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
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

  void _showLocationFilter(
    BuildContext context,
    FilterController filterController,
    ThemeController themeController,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: themeController.isDarkMode.value
          ? Colors.grey[850]
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
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
                Navigator.pop(context);
                onFiltersChanged();
              },
            ),

            const Divider(),

            // Cities list
            ...filterController.cities.map(
              (city) => ListTile(
                leading: const Icon(Icons.location_city),
                title: Text(filterController.getTranslatedCity(city)),
                onTap: () {
                  filterController.selectedCity.value = city;
                  Navigator.pop(context);
                  onFiltersChanged();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPriceFilter(
    BuildContext context,
    FilterController filterController,
    ThemeController themeController,
  ) {
    double minPrice = filterController.minPrice.value ?? 0;
    double maxPrice = filterController.maxPrice.value ?? 1000000;

    showModalBottomSheet(
      context: context,
      backgroundColor: themeController.isDarkMode.value
          ? Colors.grey[850]
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(20),
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
                        Navigator.pop(context);
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
                        Navigator.pop(context);
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

  void _showSortFilter(
    BuildContext context,
    FilterController filterController,
    ThemeController themeController,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: themeController.isDarkMode.value
          ? Colors.grey[850]
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
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
                onTap: () {
                  filterController.selectedSort.value = sortOption;
                  Navigator.pop(context);
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
}
