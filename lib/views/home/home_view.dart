import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:samsar/constants/color_constants.dart';
import 'package:samsar/controllers/auth/auth_controller.dart';
import 'package:samsar/controllers/features/location_controller.dart';
import 'package:samsar/controllers/listing/listing_controller.dart';
import 'package:samsar/controllers/features/filter_controller.dart';
import 'package:samsar/controllers/features/theme_controller.dart';
import 'package:samsar/routes/route_names.dart';
import 'package:samsar/utils/performance_manager.dart';
import 'package:samsar/widgets/main_navbar.dart';

// Lazy-loaded imports
import 'package:samsar/views/chats/chat_list_view.dart' deferred as chat;
import 'package:samsar/views/listing_features/create_listing/create_listing_view.dart' deferred as create_listing;
import 'package:samsar/views/listing_features/favourite_listings/favourite_listings.dart' deferred as favourites;
import 'package:samsar/views/profile_and_settings/profile_and_settings.dart' deferred as profile;
import 'package:samsar/views/listing_feed/listing_feed_view.dart';
import 'package:samsar/views/placeholders/auth_required_placeholder.dart';
import 'package:samsar/widgets/listing_card/listing_card.dart' deferred as listing_card;
import 'package:samsar/widgets/filters/simple_filters.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with PerformanceOptimizedWidget {
  int _currIndex = 0;
  final Map<int, Widget?> _pages = {}; // Lazy-loaded pages
  final Map<int, bool> _pageLoaded = {}; // Track loaded pages

  late final LocationController _locationController;
  late final AuthController _authController;
  late final ThemeController _themeController;

  @override
  void initState() {
    super.initState();
    // Lazy load controllers
    _locationController = PerformanceManager.lazyLoadController(
      () => LocationController(),
      permanent: true,
    );
    _authController = Get.find<AuthController>();
    _themeController = Get.put(ThemeController());
    
    // Initialize home page immediately
    _pages[0] = const _HomePageContent();
    _pageLoaded[0] = true;
  }

  List<Widget> _buildPages() {
    final pages = <Widget>[];
    for (int i = 0; i < 5; i++) {
      if (_pages.containsKey(i) && _pages[i] != null) {
        pages.add(_pages[i]!);
      } else {
        pages.add(const SizedBox()); // Placeholder
      }
    }
    return pages;
  }

  Future<void> _loadPage(int index) async {
    if (_pageLoaded[index] == true) return;

    // Wait for session restoration to complete before checking authentication
    while (!_authController.isSessionReady) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    Widget? page;
    switch (index) {
      case 0:
        page = const ListingFeedView();
        break;
      case 1:
        // Favourites - show placeholder if not authenticated
        if (_authController.isAuthenticated) {
          await favourites.loadLibrary();
          page = favourites.FavouriteListings();
        } else {
          page = const AuthRequiredPlaceholder(
            featureKey: 'favourites_feature',
            icon: Icons.favorite,
            descriptionKey: 'favourites_desc',
            benefitKeys: [
              'save_unlimited',
              'organize_categories',
              'price_notifications',
              'quick_access',
            ],
          );
        }
        break;
      case 2:
        // Create Listing - show placeholder if not authenticated
        if (_authController.isAuthenticated) {
          await create_listing.loadLibrary();
          page = create_listing.CreateListingView();
        } else {
          page = const AuthRequiredPlaceholder(
            featureKey: 'create_listing_feature',
            icon: Icons.add_circle,
            descriptionKey: 'create_listing_desc',
            benefitKeys: [
              'list_free',
              'photo_tools',
              'reach_buyers',
              'secure_payment',
            ],
          );
        }
        break;
      case 3:
        // Chats - show placeholder if not authenticated
        if (_authController.isAuthenticated) {
          await chat.loadLibrary();
          page = chat.ChatListView();
        } else {
          page = const AuthRequiredPlaceholder(
            featureKey: 'messages',
            icon: Icons.chat,
            descriptionKey: 'messages_desc',
            benefitKeys: [
              'realtime_messaging',
              'share_photos',
              'negotiate_safely',
              'translation',
            ],
          );
        }
        break;
      case 4:
        // Profile - show placeholder if not authenticated
        if (_authController.isAuthenticated) {
          await profile.loadLibrary();
          page = profile.ProfileAndSettings();
        } else {
          page = const AuthRequiredPlaceholder(
            featureKey: 'profile',
            icon: Icons.person,
            descriptionKey: 'profile_desc',
            benefitKeys: [
              'track_listings',
              'purchase_history',
              'account_settings',
              'build_reputation',
            ],
          );
        }
        break;
    }

    if (page != null && mounted) {
      setState(() {
        _pages[index] = page;
        _pageLoaded[index] = true;
      });
    }
  }

  void setPageIndex(int index) async {
    // Define which tabs require authentication for full functionality
    // 0: Home (ListingFeedView) - Public
    // 1: Favourites - Requires Auth
    // 2: Create Listing - Requires Auth
    // 3: Chats - Requires Auth
    // 4: Profile - Requires Auth
    
    List<int> protectedTabs = [1, 2, 3, 4];
    
    // Always allow navigation to the tab first
    await _loadPage(index);
    
    if (mounted) {
      setState(() {
        _currIndex = index;
      });
    }
    
    // After navigation, check if authentication is needed for protected tabs
    if (protectedTabs.contains(index)) {
      // Wait for session restoration to complete if not already done
      if (!_authController.isSessionReady) {
        print('⏳ Waiting for session restoration to complete...');
        // Show subtle loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text('Checking authentication...'),
              ],
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.blue.shade600,
          ),
        );
        
        // Wait for session restoration
        while (!_authController.isSessionReady) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }
      
      // Show user-friendly login prompt if not authenticated
      if (!_authController.isAuthenticated) {
        print('🔐 User not authenticated, showing login prompt');
        _showLoginPrompt(index);
      } else {
        print('✅ User authenticated, full access granted');
      }
    }
  }
  
  void _showLoginPrompt(int tabIndex) {
    final tabNames = ['Home', 'Favourites', 'Create Listing', 'Chats', 'Profile'];
    final tabName = tabNames[tabIndex];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.login, color: Colors.blue),
            SizedBox(width: 12),
            Text('Login Required'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'To access $tabName, you need to sign in to your account.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Benefits of signing in:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ...[
              '• Save your favorite listings',
              '• Create and manage your listings',
              '• Chat with other users',
              '• Personalized recommendations',
            ].map((benefit) => Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(benefit),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Navigate back to home tab
              setState(() {
                _currIndex = 0;
              });
            },
            child: Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Get.toNamed(RouteNames.loginView);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text('Sign In'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {


        if(_locationController.isLoading.value) {
          return Scaffold(
            backgroundColor: _themeController.isDarkMode.value ? Colors.grey[900] : Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: _themeController.isDarkMode.value ? Colors.white : blueColor,
              ),
            ),
          );
        }

        if(_locationController.errorMessage.isNotEmpty) {
          return Scaffold(
            backgroundColor: _themeController.isDarkMode.value ? Colors.grey[900] : Colors.white,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _locationController.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16, 
                        color: _themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[700]
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _locationController.errorMessage.value.contains("permanently denied")
                          ? () {
                              // Open app settings if permissions are permanently denied
                              Geolocator.openAppSettings();
                            }
                          : () {
                              _locationController.getCurrentLocation();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _locationController.errorMessage.value.contains("permanently denied") 
                            ? (_themeController.isDarkMode.value ? Colors.grey[600] : Colors.grey)
                            : blueColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: Text(
                        _locationController.errorMessage.value.contains("permanently_denied".tr)
                            ? "open_settings".tr
                            : "retry".tr,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }


        return Scaffold(
          backgroundColor: _themeController.isDarkMode.value ? Colors.grey[900] : Colors.white,
          body: IndexedStack(
            index: _currIndex,
            children: _buildPages(),
          ),
          bottomNavigationBar: MainNavBar(
            currentIndex: _currIndex,
            onTap: setPageIndex,
          ),
        );
      }
    );
  }
}

