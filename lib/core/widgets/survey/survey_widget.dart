// // views/survey_dialog.dart
// import 'package:bmd_weather_app/controllers/home_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../models/user_survey_model.dart';
//
// Future<void> showTopSurveyDialog({
//   required BuildContext context,
//   required HomeController controller,
// }) {
//   // Dialog aligned to top so it appears under your fixed header
//   return Get.dialog(
//     WillPopScope(
//       onWillPop: () async {
//         // prevent accidental dismiss, allow closing
//         return true;
//       },
//       child: Align(
//         alignment: Alignment.topCenter,
//         child: Material(
//           // use Material so elevation, shadow, rounded corners work
//           color: Colors.transparent,
//           child: Container(
//             // width: consider phone padding
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
//             constraints: BoxConstraints(maxWidth: 720),
//             decoration: BoxDecoration(
//               color: Theme.of(context).canvasColor,
//               borderRadius: BorderRadius.circular(14),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 18,
//                   offset: Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: Obx(() {
//               // If no questions loaded, show a loader / message
//               if (controller.questions.isEmpty) {
//                 return SizedBox(
//                   height: 200,
//                   child: Center(child: CircularProgressIndicator()),
//                 );
//               }
//
//               // In future get null checking here
//
//               final Question q =
//                   controller.questions[controller.currentIndex.value];
//               final selected = controller.answers[q.id];
//
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Header with close button
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 10,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.vertical(
//                         top: Radius.circular(14),
//                       ),
//                       color: Colors.white,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Align(
//                           alignment: Alignment.topRight,
//                           child: IconButton(
//                             padding: EdgeInsets.zero,
//                             icon: Icon(Icons.close, color: Colors.red),
//                             onPressed: () => Get.back(),
//                           ),
//                         ),
//                         Text(
//                           q.question,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.black87,
//                           ),
//                         ),
//
//                         SizedBox(
//                           width: double.infinity,
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 8,
//                             ),
//                             child: Wrap(
//                               spacing: 8,
//                               runSpacing: 8,
//                               children:
//                                   q.options.map((opt) {
//                                     final isSelected = opt == selected;
//                                     return ChoiceChip(
//                                       labelPadding: const EdgeInsets.symmetric(
//                                         horizontal: 8,
//                                         vertical: 0,
//                                       ),
//                                       label: Text(
//                                         opt,
//                                         style: TextStyle(
//                                           color:
//                                               isSelected
//                                                   ? Colors.white
//                                                   : Colors.black87,
//                                           fontWeight:
//                                               isSelected
//                                                   ? FontWeight.w700
//                                                   : FontWeight.w500,
//                                         ),
//                                       ),
//                                       selected: isSelected,
//                                       onSelected: (_) {
//                                         controller.selectAnswer(q.id, opt);
//                                       },
//                                       selectedColor: const Color(0xFF0077B6),
//                                       backgroundColor: Colors.grey.shade300,
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(30),
//                                         side:
//                                             isSelected
//                                                 ? BorderSide.none
//                                                 : BorderSide(
//                                                   color: Colors.transparent,
//                                                 ),
//                                       ),
//                                     );
//                                   }).toList(),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const Divider(height: 1),
//
//                   // Footer with Prev / Next or Finish
//                   Container(
//                     height: 70,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(14),
//                         bottomRight: Radius.circular(14),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 18,
//                           offset: Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12.0,
//                         vertical: 10,
//                       ),
//                       child: Row(
//                         children: [
//                           // Previous button
//                           Expanded(
//                             child:
//                                 controller.currentIndex.value != 0
//                                     ? GestureDetector(
//                                       onTap:
//                                           controller.currentIndex.value > 0
//                                               ? () => controller.previous()
//                                               : null,
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           SizedBox(width: 4),
//                                           Text(
//                                             "<< পূর্ববর্তী",
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.black87,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                     : Text(''),
//                           ),
//
//                           // Progress indicator or small text
//                           Text(
//                             "${controller.currentIndex.value + 1} / ${controller.questions.length}",
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black54,
//                             ),
//                           ),
//
//                           // Next / Finish button
//                           Expanded(
//                             child: Padding(
//                               padding: EdgeInsets.only(right: 8.0),
//                               child: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     if (controller.isLast) {
//                                       // Submit
//                                       controller.submitAndShowSnackbar();
//                                     } else {
//                                       // move next
//                                       controller.next();
//                                     }
//                                   },
//                                   child: Text(
//                                     controller.isLast
//                                         ? "শেষ করুন"
//                                         : "পরবর্তী >>",
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.tealAccent[700],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }),
//           ),
//         ),
//       ),
//     ),
//     barrierDismissible: true,
//   );
// }
import 'dart:ui';
import 'package:bmd_weather_app/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/user_survey_model.dart';

Future<void> showTopSurveyDialog({
  required BuildContext context,
  required HomeController controller,
}) {
  return Get.dialog(
    WillPopScope(
      onWillPop: () async => true,
      child: Align(
        alignment: Alignment.topCenter,

        child: Material(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),

            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),

              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                constraints: const BoxConstraints(maxWidth: 720),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26.withOpacity(0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                child: Obx(() {
                  if (controller.questions.isEmpty) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final Question q =
                  controller.questions[controller.currentIndex.value];
                  final selected = controller.answers[q.id];

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          Align(
                           alignment: Alignment.topRight,
                           child: IconButton(
                              padding: EdgeInsets.zero,
                             icon: Icon(Icons.close, color: Colors.red),
                             onPressed: () => Get.back(),
                          ),
                        ),
                            Text(
                              q.question,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: q.options.map((opt) {
                              final isSelected = opt == selected;

                              return ChoiceChip(
                                labelPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 0,
                                ),
                                label: Text(
                                  opt,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white70,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                                selected: isSelected,
                                onSelected: (_) {
                                  controller.selectAnswer(q.id, opt);
                                },
                                selectedColor: Colors.blueAccent.withOpacity(.6),
                                backgroundColor:
                                Colors.white.withOpacity(0.20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  side: isSelected
                                      ? BorderSide.none
                                      : BorderSide(
                                    color:
                                    Colors.white.withOpacity(0.15),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      const Divider(color: Colors.white24, height: 1),

                      SizedBox(
                        height: 70,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: controller.currentIndex.value != 0
                                    ? GestureDetector(
                                  onTap: controller.previous,
                                  child: const Text(
                                    "<< পূর্ববর্তী",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                                    : const Text(""),
                              ),

                              Text(
                                "${controller.currentIndex.value + 1} / ${controller.questions.length}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70,
                                ),
                              ),

                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (controller.isLast) {
                                        controller.submitAndShowSnackbar();
                                      } else {
                                        controller.next();
                                      }
                                    },
                                    child: Text(
                                      controller.isLast
                                          ? "শেষ করুন"
                                          : "পরবর্তী >>",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.tealAccent.shade100,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    ),
    barrierDismissible: true,
  );
}
