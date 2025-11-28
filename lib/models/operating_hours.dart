class OperatingHours {
  final String operatingId;
  final String serviceId;
  final int operatingDays;
  final String openTime;
  final String closeTime;
  final bool isOpen;

  OperatingHours({
    required this.operatingId,
    required this.serviceId,
    required this.operatingDays,
    required this.openTime,
    required this.closeTime,
    required this.isOpen,
  });

  factory OperatingHours.fromMap(Map<String, dynamic> map) => OperatingHours(
    operatingId: map['operating_id'] as String,
    serviceId: map['service_id'] as String,
    operatingDays: map['operating_days'] as int,
    openTime: map['open_time'] as String,
    closeTime: map['close_time'] as String,
    isOpen: map['is_open'] as bool,
  );

  Map<String, dynamic> toMap() => {
    'operating_id': operatingId,
    'service_id': serviceId,
    'operating_days': operatingDays,
    'open_time': openTime,
    'close_time': closeTime,
    'is_open': isOpen,
  };

  String get formattedHours => '$openTime - $closeTime';

  // Helper method to get day name
  String get dayName {
    switch (operatingDays) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }
}
