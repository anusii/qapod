/// File row used in QA App.
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
import 'package:qapod/constants/style.dart';
import 'package:qapod/widgets/dialog/show_file_content.dart';

/// A widget that displays a list of files. When a file row is tapped,
/// a dialog is shown with the file's content.

class FileRow extends StatefulWidget {
  final List<String> files;

  const FileRow({
    required this.files,
    super.key,
  });

  @override
  State<FileRow> createState() => _FileRowState();
}

class _FileRowState extends State<FileRow> {
  @override
  Widget build(BuildContext context) {
    if (widget.files.isEmpty) {
      return const Text('No files available.');
    }

    return Column(
      children: widget.files.map((file) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: InkWell(
            onTap: () => showFileContent(file, context),
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file),
                horizontalMediumSpace(),
                Text(
                  file,
                  style: textStyle,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
