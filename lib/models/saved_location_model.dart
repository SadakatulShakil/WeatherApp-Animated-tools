
class SavedLocation {
  final String lat;
  final String lon;
  final String id;
  final String apiName; // name returned from API (real name)
  final String displayName; // user-facing name (can be custom)
  final String upazila;
  final String district;
  final bool isCurrent;
  final String createdAt;

  SavedLocation({
    required this.lat,
    required this.lon,
    required this.id,
    required this.apiName,
    required this.displayName,
    required this.upazila,
    required this.district,
    required this.isCurrent,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'lon': lon,
    'id': id,
    'apiName': apiName,
    'displayName': displayName,
    'upazila': upazila,
    'district': district,
    'isCurrent': isCurrent,
    'createdAt': createdAt,
  };

  factory SavedLocation.fromJson(Map<String, dynamic> json) => SavedLocation(
    lat: json['lat'] ?? '',
    lon: json['lon'] ?? '',
    id: json['id']?.toString() ?? '',
    apiName: json['apiName'] ?? '',
    displayName: json['displayName'] ?? '',
    upazila: json['upazila'] ?? '',
    district: json['district'] ?? '',
    isCurrent: json['isCurrent'] == true,
    createdAt: json['createdAt'] ?? '',
  );
}