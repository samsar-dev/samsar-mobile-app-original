import 'package:flutter/material.dart';
import '../services/vehicle_service.dart';
import '../models/vehicle/vehicle_data_model.dart';

class VehicleController extends ChangeNotifier {
  // Loading states
  bool _isLoadingMakes = false;
  bool _isLoadingModels = false;
  bool _isLoadingAllData = false;

  // Data
  List<String> _makes = [];
  List<String> _models = [];
  Map<String, List<String>> _allModels = {};
  String? _selectedMake;
  String? _selectedModel;
  VehicleSubcategory? _currentSubcategory;

  // Error states
  String? _makesError;
  String? _modelsError;

  // Getters
  bool get isLoadingMakes => _isLoadingMakes;
  bool get isLoadingModels => _isLoadingModels;
  bool get isLoadingAllData => _isLoadingAllData;
  
  List<String> get makes => _makes;
  List<String> get models => _models;
  Map<String, List<String>> get allModels => _allModels;
  
  String? get selectedMake => _selectedMake;
  String? get selectedModel => _selectedModel;
  VehicleSubcategory? get currentSubcategory => _currentSubcategory;
  
  String? get makesError => _makesError;
  String? get modelsError => _modelsError;

  bool get hasError => _makesError != null || _modelsError != null;

  /// Load makes for a specific subcategory
  Future<void> loadMakes(VehicleSubcategory subcategory) async {
    // Always clear data when switching subcategories to prevent cross-contamination
    if (_currentSubcategory != subcategory) {
      _makes.clear();
      _models.clear();
      _allModels.clear();
      _selectedMake = null;
      _selectedModel = null;
      _makesError = null;
      _modelsError = null;
    }

    if (_currentSubcategory == subcategory && _makes.isNotEmpty && !hasError) {
      return; // Already loaded for this subcategory
    }

    _isLoadingMakes = true;
    _makesError = null;
    _currentSubcategory = subcategory;
    
    notifyListeners();

    try {
      final makes = await VehicleService.getMakes(subcategory.value);
      _makes = makes;
      _makesError = null;
      
    } catch (e) {
      _makesError = 'Failed to load vehicle makes: ${e.toString()}';
    } finally {
      _isLoadingMakes = false;
      notifyListeners();
    }
  }

  /// Load models for a specific make
  Future<void> loadModels(String make) async {
    if (_currentSubcategory == null) {
      _modelsError = 'No subcategory selected';
      notifyListeners();
      return;
    }

    if (_selectedMake == make && _models.isNotEmpty && _modelsError == null) {
      return; // Already loaded for this make
    }

    _isLoadingModels = true;
    _modelsError = null;
    _selectedMake = make;
    _selectedModel = null; // Clear selected model when changing make
    
    notifyListeners();

    try {
      final models = await VehicleService.getModels(make, _currentSubcategory!.value);
      _models = models;
      _modelsError = null;
      
    } catch (e) {
      _modelsError = 'Failed to load vehicle models: ${e.toString()}';
    } finally {
      _isLoadingModels = false;
      notifyListeners();
    }
  }

  /// Load all vehicle data (makes + models) for a subcategory
  Future<void> loadAllVehicleData(VehicleSubcategory subcategory) async {
    if (_currentSubcategory == subcategory && _allModels.isNotEmpty && !hasError) {
      return; // Already loaded for this subcategory
    }

    _isLoadingAllData = true;
    _makesError = null;
    _modelsError = null;
    _currentSubcategory = subcategory;
    
    // Clear previous data
    _makes.clear();
    _models.clear();
    _allModels.clear();
    _selectedMake = null;
    _selectedModel = null;
    
    notifyListeners();

    try {
      final data = await VehicleService.getAllVehicleData(subcategory.value);
      final response = VehicleDataResponse.fromJson(data);
      
      _makes = response.makes;
      _allModels = response.models ?? {};
      _makesError = null;
      _modelsError = null;
      
    } catch (e) {
      _makesError = 'Failed to load vehicle data: ${e.toString()}';
    } finally {
      _isLoadingAllData = false;
      notifyListeners();
    }
  }

  /// Select a make and load its models
  Future<void> selectMake(String make) async {
    if (_selectedMake == make) return;

    // If we have all models cached, use them directly
    if (_allModels.containsKey(make)) {
      _selectedMake = make;
      _models = _allModels[make]!;
      _selectedModel = null;
      _modelsError = null;
      notifyListeners();
      return;
    }

    // Otherwise load from API
    await loadModels(make);
  }

  /// Select a model
  void selectModel(String model) {
    if (_selectedModel == model) return;
    
    _selectedModel = model;
    notifyListeners();
  }

  /// Clear selection
  void clearSelection() {
    _selectedMake = null;
    _selectedModel = null;
    _models.clear();
    notifyListeners();
  }

  /// Reset all data
  void reset() {
    _makes.clear();
    _models.clear();
    _allModels.clear();
    _selectedMake = null;
    _selectedModel = null;
    _currentSubcategory = null;
    _makesError = null;
    _modelsError = null;
    _isLoadingMakes = false;
    _isLoadingModels = false;
    _isLoadingAllData = false;
    notifyListeners();
  }

  /// Retry loading makes
  Future<void> retryLoadMakes() async {
    if (_currentSubcategory != null) {
      await loadMakes(_currentSubcategory!);
    }
  }

  /// Retry loading models
  Future<void> retryLoadModels() async {
    if (_selectedMake != null) {
      await loadModels(_selectedMake!);
    }
  }

  /// Clear cache and reload
  Future<void> refreshData() async {
    await VehicleService.clearCache();
    if (_currentSubcategory != null) {
      await loadMakes(_currentSubcategory!);
    }
  }

  /// Force clear all cache (for debugging)
  Future<void> forceClearCache() async {
    await VehicleService.clearCache();
    reset();
  }

  /// Get models for a specific make (useful for dropdowns)
  List<String> getModelsForMake(String make) {
    if (_allModels.containsKey(make)) {
      return _allModels[make]!;
    }
    if (_selectedMake == make) {
      return _models;
    }
    return [];
  }

  /// Check if a make has models loaded
  bool hasModelsForMake(String make) {
    return _allModels.containsKey(make) || (_selectedMake == make && _models.isNotEmpty);
  }
}
