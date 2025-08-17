import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/features/search_controller.dart';
import 'package:samsar/controllers/listing/trending_listing_controller.dart';
import 'package:samsar/models/search/search_query.dart';
import 'package:samsar/views/listing_features/listing_detail/listing_detail.dart';
import 'package:samsar/views/notifications/notification_view.dart';
import 'package:samsar/widgets/enhanced_search_bar.dart';
import 'package:samsar/widgets/fillter_button/fillter_button.dart';
import 'package:samsar/widgets/listing_card/listing_card.dart';

class ListingFeedView extends StatefulWidget {
  const ListingFeedView({super.key});

  @override
  State<ListingFeedView> createState() => _ListingFeedViewState();
}

class _ListingFeedViewState extends State<ListingFeedView> {
  final TrendingListingController controller = Get.put(TrendingListingController());
  final TextEditingController _searchController = TextEditingController();
  final SearchModuleController _searchModuleController = Get.put(SearchModuleController());

  int selectedIndex = 0;
  bool isSearching = false;
  final List<String> tabs = ['vehicles'.tr, 'real_estate'.tr];
  
  // Add debounce timer for search
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    // Use the original keys for comparison, not the translated values
    final isVehiclesTab = selectedIndex == 0; // First tab is vehicles, second is real estate
    if (isVehiclesTab) {
      controller.selectedCategory("vehicles");
    } else {
      controller.selectedCategory("real_estate");
    }
  }

  void exitSearchMode() {
    print('🚪 EXITING SEARCH MODE');
    setState(() {
      isSearching = false;
      _searchController.clear();
      // Cancel any pending debounce timer
      _debounceTimer?.cancel();
      // Clear search results
      _searchModuleController.searchResults.clear();
    });
    
    print('  Search mode exited, isSearching: $isSearching');
    print('  Note: Filters are not reset as they only affect home page listings');
  }
  
  void _performSearch(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();
    
    // Set up new timer for debounced search
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (query.trim().isEmpty) {
        _searchModuleController.searchResults.clear();
        _searchModuleController.allResults.clear();
        return;
      }
      
      // Get current category for search
      String? category;
      if (selectedIndex == 0) {
        category = 'vehicles';
      } else {
        category = 'real_estate';
      }
      
      final searchQuery = SearchQuery(
        query: query.trim(),
        category: category,
      );
      
      _searchModuleController.searchController(searchQuery, reset: true);
    });
  }
  
  void _performLocalSearch(String query) {
    // For real-time fuzzy search on existing results
    _searchModuleController.performLocalSearch(query);
  }
  
  void _onSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      _performSearch(query);
      FocusScope.of(context).unfocus();
    }
  }

  String _getCurrentCategory() {
    return selectedIndex == 0 ? 'vehicles' : 'real_estate';
  }
  
  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }
  
  Widget _buildSearchResults() {
    return Obx(() {
      if (_searchModuleController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (_searchController.text.trim().isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'start_typing_to_search'.tr,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'fuzzy_search_tip'.tr,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }
      
      if (_searchModuleController.searchResults.isEmpty && !_searchModuleController.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'no_search_results'.tr,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'try_different_keywords'.tr,
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'fuzzy_search_enabled'.tr,
                style: TextStyle(color: blueColor, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }
      
      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!_searchModuleController.isLoading.value &&
              _searchModuleController.hasMore.value &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            // Load more search results
            _searchModuleController.searchController(_searchModuleController.lastQuery);
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: _searchModuleController.searchResults.length + 
                    (_searchModuleController.isLoading.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < _searchModuleController.searchResults.length) {
              final item = _searchModuleController.searchResults[index];
              final hasValidImage = item.images.isNotEmpty;
              
              return GestureDetector(
                onTap: () => Get.to(() => ListingDetail(listingId: item.id!)),
                child: ListingCard(
                  title: item.title ?? "no_title".tr,
                  imageUrl: hasValidImage
                      ? NetworkImage(item.images[0])
                      : carError,
                  description: item.description ?? '',
                  listingAction: item.listingAction ?? '',
                  subCategory: item.category?.subCategory ?? '',
                  listingId: item.id ?? 'NA',
                  price: item.price ?? 0,
                  // Search results don't have detailed vehicle info, so use defaults
                  fuelType: null,
                  year: null,
                  transmission: null,
                  mileage: null,
                ),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      );
    });
  }
  
  Widget _buildRegularListings() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.listings.isEmpty) {
        return Center(child: Text("no_listings_found".tr));
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!controller.isMoreLoading.value &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            controller.loadMore();
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchListings(isInitial: true);
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: controller.listings.length + (controller.isMoreLoading.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < controller.listings.length) {
                final item = controller.listings[index];
                final hasValidImage = item.images.isNotEmpty && (item.images[0].url?.isNotEmpty ?? false);

                return GestureDetector(
                  onTap: () => Get.to(() => ListingDetail(listingId: item.id!)),
                  child: ListingCard(
                    title: item.title ?? "no_title".tr,
                    imageUrl: hasValidImage
                        ? NetworkImage(item.images[0].url!)
                        : carError,
                    description: item.description ?? '',
                    listingAction: item.listingAction ?? '',
                    subCategory: item.subCategory ?? '',
                    listingId: item.id ?? 'NA',
                    price: item.price ?? 0,
                    fuelType: item.fuelType?.toString(),
                    year: item.year,
                    transmission: item.transmission?.toString(),
                    mileage: item.mileage?.toString(),
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isSearching
              ? AppBar(
                  key: const ValueKey('searchBar'),
                  backgroundColor: whiteColor,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: exitSearchMode,
                  ),
                  title: EnhancedSearchBar(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {});
                      if (value.length >= 2) {
                        _performLocalSearch(value);
                      } else {
                        _performSearch(value);
                      }
                    },
                    onSubmitted: _onSearchSubmitted,
                    onClear: () {
                      setState(() {
                        _searchModuleController.searchResults.clear();
                        _searchModuleController.allResults.clear();
                        _debounceTimer?.cancel();
                      });
                    },
                    showSuggestions: true,
                  ),
                )
              : AppBar(
                  key: const ValueKey('defaultAppBar'),
                  backgroundColor: whiteColor,
                  title: Text(
                    "app_name".tr,
                    style: TextStyle(fontWeight: FontWeight.bold, color: blueColor),
                  ),
                  centerTitle: false,
                  actions: [
                    IconButton(
                      onPressed: () {
                        setState(() => isSearching = true);
                      },
                      icon: Icon(Icons.search, color: blackColor),
                    ),
                    const SizedBox(width: 3),
                    IconButton(
                      onPressed: () => Get.to(() => NotificationView()),
                      icon: Icon(Icons.notifications, color: blackColor),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Remove top search bar widget since it's now inside the AppBar
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Wrap(
                  spacing: 10,
                  children: List.generate(tabs.length, (index) {
                    return ChoiceChip(
                      showCheckmark: false,
                      label: Text(tabs[index]),
                      selected: selectedIndex == index,
                      onSelected: (bool selected) {
                        if (selected) {
                          setState(() {
                            selectedIndex = index;
                            controller.setCategory(tabs[index].toLowerCase());
                            // Clear search results when switching tabs
                            if (isSearching && _searchController.text.trim().isNotEmpty) {
                              _performSearch(_searchController.text);
                            }
                          });
                        }
                      },
                      selectedColor: blueColor,
                      backgroundColor: Colors.grey[300],
                      labelStyle: TextStyle(
                        color: selectedIndex == index ? Colors.white : Colors.black,
                      ),
                    );
                  }),
                ),
                FillterButton(
                  currentCategory: _getCurrentCategory(),
                  currentQuery: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
                  onFiltersApplied: (filterSummary) {
                    print('🏠 FILTERS APPLIED TO TRENDING LISTINGS');
                    print('  filterSummary: "$filterSummary"');
                    print('  Filters only affect home page listings, not search mode');
                    
                    // Show feedback when filters are applied
                    if (filterSummary != null && filterSummary.isNotEmpty) {
                      print('  Showing snackbar with summary: $filterSummary');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${'filters_applied'.tr}: $filterSummary'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else {
                      print('  Showing generic filters applied message');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('filters_applied'.tr),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                    
                    print('✅ FILTERS APPLIED - Home page listings updated');
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: isSearching ? _buildSearchResults() : _buildRegularListings(),
            ),
          ],
        ),
      ),
    );
  }
}
