import 'dart:convert';

List<AssignRainfallStation> assignRainfallStationFromJson(String str) => List<AssignRainfallStation>.from(json.decode(str).map((x) => AssignRainfallStation.fromJson(x)));

String assignRainfallStationToJson(List<AssignRainfallStation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AssignRainfallStation {
  int id;
  MobileUser mobileUser;
  RainfallStation rainfallStation;
  bool isActive;
  DateTime createdAt;
  DateTime updatedAt;

  AssignRainfallStation({
    required this.id,
    required this.mobileUser,
    required this.rainfallStation,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AssignRainfallStation.fromJson(Map<String, dynamic> json) => AssignRainfallStation(
    id: json["id"],
    mobileUser: MobileUser.fromJson(json["mobile_user"]),
    rainfallStation: RainfallStation.fromJson(json["water_level_station"]),
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mobile_user": mobileUser.toJson(),
    "water_level_station": rainfallStation.toJson(),
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

class RainfallStation {
  int stationId;
  String stationCode;
  String name;
  String nameBn;
  String latitude;
  String longitude;
  String division;
  String divisionBn;
  String district;
  String districtBn;
  String upazilla;
  String upazillaBn;
  String header;
  String unit;
  bool status;

  RainfallStation({
    required this.stationId,
    required this.stationCode,
    required this.name,
    required this.nameBn,
    required this.latitude,
    required this.longitude,
    required this.division,
    required this.divisionBn,
    required this.district,
    required this.districtBn,
    required this.upazilla,
    required this.upazillaBn,
    required this.header,
    required this.unit,
    required this.status,
  });

  factory RainfallStation.fromJson(Map<String, dynamic> json) => RainfallStation(
    stationId: json["station_id"],
    stationCode: json["station_code"],
    name: json["name"],
    nameBn: json["name_bn"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    division: json["division"],
    divisionBn: json["division_bn"],
    district: json["district"],
    districtBn: json["district_bn"],
    upazilla: json["upazilla"],
    upazillaBn: json["upazilla_bn"],
    header: json["header"],
    unit: json["unit"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "station_id": stationId,
    "station_code": stationCode,
    "name": name,
    "name_bn": nameBn,
    "latitude": latitude,
    "longitude": longitude,
    "division": division,
    "division_bn": divisionBn,
    "district": district,
    "district_bn": districtBn,
    "upazilla": upazilla,
    "upazilla_bn": upazillaBn,
    "header": header,
    "unit": unit,
    "status": status,
  };
}