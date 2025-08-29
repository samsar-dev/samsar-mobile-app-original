import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VehicleService {
  static const String baseUrl = 'https://samsar-backend-production.up.railway.app/api/vehicles';
  static const Duration cacheExpiry = Duration(hours: 24);
  
  // Cache keys
  static const String _makesPrefix = 'vehicle_makes_';
  static const String _modelsPrefix = 'vehicle_models_';
  static const String _allDataPrefix = 'vehicle_all_';
  static const String _timestampSuffix = '_timestamp';

  /// Get vehicle makes for a specific subcategory with caching
  static Future<List<String>> getMakes(String subcategory) async {
    final cacheKey = '$_makesPrefix$subcategory';
    final timestampKey = '$cacheKey$_timestampSuffix';
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if cached data exists and is still valid
      final cachedTimestamp = prefs.getInt(timestampKey);
      if (cachedTimestamp != null) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(cachedTimestamp);
        final isExpired = DateTime.now().difference(cacheTime) > cacheExpiry;
        
        if (!isExpired) {
          final cachedData = prefs.getStringList(cacheKey);
          if (cachedData != null && cachedData.isNotEmpty) {
            return cachedData;
          }
        }
      }
      
      // Fetch from API
      final response = await http.get(
        Uri.parse('$baseUrl/makes?subcategory=$subcategory'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        // Check if response body is empty
        if (response.body.isEmpty) {
          throw Exception('Backend returned empty response - will use fallback makes');
        }
        
        final responseData = json.decode(response.body);
        final makes = List<String>.from(responseData['data']['makes'] ?? []);
        
        // Cache the data
        await prefs.setStringList(cacheKey, makes);
        await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
        
        return makes;
      } else {
        throw Exception('Failed to load makes: ${response.statusCode}');
      }
    } catch (e) {
      // Try to return cached data even if expired as fallback
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getStringList(cacheKey);
      if (cachedData != null && cachedData.isNotEmpty) {
        return cachedData;
      }
      
      // If no cache available, provide basic fallback makes for common subcategories
      final fallbackMakes = _getFallbackMakes(subcategory);
      if (fallbackMakes.isNotEmpty) {
        // Cache the fallback data temporarily
        await prefs.setStringList(cacheKey, fallbackMakes);
        await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
        return fallbackMakes;
      }
      
      throw Exception('Failed to load vehicle makes: $e');
    }
  }

  /// Get vehicle models for a specific make and subcategory with caching
  static Future<List<String>> getModels(String make, String subcategory) async {
    final cacheKey = '${_modelsPrefix}${subcategory}_$make';
    final timestampKey = '$cacheKey$_timestampSuffix';
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if cached data exists and is still valid
      final cachedTimestamp = prefs.getInt(timestampKey);
      if (cachedTimestamp != null) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(cachedTimestamp);
        final isExpired = DateTime.now().difference(cacheTime) > cacheExpiry;
        
        if (!isExpired) {
          final cachedData = prefs.getStringList(cacheKey);
          if (cachedData != null && cachedData.isNotEmpty) {
            return cachedData;
          }
        }
      }
      
      // Fetch from API
      final response = await http.get(
        Uri.parse('$baseUrl/models?make=$make&subcategory=$subcategory'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        // Check if response body is empty
        if (response.body.isEmpty) {
          throw Exception('Backend returned empty response - will use fallback models');
        }
        
        final responseData = json.decode(response.body);
        final models = List<String>.from(responseData['data']['models'] ?? []);
        
        // Cache the data
        await prefs.setStringList(cacheKey, models);
        await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
        
        return models;
      } else {
        throw Exception('Failed to load models: ${response.statusCode}');
      }
    } catch (e) {
      // Try to return cached data even if expired as fallback
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getStringList(cacheKey);
      if (cachedData != null && cachedData.isNotEmpty) {
        return cachedData;
      }
      
      throw Exception('Failed to load vehicle models: $e');
    }
  }

  /// Get all vehicle data (makes + models) for a subcategory with caching
  static Future<Map<String, dynamic>> getAllVehicleData(String subcategory) async {
    final cacheKey = '$_allDataPrefix$subcategory';
    final timestampKey = '$cacheKey$_timestampSuffix';
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check if cached data exists and is still valid
      final cachedTimestamp = prefs.getInt(timestampKey);
      if (cachedTimestamp != null) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(cachedTimestamp);
        final isExpired = DateTime.now().difference(cacheTime) > cacheExpiry;
        
        if (!isExpired) {
          final cachedDataString = prefs.getString(cacheKey);
          if (cachedDataString != null) {
            final cachedData = json.decode(cachedDataString);
            return Map<String, dynamic>.from(cachedData);
          }
        }
      }
      
      // Fetch from API
      final response = await http.get(
        Uri.parse('$baseUrl/all?subcategory=$subcategory'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Cache the data
        await prefs.setString(cacheKey, json.encode(data));
        await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
        
        return data;
      } else {
        throw Exception('Failed to load vehicle data: ${response.statusCode}');
      }
    } catch (e) {
      
      // Try to return cached data even if expired as fallback
      final prefs = await SharedPreferences.getInstance();
      final cachedDataString = prefs.getString(cacheKey);
      if (cachedDataString != null) {
        return Map<String, dynamic>.from(json.decode(cachedDataString));
      }
      
      throw Exception('Failed to load vehicle data: $e');
    }
  }

  /// Clear all cached vehicle data
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => 
      key.startsWith(_makesPrefix) || key.startsWith(_modelsPrefix)
    ).toList();
    
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  /// Get fallback vehicle makes when API is unavailable
  static List<String> _getFallbackMakes(String subcategory) {
    switch (subcategory.toUpperCase()) {
      case 'CARS':
        return [
          'Toyota', 'Honda', 'Nissan', 'Hyundai', 'Kia', 'Mazda', 'Mitsubishi',
          'BMW', 'Mercedes-Benz', 'Audi', 'Volkswagen', 'Peugeot', 'Renault',
          'Ford', 'Chevrolet', 'Opel', 'Fiat', 'Skoda', 'Citroen', 'Volvo',
          'Suzuki', 'Subaru', 'Lexus', 'Infiniti', 'Acura', 'Genesis',
          'Chery', 'Geely', 'BYD', 'Great Wall', 'JAC', 'MG', 'Others'
        ];
      case 'CONSTRUCTION_VEHICLES':
        return [
          'Caterpillar', 'Komatsu', 'Volvo', 'JCB', 'Case', 'Liebherr',
          'Hitachi', 'Doosan', 'Hyundai', 'XCMG', 'Sany', 'Zoomlion',
          'LiuGong', 'New Holland', 'Bobcat', 'Takeuchi', 'Kubota',
          'John Deere', 'Terex', 'Atlas', 'Manitou', 'Others'
        ];
      case 'PASSENGER_VEHICLES':
        return [
          'Toyota', 'Honda', 'Nissan', 'Hyundai', 'Kia', 'Mazda',
          'Mitsubishi', 'Suzuki', 'Isuzu', 'Ford', 'Chevrolet',
          'Mercedes-Benz', 'BMW', 'Volkswagen', 'Peugeot', 'Renault',
          'Fiat', 'Iveco', 'MAN', 'Volvo', 'Scania', 'Others'
        ];
      default:
        return [];
    }
  }

  /// Clear cache for specific subcategory
  static Future<void> clearCacheForSubcategory(String subcategory) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    final subcategoryKeys = keys.where((key) => 
      key.contains(subcategory)
    ).toList();
    
    for (final key in subcategoryKeys) {
      await prefs.remove(key);
    }
  }
}
