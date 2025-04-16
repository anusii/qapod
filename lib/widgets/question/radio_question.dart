/// RadioQuestion widget used in QA App.
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

import 'package:qapod/widgets/button/normal_elevated_button.dart';
import 'package:qapod/widgets/title/title.dart';

class RadioQuestion extends StatelessWidget {
  final String question;
  final List<String> options;
  final int? selected;
  final void Function(int?) onChanged;

  const RadioQuestion(
    this.question,
    this.options,
    this.selected,
    this.onChanged, {
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        leftAlignedBoldString(question),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  for (int i = 0; i < options.length; i++)
                    RadioListTile(
                      title: Text(options[i]),
                      value: i,
                      groupValue: selected,
                      onChanged: (val) {
                        onChanged(val);
                      },
                    ),
                ],
              ),
            ),
            NormalElevatedButton(
              onPressed: () {
                onChanged(null);
              },
              buttonStr: 'Reset',
            ),
          ],
        ),
      ],
    );
  }
}
