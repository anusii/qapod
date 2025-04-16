/// MarkDownSurveyData methods used in QA App.
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

import 'package:flutter/services.dart';

// Utility function to load and parse the survey data from a markdown file.

Future<List<List<String>>> markDownSurveyData(String filePath) async {
  final contents = await rootBundle.loadString(filePath);

  return [
    extractContent(
        contents, RegExp(r"## Questions\n(.*?)(\n##|$)", dotAll: true)),
    extractContent(
        contents, RegExp(r"## Answer Options\n(.*?)(\n##|$)", dotAll: true))
  ];
}

// Utility function to extract content from the markdown file.

List<String> extractContent(String markdown, RegExp regExp) {
  final questions = <String>[];
  final questionSection = regExp;
  final matches = questionSection.firstMatch(markdown);

  if (matches != null) {
    final questionBlock = matches.group(1)?.trim() ?? '';
    final questionLines = questionBlock.split('\n');
    for (var line in questionLines) {
      if (line.startsWith(RegExp(r'^\d+\.\s'))) {
        questions.add(line.trim());
      }
    }
  }

  return questions;
}
