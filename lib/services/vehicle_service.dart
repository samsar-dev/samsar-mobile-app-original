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
            print('🚗 Loaded makes for $subcategory from cache (${cachedData.length} items)');
            return cachedData;
          }
        }
      }
      
      // Fetch from API
      print('🌐 Fetching makes for $subcategory from API...');
      final response = await http.get(
        Uri.parse('$baseUrl/makes?subcategory=$subcategory'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final makes = List<String>.from(responseData['data']['makes'] ?? []);
        
        // Cache the data
        await prefs.setStringList(cacheKey, makes);
        await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
        
        print('✅ Cached ${makes.length} makes for $subcategory');
        return makes;
      } else {
        throw Exception('Failed to load makes: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching makes for $subcategory: $e');
      
      // Try to return cached data even if expired as fallback
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getStringList(cacheKey);
      if (cachedData != null && cachedData.isNotEmpty) {
        print('🔄 Using expired cache as fallback');
        return cachedData;
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
            print('🚗 Loaded models for $make ($subcategory) from cache (${cachedData.length} items)');
            return cachedData;
          }
        }
      }
      
      // Fetch from API
      print('🌐 Fetching models for $make ($subcategory) from API...');
      final response = await http.get(
        Uri.parse('$baseUrl/models?make=$make&subcategory=$subcategory'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final models = List<String>.from(responseData['data']['models'] ?? []);
        
        // Cache the data
        await prefs.setStringList(cacheKey, models);
        await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
        
        print('✅ Cached ${models.length} models for $make ($subcategory)');
        return models;
      } else {
        throw Exception('Failed to load models: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching models for $make ($subcategory): $e');
      
      // Try to return cached data even if expired as fallback
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getStringList(cacheKey);
      if (cachedData != null && cachedData.isNotEmpty) {
        print('🔄 Using expired cache as fallback');
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
            print('🚗 Loaded all vehicle data for $subcategory from cache');
            return Map<String, dynamic>.from(cachedData);
          }
        }
      }
      
      // Fetch from API
      print('🌐 Fetching all vehicle data for $subcategory from API...');
      final response = await http.get(
        Uri.parse('$baseUrl/all?subcategory=$subcategory'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Cache the data
        await prefs.setString(cacheKey, json.encode(data));
        await prefs.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch);
        
        print('✅ Cached all vehicle data for $subcategory');
        return data;
      } else {
        throw Exception('Failed to load vehicle data: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching all vehicle data for $subcategory: $e');
      
      // Try to return cached data even if expired as fallback
      final prefs = await SharedPreferences.getInstance();
      final cachedDataString = prefs.getString(cacheKey);
      if (cachedDataString != null) {
        print('🔄 Using expired cache as fallback');
        return Map<String, dynamic>.from(json.decode(cachedDataString));
      }
      
      throw Exception('Failed to load vehicle data: $e');
    }
  }

  /// Clear all vehicle cache
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    final vehicleKeys = keys.where((key) => 
      key.startsWith(_makesPrefix) || 
      key.startsWith(_modelsPrefix) || 
      key.startsWith(_allDataPrefix)
    ).toList();
    
    for (final key in vehicleKeys) {
      await prefs.remove(key);
    }
    
    print('🗑️ Cleared vehicle cache (${vehicleKeys.length} items)');
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
    
    print('🗑️ Cleared cache for $subcategory (${subcategoryKeys.length} items)');
  }

  /// Check cache status for debugging
  static Future<Map<String, dynamic>> getCacheStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    
    final vehicleKeys = keys.where((key) => 
      key.startsWith(_makesPrefix) || 
      key.startsWith(_modelsPrefix) || 
      key.startsWith(_allDataPrefix)
    ).toList();
    
    final status = <String, dynamic>{};
    
    for (final key in vehicleKeys) {
      if (key.endsWith(_timestampSuffix)) {
        final timestamp = prefs.getInt(key);
        if (timestamp != null) {
          final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
          final age = DateTime.now().difference(cacheTime);
          final isExpired = age > cacheExpiry;
          
          status[key] = {
            'timestamp': cacheTime.toIso8601String(),
            'age_hours': age.inHours,
            'expired': isExpired,
          };
        }
      }
    }
    
    return {
      'total_keys': vehicleKeys.length,
      'cache_details': status,
    };
  }
}
