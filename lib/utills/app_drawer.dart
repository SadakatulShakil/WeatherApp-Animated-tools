import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/theme_controller.dart';
import '../core/screens/dashboard_preference.dart';
import '../core/screens/icon_preference.dart';


class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final ThemeController themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: themeController.themeMode.value == ThemeMode.light
          ? Colors.white
          : Colors.grey.shade400,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mirpur DOHS, Dhaka', style: TextStyle(color: Colors.white, fontSize: 18)),
                Text('Fri 5.00 PM', style: TextStyle(color: Colors.white)),
              ],
            ),
            accountEmail: null, // You can remove or update this if not needed
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/day.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.room_preferences,
                color: themeController.themeMode.value == ThemeMode.light
                ? Colors.black
                : Colors.white),
            title: Text('Dashboard Preference',
                style: TextStyle(
                  color: themeController.themeMode.value == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                )),
            onTap: () {
              Navigator.of(context).pop();
              Get.to(()=> DashboardPreference(), transition: Transition.rightToLeft);
            },
          ),
          ListTile(
            leading: Icon(Icons.file_present_outlined,
                color: themeController.themeMode.value == ThemeMode.light
                ? Colors.black
                : Colors.white),
            title: Text('Icon Preference',
                style: TextStyle(
                  color: themeController.themeMode.value == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                )),
            onTap: () {
              Navigator.of(context).pop();
              Get.to(() => IconPreferencePage());
            }
          ),
          ListTile(
              leading: Icon(Icons.design_services,
                  color: themeController.themeMode.value == ThemeMode.light
                      ? Colors.black
                      : Colors.white),
              title: Row(
                children: [
                  Expanded(
                    child: Text('Theme Preference',
                        style: TextStyle(
                          color: themeController.themeMode.value == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                        )),
                  ),
                  GestureDetector(
                    onTap: (){
                      themeController.toggleTheme(themeController.themeMode.value != ThemeMode.dark);
                      },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      width: 50,
                      height: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                          image: AssetImage(
                            themeController.themeMode.value == ThemeMode.dark
                                ? 'assets/toggle/night.png'
                                : 'assets/toggle/day.png',
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 400),
                        alignment: themeController.themeMode.value == ThemeMode.dark
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                themeController.toggleTheme(themeController.themeMode.value != ThemeMode.dark);
              },
            splashColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
