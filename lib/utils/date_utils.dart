import 'package:get/get.dart';

class SmartDateUtils {
  /// Converts a DateTime to a user-friendly relative time string
  static String getSmartDateDisplay(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    // Less than 1 minute
    if (difference.inMinutes < 1) {
      return 'just_now'.tr;
    }
    
    // Less than 1 hour
    if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return minutes == 1 ? 'minute_ago'.tr : 'minutes_ago'.trParams({'minutes': minutes.toString()});
    }
    
    // Less than 12 hours
    if (difference.inHours < 12) {
      final hours = difference.inHours;
      return hours == 1 ? 'hour_ago'.tr : 'hours_ago'.trParams({'hours': hours.toString()});
    }
    
    // Same day (12+ hours ago but still today)
    if (_isSameDay(dateTime, now)) {
      return 'today'.tr;
    }
    
    // Yesterday
    final yesterday = now.subtract(Duration(days: 1));
    if (_isSameDay(dateTime, yesterday)) {
      return 'yesterday'.tr;
    }
    
    // Less than 7 days
    if (difference.inDays < 7) {
      final days = difference.inDays;
      return 'days_ago'.trParams({'days': days.toString()});
    }
    
    // More than a year - show actual date
    return '${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
  }
  
  /// Helper method to check if two dates are on the same day
  static bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && 
           date1.month == date2.month && 
           date1.day == date2.day;
  }
  
  /// Helper method to get month name
  static String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }
  
  /// Converts a DateTime string to a user-friendly relative time string
  static String getSmartDateDisplayFromString(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Unknown';
    
    try {
      final dateTime = DateTime.parse(dateString);
      return getSmartDateDisplay(dateTime);
    } catch (e) {
      print('Error parsing date string: $dateString');
      return 'Unknown';
    }
  }
}
