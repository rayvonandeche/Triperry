/// Helper functions for string manipulation and formatting
class StringUtils {
  /// Capitalizes the first letter of each word in a string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
  
  /// Truncates a string to a specified length with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
  
  /// Formats a price with currency symbol
  static String formatPrice(double price, {String currency = '\$', int decimals = 2}) {
    return '$currency${price.toStringAsFixed(decimals)}';
  }
  
  /// Counts the number of words in a string
  static int countWords(String text) {
    return text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }
  
  /// Removes HTML tags from a string
  static String stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }
  
  /// Checks if a string is a valid email address
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
  
  /// Extracts hashtags from a string
  static List<String> extractHashtags(String text) {
    final regex = RegExp(r'#(\w+)');
    final matches = regex.allMatches(text);
    return matches.map((match) => match.group(0) ?? '').toList();
  }
}