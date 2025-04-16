/// A tempalte question and answer App as a template for specific survey apps.
///
// Time-stamp: <Wednesday 2025-04-16 20:28:54 +1000 Graham Williams>
///
/// Copyright (C) 2024-2025, Software Innovation Institute, ANU.
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

import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

import 'package:qapod/features/bloc/survey_bloc.dart';
import 'package:qapod/welcome.dart';
import 'package:qapod/utils/create_survey.dart';
import 'package:qapod/questionnaire/welcome_back.dart'; // Import the WelcomeBackScreen

// Dummy implementations for desktop support.

bool isDesktop(dynamic platformWrapper) => true;

class PlatformWrapper {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get SharedPreferences instance.

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if credentials exist.

  final username = prefs.getString('qapod_username') ?? "";
  final password = prefs.getString('qapod_password') ?? "";
  final preferredName = prefs.getString('qapod_preferredName') ?? "";

  final bool allCredentialsPresent =
      username.isNotEmpty && password.isNotEmpty && preferredName.isNotEmpty;

  // Decide which screen to show on startup.

  final Widget initialScreen = allCredentialsPresent
      ? const WelcomeBackScreen() // If all creds exist, show "WelcomeBackScreen".
      : const WelcomeScreen(); // Otherwise, show "WelcomeScreen".

  final surveyFilename = createSurveyFilename();

  // Desktop support (if needed).

  if (!kIsWeb && !Platform.isAndroid && isDesktop(PlatformWrapper())) {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      alwaysOnTop: true,
      title: 'QA Pod',
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setAlwaysOnTop(false);
    });
  }

  runApp(
    BlocProvider(
      create: (_) => SurveyBloc(
        surveyFilename: surveyFilename,
        sharedPreferences: prefs,
      ),
      child: QAPod(initialScreen: initialScreen),
    ),
  );
}

class QAPod extends StatelessWidget {
  final Widget initialScreen;
  const QAPod({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QA Pod',
      debugShowCheckedModeBanner: false,
      home: initialScreen,
    );
  }
}
