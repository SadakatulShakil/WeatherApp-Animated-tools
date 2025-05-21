import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/screens/dashboard_preference.dart';
import '../view/screens/icon_preference.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            leading: Icon(Icons.room_preferences),
            title: Text('Dashboard Preference'),
            onTap: () {
              Navigator.of(context).pop();
              Get.to(()=> DashboardPreference(), transition: Transition.rightToLeft);
            },
          ),
          ListTile(
            leading: Icon(Icons.file_present_outlined),
            title: Text('Icon Preference'),
            onTap: () {
              Navigator.of(context).pop();
              Get.to(() => IconPreferencePage());
            }
          ),
        ],
      ),
    );
  }
}
