/// Utility functions for formatting listing IDs for user-friendly display
class ListingIdFormatter {
  /// Converts a cuid() to a user-friendly 8-digit display ID
  /// @param cuid - The original cuid() from database
  /// @returns Formatted ID like "#12345678"
  static String formatListingIdForDisplay(String cuid) {
    // Extract numeric characters from cuid and pad to ensure 8 digits
    final numericChars = cuid.replaceAll(RegExp(r'[^0-9]'), '');

    // If we have enough digits, take first 8
    if (numericChars.length >= 8) {
      return '#${numericChars.substring(0, 8)}';
    }

    // If not enough digits, use hash of the cuid to generate consistent 8-digit number
    int hash = 0;
    for (int i = 0; i < cuid.length; i++) {
      final char = cuid.codeUnitAt(i);
      hash = ((hash << 5) - hash) + char;
      hash = hash & 0xFFFFFFFF; // Convert to 32-bit integer
    }

    // Ensure positive number and format to 8 digits
    final displayId = hash.abs().toString().padLeft(8, '0').substring(0, 8);
    return '#$displayId';
  }

  /// Extracts the display ID from a formatted listing ID
  /// @param displayId - Formatted ID like "#12345678"
  /// @returns Just the numeric part "12345678"
  static String extractDisplayId(String displayId) {
    return displayId.replaceAll('#', '');
  }

  /// Validates if a string is a valid display ID format
  /// @param displayId - String to validate
  /// @returns boolean indicating if valid
  static bool isValidDisplayId(String displayId) {
    final pattern = RegExp(r'^#\d{8}$');
    return pattern.hasMatch(displayId);
  }

  /// Gets a fallback display ID if the backend doesn't provide one
  /// This ensures backward compatibility
  static String getDisplayId(String? backendDisplayId, String originalId) {
    if (backendDisplayId != null && backendDisplayId.isNotEmpty) {
      return backendDisplayId;
    }
    return formatListingIdForDisplay(originalId);
  }
}
