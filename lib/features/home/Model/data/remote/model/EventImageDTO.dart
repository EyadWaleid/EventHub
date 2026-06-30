class EventImage {
  final String? ratio;
  final String url;
  final int width;
  final int height;

  EventImage({this.ratio, required this.url, required this.width, required this.height});

  factory EventImage.fromJson(Map<String, dynamic> json) {
    return EventImage(
      ratio: json['ratio'],
      url: json['url'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }
}
