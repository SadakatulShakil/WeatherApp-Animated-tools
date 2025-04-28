import 'package:flutter/material.dart';
import 'package:package_connector/view/widgets/sunrise_arc_widget.dart';
import 'package:package_connector/view/widgets/sunset_arc_widget.dart';

class SunAndMoonWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.blue.shade500, Colors.blue.shade500],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.sunny_snowing,
                      color: Colors.white,
                      size: 22,
                    ),
                    SizedBox(width: 16,),
                    Text(
                      'Sun & Moon',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Colors.white.withOpacity(.5), Colors.white.withOpacity(.5)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Image.asset('assets/sun_moon.png', width: 70, height: 75,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Waxing Gibbous', style: TextStyle(color: Colors.white, fontSize: 24),),
                    Text('Moon Phase', style: TextStyle(color: Colors.white, fontSize: 16),),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Colors.white.withOpacity(.5), Colors.white.withOpacity(.5)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Image.asset('assets/full_moon.png', width: 45, height: 45,),
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('04/13', style: TextStyle(color: Colors.white, fontSize: 22),),
                        Text('Full Moon', style: TextStyle(color: Colors.white, fontSize: 14),),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Colors.white.withOpacity(.5), Colors.white.withOpacity(.5)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.asset('assets/last_quarter.png', width: 40, height: 40,),
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('04/21', style: TextStyle(color: Colors.white, fontSize: 22),),
                        Text('Last quarter', style: TextStyle(color: Colors.white, fontSize: 14),),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SunriseArcWidget(
                        sunrise: TimeOfDay(hour: 5, minute: 30),
                        sunset: TimeOfDay(hour: 18, minute: 45),
                        currentTime: TimeOfDay.now(),
                      ),
                    ),
                    const SizedBox(width: 16), // Space between two widgets
                    Expanded(
                      child: SunsetArcWidget(
                        moonrise: TimeOfDay(hour: 18, minute: 46),
                        moonset: TimeOfDay(hour: 5, minute: 29),
                        currentTime: TimeOfDay.now(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          // Sun and Moon icons
        ],
      ),
    );
  }
}