// ============================================================================
// HOME PAGE CONTENT - Consolidated from home_page_content.dart
// ============================================================================

class _HomePageContent extends StatefulWidget {
  const _HomePageContent();

  @override
  State<_HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<_HomePageContent> {
  String? selectedMainCategory;
  String? selectedSubCategory;
  String? selectedListingAction;
  bool showFilters = false;
  
  // Controllers for listings and filters
  late ListingController listingController;
  late FilterController filterController;
  late ThemeController _themeController;
  
  @override
  void initState() {
    super.initState();
    // Initialize controllers
    _themeController = Get.find<ThemeController>();
    // Initialize FilterController BEFORE ListingController
    // because ListingController depends on FilterController in its onInit()
    filterController = Get.put(FilterController());
    listingController = Get.put(ListingController());
    
    // Load all listings by default on home page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllListings();
    });
  }

  // Main categories - Only Real Estate and Vehicles with professional icons
  final List<CategoryItem> mainCategories = [
    CategoryItem(
      id: 'real_estate',
      title: 'real_estate'.tr,
      icon: Icons.home_work_rounded,
      color: Colors.deepOrange,
    ),
    CategoryItem(
      id: 'vehicles',
      title: 'vehicles'.tr,
      icon: Icons.directions_car_rounded,
      color: Colors.indigo,
    ),
  ];

  // Real Estate subcategories with professional colorful icons
  final List<CategoryItem> realEstateSubCategories = [
    CategoryItem(id: 'apartment', title: 'apartment'.tr, icon: Icons.apartment_rounded, color: Colors.deepOrange),
    CategoryItem(id: 'house', title: 'house'.tr, icon: Icons.house_rounded, color: Colors.teal),
    CategoryItem(id: 'villa', title: 'villa'.tr, icon: Icons.villa_rounded, color: Colors.purple),
    CategoryItem(id: 'office', title: 'office'.tr, icon: Icons.business_center_rounded, color: Colors.indigo),
    CategoryItem(id: 'store', title: 'store'.tr, icon: Icons.storefront_rounded, color: Colors.green),
    CategoryItem(id: 'land', title: 'land'.tr, icon: Icons.terrain_rounded, color: Colors.brown),
  ];

  // Vehicle subcategories with professional colorful icons
  final List<CategoryItem> vehicleSubCategories = [
    CategoryItem(id: 'cars', title: 'cars'.tr, icon: Icons.directions_car_rounded, color: Colors.blue),
    CategoryItem(id: 'motorcycles', title: 'motorcycles'.tr, icon: Icons.two_wheeler_rounded, color: Colors.red),
    CategoryItem(id: 'passengers', title: 'passengers'.tr, icon: Icons.directions_bus_rounded, color: Colors.green),
    CategoryItem(id: 'constructions', title: 'constructions'.tr, icon: Icons.engineering, color: Colors.orange),
  ];

  // Listing actions with professional colorful icons
  final List<CategoryItem> listingActions = [
    CategoryItem(id: 'for_sale', title: 'for_sale'.tr, icon: Icons.monetization_on_rounded, color: Colors.green),
    CategoryItem(id: 'for_rent', title: 'for_rent'.tr, icon: Icons.key_rounded, color: Colors.red),
    CategoryItem(id: 'searching', title: 'searching'.tr, icon: Icons.search_rounded, color: Colors.blue),
  ];

  void _onMainCategorySelected(String categoryId) {
    setState(() {
      selectedMainCategory = categoryId;
      selectedSubCategory = null;
      selectedListingAction = null;
      showFilters = false;
    });
  }

  void _onSubCategorySelected(String subCategoryId) {
    setState(() {
      selectedSubCategory = subCategoryId;
      selectedListingAction = null;
      showFilters = false;
    });
  }

  void _onListingActionSelected(String actionId) {
    setState(() {
      selectedListingAction = actionId;
      showFilters = true;
    });
    
    // Load listings immediately when action is selected
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadListingsWithFilters();
    });
  }

  void _loadListingsWithFilters() {
    // Set the category in the listing controller
    listingController.selectedCategory(selectedMainCategory!);
    
    // Apply subcategory filter if available
    if (selectedSubCategory != null) {
      filterController.selectedSubcategory.value = selectedSubCategory!;
    }
    
    // Apply listing action filter if available
    if (selectedListingAction != null) {
      filterController.selectedListingType.value = selectedListingAction!;
    }
    
    // Apply filters and load listings
    listingController.applyFilters();
  }

  void _navigateToFullListingView() async {
    // Navigate to full listing view - implementation pending
  }

  void _loadAllListings() {
    // Load all listings without any category filters
    listingController.fetchListings();
  }

  void _applySimplifiedFilters() {
    // Apply only the simplified filters and reload listings
    listingController.applyFilters();
  }

  List<CategoryItem> _getCurrentSubCategories() {
    if (selectedMainCategory == 'real_estate') {
      return realEstateSubCategories;
    } else if (selectedMainCategory == 'vehicles') {
      return vehicleSubCategories;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        // Handle back button navigation through category selection flow
        if (selectedListingAction != null) {
          // From listing action selection back to subcategory selection
          setState(() {
            selectedListingAction = null;
            showFilters = false;
          });
        } else if (selectedSubCategory != null) {
          // From subcategory selection back to main category selection
          setState(() {
            selectedSubCategory = null;
            showFilters = false;
          });
        } else if (selectedMainCategory != null) {
          // From main category selection back to home
          setState(() {
            selectedMainCategory = null;
          });
        }
      },
      child: Obx(() => Scaffold(
        backgroundColor: _themeController.isDarkMode.value ? Colors.grey[900] : Colors.grey[50],
        appBar: AppBar(
          backgroundColor: _themeController.isDarkMode.value ? Colors.grey[850] : Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false, // Remove default back button
          title: Row(
            children: [
              // Custom back button for category navigation
              if (selectedMainCategory != null || selectedSubCategory != null || selectedListingAction != null)
                IconButton(
                  icon: Icon(
                    Icons.arrow_back, 
                    color: _themeController.isDarkMode.value ? Colors.white : Colors.grey[800]
                  ),
                  onPressed: () {
                    if (selectedListingAction != null) {
                      setState(() {
                        selectedListingAction = null;
                        showFilters = false;
                      });
                    } else if (selectedSubCategory != null) {
                      setState(() {
                        selectedSubCategory = null;
                      });
                    } else if (selectedMainCategory != null) {
                      setState(() {
                        selectedMainCategory = null;
                      });
                    }
                  },
                ),
              // Search bar
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: (selectedMainCategory != null || selectedSubCategory != null || selectedListingAction != null) ? 8 : 0,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _themeController.isDarkMode.value ? Colors.grey[700] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search, 
                        size: 20, 
                        color: _themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[600]
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'search_for_listing'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: _themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[600],
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Filter button
              if (showFilters)
                IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: _themeController.isDarkMode.value ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    // TODO: Implement filter functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('filters_coming_soon'.tr)),
                    );
                  },
                ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show category selection flow or the listings based on selection
              if (selectedMainCategory == null) ...[
                _buildMainCategorySelection(),
                const SizedBox(height: 24),
                SimpleFilters(
                  onFiltersChanged: _applySimplifiedFilters,
                ),
                const SizedBox(height: 24),
                _buildListingsHeader(),
                const SizedBox(height: 16),
                _buildListingsView(), // Show all listings by default
              ] else if (selectedSubCategory == null) ...[
                _buildSubCategorySelection(),
              ] else if (selectedListingAction == null) ...[
                _buildListingActionSelection(),
              ] else if (showFilters) ...[
                _buildListingsWithFilters(),
              ]
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildListingsHeader() {
    return Text(
      'all_listings'.tr,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: _themeController.isDarkMode.value ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildListingsView() {
    return Obx(() {
      if (listingController.isLoading.value && listingController.listings.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (listingController.listings.isEmpty) {
        return Center(
          child: Text(
            'no_listings_found'.tr,
            style: TextStyle(
              color: _themeController.isDarkMode.value ? Colors.grey[400] : Colors.grey[600],
              fontSize: 16,
            ),
          ),
        );
      }

      // Use a ListView for single column layout like inside the category navigation
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: listingController.listings.length,
        itemBuilder: (context, index) {
          final item = listingController.listings[index];
          final ImageProvider imageProvider = (item.images.isNotEmpty && item.images.first.isNotEmpty)
              ? NetworkImage(item.images.first)
              : const AssetImage('lib/assets/images/vehicle_placeholder.png');

          return FutureBuilder(
            future: listing_card.loadLibrary(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // Ensure all required fields have default values to avoid null errors
                return listing_card.ListingCard(
                  listingId: item.id ?? '',
                  title: item.title ?? 'No Title',
                  description: item.description ?? 'No description available.',
                  price: item.price?.toInt() ?? 0,
                  subCategory: item.subCategory ?? 'General',
                  listingAction: item.listingAction ?? 'N/A',
                  imageUrl: imageProvider,
                  year: item.year ?? item.yearBuilt,
                  mileage: item.mileage?.toString(),
                  fuelType: item.fuelType?.toString(),
                  transmission: item.transmission?.toString(),
                  isDarkTheme: _themeController.isDarkMode.value,
                );
              } else {
                // Show a placeholder while the card is loading
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        },
      );
    });
  }

  Widget _buildMainCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade600, Colors.blue.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.category,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                'select_main_category'.tr,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildCategoryGrid(
          title: 'الفئات الرئيسية',
          categories: mainCategories,
          onCategorySelected: _onMainCategorySelected,
          columns: 2,
        ),
      ],
    );
  }

  Widget _buildSubCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBackButton(
          '${'back_to'.tr} ${_getMainCategoryTitle(selectedMainCategory!)}',
          () => setState(() => selectedMainCategory = null),
        ),
        const SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade600, Colors.orange.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.list_alt,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${'select_type_of'.tr} ${_getMainCategoryTitle(selectedMainCategory!)}',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildCategoryGrid(
          title: 'الأنواع المتاحة',
          categories: _getCurrentSubCategories(),
          onCategorySelected: _onSubCategorySelected,
        ),
      ],
    );
  }

  Widget _buildListingActionSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBackButton(
          '${'back_to'.tr} ${_getSubCategoryTitle(selectedSubCategory!)}',
          () => setState(() => selectedSubCategory = null),
        ),
        const SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade600, Colors.green.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.announcement,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                'select_listing_type'.tr,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildCategoryGrid(
          title: 'أنواع الإعلانات',
          categories: listingActions,
          onCategorySelected: _onListingActionSelected,
        ),
      ],
    );
  }

  Widget _buildCategoryGrid({
    required String title,
    required List<CategoryItem> categories,
    required Function(String) onCategorySelected,
    String? selectedId,
    int columns = 3,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0, // Adjusted for a more compact look
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final isSelected = selectedId == category.id;

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 50)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Opacity(
                opacity: value,
                child: GestureDetector(
                  onTap: () => onCategorySelected(category.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.identity()..scale(isSelected ? 1.05 : 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _themeController.isDarkMode.value ? Colors.grey[800] : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected 
                                ? category.color.withValues(alpha: 0.3)
                                : Colors.grey.withValues(alpha: 0.1),
                            blurRadius: isSelected ? 12 : 6,
                            offset: Offset(0, isSelected ? 6 : 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon container with enhanced animation
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(
                                      colors: [
                                        category.color.withValues(alpha: 0.8),
                                        category.color,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : LinearGradient(
                                      colors: [
                                        Colors.grey.shade100,
                                        Colors.grey.shade200,
                                      ],
                                    ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: category.color.withValues(alpha: 0.4),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              category.icon,
                              size: 32,
                              color: isSelected ? Colors.white : (_themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey.shade700),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Title with selection feedback
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              category.title,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? category.color : (_themeController.isDarkMode.value ? Colors.grey[200] : Colors.grey[800]),
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBackButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.arrow_back_ios, 
            size: 16, 
            color: _themeController.isDarkMode.value ? Colors.blue[400] : Colors.blue[600]
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: _themeController.isDarkMode.value ? Colors.blue[400] : Colors.blue[700],
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListingsWithFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBackButton(
          '${'back_to'.tr} ${_getListingActionTitle(selectedListingAction!)}',
          () => setState(() {
            selectedListingAction = null;
            showFilters = false;
          }),
        ),
        const SizedBox(height: 16),
        
        // Header with title and view results button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple.shade100, Colors.purple.shade200],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.purple.shade300),
                    ),
                    child: Text(
                      '${_getSubCategoryTitle(selectedSubCategory!)} ${_getListingActionTitle(selectedListingAction!)}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() => Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _themeController.isDarkMode.value ? Colors.grey[700] : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${listingController.listings.length} ${'listings_available'.tr}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _themeController.isDarkMode.value ? Colors.grey[200] : Colors.grey[800],
                        letterSpacing: 0.3,
                      ),
                    ),
                  )),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _navigateToFullListingView,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.visibility, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'view_results'.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Listings preview
        Container(
          constraints: const BoxConstraints(maxHeight: 400),
          child: Obx(() {
            if (listingController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: _themeController.isDarkMode.value ? Colors.white : blueColor,
                ),
              );
            }
            
            if (listingController.listings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off, 
                      size: 64, 
                      color: _themeController.isDarkMode.value ? Colors.grey[500] : Colors.grey[400]
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'no_listings_available'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _themeController.isDarkMode.value ? Colors.grey[300] : Colors.grey[700],
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'try_different_filters'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _themeController.isDarkMode.value ? Colors.grey[400] : Colors.grey[600],
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listingController.listings.length > 6 ? 6 : listingController.listings.length,
                  itemBuilder: (context, index) {
                    final listing = listingController.listings[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to listing detail
                          // Get.to(() => ListingDetail(listing: listing));
                        },
                        child: FutureBuilder(
                          future: listing_card.loadLibrary(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return listing_card.ListingCard(
                                listingId: listing.id ?? index.toString(),
                                title: listing.title ?? 'title_not_available'.tr,
                                imageUrl: listing.images.isNotEmpty 
                                    ? NetworkImage(listing.images.first) 
                                    : const AssetImage('assets/images/placeholder.png') as ImageProvider,
                                description: listing.description ?? 'description_not_available'.tr,
                                subCategory: listing.subCategory ?? selectedSubCategory ?? 'not_specified'.tr,
                                listingAction: listing.listingAction ?? selectedListingAction ?? 'not_specified'.tr,
                                price: listing.price ?? 0,
                                fuelType: listing.fuelType?.toString(),
                                year: listing.year ?? listing.yearBuilt,
                                transmission: listing.transmission?.toString(),
                                mileage: listing.mileage?.toString(),
                              );
                            }
                            return Container(
                              height: 120,
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: _themeController.isDarkMode.value ? Colors.grey[700] : Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: _themeController.isDarkMode.value ? Colors.white : blueColor,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                
                // Show more button if there are more listings
                if (listingController.listings.length > 6)
                  Center(
                    child: TextButton(
                      onPressed: _navigateToFullListingView,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue.shade100, Colors.blue.shade200],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.expand_more, 
                              color: _themeController.isDarkMode.value ? Colors.blue[400] : Colors.blue.shade700, 
                              size: 20
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${'view_more'.tr} (${listingController.listings.length - 6}+)',
                              style: TextStyle(
                                color: _themeController.isDarkMode.value ? Colors.blue[300] : Colors.blue.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }

  String _getMainCategoryTitle(String categoryId) {
    // Return translated category title based on ID
    switch (categoryId) {
      case 'real_estate':
        return 'real_estate'.tr;
      case 'vehicles':
        return 'vehicles'.tr;
      default:
        return categoryId.tr;
    }
  }

  String _getSubCategoryTitle(String subCategoryId) {
    // Return translated subcategory title based on ID
    return subCategoryId.tr;
  }

  String _getListingActionTitle(String actionId) {
    // Return translated listing action title based on ID
    switch (actionId) {
      case 'for_sale':
        return 'for_sale'.tr;
      case 'for_rent':
        return 'for_rent'.tr;
      default:
        return actionId.tr;
    }
  }

}

// ============================================================================
// CATEGORY ITEM MODEL
// ============================================================================

class CategoryItem {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  CategoryItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}