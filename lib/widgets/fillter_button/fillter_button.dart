import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/features/filter_controller.dart';
import 'package:samsar/controllers/listing/listing_controller.dart';

class FillterButton extends StatefulWidget {
  final String? currentCategory;
  final String? currentQuery;
  final Function(String?)? onFiltersApplied;

  const FillterButton({
    super.key,
    this.currentCategory,
    this.currentQuery,
    this.onFiltersApplied,
  });

  @override
  State<FillterButton> createState() => _FillterButtonState();
}

class _FillterButtonState extends State<FillterButton> {
  late final FilterController _filterController;
  late final ListingController _listingController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers after widget is built
    _filterController = Get.find<FilterController>();
    _listingController = Get.find<ListingController>();
  }

  void _applyFilters() {

    // Apply filters only to home page listings
    _listingController.applyFilters();

    // Notify parent if callback provided
    if (widget.onFiltersApplied != null) {
      final summary = _filterController.getFilterSummary();
      widget.onFiltersApplied!(summary);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton.icon(
          onPressed: () {
            Get.dialog(
              Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                          runSpacing: 20,
                          spacing: 20,
                          children: [
                            // Sort Dropdown
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "sort_by".tr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Obx(
                                  () => DropdownButton<String>(
                                    value:
                                        _filterController
                                            .selectedSort
                                            .value
                                            .isEmpty
                                        ? null
                                        : _filterController.selectedSort.value,
                                    hint: Text("select_sort_option".tr),
                                    items: _filterController.sortOptions
                                        .map(
                                          (option) => DropdownMenuItem(
                                            value: option,
                                            child: Text(
                                              _filterController
                                                  .getTranslatedSortOption(
                                                    option,
                                                  ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (val) {
                                      _filterController.selectedSort.value =
                                          val ?? '';
                                    },
                                  ),
                                ),
                              ],
                            ),

                            // Subcategory Dropdown
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "subcategory".tr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Obx(
                                  () => DropdownButton<String>(
                                    value:
                                        _filterController
                                            .selectedSubcategory
                                            .value
                                            .isEmpty
                                        ? null
                                        : _filterController
                                              .selectedSubcategory
                                              .value,
                                    hint: Text("select_subcategory".tr),
                                    items: _filterController.subcategories
                                        .map(
                                          (sub) => DropdownMenuItem(
                                            value: sub,
                                            child: Text(
                                              _filterController
                                                  .getTranslatedSubcategory(
                                                    sub,
                                                  ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (val) {
                                      _filterController
                                              .selectedSubcategory
                                              .value =
                                          val ?? '';
                                    },
                                  ),
                                ),
                              ],
                            ),

                            // Listing Type Toggle Buttons
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "listing_type".tr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Obx(
                                  () => Row(
                                    children: _filterController.listingTypes.map((
                                      type,
                                    ) {
                                      final isSelected =
                                          _filterController
                                              .selectedListingType
                                              .value ==
                                          type;
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 8.0,
                                        ),
                                        child: ChoiceChip(
                                          label: Text(
                                            _filterController
                                                .getTranslatedListingType(type),
                                            style: TextStyle(
                                              color: isSelected
                                                  ? whiteColor
                                                  : blackColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          selected: isSelected,
                                          selectedColor: blueColor,
                                          backgroundColor: whiteColor,
                                          side: BorderSide(
                                            color: isSelected
                                                ? blueColor
                                                : Colors.grey.shade300,
                                          ),
                                          onSelected: (_) {
                                            _filterController
                                                    .selectedListingType
                                                    .value =
                                                type;
                                          },
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),

                            // City Dropdown
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "city".tr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Obx(
                                  () => DropdownButton<String>(
                                    value:
                                        _filterController
                                            .selectedCity
                                            .value
                                            .isEmpty
                                        ? null
                                        : _filterController.selectedCity.value,
                                    hint: Text("select_city".tr),
                                    items: _filterController.cities
                                        .map(
                                          (city) => DropdownMenuItem(
                                            value: city,
                                            child: Text(
                                              _filterController
                                                  .getTranslatedCity(city),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (val) {
                                      _filterController.selectedCity.value =
                                          val ?? '';
                                    },
                                  ),
                                ),
                              ],
                            ),

                            // Year Dropdown
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "year".tr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Obx(
                                  () => DropdownButton<int>(
                                    value: _filterController.selectedYear.value,
                                    hint: Text("select_year".tr),
                                    items: _filterController.years
                                        .map(
                                          (year) => DropdownMenuItem(
                                            value: year,
                                            child: Text(year.toString()),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (val) {
                                      _filterController.selectedYear.value =
                                          val;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Apply & Reset Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                _filterController.resetFilters();
                              },
                              child: Text("reset".tr),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _applyFilters();
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: blueColor,
                                foregroundColor: Colors.white,
                              ),
                              child: Text("apply".tr),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          icon: const Icon(Icons.filter_list),
          label: Text("filter".tr),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade200,
            foregroundColor: Colors.black87,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
      ),
    );
  }
}
