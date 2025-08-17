import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const String _searchHistoryKey = 'search_history';
  static const String _searchSuggestionsKey = 'search_suggestions';
  static const int _maxHistoryItems = 20;
  static const int _maxSuggestions = 100;

  /// Save a search query to history
  static Future<void> saveSearchQuery(String query) async {
    if (query.trim().isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final history = await getSearchHistory();
    
    // Remove if already exists to avoid duplicates
    history.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
    
    // Add to beginning
    history.insert(0, query.trim());
    
    // Limit history size
    if (history.length > _maxHistoryItems) {
      history.removeRange(_maxHistoryItems, history.length);
    }
    
    await prefs.setStringList(_searchHistoryKey, history);
  }

  /// Get search history
  static Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_searchHistoryKey) ?? [];
  }

  /// Clear search history
  static Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_searchHistoryKey);
  }

  /// Remove specific item from history
  static Future<void> removeFromHistory(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getSearchHistory();
    history.removeWhere((item) => item.toLowerCase() == query.toLowerCase());
    await prefs.setStringList(_searchHistoryKey, history);
  }

  /// Save search suggestions (popular terms, brand names, etc.)
  static Future<void> saveSuggestions(List<String> suggestions) async {
    final prefs = await SharedPreferences.getInstance();
    final currentSuggestions = await getSuggestions();
    
    // Merge with existing suggestions
    final allSuggestions = <String>{...currentSuggestions, ...suggestions}.toList();
    
    // Limit suggestions
    if (allSuggestions.length > _maxSuggestions) {
      allSuggestions.removeRange(_maxSuggestions, allSuggestions.length);
    }
    
    await prefs.setStringList(_searchSuggestionsKey, allSuggestions);
  }

  /// Get search suggestions
  static Future<List<String>> getSuggestions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_searchSuggestionsKey) ?? _getDefaultSuggestions();
  }

  /// Get filtered suggestions based on query
  static Future<List<String>> getFilteredSuggestions(String query, {int limit = 5}) async {
    if (query.trim().isEmpty) return [];

    final suggestions = await getSuggestions();
    final history = await getSearchHistory();
    final queryLower = query.toLowerCase();

    final filtered = <String>[];

    // First, add matching history items
    for (final item in history) {
      if (item.toLowerCase().contains(queryLower) && filtered.length < limit) {
        filtered.add(item);
      }
    }

    // Then, add matching suggestions
    for (final suggestion in suggestions) {
      if (suggestion.toLowerCase().contains(queryLower) && 
          !filtered.any((f) => f.toLowerCase() == suggestion.toLowerCase()) &&
          filtered.length < limit) {
        filtered.add(suggestion);
      }
    }

    return filtered;
  }

  /// Get default suggestions for common search terms
  static List<String> _getDefaultSuggestions() {
    return [
      // Vehicle brands
      'Mercedes', 'BMW', 'Audi', 'Toyota', 'Honda', 'Nissan', 'Ford', 'Volkswagen',
      'Hyundai', 'Kia', 'Mazda', 'Subaru', 'Lexus', 'Infiniti', 'Acura',
      'Chevrolet', 'Dodge', 'Jeep', 'Land Rover', 'Jaguar', 'Porsche',
      
      // Vehicle types
      'Sedan', 'SUV', 'Hatchback', 'Coupe', 'Convertible',
      'Motorcycle', 'Scooter', 'Electric', 'Hybrid',
      
      // Real estate types
      'Apartment', 'Villa', 'House', 'Studio', 'Penthouse', 'Duplex',
      'Townhouse', 'Condo', 'Office', 'Shop', 'Warehouse', 'Land',
      
      // Common features
      'Automatic', 'Manual', 'Leather', 'Sunroof', 'GPS', 'Bluetooth',
      'Parking', 'Garden', 'Pool', 'Gym', 'Security', 'Furnished',
      'Balcony', 'Terrace', 'Sea view', 'City view',
      
      // Price ranges
      'Under 50000', 'Under 100000', 'Under 200000', 'Luxury',
      'Budget', 'Premium', 'New', 'Used', 'Excellent condition',
    ];
  }

  /// Initialize suggestions with default values
  static Future<void> initializeDefaultSuggestions() async {
    final currentSuggestions = await getSuggestions();
    if (currentSuggestions.isEmpty) {
      await saveSuggestions(_getDefaultSuggestions());
    }
  }
}
