import 'package:get/get.dart';

class LocalizationString extends Translations {

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {

      //Login Page
      'app_name': 'Citizen Science',
      'welcome_login': 'LOGIN',
      'login_greetings': 'Welcome to Citizen Science',
      'welcome_message': 'Welcome to the Citizen Science',
      'mobile_no_hint': 'Enter Mobile Number',
      'login_btn': 'Login',

      //Otp Page
      'otp_title': 'OTP VERIFICATION',
      'otp_message': 'Enter the OTP sent to:',
      'wait': 'Wait ',
      'after_wait': ' seconds to send new code.',
      'resend_otp': 'RESEND CODE',
      'otp_btn': 'Send OTP',

      //Profile
      'profile_title': 'Profile',
      'profile_info': 'Profile Info',
      'profile_logout': 'Logout',
      'profile_info_name': 'Full Name',
      'profile_info_email': 'Email Address',
      'profile_info_address': 'Address',
      'profile_info_update_button': 'Update Profile Info',
      'profile_language_select': 'Language',
      'theme_select': 'Select Theme',
      'profile_logout_text': 'Logging out? We will be here when you are back!',
      'confirm_btn': 'Confirm',

      // Additional strings
      'location_label': 'Name this location',
      'location_hint': 'e.g., Home, Office',
      'save_btn': 'Save',
      'other': 'Other',

      //Station information
      'search_text': 'Search by Station Name',
      'no_results_found': 'No results found',

      //-------------/// Water Watch App ///-------------//
      'water_watch_app': 'Water Watch App',
      'tool': 'tool',
      'settings': 'Settings',

      'help_center': 'Help Center',
      'faq': 'FAQ',

      'dashboard_sidebar_about_us': 'About Us',
      'mission': 'Mission',
      'vision': 'Vision',

      'citizen_charter': 'Citizen Charter',
      'dashboard_sidebar_privacy_policy': 'Privacy Policy',
      'dashboard_rainfall': 'Rainfall',
      'dashboard_humidity': 'Humidity',
      'dashboard_wind': 'Wind Speed',
      'dashboard_time_good_morning': "Good Morning",
      'dashboard_time_good_noon': "Good Noon",
      'dashboard_time_good_afternoon': "Good Afternoon",
      'dashboard_time_good_evening': "Good Evening",
      'dashboard_time_good_night': "Good Night",

      'weather_forecast': 'Weather Forecast',
      'wf_title': 'Weather Forecast',
      'wf_subtitle': 'Weather forecast for next 10 days',
      'wf_temp': 'Temparature',
      'wf_rf': 'Rainfall',
      'wf_rh': 'Humidity',
      'wf_wind': 'Wind Speed',

      'today_weather': 'Today\'s Weather',

      'validation': 'Validation',
      'title_required': 'Title is required',
      'create_btn': 'Create',

      'ok': 'OK',

      'latitude': 'Latitude: ',
      'longitude': 'Longitude: ',

      'yes': 'YES',
      'no': 'NO',

      'notification': 'Notification',
      'alert': 'Alert',
      'time': 'Time',

      'station': 'Station',
      'status': 'Status',

      'all': 'All',
      'close': 'Close',
      'data_load_indicator': 'Loading data...',
      'date': 'Date',
      'empty_data': 'No data found yet!',

      'division': 'Division: ',
      'district': 'District: ',
      'upazila': 'Upazilla: ',
      'recorded_rainfall': 'Last recorded: ',
      'alert_text': 'Alert: ',
      'record': 'Record',
      'welcome': 'Welcome,',
      'my_record': "My Record",
      "add_record": "Add Record",
      "history_title": "History",
      "graph_title" :"Graph",
      "time_header": "Time",
      "water_level_heder": "Water Level",
      "status_header": "Action",
      "update": "Update",
      "delete": "Delete",
      "confirm_delete_title": "Confirm Delete",
      "confrim_delete_msg": "Are you sure you want to delete this record?", // Fixed typo: confrim_delete_msg -> confirm_delete_msg
      "day_of_week": "Day of Week",
      "select_date": "Select Date",
      "date_msg": "By default today's date is selected, you can adjust it by previous 7 days as well.",
      "measurement_value": "Measurement",
      "send_record_btn": "Send Record",
      "confirm_text": 'Confirm?',
      "log_out_alert" : 'Are you sure ypu want to log Out?',
      'log_out' : 'Logout',
      'my_profile': 'My Profile',
      'first_name_label': 'First Name',
      'first_name_hint': 'Enter First Name',
      'last_name_label' : 'Last Name',
      'last_name_hint': 'Enter Last Name',
      'station_list_view_only': 'Station List (View Only)',
      'mobile_view_only': 'Mobile (View Only)',
      'verified': 'Verified',
      'profile_info_address_hint' : 'Enter detail Address',
      'your_locations': 'Your Locations',
      'authorize_text': 'Only for Authorized User',
      'select_station': 'Select Station',
      'add_location': 'Add New Location',
      'location_list': 'Locations',
      'canceled': 'Canceled',
      'canceled_hint': 'No name provided',
      'success_title': 'Success',
      'success_msg': 'Location saved and selected',
      'server_maintenance_msg': 'Server Under Maintenance',
      'error': 'Error',
      'error_msg1': 'Failed to fetch forecast data',
      'error_msg2': 'An error occurred while fetching forecast data',

      ///weather app
      'next_72_hours_forecast': 'Next 72 Hours Forecast',
      'next_15_days_forecast': 'Next 15 Days Forecast',
      'wind_title': 'Wind',
      'pressure_title': 'Pressure',
      'humidity_title': 'Humidity',
      'uv_index_title': 'UV Ray',
      'rainfall_title': 'Rainfall',
      'sunrise_title': 'Sunrise',
      'sunset_title': 'Sunset',
      'visibility_title': 'Visibility',
      'sun_moon_title': 'Sun & Moon',
      'air_quality_title': 'Air Quality',
      'index': 'Indexes',
      'prayer_times_title': 'Prayer Times',
      'details': 'Details',
      'my_feedback': 'My Feedback',
      'waxing_gibbous': 'Waxing Gibbous',
      'feels_like': 'Feels Like ',

      ///Side menu item
      'preferences': 'Preferences',
      'dashboard_preference': 'Dashboard Preference',
      'icon_preference': 'Icon Preference',
      'satellite_image': 'Satellite Image',
      'radar_image': 'Radar Image',
      'weather_alerts': 'Weather Alerts',
      'emergency_contacts': 'Emergency Contacts',
      'citizen_science': 'Citizen Science',

    },
    'bn_BD': {

      //Login Page
      'app_name': 'এফএফডব্লিউসি অ্যাপ',
      'welcome_login': 'লগইন',
      'login_greetings': 'সিটিজেন সেয়েন্সে স্বাগত',
      'welcome_message': 'এফএফডব্লিউসি অ্যাপে আপনাকে স্বাগতম',
      'mobile_no_hint': 'মোবাইল নম্বর',
      'login_btn': 'লগইন করুন',

      //Otp Page
      'otp_title': 'ওটিপি যাচাইকরণ',
      'otp_message': 'আপনার ওটিপি লিখুন যা পাঠানো হয়েছে: ',
      'wait': 'অপেক্ষা করুন ',
      'after_wait': ' সেকেন্ড নতুন কোড পাঠানোর জন্য',
      'resend_otp': 'কোড পুনরায় পাঠান',
      'otp_btn': 'OTP পাঠান',

      //Profile
      'profile_title': 'প্রোফাইল',
      'profile_info': 'প্রোফাইল তথ্য',
      'profile_logout': 'লগ আউট',
      'profile_info_name': 'পুরো নাম',
      'profile_info_email': 'ইমেল ঠিকানা',
      'profile_info_address': 'ঠিকানা',
      'profile_info_update_button': 'প্রোফাইল তথ্য হালনাগাদ করুন',
      'profile_language_select': 'ভাষা নির্বাচন',
      'theme_select': 'থিম নির্বাচন করুন',
      'profile_logout_text': 'লগ আউট করতে চান? আমরা আবার দেখা হবে যখন আপনি ফিরে আসবেন!',
      'confirm_btn': 'নিশ্চিত করুন',

      // Additional strings
      'location_label': 'লোকেশন এর নাম দিন',
      'location_hint': 'বাসা, অফিস, স্কুল ইত্যাদি',
      'save_btn': 'সেভ করুন',
      'other': 'অন্যান্য',

      //Station information
      'search_text': 'স্টেশন অনুসারে অনুসন্ধান করুন',
      'no_results_found': 'কোন ফলাফল পাওয়া যায়নি',


      //-------------/// Water Watch App ///-------------//
      'water_watch_app': 'ওয়াটার ওয়াচ অ্যাপ',
      'tool': 'tool',
      'settings': 'সেটিংস',

      'help_center': 'সাহায্য কেন্দ্র',
      'faq': 'জিজ্ঞাসিত প্রশ্নাবলী',


      'dashboard_sidebar_about_us': 'আমাদের সম্পর্কে',
      'mission': 'মিশন',
      'vision': 'ভিশন',
      'citizen_charter': 'নাগরিক সনদ',
      'dashboard_sidebar_privacy_policy': 'গোপনীয়তা নীতি',
      'dashboard_rainfall': 'বৃষ্টিপাত',
      'dashboard_humidity': 'আর্দ্রতা',
      'dashboard_wind': 'বাতাসের গতি',
      'dashboard_time_good_morning': "শুভ সকাল",
      'dashboard_time_good_noon': "শুভ দুপুর",
      'dashboard_time_good_afternoon': "শুভ বিকাল",
      'dashboard_time_good_evening': "শুভ সন্ধ্যা",
      'dashboard_time_good_night': "শুভ রাত্রি",

      'weather_forecast': 'আবহাওয়া পূর্বাভাস',
      'wf_title': 'আবহাওয়া পূর্বাভাস',
      'wf_subtitle': 'পরবর্তী ১০ দিনের আবহাওয়া পূর্বাভাস',
      'wf_temp': 'তাপমাত্রা',
      'wf_rf': 'বৃষ্টিপাত',
      'wf_rh': 'আপেক্ষিক আর্দ্রতা',
      'wf_wind': 'বাতাসের গতি',

      'today_weather': 'আজকের আবহাওয়া',

      'validation': 'ভ্যালিডেশন',
      'title_required': 'শিরোনাম আবশ্যক',
      'create_btn': 'তৈরি করুন',

      'ok': 'ওকে',

      'latitude': 'অক্ষাংশ: ',
      'longitude': 'দ্রাঘিমাংশ: ',

      'yes': 'হ্যাঁ',
      'no': 'না',

      'notification': 'নোটিফিকেশন',
      'alert': 'সতর্কতা',
      'time': 'সময়',

      'station': 'স্টেশন',
      'status': 'অবস্থা',

      'all': 'সকল',
      'close': 'বন্ধ করুন',
      'data_load_indicator': 'তথ্য লোড হচ্ছে...',
      'date': 'তারিখ',
      'empty_data': 'কোন তথ্য পাওয়া যায় নি!',

      'division': 'বিভাগ: ',
      'district': 'জেলা: ',
      'upazila': 'উপজেলা: ',
      'recorded_rainfall': 'রেকর্ড করা হয়েছে: ',
      'alert_text': 'বার্তা: ',
      'record': 'রেকর্ড',
      'welcome': 'স্বাগতম,',
      'my_record': 'আমার রেকর্ড',
      "add_record": "রেকর্ড যোগ করুণ",
      "history_title" :"রেকর্ড সমূহ",
      "graph_title" :"গ্রাফ",
      "time_header": "সময়",
      "water_level_heder": "পানির স্তর",
      "status_header": "একশন",
      "update": "হালনাগাদ",
      "delete": "মুছুন",
      "confirm_delete_title": "মুছুন নিশ্চিত করুণ",
      "confrim_delete_msg": "আপনি কি নিশ্চিত যে আপনি এই রেকর্ড মুছে ফেলতে চান?", // Assuming this was meant to match confirm_delete_msg in English
      "day_of_week": "সাপ্তাহিক দিন",
      "select_date": "তারিখ নির্বাচন করুন",
      "date_msg": "ডিফল্ট আজকের তারিখ দেখায়, গত ৭ দিন পর্যন্ত সামঞ্জস্য করুন।",
      "measurement_value": "পরিমাপ",
      "send_record_btn": "রেকর্ড পাঠান",
      "confirm_text": 'নিশ্চিত?',
      "log_out_alert" : 'আপনি লগআউট করতে চান?',
      'log_out' : 'লগআউট',
      'my_profile': 'আমার প্রোফাইল',
      'first_name_label': 'প্রথম নাম',
      'first_name_hint': 'প্রথম নাম এন্ট্রি করান',
      'last_name_label' : 'শেষের নাম',
      'last_name_hint': 'শেষের নাম এন্ট্রি করান',
      'station_list_view_only': 'স্টেশন সমূহ (শুধু দেখা)',
      'mobile_view_only': 'মোবাইল (শুধু দেখা)',
      'verified': 'যাচাইকৃত',
      'profile_info_address_hint' : 'আপনার পূর্ন ঠিকানা দিন',
      'your_locations': 'আপনার অবস্থান সমূহ',
      'authorize_text': 'শুধুমাত্র অনুমোদিত ব্যবহারকারীর জন্য',
      'select_station': 'স্টেশন নির্বাচন করুন',
      'add_location': 'লোকেশন যোগ করুন',
      'location_list': 'লোকেশন সমূহ',
      'canceled': 'বাতিল',
      'canceled_hint': 'কোন নাম প্রদান করা হয়নি',
      'success_title': 'সফল',
      'success_msg': 'লোকেশন সেভ এবং সিলেক্ট করা হয়েছে',
      'server_maintenance_msg': 'সার্ভার রক্ষণাবেক্ষণ এর কাজ চলছে',
      'error': 'ত্রুটি',
      'error_msg1': 'তথ্য আনতে ব্যর্থ হয়েছে',
      'error_msg2': 'সার্ভার রক্ষণাবেক্ষণ এর জন্যে তথ্য আনতে ব্যর্থ হয়েছে',

      ///weather app
      'feels_like': 'মনে হচ্ছে ',
      'next_72_hours_forecast': 'পরবর্তী ৭২ ঘন্টার পূর্বাভাস',
      'next_15_days_forecast': 'পরবর্তী ১৫ দিনের পূর্বাভাস',
      'wind_title': 'বাতাস',
      'pressure_title': 'চাপ',
      'humidity_title': 'আর্দ্রতা',
      'uv_index_title': 'অতিবেগুনী রে',
      'rainfall_title': 'বৃষ্টিপাত',
      'sunrise_title': 'সূর্যোদয়',
      'sunset_title': 'সূর্যাস্ত',
      'visibility_title': 'দৃশ্যমানতা',
      'sun_moon_title': 'সূর্য ও চাঁদ',
      'air_quality_title': 'বাতাসের গুণমান',
      'index': 'সূচকসমূহ',
      'prayer_times_title': 'নামাজের সময়',
      'details': 'বিস্তারিত',
      'my_feedback': 'আমার প্রতিক্রিয়া',

      ///Side menu item
      'preferences': 'পছন্দসমূহ',
      'dashboard_preference': 'ড্যাশবোর্ড পছন্দ',
      'icon_preference': 'আইকন পছন্দ',
      'satellite_image': 'স্যাটেলাইট ইমেজ',
      'radar_image': 'রাডার ইমেজ',
      'weather_alerts': 'আবহাওয়া সতর্কতা',
      'emergency_contacts': 'জরুরি যোগাযোগ',
      'citizen_science': 'নাগরিক বিজ্ঞান',

    }
  };
}