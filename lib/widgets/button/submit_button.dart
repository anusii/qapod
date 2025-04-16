/// Submit buttob used in QA App.
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

import 'package:qapod/constants/colors.dart';
import 'package:qapod/widgets/dialog/show_warning.dart';

class SubmitButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String buttonStr;
  final String? webId;

  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.buttonStr,
    required this.webId,
  });

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.webId == null ? disabledColor : iconColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: widget.webId == null
            ? () {
                showWarning('Warning',
                    'Please first login in to upload survey!', context);
              }
            : () {
                widget.onPressed();
              },
        child: Text(
          widget.buttonStr,
        ),
      ),
    );
  }
}
