import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/forecast_model.dart';
import '../models/saved_location_model.dart';
import 'api_urls.dart';

class UserPrefService {
  // Singleton instance
  static final UserPrefService _instance = UserPrefService._internal();
  factory UserPrefService() => _instance;
  UserPrefService._internal();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Keys
  static const String _keyUserToken = 'TOKEN';
  static const String _keyUserRefresh = 'REFRESH';
  static const String _keyUserId = 'ID';
  static const String _keyUserEmail = 'EMAIL';
  static const String _keyUserName = 'NAME';
  static const String _keyFirstName = 'FIRSTNAME';
  static const String _keyLastName = 'LASTNAME';
  static const String _keyUserMobile = 'MOBILE';
  static const String _keyUserAddress = 'ADDRESS';
  static const String _keyUserType = 'TYPE';
  static const String _keyUserPhoto = 'PHOTO';
  static const String _keyFcmToken = 'FCM';
  static const String _keyLat = 'LAT';
  static const String _keyLon = 'LON';
  static const String _keyLocationId = 'LOCATION_ID';
  static const String _keyLocationName = 'LOCATION_NAME';
  static const String _keyDisplayName = 'DISPLAY_NAME';
  static const String _keyLocationUpazila = 'LOCATION_UPAZILA';
  static const String _keyLocationDistrict = 'LOCATION_DISTRICT';
  static const String _keyAppLanguage = 'APP_LANGUAGE';
  static const String _updatedDate = 'CONTENT_UPDATE';

  static const String _keySavedLocations = 'SAVED_LOCATIONS';

  // ===== Utility =====
  Future<void> _setStringIfChanged(String key, String value) async {
    if (_prefs?.getString(key) != value) {
      await _prefs?.setString(key, value);
    }
  }

  // << ADDED: set StringList only if changed
  Future<void> _setStringListIfChanged(String key, List<String> value) async {
    final old = _prefs?.getStringList(key);
    final areEqual = old != null && old.length == value.length && listEquals(old, value);
    if (!areEqual) {
      await _prefs?.setStringList(key, value);
    }
  }

