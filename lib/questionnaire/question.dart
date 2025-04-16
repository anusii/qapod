/// Question page used in QA App.
///
// Time-stamp: <Wednesday 2025-04-16 20:11:26 +1000 Graham Williams>
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

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:qapod/features/bloc/survey_bloc.dart';
import 'package:qapod/questionnaire/suvey_completed.dart';
import 'package:qapod/questionnaire/submission.dart';
import 'package:qapod/utils/pod.dart';
import 'package:qapod/widgets/image/image.dart';

class QuestionPage extends StatefulWidget {
  /// Optionally pre-fill answers (map of question -> answer)

  final Map<String, String?>? savedResponses;
  const QuestionPage({super.key, this.savedResponses});
  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  String? webId;
  final List<String> options = [
    "Strongly disagree",
    "Disagree",
    "Agree",
    "Strongly agree",
    "Don't know",
    "Not applicable",
  ];
  final List<Color> gradientColors = [
    const Color(0xFFFFE6EB),
    const Color(0xFFFFD6DE),
    const Color(0xFFFFC6D1),
    const Color(0xFFFFB6C5),
    const Color.fromARGB(255, 200, 195, 195),
    const Color.fromARGB(255, 220, 215, 215),
  ];

  @override
  void initState() {
    super.initState();
    _loadWebId();
    _loadQuestionsIntoBloc();
  }

  Future<void> _loadWebId() async {
    final prefs = context.read<SurveyBloc>().sharedPreferences;
    setState(() {
      webId = prefs.getString('webId');
    });
  }

  Future<void> _loadQuestionsIntoBloc() async {
    final data =
        await rootBundle.loadString('assets/markdown/small_questionnaire.md');
    if (!mounted) return;
    final List<String> loadedQuestions = _parseQuestions(data);

    // Initialize the bloc with the question list.

    final surveyBloc = context.read<SurveyBloc>();
    surveyBloc.add(InitializeSurvey(questions: loadedQuestions));

    // Load saved responses from SharedPreferences.

    final prefs = await SharedPreferences.getInstance();
    final savedResponsesString = prefs.getString('surveyResponses');
    if (savedResponsesString != null && savedResponsesString.isNotEmpty) {
      final Map<String, dynamic> decoded = json.decode(savedResponsesString);
      for (int i = 0; i < loadedQuestions.length; i++) {
        final question = loadedQuestions[i];
        if (decoded.containsKey(question) && decoded[question] != null) {
          final answer = decoded[question] as String;
          if (answer.isNotEmpty) {
            surveyBloc.add(UpdateResponse(questionIndex: i, response: answer));
          }
        }
      }
    }
    // Load last saved question index.

    final int lastIndex = prefs.getInt('lastQuestionIndex') ?? 0;
    surveyBloc.add(SetQuestionIndex(lastIndex));
  }

  List<String> _parseQuestions(String data) {
    final lines = data.split('\n');
    final List<String> extracted = [];
    bool isQuestion = false;
    for (var line in lines) {
      if (line.startsWith('## Questions')) {
        isQuestion = true;
      } else if (line.startsWith('## Answer Options')) {
        isQuestion = false;
      } else if (isQuestion && line.trim().isNotEmpty) {
        extracted.add(line.substring(line.indexOf('.') + 2).trim());
      }
    }
    return extracted;
  }

