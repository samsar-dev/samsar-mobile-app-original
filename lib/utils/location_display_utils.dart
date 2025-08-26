/// Utility functions for formatting location display
class LocationDisplayUtils {
  /// Formats location for display by removing "Syria" and cleaning up formatting
  static String formatLocationForDisplay(String? location) {
    if (location == null || location.isEmpty) {
      return "Location not specified";
    }
    
    // Remove "Syria" and "سوريا" from the location string
    String formatted = location
        .replaceAll(RegExp(r'،\s*سوريا\s*$'), '') // Remove ", سوريا" at the end
        .replaceAll(RegExp(r'،\s*Syria\s*$'), '') // Remove ", Syria" at the end
        .replaceAll(RegExp(r'\s*,\s*سوريا\s*$'), '') // Remove ", سوريا" with English comma
        .replaceAll(RegExp(r'\s*,\s*Syria\s*$'), '') // Remove ", Syria" with English comma
        .trim();
    
    // If the formatted string is empty after removing Syria, return original
    if (formatted.isEmpty) {
      return location;
    }
    
    return formatted;
  }
  
  /// Formats location for saving (ensures Syria is included)
  static String formatLocationForSaving(String location) {
    // If location already contains Syria, return as is
    if (location.contains('سوريا') || location.contains('Syria')) {
      return location;
    }
    
    // Add Syria to the location
    return '$location، سوريا';
  }
}
