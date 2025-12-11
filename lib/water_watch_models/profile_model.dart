import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  int id;
  String mobileNumber;
  dynamic firstName;
  dynamic lastName;
  String fullName;
  dynamic address;
  dynamic profileImage;
  double lat;
  double long;
  bool isVerified;
  String fcmToken;
  DeviceInfo deviceInfo;
  DateTime createdAt;
  DateTime updatedAt;

  ProfileModel({
    required this.id,
    required this.mobileNumber,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.address,
    required this.profileImage,
    required this.lat,
    required this.long,
    required this.isVerified,
    required this.fcmToken,
    required this.deviceInfo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["id"],
    mobileNumber: json["mobile_number"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    fullName: json["full_name"],
    address: json["address"],
    profileImage: json["profile_image"],
    lat: json["lat"]?.toDouble(),
    long: json["long"]?.toDouble(),
    isVerified: json["is_verified"],
    fcmToken: json["fcm_token"],
    deviceInfo: DeviceInfo.fromJson(json["device_info"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "mobile_number": mobileNumber,
    "first_name": firstName,
    "last_name": lastName,
    "full_name": fullName,
    "address": address,
    "profile_image": profileImage,
    "lat": lat,
    "long": long,
    "is_verified": isVerified,
    "fcm_token": fcmToken,
    "device_info": deviceInfo.toJson(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
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