class LocationModel {
  final String id;
  final String title;
  final String subtitle;

  LocationModel({required this.id, required this.title, required this.subtitle});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
    );
  }
}
