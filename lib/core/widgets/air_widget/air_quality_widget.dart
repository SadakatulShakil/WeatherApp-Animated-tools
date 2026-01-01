import 'package:bmd_weather_app/core/widgets/air_widget/air_quality_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controllers/theme_controller.dart';
import 'air_quality_animation.dart';

class AirQualityWidget extends StatefulWidget {

  final String currentValue;// Expected between 0-100
  AirQualityWidget({
    super.key,
    required this.currentValue,
  });
  @override
  State<AirQualityWidget> createState() => _AirQualityWidgetState();
}

class _AirQualityWidgetState extends State<AirQualityWidget> {
  final ThemeController themeController = Get.find<ThemeController>();
  String banglaToEnglishNumber(String input) {
    const bangla = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    const english = ['0','1','2','3','4','5','6','7','8','9'];

    for (int i = 0; i < bangla.length; i++) {
      input = input.replaceAll(bangla[i], english[i]);
    }
    return input;
  }
  final isBangla = Get.locale?.languageCode == 'bn';
  String englishNumberToBangla(String input) {
    const bangla = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    const english = ['0','1','2','3','4','5','6','7','8','9'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], bangla[i]);
    }
    return input;
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        //Get.to(()=>AirQualityDetailsWidget());
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: themeController.themeMode.value == ThemeMode.light
                ? [Colors.white, Colors.white]
                : [Color(0xFF3986DD), Color(0xFF3986DD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.wind_power,
                        color: themeController.themeMode.value == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'air_quality_title'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeController.themeMode.value == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(
                color: themeController.themeMode.value == ThemeMode.light
                    ? Colors.grey.shade300
                    : Colors.grey.shade500,
                height: 1,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        isBangla ? englishNumberToBangla(banglaToEnglishNumber(widget.currentValue).split('.')[0]) : widget.currentValue.split('.')[0],
                      //widget.currentValue.toStringAsFixed(0),
                      style: TextStyle(
                          color: themeController.themeMode.value == ThemeMode.light
                              ? Colors.black.withValues(alpha: 0.7)
                              : Colors.white,
                          fontSize: 65,
                        fontWeight: FontWeight.bold
                      )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(isBangla? 'অস্বাস্থ্যকর' : 'Unhealthy', style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                        ? Colors.black
                        : Colors.white, fontSize: 16),),
                  )
                ],
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('air_quality_subtitle'.tr,
                  style: TextStyle(color: themeController.themeMode.value == ThemeMode.light
                      ? Colors.black
                      : Colors.white, fontSize: 16),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AirQualityAnimated(currentValue: double.tryParse(isBangla ? banglaToEnglishNumber(widget.currentValue) : widget.currentValue) ?? 0.0,),
              )
              // Sun and Moon icons
            ],
          ),
        ),
      ),
    );
  }
}