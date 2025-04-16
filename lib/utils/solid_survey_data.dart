/// SolidSurveyData method used in QA App.
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

import 'package:solidpod/solidpod.dart';

import 'package:qapod/constants/app.dart';

Future<({List<String> files, List<String> subDirs})> solidSurveyData() async {
  String? webId = await getWebId();

  if (webId != null) {
    String surveyFolderLoc = webId.replaceAll(suffixWebID, solidSurveyDataLoc);

    // Fetch the resources in the container and explicitly type the result as List<String>.

    ({List<dynamic> files, List<dynamic> subDirs}) surveyRecords =
        await getResourcesInContainer(surveyFolderLoc);

    // Cast the dynamic lists to List<String>.

    return (
      files: List<String>.from(surveyRecords.files),
      subDirs: List<String>.from(surveyRecords.subDirs),
    );
  } else {
    // Return empty lists with explicit typing as List<String>.
    
    return (files: <String>[], subDirs: <String>[]);
  }
}
