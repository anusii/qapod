/// Side drawer widget used in QA App.
///
// Time-stamp: <Wednesday 2025-04-16 19:38:16 +1000 Graham Williams>
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

import 'package:package_info_plus/package_info_plus.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_tooltip/markdown_tooltip.dart';

import 'package:qapod/constants/layout.dart';
import 'package:qapod/welcome.dart';
import 'package:qapod/widgets/page/consent_settings.dart';
import 'package:qapod/widgets/page/personal_settings.dart';
import 'package:qapod/widgets/image/image.dart';

class SideDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideDrawer({
    super.key,
    required this.scaffoldKey,
  });

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  String _appVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  /// Load appName and version from pubspec.yaml using package_info_plus.

  Future<void> _loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      // Combine version and buildNumber if desired, e.g. "0.0.6+4".

      _appVersion = '${info.version}+${info.buildNumber}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              /// Header: icon in center, close button top-right.

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 80,
                  child: Stack(
                    children: [
                      Center(child: iconImage),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 40,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// SETTINGS label.

              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    'SETTINGS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              /// 1) Personal settings.

              ListTile(
                title: const Text('Account details'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PersonalSettings(),
                    ),
                  );
                },
              ),
              const Divider(height: 2, color: Colors.black),

              /// 3) Consent settings.

              ListTile(
                title: const Text('Consent settings'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConsentSettings(),
                    ),
                  );
                },
              ),
              const Divider(height: 2, color: Colors.black),

              /// 2) Account details.

              // ListTile(
              //   title: const Text('Save location'),
              //   trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              //   onTap: () async {
              //     Navigator.pop(context);
              //     await Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => const AccountDetails(),
              //       ),
              //     );
              //   },
              // ),
              // const Divider(height: 2, color: Colors.black),

              /// 4) About the app.

              ListTile(
                title: const Text('About the app'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);

                  // Show an about dialog with appName, version, etc.

                  showAboutDialog(
                    context: context,
                    applicationIcon: iconImage,
                    applicationName: 'QA Pod Survey',
                    applicationVersion: 'Version ${_appVersion.split("+")[0]}',
                    applicationLegalese:
                        'Copyright © 2025 ANU\nApp License GPLv3\n',
                    children: [
                      MarkdownBody(
                        data: wordWrap('''

                          The **QA Pod** app is a survey to collect data for
                          secure and private storage.  The app was implemented
                          by the [Software Innovation Institute, Australian
                          National University](https://sii.anu.edu.au).

                          '''),
                      ),
                    ],
                  );
                },
              ),

              const Spacer(),

              /// Logout button.

              Center(
                child: SizedBox(
                  width: 250,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.grey, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    onPressed: () async {
                      // Example of your logout flow.

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WelcomeScreen()),
                      );
                    },
                    child: MarkdownTooltip(
                      message: '''

                    You can logout from your connection to the storage.

                    ''',
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              verticalMediumSpace(),
            ],
          ),
        ),
      ),
    );
  }
}
