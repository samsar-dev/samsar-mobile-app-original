import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samsar/controllers/features/location_controller.dart';
import 'package:samsar/models/location/city_model.dart';

class LocationPicker extends StatefulWidget {
  final Function(LocationSearchResult) onLocationSelected;
  final String? initialLocation;
  final bool showCurrentLocationButton;
  final bool showCitiesTab;

  const LocationPicker({
    Key? key,
    required this.onLocationSelected,
    this.initialLocation,
    this.showCurrentLocationButton = true,
    this.showCitiesTab = true,
  }) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final LocationController _locationController = Get.find<LocationController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.showCitiesTab ? 2 : 1,
      vsync: this,
    );
    
    if (widget.initialLocation != null) {
      _searchController.text = widget.initialLocation!;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
                Expanded(
                  child: Text(
                    'select_location'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 48), // Balance the close button
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'search_for_location'.tr,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              _locationController.clearSearch();
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      _locationController.searchLocations(value);
                    } else {
                      _locationController.clearSearch();
                    }
                  },
                ),
                
                // Current Location Button
                if (widget.showCurrentLocationButton)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Obx(() => ElevatedButton.icon(
                      onPressed: _locationController.isLoading.value
                          ? null
                          : () async {
                              await _locationController.getCurrentLocation();
                              if (_locationController.selectedLocation.value != null) {
                                widget.onLocationSelected(_locationController.selectedLocation.value!);
                                Navigator.pop(context);
                              }
                            },
                      icon: _locationController.isLoading.value
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location),
                      label: Text('use_current_location'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )),
                  ),
              ],
            ),
          ),

          // Tabs (if cities tab is enabled)
          if (widget.showCitiesTab)
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'search_results'.tr),
                Tab(text: 'cities'.tr),
              ],
            ),

          // Content
          Expanded(
            child: widget.showCitiesTab
                ? TabBarView(
                    controller: _tabController,
                    children: [
                      _buildSearchResults(),
                      _buildCitiesList(),
                    ],
                  )
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Obx(() {
      if (_locationController.isSearching.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_locationController.searchResults.isEmpty && _searchController.text.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'start_typing_to_search'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      if (_locationController.searchResults.isEmpty && _searchController.text.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'no_search_results_found'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: _locationController.searchResults.length,
        itemBuilder: (context, index) {
          final result = _locationController.searchResults[index];
          return ListTile(
            leading: const Icon(Icons.location_on, color: Colors.blue),
            title: Text(
              result.displayName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: result.address?.city != null
                ? Text('${result.address!.city}, ${result.address!.country ?? 'Syria'}')
                : null,
            onTap: () {
              widget.onLocationSelected(result);
              Navigator.pop(context);
            },
          );
        },
      );
    });
  }

  Widget _buildCitiesList() {
    return Obx(() {
      if (_locationController.isLoadingCities.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_locationController.majorCities.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_city,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'no_cities_found'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      return Obx(() {
        // If a major city is selected, show its neighbors
        if (_locationController.selectedMajorCity.value != null) {
          return _buildNeighborsList();
        }

        // Otherwise, show the list of major cities
        return ListView.builder(
          itemCount: _locationController.majorCities.length,
          itemBuilder: (context, index) {
            final city = _locationController.majorCities[index];
            return ListTile(
              leading: const Icon(Icons.location_city, color: Colors.green),
              title: Text(
                city.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                '${city.neighbors.length} ${'neighborhoods'.tr}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _locationController.selectMajorCity(city);
              },
            );
          },
        );
      });
    });
  }

  Widget _buildNeighborsList() {
    final selectedCity = _locationController.selectedMajorCity.value!;

    return Column(
      children: [
        // Header with back button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  _locationController.clearMajorCitySelection();
                },
              ),
              Expanded(
                child: Text(
                  selectedCity.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48), // Balance the back button
            ],
          ),
        ),

        // Option to select the major city itself
        ListTile(
          leading: const Icon(Icons.location_city, color: Colors.blue),
          title: Text(
            '${selectedCity.name} (${'city_center'.tr})',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          onTap: () {
            _locationController.selectCity(selectedCity);
            widget.onLocationSelected(_locationController.selectedLocation.value!);
            Navigator.pop(context); // Close location picker
          },
        ),

        const Divider(),

        // List of neighbors
        Expanded(
          child: ListView.builder(
            itemCount: _locationController.selectedCityNeighbors.length,
            itemBuilder: (context, index) {
              final neighbor = _locationController.selectedCityNeighbors[index];
              return ListTile(
                leading: const Icon(Icons.location_on, color: Colors.green),
                title: Text(neighbor.name),
                onTap: () {
                  _locationController.selectCity(neighbor);
                  widget.onLocationSelected(_locationController.selectedLocation.value!);
                  Navigator.pop(context); // Close location picker
                },
              );
            },
          ),
        ),
      ],
    );
  }

}