  Future<void> _showEndDialog() async {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 5, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(width: 2, color: Colors.pink),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30),
                const Text(
                  "Are you sure you want to end now?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
                const SizedBox(height: 40),
                const Text(
                  "You can return to the survey any time before midnight.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(dialogCtx);
                    _endSurvey();
                  },
                  child: Container(
                    width: 200,
                    height: 46,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF79D4), Color(0xFFFF5A5F)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        "Yes, end now",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 200,
                  height: 46,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(dialogCtx),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.pink),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Center(
                      child: Text(
                        "No, return to the survey",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Ends the survey by navigating to the SurveyCompleted page (or "SubmissionPage").

  void _endSurvey() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SurveyCompleted(),
      ),
    );
  }

  /// Submits the survey by navigating to the SurveyCompleted page (or "SubmissionPage").

  void _submitSurvey() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SubmissionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SurveyBloc, SurveyState>(
      listener: (context, state) async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('surveyResponses', json.encode(state.responses));
        await prefs.setInt('lastQuestionIndex', state.currentQuestionIndex);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<SurveyBloc, SurveyState>(
          builder: (context, state) {
            if (state.questionList.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            final List<String> questionList = state.questionList;
            final int currentIndex = state.currentQuestionIndex;
            final int questionTotal = questionList.length;
            if (currentIndex >= questionTotal) {
              return const Center(child: Text("No more questions."));
            }
            final String currentQuestion = questionList[currentIndex];
            String? selectedResponse = state.responses[currentQuestion];
            if (widget.savedResponses != null &&
                widget.savedResponses!.containsKey(currentQuestion) &&
                state.responses[currentQuestion] == null) {
              selectedResponse = widget.savedResponses![currentQuestion];
            }
            Future<void> handleNext() async {
              context.read<SurveyBloc>().add(NextQuestion());
              if (webId != null && webId!.isNotEmpty) {
                final newState = context.read<SurveyBloc>().state;
                final String fileName = newState.surveyFilename;
                final Map<String, String?> dataResponses = newState.responses;
                final List<({String key, dynamic value})> dataRecords = [];
                int index = 0;
                for (var entry in dataResponses.entries) {
                  dataRecords.add((
                    key: index.toString(),
                    value: '{${entry.key}} {${entry.value}}'
                  ));
                  index++;
                }
                await saveToPod(dataRecords, fileName, context);
              }
              if (currentIndex == questionTotal - 1) {
                _submitSurvey();
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Stack(
                      children: [
                        Center(child: iconImage),
                        Positioned(
                          right: 16,
                          top: 16,
                          child: OutlinedButton(
                            onPressed: _showEndDialog,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Colors.pink, width: 1.8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                            ),
                            child: const Text(
                              'End now',
                              style: TextStyle(color: Colors.pinkAccent),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(5),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 8.0),
                    child: Stack(
                      children: [
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.pink[100],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 0.0,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [Colors.red, Colors.pink]),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      'QUESTION ${currentIndex + 1} OF $questionTotal',
                      style: const TextStyle(fontSize: 12, color: Colors.pink),
                    ),
                  ),
                  const Gap(10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                    child: MarkdownBody(
                      data: '${currentIndex + 1}. $currentQuestion',
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(fontSize: 18),
                        listIndent: 32.0,
                      ),
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        bool isSelected = (selectedResponse == options[index]);
                        return GestureDetector(
                          onTap: () {
                            context.read<SurveyBloc>().add(
                                  UpdateResponse(
                                    questionIndex: currentIndex,
                                    response: options[index],
                                  ),
                                );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (index >= gradientColors.length - 2
                                      ? Colors.grey[600]
                                      : Colors.pink[300])
                                  : gradientColors[index],
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 30),
                                Text(
                                  options[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const Gap(25),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          onPressed: currentIndex > 0
                              ? () {
                                  context
                                      .read<SurveyBloc>()
                                      .add(PreviousQuestion());
                                }
                              : null,
                          icon: Icon(
                            Icons.arrow_left,
                            color: (currentIndex > 0)
                                ? Colors.grey[700]
                                : Colors.grey,
                          ),
                          label: Text(
                            "Previous  ",
                            style: TextStyle(
                              color: (currentIndex > 0)
                                  ? Colors.grey[700]
                                  : Colors.grey,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: (currentIndex > 0)
                                  ? Colors.grey.shade700
                                  : Colors.grey,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 5),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        const Text(
                          '© 2025 ANU',
                          style: TextStyle(fontSize: 12),
                        ),
                        OutlinedButton.icon(
                          onPressed: (selectedResponse != null &&
                                  selectedResponse.isNotEmpty)
                              ? handleNext
                              : null,
                          icon: Text(
                            "  Next",
                            style: TextStyle(
                              color: (selectedResponse != null &&
                                      selectedResponse.isNotEmpty)
                                  ? Colors.pink
                                  : Colors.grey,
                            ),
                          ),
                          label: Icon(
                            Icons.arrow_right,
                            color: (selectedResponse != null &&
                                    selectedResponse.isNotEmpty)
                                ? Colors.pink
                                : Colors.grey,
                            size: 25,
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 2,
                              color: (selectedResponse != null &&
                                      selectedResponse.isNotEmpty)
                                  ? Colors.pink
                                  : Colors.grey,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 5),
                            alignment: Alignment.centerRight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
