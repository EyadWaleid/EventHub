class Venue {
  final String? id;
  final String? name;
  final String? city;
  final String? state;
  final String? country;
  final String? address;

  Venue({
    this.id,
    this.name,
    this.city,
    this.state,
    this.country,
    this.address,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'],
      name: json['name'],
      city: json['city']?['name'],
      state: json['state']?['name'],
      country: json['country']?['name'],
      address: json['address']?['line1'],
    );
  }
}
