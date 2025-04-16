/// Review Panel used in QA App.
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

import 'package:qapod/features/review/display.dart';
import 'package:qapod/utils/solid_survey_data.dart';

class ReviewPanel extends StatefulWidget {
  const ReviewPanel({super.key});

  @override
  State<ReviewPanel> createState() => _ReviewPanelState();
}

class _ReviewPanelState extends State<ReviewPanel> {
  Future<({List<String> files, List<String> subDirs})>? surveyRecords;

  @override
  void initState() {
    super.initState();

    // Load the survey records after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var loadedRecords = await solidSurveyData();

      // Update the state with loaded records.
      setState(() {
        surveyRecords = Future.value(loadedRecords);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<({List<String> files, List<String> subDirs})>(
      future: surveyRecords,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display loading spinner while data is loading.

          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Handle any errors.

          return const Center(child: Text('Error loading data'));
        } else if (snapshot.hasData) {
          var files = snapshot.data!.files;

          return ViewDisplay(
            files: files,
          );
        } else {
          // Handle the case where no data is available.
          
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
