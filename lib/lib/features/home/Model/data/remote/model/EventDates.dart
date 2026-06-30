class EventDates {
  final String localDate;
  final String localTime;
  final String? timezone;
  final String status;

  EventDates({
    required this.localDate,
    required this.localTime,
    this.timezone,
    required this.status,
  });

  factory EventDates.fromJson(Map<String, dynamic> json) {
    return EventDates(
      localDate: json['start']?['localDate'] ?? '',
      localTime: json['start']?['localTime'] ?? '00:00:00',
      timezone: json['timezone'],
      status: json['status']?['code'] ?? 'unknown',
    );
  }
}
