import 'dart:convert';

List<StationHistoryModel> stationHistoryModelFromJson(String str) => List<StationHistoryModel>.from(json.decode(str).map((x) => StationHistoryModel.fromJson(x)));

String stationHistoryModelToJson(List<StationHistoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StationHistoryModel {
  int id;
  int station;
  DateTime observationDate;
  String waterLevel;
  bool isAcepted;
  DateTime createdAt;
  DateTime updatedAt;

  StationHistoryModel({
    required this.id,
    required this.station,
    required this.observationDate,
    required this.waterLevel,
    required this.isAcepted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StationHistoryModel.fromJson(Map<String, dynamic> json) => StationHistoryModel(
    id: json["id"],
    station: json["station"],
    observationDate: DateTime.parse(json["observation_date"]),
    waterLevel: json["water_level"],
    isAcepted: json["is_acepted"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "station": station,
    "observation_date": observationDate.toIso8601String(),
    "water_level": waterLevel,
    "is_acepted": isAcepted,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}