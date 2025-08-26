import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:samsar/models/location/city_model.dart';
import 'package:samsar/services/location/location_api_service.dart';

class LocationController extends GetxController {
  // Current location data
  RxString latitude = ''.obs;
  RxString longitude = ''.obs;
  RxString address = ''.obs;
  RxString errorMessage = ''.obs;
  RxBool isLoading = false.obs;

  // Location search data
  RxList<LocationSearchResult> searchResults = <LocationSearchResult>[].obs;
  RxBool isSearching = false.obs;
  RxString searchQuery = ''.obs;

  // Syrian cities data
  RxList<CityInfo> allCities = <CityInfo>[].obs;
  RxList<CityInfo> nearbyCities = <CityInfo>[].obs;
  RxBool isLoadingCities = false.obs;

  // For major cities and their neighbors
  RxList<CityInfo> majorCities = <CityInfo>[].obs;
  Rx<CityInfo?> selectedMajorCity = Rx<CityInfo?>(null);
  RxList<CityInfo> selectedCityNeighbors = <CityInfo>[].obs;

  // Selected location for listing creation
  Rx<LocationSearchResult?> selectedLocation = Rx<LocationSearchResult?>(null);

  @override
  void onInit() {
    super.onInit();
    loadAllCities();
  }

  /// Get current GPS location
  Future<void> getCurrentLocation() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        errorMessage.value = "Location services are disabled.";
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          errorMessage.value = "Location permissions are denied.";
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        errorMessage.value = "Location permissions are permanently denied.";
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude.toString();
      longitude.value = position.longitude.toString();

      // Use backend reverse geocoding for better accuracy
      await reverseGeocodeWithBackend(position.latitude, position.longitude);

