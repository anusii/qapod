/// Check credentials Page used in QA App.
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

import 'package:shared_preferences/shared_preferences.dart';

import 'package:qapod/welcome.dart';
import 'package:qapod/widgets/page/credentials_page.dart';

class CheckCredentials extends StatefulWidget {
  const CheckCredentials({super.key});

  @override
  State<CheckCredentials> createState() => _CheckCredentialsState();
}

class _CheckCredentialsState extends State<CheckCredentials> {
  Future<bool> _loadCredentialsExist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('qapod_username');
    final password = prefs.getString('qapod_password');
    final preferredName = prefs.getString('qapod_preferredName');
    return (username != null && password != null && preferredName != null);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loadCredentialsExist(),
      builder: (context, snapshot) {
        // While waiting for the Future to complete, show a progress indicator.

        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // If an error occurred, display it.

        else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }
        // Once the Future completes, check the credentials.

        else {
          final credentialsExist = snapshot.data ?? false;
          if (!credentialsExist) {
            // If credentials are missing, show a message with a button.

            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Please enter your username, password, and preferred name.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                          builder: (_) => const CredentialsPage(),
                        ))
                            .then((_) {
                          // After returning, rebuild to re-check credentials.

                          setState(() {});
                        });
                      },
                      child: const Text("Enter Credentials"),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // If credentials exist, go to the WelcomeScreen.

            return const WelcomeScreen();
          }
        }
      },
    );
  }
}
