/// Show file content used in QA App.
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

import 'package:path/path.dart' as path;
import 'package:solidpod/solidpod.dart';

import 'package:qapod/utils/clean_number_dot.dart';
import 'package:qapod/utils/rdf.dart';

/// Shows a dialog with the content of the selected file.
///
/// [fileName] is displayed in the dialog's title and [content] in its body.

void showFileContent(
  String fileName,
  BuildContext context,
) async {
  final dataDirPath = await getDataDirPath();

  // Remove mounted check since this is a standalone function.

  if (!context.mounted) return;

  final filePath = path.join(dataDirPath, fileName);

  try {
    String content = await readPod(filePath, context, Container());
    Map questionsList = await listSurveyQuestions(content);

    if (questionsList.isNotEmpty) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(fileName),
            content: SingleChildScrollView(
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2), // Question column width
                  1: FlexColumnWidth(1), // Answer column width
                },
                border:
                    TableBorder.all(color: Colors.grey), // Add borders to table
                children: [
                  // Header Row
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Question',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Answer',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  // Data Rows.
                  for (var entry in questionsList.entries)
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            cleanNumberDot(entry.key),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            cleanNumberDot(entry.value),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }

    // ignore: empty_catches
  } catch (e) {}
}
