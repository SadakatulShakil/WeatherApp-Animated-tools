import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_survey_model.dart';

enum HomeSection {
  weather_Forecast,
  weekly_Forecast,
  wind_Pressure,
  other_Info,
  sun_Moon,
  air_Quality,
  activity_Indicator,
  prayer_Time,
}

class HomeController extends GetxController {
  var sectionOrder = <HomeSection>[].obs;
  var sectionVisibility = <HomeSection, bool>{}.obs;
  var isLoaded = false.obs;
  static const String _storageKey = 'sectionOrder';
  static const String _storageKeyVisibility = 'sectionVisibility';

  RxList<Question> questions = <Question>[].obs;
  RxMap<int, String> answers = <int, String>{}.obs;
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    initData();
  }

  Future<void> initData() async {
    await loadSectionOrder();
    await loadVisibilitySettings();
    await loadQuestions();

    isLoaded.value = true;  // IMPORTANT
  }
  /// This method is called when the user reorders the sections in the dashboard.
  void updateSectionOrder(List<HomeSection> newOrder) async {
    sectionOrder.value = newOrder;
    await saveSectionOrder();
  }

  void updateSectionVisibility(HomeSection section, bool isVisible) async {
    sectionVisibility[section] = isVisible;
    await saveVisibilitySettings();
  }

  Future<void> saveSectionOrder() async {
    final prefs = await SharedPreferences.getInstance();
    ///Convert a list of enum values to a list of strings for sharedPreference storage, because sharedPreference
    ///can only store strings.
    ///TIPS: e.name is the string of the enum value.
    List<String> orderAsString = sectionOrder.map((e) => e.name).toList();
    await prefs.setStringList(_storageKey, orderAsString);
  }

  /// This method loads the section order from shared preferences when the app starts.
  Future<void> loadSectionOrder() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedOrder = prefs.getStringList(_storageKey);

    if (savedOrder != null && savedOrder.isNotEmpty) {
      sectionOrder.value = savedOrder.map((name) => _stringToHomeSection(name)).toList();
    } else {
      /// Default Order(If there is no saved order in sharedPreference)
      sectionOrder.value = [
        HomeSection.weather_Forecast,
        HomeSection.weekly_Forecast,
        HomeSection.wind_Pressure,
        HomeSection.other_Info,
        HomeSection.sun_Moon,
        HomeSection.air_Quality,
        HomeSection.activity_Indicator,
        HomeSection.prayer_Time,
      ];
    }
  }

  /// Saves the visibility settings of each section to shared preferences.
  Future<void> saveVisibilitySettings() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> map = {
      for (var entry in sectionVisibility.entries) entry.key.name: entry.value.toString()
    };
    await prefs.setString(_storageKeyVisibility, jsonEncode(map));
  }

  /// Loads the visibility settings of each section from shared preferences.
  Future<void> loadVisibilitySettings() async {
    final prefs = await SharedPreferences.getInstance();
    String? raw = prefs.getString(_storageKeyVisibility);
    if (raw != null) {
      Map<String, dynamic> map = jsonDecode(raw);
      sectionVisibility.value = {
        for (var entry in map.entries)
          _stringToHomeSection(entry.key): entry.value == 'true'
      };
    } else {
      // Default: all visible
      sectionVisibility.value = {
        for (var section in HomeSection.values) section: true
      };
    }
  }

  ///Converts a string (e.g., "sunMoon") back to the corresponding enum value.
  ///Uses firstWhere to match the name of the enum value.
  HomeSection _stringToHomeSection(String name) {
    return HomeSection.values.firstWhere((e) => e.name == name, orElse: () => HomeSection.weather_Forecast);
  }


  /// Load data from API (your static JSON for now)

  Future loadQuestions() async{
    final List<Map<String, dynamic>> apiData = [
      {
        "id": 1,
        "question": "আজকে আপনার এলাকায় বৃষ্টিপাতের অবস্থা কেমন?",
        "options": ["কোন বৃষ্টিপাত নেই", "সামান্য বৃষ্টিপাত আছে", "ঝড়ো বৃষ্টি হচ্ছে", "ভারি বৃষ্টি হচ্ছে"]
      },
      {
        "id": 2,
        "question": "আজকের তাপমাত্রা কেমন মনে হচ্ছে?",
        "options": ["ঠান্ডা", "গরম", "খুব গরম", "ঠান্ডা ও গরমের মধ্যে"]
      },
      {
        "id": 3,
        "question": "আপনার এলাকায় বন্যার পরিস্থিতি কেমন?",
        "options": ["আগের থেকে অবস্থা উন্নত হয়েছে", "কোন পরিবর্তন নেই", "ভারি বৃষ্টি হচ্ছে"]
      },
      {
        "id": 4,
        "question": "আজকে আপনার এলাকায় বজ্রপাতের অবস্থা কেমন?",
        "options": ["এক বা দুই বার দেখা গেছে", "আজকে একদমই নাই", "বদ্রপাতে সাথে ভারি বৃষ্টি হচ্ছে"]
      },
    ];

    questions.value =
        apiData.map((e) => Question.fromJson(e)).toList();
  }

  /// select/update answer for question id
  void selectAnswer(int questionId, String option) {
    answers[questionId] = option;
    // reactive update happens automatically since answers is RxMap
  }

  /// get selected answer for current question
  String? selectedForCurrent() {
    if (questions.isEmpty) return null;
    final q = questions[currentIndex.value];
    return answers[q.id];
  }

  /// go to next question, but don't exceed length
  void next() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
    }
  }

  /// go to previous question
  void previous() {
    if (currentIndex.value > 0) currentIndex.value--;
  }

  /// whether on last question
  bool get isLast => currentIndex.value == questions.length - 1;

  /// submit answers: validate all answered, then show snackbar formatted
  void submitAndShowSnackbar() {
    // require all questions answered
    if (answers.length != questions.length) {
      Get.snackbar(
        "ত্রুটি",
        "অনুগ্রহ করে সকল প্রশ্নের উত্তর দিন",
        snackPosition: SnackPosition.TOP,
          colorText: Colors.black,
      );
      return;
    }

    // format number-wise (use question id order or index order)
    final List<String> lines = [];
    for (var q in questions) {
      final ans = answers[q.id] ?? '';
      lines.add("${q.id}. $ans");
    }
    final formatted = lines.join("\n");

    // close dialog first (caller should call Get.back() after invoking this OR we can pop here)
    // We'll pop here to be safe if dialog is open:
    if (Get.isDialogOpen ?? false) Get.back();

    // show top snackbar with only numbered answers in message
    Get.snackbar(
      '',
      formatted,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 5),
      // styling to look like simple toast (no title)
      titleText: const SizedBox.shrink(),
      messageText: Text(
        formatted,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF0B72A6),
      margin: const EdgeInsets.only(top: 10, left: 12, right: 12),
      borderRadius: 8,
    );
  }
}
