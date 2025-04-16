/// Clean number dot method used in QA App.
///
// Time-stamp: <Wednesday 2025-04-16 20:16:05 +1000 Graham Williams>
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

/// Helper function to clean the question by removing the number and dot.
/// Example: "1. I am feeling well today." => "I am feeling well today."

String cleanNumberDot(String question) {
  // Remove number and dot at the start of the question using regex.
  return question.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim();
}
