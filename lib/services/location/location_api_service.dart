import 'package:dio/dio.dart';
import 'package:samsar/constants/api_route_constants.dart';
import 'package:samsar/models/location/city_model.dart';

class LocationApiService {
  static final Dio _dio = Dio();

  /// Search for locations using backend API
  static Future<List<LocationSearchResult>> searchLocations({
    required String query,
    int limit = 5,
    String? proximity,
    String country = 'sy',
  }) async {
    try {
      final response = await _dio.get(
        searchLocationsRoute,
        queryParameters: {
          'q': query,
          'limit': limit.toString(),
          if (proximity != null) 'proximity': proximity,
          'country': country,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> results = response.data['data'] ?? [];
        return results
            .map((json) => LocationSearchResult.fromJson(json))
            .toList();
      } else {
        throw Exception(
          'Failed to search locations: ${response.data['error']?['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      throw Exception('Failed to search locations: $e');
    }
  }

  /// Reverse geocode coordinates to get address
  static Future<LocationSearchResult?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.get(
        reverseGeocodeRoute,
        queryParameters: {
          'lat': latitude.toString(),
          'lng': longitude.toString(),
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return LocationSearchResult.fromJson(response.data['data']);
      } else {
        throw Exception(
          'Failed to reverse geocode: ${response.data['error']?['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      throw Exception('Failed to reverse geocode: $e');
    }
  }

  /// Get all Syrian cities from backend (Arabic only)
  static Future<List<CityInfo>> getAllCities() async {
    try {
      final response = await _dio.get(getAllCitiesRoute);

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> cities = response.data['data'] ?? [];
        return cities.map((json) => CityInfo.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to get cities: ${response.data['error']?['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      throw Exception('Failed to get cities: $e');
    }
  }

  /// Get nearby cities based on coordinates
  static Future<List<CityInfo>> getNearbyCities({
    required double latitude,
    required double longitude,
    double radiusKm = 50.0,
    int? limit,
  }) async {
    try {
      final queryParams = {
        'lat': latitude.toString(),
        'lng': longitude.toString(),
        'radiusKm': radiusKm.toString(),
      };

      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }

      final response = await _dio.get(
        getNearbyCitiesRoute,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> cities = response.data['data']['cities'] ?? [];
        return cities.map((json) => CityInfo.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to get nearby cities: ${response.data['error']?['message'] ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      throw Exception('Failed to get nearby cities: $e');
    }
  }
}