      // Get nearby cities
      await getNearbyCities(position.latitude, position.longitude);
    } catch (e) {
      errorMessage.value = 'Error: $e';
      print('🔴 Location Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Reverse geocode using backend API
  Future<void> reverseGeocodeWithBackend(double lat, double lng) async {
    try {
      final result = await LocationApiService.reverseGeocode(
        latitude: lat,
        longitude: lng,
      );

      if (result != null) {
        address.value = result.displayName;
        selectedLocation.value = result;
        print('🌍 Reverse geocoded: ${result.displayName}');
      } else {
        // Fallback to local geocoding
        await getAddressFromCoordinates(lat, lng);
      }
    } catch (e) {
      print('🔴 Backend reverse geocoding failed: $e');
      // Fallback to local geocoding
      await getAddressFromCoordinates(lat, lng);
    }
  }

  /// Fallback local geocoding
  Future<void> getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        address.value =
            "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
        print('📍 Local geocoded: ${address.value}');
      } else {
        address.value = "Address not found";
      }
    } catch (e) {
      errorMessage.value = "Failed to get address: $e";
      print('🔴 Local geocoding error: $e');
    }
  }

  /// Search locations using backend API - NO FALLBACKS
  Future<void> searchCities(String query) async {
    print('🔍 LOCATION SEARCH DEBUG - START');
    print('  Query: "$query"');
    print('  Query length: ${query.length}');
    print('  Is empty: ${query.isEmpty}');

    if (query.isEmpty) {
      print('  ❌ Empty query, clearing results');
      searchResults.clear();
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    print('  🔄 Loading started, calling backend API...');
    print('  🎯 BACKEND-ONLY MODE: No fallbacks will be used');

    try {
      print('  📡 Making API call to backend...');
      final stopwatch = Stopwatch()..start();

      final results = await LocationApiService.searchLocations(
        query: query,
        limit: 10,
      );

      stopwatch.stop();
      print('  ⏱️ API call completed in ${stopwatch.elapsedMilliseconds}ms');
      print('  📊 DETAILED API Response:');
      print('    Results count: ${results.length}');
      print('    Results type: ${results.runtimeType}');

      // Convert LocationSearchResult to CityInfo for compatibility
      final locationResults = results;
      searchResults.value = locationResults;
      print(
        '  ✅ SUCCESS: Found ${searchResults.length} cities from comprehensive backend database',
      );

      // Debug: Print ALL results for comprehensive debugging
      for (int i = 0; i < searchResults.length; i++) {
        final result = searchResults[i];
        print(
          '    🏙️ City $i: "${result.displayName}" (${result.lat}, ${result.lon})',
        );
      }

      if (searchResults.isEmpty) {
        print('  ⚠️ Backend returned no cities for query: "$query"');
        errorMessage.value = 'No cities found for "$query"';
      }
    } catch (e, stackTrace) {
      print('  ❌ CRITICAL BACKEND ERROR - NO FALLBACK AVAILABLE:');
      print('    Error: $e');
      print('    Error type: ${e.runtimeType}');
      print('    Stack trace: $stackTrace');

      searchResults.clear();
      errorMessage.value = 'Connection error: $e';
    } finally {
      isLoading.value = false;
      print('  🏁 Loading completed - Final state:');
      print('    Cities found: ${searchResults.length}');
      print('    Error message: "${errorMessage.value}"');
      print('    Is loading: ${isLoading.value}');
      print('🔍 LOCATION SEARCH DEBUG - END\n');
    }
  }

  // ALL FALLBACK CODE REMOVED - BACKEND ONLY MODE
  // The app now relies completely on the comprehensive Syrian cities backend database

  /// Load all Syrian cities from backend - Arabic only
  Future<void> loadAllCities() async {
    print('📋 LOAD ALL CITIES DEBUG - START');

    isLoadingCities.value = true;
    errorMessage.value = '';
    print('  🔄 Loading started, calling backend API...');
    print('  🎯 ARABIC-ONLY MODE: Using Arabic cities database');

    try {
      print(
        '  📡 Making API call to get all Arabic cities from database...',
      );
      final stopwatch = Stopwatch()..start();

      final cities = await LocationApiService.getAllCities();

      stopwatch.stop();
      print('  ⏱️ API call completed in ${stopwatch.elapsedMilliseconds}ms');
      print('  📊 DETAILED API Response:');
      print('    Cities count: ${cities.length}');
      print('    Cities type: ${cities.runtimeType}');

      // Backend already provides cities with their neighborhoods - use directly!
      allCities.value = cities;
      majorCities.value = cities; // Backend filters to major cities only
      
      print('🏙️ Using backend-provided cities with neighborhoods:');
      for (var city in cities) {
        print('   ${city.name}: ${city.neighbors.length} neighborhoods');
        if (city.neighbors.isNotEmpty) {
          city.neighbors.take(3).forEach((neighbor) => 
            print('     → ${neighbor.name}'));
          if (city.neighbors.length > 3) {
            print('     ... and ${city.neighbors.length - 3} more');
          }
        }
      }

      print(
        '  ✅ SUCCESS: Loaded ${allCities.length} total cities, ${majorCities.length} major cities from comprehensive backend database',
      );

      // Debug: Print sample cities with detailed info
      final sampleSize = allCities.length > 10 ? 10 : allCities.length;
      for (int i = 0; i < sampleSize; i++) {
        final city = allCities[i];
        print(
          '    🏙️ City $i: "${city.name}" (${city.latitude}, ${city.longitude})',
        );
        if (city.neighbors.isNotEmpty) {
          print(
            '      Neighbors: ${city.neighbors.map((n) => n.name).take(3).join(", ")}${city.neighbors.length > 3 ? "..." : ""}',
          );
        }
      }

      if (allCities.length > 10) {
        print('    ... and ${allCities.length - 10} more cities');
      }

      // Check for specific cities to verify comprehensive data
      final aleppoVariants = allCities
          .where((city) => city.name.toLowerCase().contains('aleppo'))
          .toList();
      print('  🔍 Aleppo variants found: ${aleppoVariants.length}');
      for (final variant in aleppoVariants) {
        print('    - ${variant.name}');
      }

      // Debug: Print major cities specifically
      print('  🏙️ Major cities found:');
      for (int i = 0; i < majorCities.length && i < 10; i++) {
        final city = majorCities[i];
        print(
          '    ${i + 1}. ${city.name} (${city.neighbors.length} neighborhoods)',
        );
      }

      if (majorCities.isEmpty) {
        print('  ⚠️ No major cities found');
        errorMessage.value = 'No major cities available from backend';
      }
    } catch (e, stackTrace) {
      print('  ❌ CRITICAL BACKEND ERROR - NO FALLBACK AVAILABLE:');
      print('    Error: $e');
      print('    Error type: ${e.runtimeType}');
      print('    Stack trace: $stackTrace');

      allCities.clear();
      majorCities.clear();
      errorMessage.value = 'Connection error: $e';
    } finally {
      isLoadingCities.value = false;
      print('  🏁 Loading completed - Final state:');
      print('    Total cities loaded: ${allCities.length}');
      print('    Major cities loaded: ${majorCities.length}');
      print('    Error message: "${errorMessage.value}"');
      print('    Is loading: ${isLoadingCities.value}');
      print('📋 LOAD ALL CITIES DEBUG - END\n');
    }
  }

  /// Alias for searchCities to maintain compatibility with location picker
  Future<void> searchLocations(String query) async {
    print('🔄 searchLocations called - redirecting to searchCities');
    await searchCities(query);
  }

  /// Get nearby cities from backend - NO FALLBACKS
  Future<void> getNearbyCities(
    double lat,
    double lng, {
    double radiusKm = 50.0,
  }) async {
    print('🗺️ GET NEARBY CITIES DEBUG - START');
    print('  Coordinates: ($lat, $lng)');
    print('  Radius: ${radiusKm}km');
    print('  🎯 BACKEND-ONLY MODE: No fallbacks will be used');

    try {
      print('  📡 Making API call to get nearby cities...');
      final stopwatch = Stopwatch()..start();

      final cities = await LocationApiService.getNearbyCities(
        latitude: lat,
        longitude: lng,
        radiusKm: radiusKm,
        limit: 20,
      );
      nearbyCities.value = cities;
      print('🏘️ Found ${cities.length} nearby cities');
    } catch (e) {
      print('🔴 Failed to get nearby cities: $e');
    }
  }

  /// Select a location for listing creation
  void selectLocation(LocationSearchResult location) {
    selectedLocation.value = location;
    latitude.value = location.lat.toString();
    longitude.value = location.lon.toString();
    address.value = location.displayName;
    print('✅ Selected location: ${location.displayName}');
  }

  /// Select a major city to view its neighbors
  void selectMajorCity(CityInfo city) {
    selectedMajorCity.value = city;
    selectedCityNeighbors.value = city.neighbors
        .map(
          (neighbor) => CityInfo(
            name: neighbor.name,
            latitude: neighbor.latitude,
            longitude: neighbor.longitude,
            neighbors:
                [], // Neighbors don't have their own neighbors in this context
          ),
        )
        .toList();
    print(
      '🏙️ Selected major city: ${city.name}, found ${city.neighbors.length} neighbors.',
    );
  }

  /// Clear the major city selection and hide neighbors
  void clearMajorCitySelection() {
    selectedMajorCity.value = null;
    selectedCityNeighbors.clear();
  }

  /// Select a city for listing creation (can be a major city or a neighbor)
  void selectCity(CityInfo city) {
    // Determine if this is a neighborhood or a major city
    String fullDisplayName;
    String cityName;
    
    if (selectedMajorCity.value != null) {
      // This is a neighborhood selection
      final majorCity = selectedMajorCity.value!;
      fullDisplayName = '${city.name}، ${majorCity.name}، سوريا';
      cityName = majorCity.name;
    } else {
      // This is a major city selection (city center)
      fullDisplayName = '${city.name}، سوريا';
      cityName = city.name;
    }
    
    final locationResult = LocationSearchResult(
      placeId: 'city_${city.name}',
      displayName: fullDisplayName,
      lat: city.latitude,
      lon: city.longitude,
      address: LocationAddress(city: cityName, country: 'Syria'),
    );
    selectLocation(locationResult);
  }

  /// Clear search results
  void clearSearch() {
    searchResults.clear();
    searchQuery.value = '';
    isSearching.value = false;
  }

  /// Reset location selection
  void resetLocation() {
    selectedLocation.value = null;
    latitude.value = '';
    longitude.value = '';
    address.value = '';
    errorMessage.value = '';
  }

  /// Get formatted location string for display
  String get formattedLocation {
    if (selectedLocation.value != null) {
      return selectedLocation.value!.displayName;
    } else if (address.value.isNotEmpty) {
      return address.value;
    } else {
      return 'No location selected';
    }
  }

  /// Check if location is selected and valid
  bool get isLocationValid {
    return selectedLocation.value != null &&
        latitude.value.isNotEmpty &&
        longitude.value.isNotEmpty;
  }
}
