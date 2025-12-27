class ApiURL {
  // Base URLs
  static const String BASE_API_URL = 'https://api.ffwc.gov.bd';
  static const String BASE_API3_URL = 'https://api3.ffwc.gov.bd';
  static const String BASE_ASSETS_URL = 'https://ffwc.gov.bd/assets';
  static const String BASE_WWW_URL = 'https://www.ffwc.gov.bd/assets';
  static const String BAMIS_URL = "https://bamisapp.bdservers.site";
  static const String BASE_URL_WEATHER = "https://usf.bmd.gov.bd/api/app";

  /// FCM Token Update
  static const String FCM_TOKEN_UPDATE = '$BASE_API_URL/api/app_user_mobile/v1/update_location_by_fcm_token/';

  /// Standard endpoint for checking network connectivity.
  static const String CHECK_NETWORK = 'http://clients3.google.com/generate_204';

  /// Refresh Token.
  static String REFRESH_TOKEN = '${BASE_URL_WEATHER}/auth/refresh';

  // ===================================
  // Citizen Science (Add/Update/Delete)
  // ===================================

  /// Retrieves the mobile user's profile details.
  static const String USER_PROFILE_DETAILS = '$BASE_URL_WEATHER/user/info';

  /// Retrieves the Dashboard  details.
  static const String DASHBOARD_DETAILS = '$BASE_URL_WEATHER/user/module';

  /// Updates the mobile user's profile.
  static const String USER_PROFILE_UPDATE = '$BASE_URL_WEATHER/user/info';

  /// Sends a mobile OTP.
  static const String SEND_OTP = '$BASE_URL_WEATHER/auth/mobile';

  /// Verifies a mobile OTP.
  static const String VERIFY_OTP = '$BASE_URL_WEATHER/auth/otpcheck';

  // ===================================
  // BMD_Weather APIs
  // ===================================

  //static String LOCATION_LATLON = '${BASE_URL_WEATHER}/weather/location';
  static String LOCATION_LATLON = '${BASE_URL_WEATHER}/weather/forecast';

  /// Get Current Forecast
  static String CURRENT_FORECAST = '${BASE_URL_WEATHER}/weather/forecast?type=point&';

  /// Get Current Prayer Time
  static String PRAYER_TIME = '${BASE_URL_WEATHER}/weather/prayer';
  /// Get Notification List
  static String NOTIFICATION_LIST = '${BASE_URL_WEATHER}/notification/list';

}