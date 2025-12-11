import 'dart:convert';

List<AssignStationModel> assignStationModelFromJson(String str) => List<AssignStationModel>.from(json.decode(str).map((x) => AssignStationModel.fromJson(x)));

String assignStationModelToJson(List<AssignStationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AssignStationModel {
  int id;
  MobileUser mobileUser;
  WaterLevelStation waterLevelStation;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  AssignStationModel({
    required this.id,
    required this.mobileUser,
    required this.waterLevelStation,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AssignStationModel.fromJson(Map<String, dynamic> json) => AssignStationModel(
    id: json["id"],
    mobileUser: MobileUser.fromJson(json["mobile_user"]),
    waterLevelStation: WaterLevelStation.fromJson(json["water_level_station"]),
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mobile_user": mobileUser.toJson(),
    "water_level_station": waterLevelStation.toJson(),
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class MobileUser {
  int id;
  String mobileNumber;
  double lat;
  double long;
  String fcmToken;
  DeviceInfo deviceInfo;
  bool isVerified;

  MobileUser({
    required this.id,
    required this.mobileNumber,
    required this.lat,
    required this.long,
    required this.fcmToken,
    required this.deviceInfo,
    required this.isVerified,
  });

  factory MobileUser.fromJson(Map<String, dynamic> json) => MobileUser(
    id: json["id"],
    mobileNumber: json["mobile_number"],
    lat: json["lat"]?.toDouble(),
    long: json["long"]?.toDouble(),
    fcmToken: json["fcm_token"],
    deviceInfo: DeviceInfo.fromJson(json["device_info"]),
    isVerified: json["is_verified"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mobile_number": mobileNumber,
    "lat": lat,
    "long": long,
    "fcm_token": fcmToken,
    "device_info": deviceInfo.toJson(),
    "is_verified": isVerified,
  };
}

class DeviceInfo {
  String os;
  String model;
  String version;
  String manufacturer;

  DeviceInfo({
    required this.os,
    required this.model,
    required this.version,
    required this.manufacturer,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) => DeviceInfo(
    os: json["os"],
    model: json["model"],
    version: json["version"],
    manufacturer: json["manufacturer"],
  );

  Map<String, dynamic> toJson() => {
    "os": os,
    "model": model,
    "version": version,
    "manufacturer": manufacturer,
  };
}

class WaterLevelStation {
  int stationId;
  String stationCode;
  String name;
  String nameBn;
  int stationSerialNo;
  double dangerLevel;
  double highestWaterLevel;

  WaterLevelStation({
    required this.stationId,
    required this.stationCode,
    required this.name,
    required this.nameBn,
    required this.stationSerialNo,
    required this.dangerLevel,
    required this.highestWaterLevel,
  });

  factory WaterLevelStation.fromJson(Map<String, dynamic> json) => WaterLevelStation(
    stationId: json["station_id"],
    stationCode: json["station_code"],
    name: json["name"],
    nameBn: json["name_bn"],
    stationSerialNo: json["station_serial_no"],
    dangerLevel: json["danger_level"]?.toDouble(),
    highestWaterLevel: json["highest_water_level"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "station_id": stationId,
    "station_code": stationCode,
    "name": name,
    "name_bn": nameBn,
    "station_serial_no": stationSerialNo,
    "danger_level": dangerLevel,
    "highest_water_level": highestWaterLevel,
  };
}
