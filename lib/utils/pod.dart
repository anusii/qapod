/// Pod operation methods used in QA App.
///
// Time-stamp: <Wednesday 2024-07-10 09:49:30 +1000 Graham Williams>
///
/// Copyright (C) 2024, Software Innovation Institute, ANU.
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
/// Authors: Zheyuan Xu

library;

// Save data to PODs.

import 'package:flutter/material.dart';

import 'package:solidpod/solidpod.dart';

import 'package:qapod/questionnaire/question.dart';
import 'package:qapod/utils/rdf.dart';
import 'package:qapod/widgets/dialog/show_warning.dart';

Future<bool> saveToPod(List<({String key, dynamic value})> dataRecords,
    String fileName, BuildContext context,
    {bool isSubmit = false}) async {
  if (dataRecords.isEmpty) {
    return false;
  }

  try {
    // Generate TTL str with dataMap.

    final ttlStr = await genTTLStr(dataRecords);

    // Write to POD.

    if (context.mounted) {
      await writePod(fileName, ttlStr, context, const QuestionPage());
    }

    // Show a SnackBar indicating successful upload.

    if (context.mounted) {
      if (isSubmit) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.pink,
            content: Text('Successfully saved "$fileName" to PODs'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
    return true;
  } on Exception catch (e) {
    // ignore: use_build_context_synchronously
    showWarning('Failed', 'Questions are not saved to pods', context);
    debugPrint('Exception: $e');
  }
  return false;
}
