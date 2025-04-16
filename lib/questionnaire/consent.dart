/// Consent page used in QA App.
///
// Time-stamp: <Wednesday 2025-04-16 20:20:16 +1000 Graham Williams>
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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:qapod/features/bloc/survey_bloc.dart';
import 'package:qapod/questionnaire/question.dart';
import 'package:qapod/widgets/page/dummy_sheet.dart';
import 'package:qapod/widgets/image/image.dart';
import 'package:qapod/welcome.dart';
import 'package:qapod/utils/format_preferred_name.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  String? preferredName;

  @override
  void initState() {
    super.initState();
    _loadPreferredName();
  }

  /// Loads the user's preferredName from SharedPreferences.

  Future<void> _loadPreferredName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      preferredName = prefs.getString('qapod_preferredName');
    });
  }

  /// Records the consent date/time in SharedPreferences.

  Future<void> _recordConsentDate() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final dateString = DateFormat('d MMMM yyyy, h:mm a').format(now);
    await prefs.setString('consentDate', dateString);
  }

  @override
  Widget build(BuildContext context) {
    // Format "Welcome <Name>!" if we have a preferredName.

    final welcomeText = (preferredName == null || preferredName!.isEmpty)
        ? "Welcome!"
        : "Welcome ${formatPreferredName(preferredName!)}!";

    final surveyState = context.read<SurveyBloc>().state;
    final dataResponses = surveyState.responses;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 80,
        title: iconImage,
        iconTheme: const IconThemeData(size: 40, color: Colors.grey),

        // Remove the top-left back arrow.

        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              welcomeText,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.pink,
              ),
            ),
            const SizedBox(height: 16),

            // Participant Information Sheet link.

            MarkdownBody(
              data:
                  'Please review the [Participant Information Sheet](info) for this research study.',
              onTapLink: (text, href, title) {
                if (href == 'info') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DummySheet(),
                    ),
                  );
                }
              },
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 16, color: Colors.black),
                a: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 8),
            MarkdownBody(
              selectable: true,
              data:
                  "The ethical aspects of this research have been approved by the ANU Human Research Ethics Committee (2024/0698).",
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            MarkdownBody(
              selectable: true,
              data:
                  '**Please confirm** *that you have read the Participant Information Sheet provided in the above link and that you hereby give your consent to participate in this study.*',
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),

            // Row of two big buttons.

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate back to the WELCOME page.

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey, width: 2),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "◄   No I Don't Consent",
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),

                // Right: "Yes I Consent".

                ElevatedButton(
                  onPressed: () async {
                    // Start navigation process.

                    final navigator = Navigator.of(context);

                    // Record the consent date in SharedPreferences.

                    await _recordConsentDate();

                    // Check if the widget is still mounted after the async operation.

                    if (!mounted) return;

                    // Use the captured navigator instance for navigation.

                    navigator.pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => QuestionPage(
                          savedResponses: dataResponses,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.pink, width: 2),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: MarkdownTooltip(
                    message: '''

                    By consenting you agree to share your survey answers with
                    the researchers who are conducting this research. You can
                    withdraw your consent at any time through the **Withdraw**
                    button in the side menu.

                    ''',
                    child: const Text(
                      "Yes I Consent   ►",
                      style: TextStyle(fontSize: 16, color: Colors.pink),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Bottom image.

            Image.asset(
              'assets/images/bottom_dot_two.png',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitWidth,
            ),
          ],
        ),
      ),
    );
  }
}
