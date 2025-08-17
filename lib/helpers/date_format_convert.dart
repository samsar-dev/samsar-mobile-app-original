String formatDateToDMY(String isoDate) {
  try {
    final dateTime = DateTime.parse(isoDate);
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    return "$day-$month-$year";
  } catch (e) {
    return "Invalid date";
  }
}
