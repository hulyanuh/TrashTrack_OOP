import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xFF4A5F44);
  static const secondaryColor = Color(0xFF8B9D83);
  static const backgroundColor = Colors.white;
  static const textColor = Colors.black87;
  static const subtitleColor = Colors.black54;
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}

class StringUtils {
  static String getDistanceText(double distance) {
    if (distance < 1) {
      return '${(distance * 1000).toInt()}m';
    }
    return '${distance.toStringAsFixed(1)}km';
  }
}

class DateTimeUtils {
  static String getOpeningStatus(TimeOfDay opening, TimeOfDay closing) {
    final now = TimeOfDay.now();
    final currentMinutes = now.hour * 60 + now.minute;
    final openingMinutes = opening.hour * 60 + opening.minute;
    final closingMinutes = closing.hour * 60 + closing.minute;

    if (currentMinutes >= openingMinutes && currentMinutes <= closingMinutes) {
      return 'open';
    }
    return 'closed';
  }
}
