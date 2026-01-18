import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'home_controller.dart';

class ForecastDetailsController extends GetxController {
  final HomeController homeController = Get.find<HomeController>();

  // --- 1. LOCALE HELPER ---
  bool get isBangla => Get.locale?.languageCode == 'bn';

  // ==========================================
  // STATE FOR 72 HOURS PAGE
  // ==========================================
  var selectedHourlyTab = 0.obs;
  var hourlyTabs = <String>[].obs;
  var hourlyViewData = <Map<String, dynamic>>[].obs;
  Map<String, List<Map<String, dynamic>>> _groupedSteps = {};

  // ==========================================
  // STATE FOR 10 DAYS PAGE
  // ==========================================
  var selectedDailyTab = 0.obs;
  var dailyTabs = <Map<String, dynamic>>[].obs;
  var dailyViewData = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Re-load data if locale changes (optional, but good for immediate update)
    // For now, standard init:
    loadHourlyData();
    loadTenDayData();
  }

  // ----------------------------------------------------------------------
  // 2. SAFE PARSING (Input Logic)
  // ----------------------------------------------------------------------
  /// Safely parses "12.5" or "১২.৫" to a double for calculations.
  /// (Always converts Bangla -> English for parsing, regardless of App Locale)
  double _safeDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      String normalized = _normalizeToEnglish(value);
      return double.tryParse(normalized) ?? 0.0;
    }
    return 0.0;
  }

  String _normalizeToEnglish(String input) {
    const bangla = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    const english = ['0','1','2','3','4','5','6','7','8','9'];
    for (int i = 0; i < bangla.length; i++) {
      input = input.replaceAll(bangla[i], english[i]);
    }
    return input;
  }

  DateTime _parseApiDate(String dateStr) {
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      try {
        return DateFormat("d MMM, yyyy").parse(dateStr);
      } catch (e2) {
        return DateTime.now();
      }
    }
  }

  // ----------------------------------------------------------------------
  // 3. LOGIC FOR 72 HOURS PAGE
  // ----------------------------------------------------------------------
  void loadHourlyData() {
    final steps = homeController.forecast.value?.result?.steps;
    if (steps == null || steps.isEmpty) return;

    _groupedSteps.clear();
    hourlyTabs.clear();

    for (var step in steps) {
      String rawTime = step.stepStart ?? "";
      DateTime dt = DateTime.tryParse(rawTime) ?? DateTime.now();
      String dateKey = DateFormat('yyyy-MM-dd').format(dt);

      double temp = _safeDouble(step.temp?.valAvg);
      double rainChance = _safeDouble(step.rf?.valMax);
      double rainAmount = _safeDouble(step.rf?.valAvg);
      double humidity = _safeDouble(step.rh?.valAvg);
      double wind = _safeDouble(step.windspd?.valAvg);
      double cloud = _safeDouble(step.cldcvr?.valAvg);
      double windDir = _safeDouble(step.winddir?.valAvg);

      Map<String, dynamic> item = {
        'time': _formatTime(dt),
        'date': _formatDateFull(dt),
        'temperature': '${_localizeNumber(temp.toInt())}° ${step.type ?? ""}',
        'rainChance': '${_localizeNumber(rainChance.toInt())}%',
        'rainAmount': '${_localizeNumber(rainAmount.toStringAsFixed(1))} ${isBangla ? "মিমি" : "mm"}',
        'humidity': '${_localizeNumber(humidity.toInt())}%',
        'windSpeed': '${_localizeNumber(wind.toInt())} ${isBangla ? "কিমি/ঘ" : "km/h"}',
        'windDirection': _getWindDir(windDir),
        'cloud': '${_localizeNumber(cloud.toInt())}%',
        'visibility': '---',
        'uvIndex': '---',
        // 'visibility': '${_localizeNumber(5)} ${isBangla ? "কিমি" : "km"}',
        // 'uvIndex': _localizeNumber(4),
      };

      if (!_groupedSteps.containsKey(dateKey)) {
        _groupedSteps[dateKey] = [];
        hourlyTabs.add(_formatDayName(dt));
      }
      _groupedSteps[dateKey]!.add(item);
    }

    if (hourlyTabs.isNotEmpty) updateHourlyView(0);
  }

  void updateHourlyView(int index) {
    selectedHourlyTab.value = index;
    if (index < _groupedSteps.keys.length) {
      String dateKey = _groupedSteps.keys.elementAt(index);
      hourlyViewData.value = _groupedSteps[dateKey] ?? [];
    }
  }

  // ----------------------------------------------------------------------
  // 4. LOGIC FOR 10 DAYS PAGE
  // ----------------------------------------------------------------------
  void loadTenDayData() {
    final dailyList = homeController.forecast.value?.result?.daily;
    if (dailyList == null || dailyList.isEmpty) return;

    dailyTabs.clear();

    for (var daily in dailyList) {
      DateTime dt = _parseApiDate(daily.stepStart ?? daily.date ?? "");

      // Map ISO date string for lookup
      String isoDateKey = DateFormat('yyyy-MM-dd').format(dt);

      dailyTabs.add({
        'dayLabel': _formatDayName(dt), // e.g., "Friday" or "শুক্রবার"
        'dateLabel': '${_localizeNumber(dt.day)}/${_localizeNumber(DateTime.now().month)}/${_localizeNumber(DateTime.now().year)}', // e.g., "17/26" or "১৭/২৬"
        'isoDateKey': isoDateKey,
        'dailyObj': daily,
        'dateTime': dt,
      });
    }

    if (dailyTabs.isNotEmpty) updateDailyView(0);
  }

  void updateDailyView(int index) {
    selectedDailyTab.value = index;
    dailyViewData.clear();

    final selectedItem = dailyTabs[index];
    var dailyObj = selectedItem['dailyObj'];
    DateTime dt = selectedItem['dateTime'];

    // SINGLE CARD for Daily Average
    double min = _safeDouble(dailyObj.temp?.valMin);
    double max = _safeDouble(dailyObj.temp?.valMax);
    double rainAmt = _safeDouble(dailyObj.rf?.valMax);
    double rainChange = _safeDouble(dailyObj.rf?.valAvg);
    double humidity = _safeDouble(dailyObj.rh?.valAvg);
    double wind = _safeDouble(dailyObj.windspd?.valAvg);
    double windDir = _safeDouble(dailyObj.winddir?.valAvg);
    double cloud = _safeDouble(dailyObj.cldcvr?.valAvg);

    dailyViewData.add({
      'time': isBangla ? 'সারাদিন' : 'All Day',
      'date': _formatDateFull(dt),
      'temperature': isBangla
          ?'▲ ${_localizeNumber(max.toInt())}°সে / ▼ ${_localizeNumber(min.toInt())}°সে'
          : '▲ ${_localizeNumber(max.toInt())}°C / ▼ ${_localizeNumber(min.toInt())}°C',
      'rainChance': '${_localizeNumber(rainChange.toStringAsFixed(1))} ${isBangla ? "মিমি" : "mm"}',
      'rainAmount': '${_localizeNumber(rainAmt.toStringAsFixed(1))} ${isBangla ? "মিমি" : "mm"}',
      'humidity': '${_localizeNumber(humidity.toInt())}%',
      'windSpeed': '${_localizeNumber(wind.toInt())} ${isBangla ? "কিমি/ঘ" : "km/h"}',
      'windDirection': _getWindDir(windDir),
      'cloud': '${_localizeNumber(cloud.toInt())}%',
      'visibility': '---',
      'uvIndex': '---',
    });
  }

  // ----------------------------------------------------------------------
  // 5. LOCALIZATION HELPERS
  // ----------------------------------------------------------------------

  /// Display Number: Converts to Bangla digits IF isBangla is true
  String _localizeNumber(dynamic input) {
    String str = input.toString();
    if (!isBangla) return str; // Return English digits

    const english = ['0','1','2','3','4','5','6','7','8','9'];
    const bangla = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];

    for (int i = 0; i < english.length; i++) {
      str = str.replaceAll(english[i], bangla[i]);
    }
    return str;
  }

  /// Day Name: Today/Tomorrow or Full Name (Friday/শুক্রবার)
  String _formatDayName(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dt.year, dt.month, dt.day);

    if (date == today) return isBangla ? "আজ" : "Today";
    if (date == today.add(Duration(days: 1))) return isBangla ? "আগামীকাল" : "Tomorrow";

    String eDay = DateFormat.EEEE().format(dt); // Friday

    if (isBangla) {
      Map<String, String> days = {
        'Monday': 'সোমবার',
        'Tuesday': 'মঙ্গলবার',
        'Wednesday': 'বুধবার',
        'Thursday': 'বৃহস্পতিবার',
        'Friday': 'শুক্রবার',
        'Saturday': 'শনিবার',
        'Sunday': 'রবিবার'
      };
      return days[eDay] ?? eDay;
    }
    return eDay;
  }

  /// Time: 12:00 PM or দুপুর ১২.০০
  String _formatTime(DateTime dt) {
    if (!isBangla) {
      return DateFormat('h:00 a').format(dt); // 3:00 PM
    }

    String hour = DateFormat('hh').format(dt);
    String ampm = DateFormat('a').format(dt);
    String prefix = "";

    if (ampm == "AM") {
      if (dt.hour < 5) prefix = "রাত";
      else prefix = "সকাল";
    } else {
      if (dt.hour < 15) prefix = "দুপুর";
      else if (dt.hour < 18) prefix = "বিকাল";
      else prefix = "রাত";
    }
    return '$prefix ${_localizeNumber(hour)}.০০';
  }

  /// Date Full: Friday, 10 April 2025 or শুক্রবার, ১০ এপ্রিল ২০২৫
  String _formatDateFull(DateTime dt) {
    if (!isBangla) {
      return DateFormat('EEEE, d MMMM yyyy').format(dt);
    }

    String dayName = _formatDayName(dt); // Re-use logic
    String d = _localizeNumber(dt.day);
    String y = _localizeNumber(dt.year);
    String m = DateFormat.MMMM().format(dt);

    Map<String, String> months = {
      'January': 'জানুয়ারি', 'February': 'ফেব্রুয়ারি', 'March': 'মার্চ',
      'April': 'এপ্রিল', 'May': 'মে', 'June': 'জুন',
      'July': 'জুলাই', 'August': 'আগস্ট', 'September': 'সেপ্টেম্বর',
      'October': 'অক্টোবর', 'November': 'নভেম্বর', 'December': 'ডিসেম্বর'
    };

    return '$dayName, $d ${months[m] ?? m} $y';
  }

  String _getWindDir(double? deg) {
    if (deg == null) return isBangla ? "দক্ষিণ" : "South";

    // Logic for direction
    String dir = "South";
    if (deg >= 337.5 || deg < 22.5) dir = "North";
    else if (deg >= 22.5 && deg < 67.5) dir = "North-East";
    else if (deg >= 67.5 && deg < 112.5) dir = "East";
    else if (deg >= 112.5 && deg < 157.5) dir = "South-East";
    else if (deg >= 157.5 && deg < 202.5) dir = "South";
    else if (deg >= 202.5 && deg < 247.5) dir = "South-West";
    else if (deg >= 247.5 && deg < 292.5) dir = "West";
    else dir = "North-West";

    if (isBangla) {
      Map<String, String> dirs = {
        "North": "উত্তর", "North-East": "উত্তর-পূর্ব", "East": "পূর্ব",
        "South-East": "দক্ষিণ-পূর্ব", "South": "দক্ষিণ", "South-West": "দক্ষিণ-পশ্চিম",
        "West": "পশ্চিম", "North-West": "উত্তর-পশ্চিম"
      };
      return dirs[dir] ?? dir;
    }
    return dir;
  }
}