// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/forecast_controller.dart';
// import '../../models/icon_model.dart';
//
// class IconRowWidget extends StatelessWidget {
//   final IconMode mode;
//   final List<WeatherIcon> icons;
//
//   const IconRowWidget({required this.mode, required this.icons});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<ForecastController>();
//     return Obx(() {
//       return Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Radio<IconMode>(
//             value: mode,
//             groupValue: controller.iconMode.value,
//             onChanged: (val) {
//               controller.switchIconMode(val!);
//             },
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: icons.map((icon) {
//                   return Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: Image.asset(
//                       icon.iconUrl,
//                       width: 40,
//                       height: 40,
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
