/// Preferred name of saved credentials in app.
///
// Time-stamp: <Friday 2024-08-16 12:34:33 +1000 Graham Williams>
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
/// Authors: Graham Williams, Zheyuan Xu

library;

/// Helper function to format the preferred name:
/// first letter uppercase and the rest lowercase.

String formatPreferredName(String name) {
  // Trim leading/trailing spaces and split on whitespace.

  final parts = name.trim().split(RegExp(r'\s+'));

  if (parts.isEmpty) {
    // If somehow it's all spaces, just return empty.

    return '';
  } else if (parts.length == 1) {
    // Only one part => capitalize first letter, rest lower.

    final single = parts.first;
    if (single.length == 1) {
      return single.toUpperCase();
    } else {
      return single[0].toUpperCase() + single.substring(1).toLowerCase();
    }
  } else {
    // Two or more parts => capitalize each part.

    final capitalizedParts = parts.map((part) {
      if (part.isEmpty) return part;
      if (part.length == 1) {
        return part.toUpperCase();
      } else {
        return part[0].toUpperCase() + part.substring(1).toLowerCase();
      }
    }).toList();

    // Join them back with a space.

    return capitalizedParts.join(' ');
  }
}
