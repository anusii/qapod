/// SurveyEvent bloc used in QA App.
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

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SurveyEvent extends Equatable {
  const SurveyEvent();
  @override
  List<Object> get props => [];
}

/// Initialize the survey with an ordered list of questions.

class InitializeSurvey extends SurveyEvent {
  final List<String> questions;
  const InitializeSurvey({required this.questions});
  @override
  List<Object> get props => [questions];
}

/// Update the response for a specific question.

class UpdateResponse extends SurveyEvent {
  final int questionIndex;
  final String response;
  const UpdateResponse({required this.questionIndex, required this.response});
  @override
  List<Object> get props => [questionIndex, response];
}

/// Move to the next question.

class NextQuestion extends SurveyEvent {}

/// Move to the previous question.

class PreviousQuestion extends SurveyEvent {}

/// Set the current question index explicitly.

class SetQuestionIndex extends SurveyEvent {
  final int newIndex;
  const SetQuestionIndex(this.newIndex);
  @override
  List<Object> get props => [newIndex];
}

/// Clear all survey responses.

class ClearSurvey extends SurveyEvent {
  const ClearSurvey();
  @override
  List<Object> get props => [];
}

/// --- SURVEY STATE ---

class SurveyState extends Equatable {
  /// The original ordered list of questions.
  
  final List<String> questionList;

  /// A map where each key is a question and its value is the answer (or null if unanswered).
  
  final Map<String, String?> responses;

  /// The index (in the ordered list) of the currently displayed question.
  
  final int currentQuestionIndex;

  /// The survey filename.
  
  final String surveyFilename;
  const SurveyState({
    required this.questionList,
    required this.responses,
    required this.currentQuestionIndex,
    required this.surveyFilename,
  });
  SurveyState copyWith({
    List<String>? questionList,
    Map<String, String?>? responses,
    int? currentQuestionIndex,
    String? surveyFilename,
  }) {
    return SurveyState(
      questionList: questionList ?? this.questionList,
      responses: responses ?? this.responses,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      surveyFilename: surveyFilename ?? this.surveyFilename,
    );
  }

  @override
  List<Object?> get props =>
      [questionList, responses, currentQuestionIndex, surveyFilename];
}

/// --- SURVEY BLOC ---

class SurveyBloc extends Bloc<SurveyEvent, SurveyState> {
  final SharedPreferences sharedPreferences;
  final String surveyFilename;
  SurveyBloc({required this.surveyFilename, required this.sharedPreferences})
      : super(SurveyState(
          questionList: const [],
          responses: const {},
          currentQuestionIndex: 0,
          surveyFilename: surveyFilename,
        )) {
    on<InitializeSurvey>((event, emit) {
      final List<String> qList = event.questions;
      final Map<String, String?> responsesMap = {for (var q in qList) q: null};
      emit(SurveyState(
        questionList: qList,
        responses: responsesMap,
        currentQuestionIndex: 0,
        surveyFilename: state.surveyFilename,
      ));
    });
    on<UpdateResponse>((event, emit) {
      final Map<String, String?> newResponses = Map.from(state.responses);
      if (event.questionIndex >= 0 &&
          event.questionIndex < state.questionList.length) {
        final String question = state.questionList[event.questionIndex];
        newResponses[question] = event.response;
      }
      emit(state.copyWith(responses: newResponses));
    });
    on<NextQuestion>((event, emit) {
      final int maxIndex = state.questionList.length - 1;
      if (state.currentQuestionIndex < maxIndex) {
        emit(state.copyWith(
            currentQuestionIndex: state.currentQuestionIndex + 1));
      }
    });
    on<PreviousQuestion>((event, emit) {
      if (state.currentQuestionIndex > 0) {
        emit(state.copyWith(
            currentQuestionIndex: state.currentQuestionIndex - 1));
      }
    });
    on<SetQuestionIndex>((event, emit) {
      final int maxIndex = state.questionList.length - 1;
      final int safeIndex = event.newIndex < 0
          ? 0
          : (event.newIndex > maxIndex ? maxIndex : event.newIndex);
      emit(state.copyWith(currentQuestionIndex: safeIndex));
    });
    on<ClearSurvey>((event, emit) {
      final Map<String, String?> cleared = {
        for (var q in state.questionList) q: null
      };
      emit(SurveyState(
        questionList: state.questionList,
        responses: cleared,
        currentQuestionIndex: 0,
        surveyFilename: state.surveyFilename,
      ));
    });
  }
}
