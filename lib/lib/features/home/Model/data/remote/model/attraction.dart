class Attraction {
  final String? id;
  final String? name;
  final String? url;

  Attraction({this.id, this.name, this.url});

  factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
      id: json['id'],
      name: json['name'],
      url: json['url'],
    );
  }
}
