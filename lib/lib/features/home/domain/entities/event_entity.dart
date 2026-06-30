class EventEntity {
  final String id;
  final String name;
  final String type;
  final String url;
  final String imageUrl;
  final DateTime startDate;
  final String localTime;
  final String timezone;
  final String status;
  final String? venueName;
  final String? venueCity;
  final String? venueAddress;
  final String? attractionName;
  final String? info;

  const EventEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.url,
    required this.imageUrl,
    required this.startDate,
    required this.localTime,
    required this.timezone,
    required this.status,
    this.venueName,
    this.venueCity,
    this.venueAddress,
    this.attractionName,
    this.info,
  });

  String get location {
    if (venueName != null && venueCity != null) return '$venueName, $venueCity';
    if (venueName != null) return venueName!;
    if (venueCity != null) return venueCity!;
    return 'Location TBD';
  }

  String get formattedDate {
    const months = [
      '', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    return '${startDate.day} ${months[startDate.month]}';
  }

  /// True if the event is within the next 7 days (upcoming)
  bool get isUpcoming {
    final now = DateTime.now();
    final sevenDaysFromNow = now.add(const Duration(days: 7));
    return startDate.isAfter(now) && startDate.isBefore(sevenDaysFromNow);
  }

  /// True if the event happened within the last 7 days (latest/past)
  bool get isLatest {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    return startDate.isBefore(now) && startDate.isAfter(sevenDaysAgo);
  }
}