  // check list equality
  bool listEquals(List<String>? a, List<String>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  // ===== Token =====
  String? get userToken => _prefs?.getString(_keyUserToken);
  String? get refreshToken => _prefs?.getString(_keyUserRefresh);

  Future<bool> refreshAccessToken() async {
    final refreshTokenValue = refreshToken;
    if (refreshTokenValue == null) return false;

    try {
      var params = jsonEncode({"refresh": refreshTokenValue, "device": "api"});
      var response = await http.post(Uri.parse(ApiURL.REFRESH_TOKEN),
          headers: {"Content-Type": "application/json"}, body: params);

      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        await _setStringIfChanged(_keyUserToken, decode['result']['token']);
        await _setStringIfChanged(
            _keyUserRefresh, decode['result']['token'] ?? refreshTokenValue);
        return true;
      } else {
        await clearUserData();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // ===== User Data =====
  Future<void> saveUserData(
      String token,
      String refresh,
      String id,
      String name,
      String email,
      String mobile,
      String address,
      String type,
      String photo
      ) async {
    await _prefs?.setString(_keyUserToken, token);
    await _prefs?.setString(_keyUserRefresh, refresh);
    await _prefs?.setString(_keyUserId, id);
    await _prefs?.setString(_keyUserName, name);
    await _prefs?.setString(_keyUserEmail, email);
    await _prefs?.setString(_keyUserMobile, mobile);
    await _prefs?.setString(_keyUserAddress, address);
    await _prefs?.setString(_keyUserType, type);
    await _prefs?.setString(_keyUserPhoto, photo);
  }

  // ===== Profile Data =====
  Future<void> saveProfileData(
      String fullName,
      String email,
      String mobile,
      String address,
      String lat,
      String lon,
      String status,
      String photo
      ) async {
    await _prefs?.setString(_keyUserName, fullName);
    await _prefs?.setString(_keyUserEmail, email);
    await _prefs?.setString(_keyUserMobile, mobile);
    await _prefs?.setString(_keyUserAddress, address);
    await _prefs?.setString(_keyLat, lat);
    await _prefs?.setString(_keyLon, lon);
    await _prefs?.setString(_keyUserType, status);
    await _prefs?.setString(_keyUserPhoto, photo);
  }

  Future<void> updateUserData(
      String name,
      String email,
      String address,
      String type,
      ) async {
    await _prefs?.setString(_keyUserName, name);
    await _prefs?.setString(_keyUserEmail, email);
    await _prefs?.setString(_keyUserAddress, address);
    await _prefs?.setString(_keyUserType, type);
  }

  Future<void> updateUserPhoto(String url) async {
    await _setStringIfChanged(_keyUserPhoto, url);
  }

  // ===== Location =====
  Future<void> saveLatLonData(String lat, String lon) async {
    await _setStringIfChanged(_keyLat, lat);
    await _setStringIfChanged(_keyLon, lon);
  }


  //add/update saved-locations list
  Future<void> _addOrUpdateSavedLocation(SavedLocation loc) async {
    final raw = _prefs?.getStringList(_keySavedLocations) ?? [];
    final list = raw.map((e) {
      try {
        return SavedLocation.fromJson(jsonDecode(e) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }).whereType<SavedLocation>().toList();

    // If saving as current, unset other isCurrent
    if (loc.isCurrent) {
      for (int i = 0; i < list.length; i++) {
        final item = list[i];
        if (item.isCurrent) {
          list[i] = SavedLocation(
            lat: item.lat,
            lon: item.lon,
            id: item.id,
            apiName: item.apiName,
            displayName: item.displayName,
            upazila: item.upazila,
            district: item.district,
            isCurrent: false,
            createdAt: item.createdAt,
          );
        }
      }
    }

    // Try update by displayName
    final idx = list.indexWhere((l) => l.displayName == loc.displayName);
    if (idx >= 0) {
      list[idx] = loc;
    } else {
      list.add(loc);
    }

    final serialized = list.map((e) => jsonEncode(e.toJson())).toList();
    await _setStringListIfChanged(_keySavedLocations, serialized);
  }

  // save custom location
  Future<void> saveCustomLocation({
    required String lat,
    required String lon,
    required String apiId,
    required String apiName,
    required String displayName,
    required String upazila,
    required String district,
    bool setAsCurrent = false,
  }) async {
    final now = DateTime.now().toIso8601String();
    final loc = SavedLocation(
      lat: lat,
      lon: lon,
      id: apiId,
      apiName: apiName,
      displayName: displayName,
      upazila: upazila,
      district: district,
      isCurrent: setAsCurrent,
      createdAt: now,
    );
    await _addOrUpdateSavedLocation(loc);

    if (setAsCurrent) {
      await _prefs?.setString(_keyLat, lat);
      await _prefs?.setString(_keyLon, lon);
      await _prefs?.setString(_keyLocationId, apiId);
      await _prefs?.setString(_keyLocationName, apiName);
      await _prefs?.setString(_keyDisplayName, displayName);
      await _prefs?.setString(_keyLocationUpazila, upazila);
      await _prefs?.setString(_keyLocationDistrict, district);
    }
  }

  // get saved locations
  Future<List<SavedLocation>> getSavedLocations() async {
    final raw = _prefs?.getStringList(_keySavedLocations) ?? [];
    final list = raw.map((e) {
      try {
        return SavedLocation.fromJson(jsonDecode(e) as Map<String, dynamic>);
      } catch (_) {
        return null;
      }
    }).whereType<SavedLocation>().toList();

    // current first, then by createdAt desc
    list.sort((a, b) {
      if (a.isCurrent && !b.isCurrent) return -1;
      if (!a.isCurrent && b.isCurrent) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });

    return list;
  }

  // delete saved location by displayName (or change to id)
  Future<void> deleteSavedLocation(String displayName) async {
    final raw = _prefs?.getStringList(_keySavedLocations) ?? [];
    final filtered = raw.where((e) {
      try {
        final m = jsonDecode(e) as Map<String, dynamic>;
        return (m['displayName'] as String) != displayName;
      } catch (_) {
        return true;
      }
    }).toList();
    await _setStringListIfChanged(_keySavedLocations, filtered);
  }

  // set a saved location as current by displayName
  Future<bool> setCurrentLocationByName(String displayName) async {
    final locations = await getSavedLocations();
    final match = locations.firstWhere((l) => l.displayName == displayName, orElse: () => SavedLocation(
      lat: '',
      lon: '',
      id: '',
      apiName: '',
      displayName: '',
      upazila: '',
      district: '',
      isCurrent: false,
      createdAt: '',
    ));

    // mark match as current and update list
    final newMatch = SavedLocation(
      lat: match.lat,
      lon: match.lon,
      id: match.id,
      apiName: match.apiName,
      displayName: match.displayName,
      upazila: match.upazila,
      district: match.district,
      isCurrent: true,
      createdAt: match.createdAt,
    );

    await _addOrUpdateSavedLocation(newMatch);

    // update single keys used in other parts of your app
    await _prefs?.setString(_keyLat, newMatch.lat);
    await _prefs?.setString(_keyLon, newMatch.lon);
    await _prefs?.setString(_keyLocationId, newMatch.id);
    await _prefs?.setString(_keyLocationName, newMatch.apiName);
    await _prefs?.setString(_keyDisplayName, newMatch.displayName);
    await _prefs?.setString(_keyLocationUpazila, newMatch.upazila);
    await _prefs?.setString(_keyLocationDistrict, newMatch.district);

    return true;
  }

  // helper to fetch location details from your API by lat/lon
  // Returns SavedLocation (apiName used as apiName) or null on failure
  Future<SavedLocation?> fetchLocationDetailsFromApi({
    required double lat,
    required double lon,
    String displayNameFallback = '',
    bool setAsCurrent = false,
  }) async {
    try {
      final resp = await http.get(
        Uri.parse("${ApiURL.LOCATION_LATLON}?type=point&lat=$lat&lon=$lon"),
        headers: {'Accept-Language': 'bn'}, // or Get.locale?.languageCode if Get is available in this file
      );

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final forecast = WeatherForecastModel.fromJson(data);
        final apiName = forecast.result?.location?.locationName ?? 'Unknown';
        final displayName = displayNameFallback.isNotEmpty ? displayNameFallback : apiName;

        final sl = SavedLocation(
          lat: lat.toStringAsFixed(5),
          lon: lon.toStringAsFixed(5),
          id: forecast.result?.location?.id ?? 'Unknown',
          apiName: apiName,
          displayName: displayName,
          upazila: forecast.result?.location?.upazilaBn ?? 'Unknown',
          district: forecast.result?.location?.districtBn ?? 'Unknown',
          isCurrent: setAsCurrent,
          createdAt: DateTime.now().toIso8601String(),
        );
        return sl;

      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Update your existing saveLocationData to also add/update saved-locations list
  Future<void> saveLocationData(
      String lat,
      String lon,
      String locationId,
      String locationName,
      String locationUpazila,
      String locationDistrict,
      ) async {
    await _prefs?.setString(_keyLat, lat);
    await _prefs?.setString(_keyLon, lon);
    await _prefs?.setString(_keyLocationId, locationId);
    await _prefs?.setString(_keyLocationName, locationName);
    await _prefs?.setString(_keyLocationUpazila, locationUpazila);
    await _prefs?.setString(_keyLocationDistrict, locationDistrict);

    // store/update "Current Location" into saved-locations list
    final now = DateTime.now().toIso8601String();
    final sl = SavedLocation(
      lat: lat,
      lon: lon,
      id: locationId,
      apiName: locationName,
      displayName: "Current Location", // keep your app's existing label
      upazila: locationUpazila,
      district: locationDistrict,
      isCurrent: true,
      createdAt: now,
    );
    await _addOrUpdateSavedLocation(sl);
  }

  // ===== Firebase =====
  Future<void> saveFireBaseData(String fcmToken) async {
    await _setStringIfChanged(_keyFcmToken, fcmToken);
  }

  // ===== App Language & Content =====
  Future<void> saveAppLanguage(String languageCode) async {
    await _setStringIfChanged(_keyAppLanguage, languageCode);
  }

  String get appLanguage => _prefs?.getString(_keyAppLanguage) ?? 'bn';

  Future<void> saveContentUpdateDate(String date) async {
    await _setStringIfChanged(_updatedDate, date);
  }

  String? get contentUpdateDate => _prefs?.getString(_updatedDate);

  // ===== Getters =====
  String? get userId => _prefs?.getString(_keyUserId);
  String? get userName => _prefs?.getString(_keyUserName);
  String? get firstName => _prefs?.getString(_keyFirstName);
  String? get lastName => _prefs?.getString(_keyLastName);
  String? get userEmail => _prefs?.getString(_keyUserEmail);
  String? get userMobile => _prefs?.getString(_keyUserMobile);
  String? get userAddress => _prefs?.getString(_keyUserAddress);
  String? get userType => _prefs?.getString(_keyUserType);
  String? get userPhoto => _prefs?.getString(_keyUserPhoto);
  String? get fcmToken => _prefs?.getString(_keyFcmToken);
  String? get lat => _prefs?.getString(_keyLat);
  String? get lon => _prefs?.getString(_keyLon);
  String? get locationId => _prefs?.getString(_keyLocationId);
  String? get locationName => _prefs?.getString(_keyLocationName);
  String? get displayName => _prefs?.getString(_keyDisplayName);
  String? get locationUpazila => _prefs?.getString(_keyLocationUpazila);
  String? get locationDistrict => _prefs?.getString(_keyLocationDistrict);

  // ===== Clear Data =====
  Future<void> clearUserData() async {
    final keys = [
      _keyUserToken,
      _keyUserRefresh,
      _keyUserId,
      _keyUserName,
      _keyUserEmail,
      _keyUserMobile,
      _keyUserAddress,
      _keyUserType,
      _keyUserPhoto,
    ];
    for (var key in keys) {
      await _prefs?.remove(key);
    }
  }
}
