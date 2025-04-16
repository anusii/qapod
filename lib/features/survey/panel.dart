/// Survey panel page used in QA App.
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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solidpod/solidpod.dart';

import 'package:qapod/constants/app.dart';
import 'package:qapod/features/bloc/survey_bloc.dart';
import 'package:qapod/utils/markdown_survey_data.dart';
import 'package:qapod/utils/pod.dart';
import 'package:qapod/constants/layout.dart';
import 'package:qapod/questionnaire/submit_confirmation.dart';
import 'package:qapod/widgets/button/submit_button.dart';
import 'package:qapod/widgets/dialog/show_warning.dart';
import 'package:qapod/widgets/question/radio_question.dart';

class SurveyPanel extends StatefulWidget {
  const SurveyPanel({super.key});

  @override
  State<SurveyPanel> createState() => _SurveyPanelState();
}

class _SurveyPanelState extends State<SurveyPanel> {
  List<String> questions = [];
  List<String> surveyAnswers = [];
  List<int?> qChosenList = [];
  String? webId;

  // Update the list of selected options for the survey, with [index] specifying
  // the question being answered and [value] the selected option for the
  // question.

  void onChanged(int index, int? value) {
    setState(() {
      qChosenList[index] = value;
    });
  }

  @override
  void initState() {
    super.initState();
    // Load the webId after the first frame.

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      webId = await getWebId();
    });

    _initializeSurveyData();
  }

  // Load the survey data using the utils function.

  Future<void> _initializeSurveyData() async {
    final loadedQuestions = (await markDownSurveyData(surveyFilePath)).first;
    final loadedAnswers = (await markDownSurveyData(surveyFilePath)).last;

    setState(() {
      questions = loadedQuestions;
      surveyAnswers = loadedAnswers;
      qChosenList = List.filled(questions.length,
          null); // Initialize qChosenList based on questions length.
    });
  }

  // Create a mapping of questions to answers using records.

  List<({String key, dynamic value})> _buildDataRecords() {
    List<({String key, dynamic value})> dataRecords = [];

    for (int i = 0; i < questions.length; i++) {
      if (qChosenList[i] != null) {
        dataRecords.add((
          key: i.toString(),
          value: '{${questions[i]}} {${surveyAnswers[qChosenList[i]!]}}'
        ));
      }
    }

    return dataRecords;
  }

  // Handle the submit action based on webId and answers.

  Future<void> handleSubmit() async {
    // Check if all items in qChosenList are null.

    if (qChosenList.every((element) => element == null)) {
      showWarning('Incomplete Submission',
          'Please answer at least one question.', context);
      return;
    }

    // If webId exists and is not empty, proceed with pod save.

    if (webId != null && webId!.isNotEmpty) {
      // Build the data map of questions and selected answers.

      List<({String key, dynamic value})> dataRecords = _buildDataRecords();

      final surveyState = BlocProvider.of<SurveyBloc>(context).state;
      String fileName = surveyState.surveyFilename;

      await saveToPod(dataRecords, fileName, context, isSubmit: true);
    } else {
      // Show successful submission without saving to pod.

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Survey submitted successfully'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to next screen or handle completion as needed.

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SubmitConfirmation(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double bodyWidth =
        screenWidth > 800 ? screenWidth * 0.5 : screenWidth * 0.8;

    return Center(
      child: SizedBox(
        width: bodyWidth,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    questions.length,
                    (index) => Column(
                      children: [
                        RadioQuestion(
                          questions[index],
                          surveyAnswers,
                          qChosenList[index],
                          (val) => onChanged(index, val),
                        ),
                        verticalMediumSpace(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SubmitButton(
              buttonStr: 'Submit',
              webId: webId,
              onPressed: handleSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
