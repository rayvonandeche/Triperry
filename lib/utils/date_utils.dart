import 'package:intl/intl.dart';

/// Helper functions for date manipulation and formatting
class TripDateUtils {
  /// Format a date as a readable string (e.g. "April 21, 2025")
  static String formatDate(DateTime date) {
    return DateFormat.yMMMMd().format(date);
  }
  
  /// Format a date as a short string (e.g. "04/21/2025")
  static String formatShortDate(DateTime date) {
    return DateFormat.yMd().format(date);
  }
  
  /// Format a time (e.g. "3:30 PM")
  static String formatTime(DateTime date) {
    return DateFormat.jm().format(date);
  }
  
  /// Format a date and time (e.g. "April 21, 2025 at 3:30 PM")
  static String formatDateTime(DateTime date) {
    return "${DateFormat.yMMMMd().format(date)} at ${DateFormat.jm().format(date)}";
  }
  
  /// Get a relative date description (e.g. "Today", "Yesterday", "2 days ago")
  static String getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    
    final aDate = DateTime(date.year, date.month, date.day);
    
    if (aDate == today) {
      return "Today";
    } else if (aDate == yesterday) {
      return "Yesterday";
    } else if (aDate == tomorrow) {
      return "Tomorrow";
    }
    
    final difference = today.difference(aDate).inDays;
    
    if (difference > 0) {
      // In the past
      if (difference < 7) {
        return "$difference day${difference == 1 ? '' : 's'} ago";
      } else if (difference < 30) {
        final weeks = (difference / 7).floor();
        return "$weeks week${weeks == 1 ? '' : 's'} ago";
      } else {
        return formatShortDate(date);
      }
    } else {
      // In the future
      final futureDifference = difference.abs();
      if (futureDifference < 7) {
        return "In $futureDifference day${futureDifference == 1 ? '' : 's'}";
      } else if (futureDifference < 30) {
        final weeks = (futureDifference / 7).floor();
        return "In $weeks week${weeks == 1 ? '' : 's'}";
      } else {
        return formatShortDate(date);
      }
    }
  }
  
  /// Calculate duration between two dates in days
  static int calculateDurationDays(DateTime start, DateTime end) {
    return end.difference(start).inDays + 1; // Include both start and end days
  }
  
  /// Check if a date is within a range
  static bool isDateInRange(DateTime date, DateTime start, DateTime end) {
    return date.isAfter(start.subtract(const Duration(days: 1))) &&
           date.isBefore(end.add(const Duration(days: 1)));
  }
  
  /// Get a list of month names
  static List<String> getMonthNames({bool abbreviated = false}) {
    return List.generate(12, (index) {
      final month = DateTime(2022, index + 1);
      return abbreviated
        ? DateFormat.MMM().format(month)
        : DateFormat.MMMM().format(month);
    });
  }
}