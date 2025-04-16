/// Consent settings Page used in QA App.
///
// Time-stamp: <Wednesday 2025-04-16 20:10:14 +1000 Graham Williams>
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

import 'package:shared_preferences/shared_preferences.dart';

import 'package:qapod/widgets/image/image.dart';

class ConsentSettings extends StatefulWidget {
  const ConsentSettings({super.key});

  @override
  State<ConsentSettings> createState() => _ConsentSettingsState();
}

class _ConsentSettingsState extends State<ConsentSettings> {
  String? _consentDate;

  @override
  void initState() {
    super.initState();
    _loadConsentDate();
  }

  /// Loads the consent date from SharedPreferences, if any.

  Future<void> _loadConsentDate() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _consentDate = prefs.getString('consentDate');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 125,

        // Remove the leading arrow since we use a close button in actions.

        automaticallyImplyLeading: false,
        title: iconImage,
        centerTitle: true,

        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0),
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.grey,
                size: 40,
              ),
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CONSENT SETTINGS',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 10),

            // If we have a date, show it. Otherwise fallback text.

            if (_consentDate != null && _consentDate!.isNotEmpty) ...[
              Text(
                'You consented to sharing your survey data for this research project on $_consentDate.',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
            ] else ...[
              const Text(
                'No consent date recorded. You have not consented yet.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
            ],
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'Previously agreed consent\n\n',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  TextSpan(
                    text: 'You\'ve been invited to participate in a survey.\n\n'
                        'The focus of the survey is your recent experiences.\n\n'
                        'The survey should take 10-20 minutes to complete.\n\n',
                  ),
                  TextSpan(
                    text: 'Withdrawal of consent\n\n',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  TextSpan(
                    text:
                        'If you would like to withdraw your consent from this study, '
                        'please email survey@example.com',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
