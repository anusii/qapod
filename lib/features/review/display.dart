/// Review panel display used in QA App.
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

import 'package:qapod/constants/layout.dart';
import 'package:qapod/widgets/file/file_row.dart';
import 'package:qapod/widgets/title/title.dart';

class ViewDisplay extends StatefulWidget {
  final List<String> files;

  const ViewDisplay({
    required this.files,
    super.key,
  });

  @override
  State<ViewDisplay> createState() => _ViewDisplayState();
}

class _ViewDisplayState extends State<ViewDisplay> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pageTitle('Files'),
          verticalMediumSpace(),
          if (widget.files.isEmpty)
            const Text('No files available.')
          else
            FileRow(files: widget.files)
        ],
      ),
    );
  }
}
