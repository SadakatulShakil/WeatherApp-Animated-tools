class ApiURL {
  // Base URLs
  static const String BASE_API_URL = 'https://api.ffwc.gov.bd';
  static const String BASE_API3_URL = 'https://api3.ffwc.gov.bd';
  static const String BASE_ASSETS_URL = 'https://ffwc.gov.bd/assets';
  static const String BASE_WWW_URL = 'https://www.ffwc.gov.bd/assets';
  static const String BAMIS_URL = "https://bamisapp.bdservers.site";
  static const String BASE_URL_WEATHER = "https://usf.bmd.gov.bd/api/app";

  // ===================================
  // FFWC APP
  // ===================================

  /// Retrieves the last update date.
  static const String UPDATE_DATE = '$BASE_API_URL/data_load/update-date/';

  /// Retrieves station data for mobile applications (v2-mobile-stations-2025).
  static const String STATION_DATA = '$BASE_API3_URL/data_load/v2-mobile-stations-2025/';

  /// Retrieves the forecast trend/flood summary.
  static const String FORECAST_TREND = '$BASE_API_URL/data_load/flood-summary/';

  /// Retrieves scroller messages.
  static const String SCROLLER_MESSAGES = '$BASE_API_URL/data_load/scroller-messages/';

  /// FCM Token Update
  static const String FCM_TOKEN_UPDATE = '$BASE_API_URL/api/app_user_mobile/v1/update_location_by_fcm_token/';

  /// Profile/Settings.
  static const String PROFILE = '$BAMIS_URL/api/profile';

  /// Retrieves current district flood alerts. Requires a \$currentDate parameter.
  static const String CURRENT_FLOOD_ALERT = '$BASE_API_URL/data_load/district-flood-alerts-observed-forecast-by-observed-dates/';

  /// GeoJSON file for district boundaries (bd_adm2.json).
  static const String DISTRICT_GEO_JSON = '$BASE_ASSETS_URL/geojson/bd_adm2.json';

  /// Retrieves a list of bulletin PDFs.
  static const String BULLETIN_PDF_LIST = '$BASE_API3_URL/data_load/bulletins_pdf_manues/';

  /// Retrieves the Tiff file for rainfall distribution (IDW). Requires a \$date parameter.
  static const String RAINFALL_MAP_TIFF = '$BASE_API_URL/assets/tiffOutput/rainfall_distribution_idw_';

  /// Retrieves current observed rainfall data by date. Requires a \$date parameter.
  static const String CURRENT_OBSERVED_RAINFALL = '$BASE_API_URL/data_load/observed-rainfall-by-date/';

  /// GeoJSON for the BD coastline.
  static const String BD_COASTLINE_GEO_JSON = '$BASE_ASSETS_URL/geojson/adm0_bd_no_coast_line.json';

  /// Retrieves the list of professionals.
  static const String PROFESSIONAL_LIST = '$BASE_API3_URL/api/app_mobile_static_data/professionals_list/';

  /// Retrieves the list of useful links.
  static const String USEFUL_LINK_LIST = '$BASE_API3_URL/api/app_mobile_static_data/useful_link_list/';

  /// Retrieves the list of user manuals.
  static const String USER_MANUAL_LIST = '$BASE_API3_URL/api/app_mobile_static_data/user_manual_list/';

  /// Retrieves the list of report links.
  static const String REPORTS_LINK = '$BASE_API3_URL/api/app_mobile_static_data/reports_links/';

  /// Retrieves the flood information PDF.
  static const String FLOOD_INFO_PDF = '$BASE_API_URL/assets/uploads/fsumm.pdf';

  /// Standard endpoint for checking network connectivity.
  static const String CHECK_NETWORK = 'http://clients3.google.com/generate_204';

  /// Retrieves three days of observed rainfall information.
  static const String OBSERVED_RAINFALL_INFO = '$BASE_API_URL/data_load/three-days-observed-rainfall/';
  static const String RAINFALL_INFO_LIST = '$BASE_API_URL/data_load/observed-rainfall-by-date/';

  /// Retrieves observed rainfall station data.
  static const String OBSERVED_RAINFALL_STATION = '$BASE_API_URL/data_load/observed-rainfall/';

  /// GeoJSON for BD boundary (re-use).
  static const String BD_BOUNDARY_GEO_JSON = '$BASE_WWW_URL/geojson/adm0_bd_no_coast_line.json';

  /// GeoJSON for river attributes.
  static const String RIVER_GEO_JSON = '$BASE_ASSETS_URL/geojson/river_attriub.json';

  /// Retrieves five days of water level forecast data.
  static const String WATER_LEVEL_FORECAST = '$BASE_API_URL/data_load/seven-days-forecast-waterlevel-by-station/';

  /// Retrieves three days of observed water level data.
  static const String WATER_LEVEL_OBSERVED = '$BASE_API_URL/data_load/seven-days-observed-waterlevel-by-station/';

  // ===================================
  // Water Watch (Add/Update/Delete)
  // ===================================

  /// Creates a bulk record for rainfall level.
  static const String RAINFALL_RECORD_CREATE = '$BASE_API3_URL/api/app_water_watch_mobile/rflevel/bulk-create/';

  /// Creates a bulk record for water level.
  static const String WATER_LEVEL_RECORD_CREATE = '$BASE_API3_URL/api/app_water_watch_mobile/waterlevel/bulk-create/';

  /// Updates a rainfall record. Requires a \$id parameter.
  static const String RAINFALL_RECORD_UPDATE_BASE = '$BASE_API3_URL/api/app_water_watch_mobile/rflevel/';

  /// Updates a water level record. Requires a \$id parameter.
  static const String WATER_LEVEL_RECORD_UPDATE_BASE = '$BASE_API3_URL/api/app_water_watch_mobile/waterlevel/';

  /// Retrieves the mobile user's profile details.
  static const String USER_PROFILE_DETAILS = '$BASE_API3_URL/api/app_user_mobile/mobile_user_profile_details/';

  /// Updates the mobile user's profile.
  static const String USER_PROFILE_UPDATE = '$BASE_API3_URL/api/app_user_mobile/mobile_user_profile_update/';

  /// Retrieves water level stations linked to the logged-in user.
  static const String LOGGEDIN_WATER_LEVEL_STATION = '$BASE_API3_URL/api/app_water_watch_mobile/waterlevel/loggedin-user-stations/';

  /// Retrieves rainfall stations linked to the logged-in user.
  static const String LOGGEDIN_RAINFALL_STATION = '$BASE_API3_URL/api/app_water_watch_mobile/rflevel/loggedin-user-stations/';

  /// Sends a mobile OTP.
  static const String SEND_OTP = '$BASE_API3_URL/api/app_user_mobile/send-otp/';

  /// Verifies a mobile OTP.
  static const String VERIFY_OTP = '$BASE_API3_URL/api/app_user_mobile/verify-otp/';

  // ===================================
  // BMD_Weather APIs
  // ===================================

  //static String LOCATION_LATLON = '${BASE_URL_WEATHER}/weather/location';
  static String LOCATION_LATLON = '${BASE_URL_WEATHER}/weather/forecast';

  /// Get Current Forecast
  static String CURRENT_FORECAST = '${BASE_URL_WEATHER}/weather/forecast?type=point&';

  /// Get Current Prayer Time
  static String PRAYER_TIME = '${BASE_URL_WEATHER}/weather/prayer';

  // ===================================
  // BMD_Weather APIs
  // ===================================

  /// Refresh Token.
  static String REFRESH_TOKEN = '${BAMIS_URL}/api/auth/refresh';

  /// Retrieves water level history for the last 7 days.
  static const String WATER_LEVEL_HISTORY = '$BASE_API3_URL/api/app_water_watch_mobile/waterlevel/last-7-days/';

  /// Retrieves rainfall history for the last 7 days.
  static const String RAINFALL_HISTORY = '$BASE_API3_URL/api/app_water_watch_mobile/rflevel/last-7-days/';

  /// Deletes a water level history record. Requires a \$id parameter.
  static const String WATER_LEVEL_DELETE_BASE = '$BASE_API3_URL/api/app_water_watch_mobile/waterlevel/';
}