/// Show warning dialog used in QA App.
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

import 'package:qapod/questionnaire/welcome_back.dart';

void showWarning(String title, String content, BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.health_and_safety,
              size: 24,
              color: Color(0xFFFF79D4),
            ),
            Gap(20),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // First exit the dialog.
              // Then pop the current screen and navigate to the welcome screen.

              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const WelcomeBackScreen()),
              );
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
