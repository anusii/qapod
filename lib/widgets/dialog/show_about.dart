/// Show about dialog used in QA App.
///
// Time-stamp: <Wednesday 2025-04-16 20:18:13 +1000 Graham Williams>
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

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:solidpod/solidpod.dart';

import 'package:qapod/constants/layout.dart';

Future<void> showAbout(BuildContext context, {String? webId}) async {
  final appInfo = await getAppNameVersion();

  if (context.mounted) {
    showAboutDialog(
      context: context,
      applicationLegalese: '© 2025 Software Innovation Institute ANU',
      applicationIcon: Image.asset(
        'assets/images/image.png',
        width: 100,
        height: 100,
      ),
      applicationName: appInfo.name,
      applicationVersion: appInfo.version,
      children: [
        SizedBox(
          // Limit the width of the about dialog box.

          width: 300,

          child: Column(
            children: [
              verticalMediumSpace(),
              const MarkdownBody(
                selectable: true,
                data: '''
**QA Pod App.**

**Authors**: Graham Williams, Zheyuan Xu.
''',
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
