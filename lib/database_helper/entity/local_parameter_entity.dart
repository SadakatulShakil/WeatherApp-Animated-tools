import 'package:floor/floor.dart';

@entity
class ParameterEntity {
  @primaryKey
  final String id;
  final String title;
  final String titleBn;

  ParameterEntity({
    required this.id,
    required this.title,
    required this.titleBn,
  });

  factory ParameterEntity.fromJson(Map<String, dynamic> json) {
    return ParameterEntity(
      id: json['id'],
      title: json['title'],
      titleBn: json['titleBn'],
    );
  }
}
