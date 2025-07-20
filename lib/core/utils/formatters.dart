import 'package:intl/intl.dart';

/// Utility class for formatting various data types
class AppFormatters {
  // Date formatters
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  static final DateFormat _displayDateFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _displayDateTimeFormat = DateFormat('MMM dd, yyyy HH:mm');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _monthYearFormat = DateFormat('MMM yyyy');

  // Number formatters
  static final NumberFormat _currencyFormat = NumberFormat.currency(symbol: '\$');
  static final NumberFormat _decimalFormat = NumberFormat('#,##0.00');
  static final NumberFormat _percentFormat = NumberFormat.percentPattern();
  static final NumberFormat _compactFormat = NumberFormat.compact();

  /// Format date to API format (yyyy-MM-dd)
  static String formatDateForApi(DateTime date) {
    return _dateFormat.format(date);
  }

  /// Format datetime to API format (yyyy-MM-dd HH:mm:ss)
  static String formatDateTimeForApi(DateTime dateTime) {
    return _dateTimeFormat.format(dateTime);
  }

  /// Format date for display (MMM dd, yyyy)
  static String formatDateForDisplay(DateTime date) {
    return _displayDateFormat.format(date);
  }

  /// Format datetime for display (MMM dd, yyyy HH:mm)
  static String formatDateTimeForDisplay(DateTime dateTime) {
    return _displayDateTimeFormat.format(dateTime);
  }

  /// Format time only (HH:mm)
  static String formatTime(DateTime dateTime) {
    return _timeFormat.format(dateTime);
  }

  /// Format month and year (MMM yyyy)
  static String formatMonthYear(DateTime date) {
    return _monthYearFormat.format(date);
  }

  /// Format relative time (e.g., "2 hours ago", "Yesterday")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return 'Yesterday';
      } else {
        return '${difference.inDays} days ago';
      }
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 ? '1 hour ago' : '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 ? '1 minute ago' : '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  /// Format currency
  static String formatCurrency(double amount, {String? symbol}) {
    if (symbol != null) {
      final customFormat = NumberFormat.currency(symbol: symbol);
      return customFormat.format(amount);
    }
    return _currencyFormat.format(amount);
  }

  /// Format decimal number
  static String formatDecimal(double number) {
    return _decimalFormat.format(number);
  }

  /// Format percentage
  static String formatPercentage(double value) {
    return _percentFormat.format(value);
  }

  /// Format number in compact form (e.g., 1.2K, 3.4M)
  static String formatCompactNumber(num number) {
    return _compactFormat.format(number);
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (bytes.bitLength - 1) ~/ 10;
    
    if (i >= suffixes.length) {
      return '${(bytes / (1 << (suffixes.length - 1) * 10)).toStringAsFixed(1)} ${suffixes.last}';
    }
    
    return '${(bytes / (1 << i * 10)).toStringAsFixed(1)} ${suffixes[i]}';
  }

  /// Format phone number
  static String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    final digits = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digits.length == 10) {
      // US format: (123) 456-7890
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    } else if (digits.length == 11 && digits.startsWith('1')) {
      // US format with country code: +1 (123) 456-7890
      return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
    }
    
    // Return original if format is not recognized
    return phoneNumber;
  }

  /// Capitalize first letter of each word
  static String capitalizeWords(String text) {
    return text.split(' ')
        .map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  /// Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Format initials from name
  static String formatInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    } else {
      return '${parts[0].substring(0, 1)}${parts[parts.length - 1].substring(0, 1)}'.toUpperCase();
    }
  }

  /// Format credit card number
  static String formatCreditCard(String cardNumber) {
    final digits = cardNumber.replaceAll(RegExp(r'[^\d]'), '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(digits[i]);
    }
    
    return buffer.toString();
  }

  /// Mask sensitive data (e.g., email, phone)
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    
    final username = parts[0];
    final domain = parts[1];
    
    if (username.length <= 2) return email;
    
    final maskedUsername = '${username.substring(0, 2)}${'*' * (username.length - 2)}';
    return '$maskedUsername@$domain';
  }

  /// Mask phone number
  static String maskPhoneNumber(String phoneNumber) {
    final digits = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digits.length < 4) return phoneNumber;
    
    final lastFour = digits.substring(digits.length - 4);
    final masked = '*' * (digits.length - 4);
    
    return formatPhoneNumber('$masked$lastFour');
  }

  /// Parse date from string
  static DateTime? parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Parse display date
  static DateTime? parseDisplayDate(String dateString) {
    try {
      return _displayDateFormat.parse(dateString);
    } catch (e) {
      return null;
    }
  }
}