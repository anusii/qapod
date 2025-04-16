/// SurveyCompleted screen used in QA App.
///
// Time-stamp: <Friday 2025-02-16 12:34:33 +1000 Graham Williams>
///
/// Copyright (C) 2025, Software Innovation Institute, ANU.
///
/// Licensed under the GNU General Public License, Version 3 (the "License").
///
/// License: https://www.gnu.org/licenses/gpl-3.0.en.html.
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation, either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <https://www.gnu.org/licenses/>.
///
/// Authors: Graham Williams, Zheyuan Xu

library;

import 'package:flutter/material.dart';

import 'package:gap/gap.dart';

import 'package:qapod/widgets/drawer/side_drawer.dart';
import 'package:qapod/widgets/gradient_icon.dart';
import 'package:qapod/widgets/image/image.dart';
import 'package:qapod/questionnaire/welcome_back.dart';

class SurveyCompleted extends StatefulWidget {
  const SurveyCompleted({super.key});

  @override
  State<SurveyCompleted> createState() => _SurveyCompletedState();
}

class _SurveyCompletedState extends State<SurveyCompleted> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  /// Show a dialog to confirm if the user really wants to end now.
  /// Adjust the logic here if you want different end-behavior.

  // Future<void> _showEndDialog() async {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext dialogContext) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         child: Container(
  //           padding: const EdgeInsets.fromLTRB(24, 5, 24, 24),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(16),
  //             border: Border.all(width: 2, color: Colors.pink),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const SizedBox(height: 30),
  //               const Text(
  //                 "Are you sure you want to end now?",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   fontSize: 28,
  //                   fontWeight: FontWeight.w400,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //               const SizedBox(height: 40),
  //               const Text(
  //                 "You can return to the survey any time before midnight.",
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(fontSize: 16, color: Colors.black),
  //               ),
  //               const SizedBox(height: 40),
  //               GestureDetector(
  //                 onTap: () {
  //                   Navigator.pop(dialogContext);
  //                   // Perform "end now" logic, e.g. pop to home
  //                   // Navigator.popUntil(context, (route) => route.isFirst);
  //                 },
  //                 child: Container(
  //                   width: 200,
  //                   height: 46,
  //                   padding: const EdgeInsets.symmetric(vertical: 12),
  //                   decoration: BoxDecoration(
  //                     gradient: const LinearGradient(
  //                       colors: [Color(0xFFFF79D4), Color(0xFFFF5A5F)],
  //                       begin: Alignment.centerLeft,
  //                       end: Alignment.centerRight,
  //                     ),
  //                     borderRadius: BorderRadius.circular(5),
  //                   ),
  //                   child: const Center(
  //                     child: Text(
  //                       "Yes, end now",
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 16,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //               SizedBox(
  //                 width: 200,
  //                 height: 46,
  //                 child: OutlinedButton(
  //                   onPressed: () => Navigator.pop(dialogContext),
  //                   style: OutlinedButton.styleFrom(
  //                     side: const BorderSide(color: Colors.pink),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(5),
  //                     ),
  //                     padding: EdgeInsets.zero,
  //                   ),
  //                   child: const Center(
  //                     child: Text(
  //                       "No, return to the survey",
  //                       style: TextStyle(
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.w300,
  //                         fontSize: 16,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  /// Navigate to WelcomeBackScreen.

  void _goHome() {
    // If you want to remove the entire navigation stack:

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeBackScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
        iconTheme: const IconThemeData(size: 40, color: Colors.grey),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: GradientIcon(
                icon: Icons.menu,
                size: 40.0,
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.grey.shade50],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: iconImage,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 16),
        //     child: OutlinedButton(
        //       onPressed: _showEndDialog,
        //       style: OutlinedButton.styleFrom(
        //         side: const BorderSide(color: Colors.pink, width: 1.8),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(5),
        //         ),
        //         padding:
        //             const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        //       ),
        //       child: const Text(
        //         'End now',
        //         style: TextStyle(color: Colors.pinkAccent),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      drawer: SideDrawer(scaffoldKey: scaffoldKey),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(30),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  "Your data matters!\n      Thank you",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            const Gap(10),
            Center(
              child: Image.asset(
                'assets/images/bottom_dot_six.png',
                height: 300,
              ),
            ),
            const Gap(30),

            // Home button that navigates to WelcomeBackScreen.

            SizedBox(
              width: 260,
              child: ElevatedButton(
                onPressed: _goHome,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFF79D4),
                        Color(0xFFFF5A5F),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 46,
                    child: const Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
