import 'package:floor/floor.dart';

@entity
class LocationEntity {
  @primaryKey
  final String id;
  final String title;
  final String titleBn;
  final String subtitle;
  final String subtitleBn;

  LocationEntity({
    required this.id,
    required this.title,
    required this.titleBn,
    required this.subtitle,
    required this.subtitleBn,
  });

  factory LocationEntity.fromJson(Map<String, dynamic> json) {
    return LocationEntity(
      id: json['id'],
      title: json['title'],
      titleBn: json['titleBn'],
      subtitle: json['subtitle'],
      subtitleBn: json['subtitleBn'],
    );
  }
}
