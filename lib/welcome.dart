/// A Welcome Page for QA App.
///
// Time-stamp: <Wednesday 2025-04-16 19:37:41 +1000 Graham Williams>
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

import 'package:shared_preferences/shared_preferences.dart';

import 'package:qapod/constants/secrets.dart';
import 'package:qapod/questionnaire/consent.dart';
import 'package:qapod/utils/format_preferred_name.dart';
import 'package:qapod/widgets/drawer/side_drawer.dart';
import 'package:qapod/widgets/page/credentials_page.dart';
import 'package:qapod/widgets/gradient_icon.dart';
import 'package:qapod/widgets/image/image.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String? preferredName;
  String? username;
  String? password;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      preferredName = prefs.getString('qapod_preferredName');
      username = prefs.getString('qapod_username');
      password = prefs.getString('qapod_password');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Compute the welcome text.

    final welcomeText = (preferredName == null || preferredName!.isEmpty)
        ? "Welcome!"
        : "Welcome ${formatPreferredName(preferredName!)}!";

    // Check if all credentials are present.

    final bool allCredentialsPresent =
        (username != null && username!.isNotEmpty) &&
            (password != null && password!.isNotEmpty) &&
            (preferredName != null && preferredName!.isNotEmpty);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,

      // Overriding the default hamburger icon: fade to grey, smaller size.

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: GradientIcon(
                icon: Icons.menu,
                size: 40.0,
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.grey.shade50],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),

        title: iconImage, // Our icon
      ),

      drawer: SideDrawer(scaffoldKey: scaffoldKey),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/title_dot_one.png',
                          width: 325,
                          fit: BoxFit.fitWidth,
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Text(
                              welcomeText,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: Colors.pink,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        MarkdownBody(
                          selectable: true,
                          data:
                              "You've been invited to participate in this survey.",
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 8),

                        MarkdownBody(
                          selectable: true,
                          data:
                              "The focus of the survey is to demonstrate a survey-based pods app.",
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 8),

                        MarkdownBody(
                          selectable: true,
                          data:
                              'The survey should take 10-20 minutes to complete.',
                          styleSheet: MarkdownStyleSheet(
                            p: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // If credentials are present, show the "Continue" button.

                        if (allCredentialsPresent)
                          Center(
                            child: SizedBox(
                              width: 260,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  if (!mounted) return;

                                  final storedUsername =
                                      prefs.getString('qapod_username') ?? "";
                                  final storedPassword =
                                      prefs.getString('qapod_password') ?? "";

                                  // If credentials are valid, schedule navigation to ConsentScreen.

                                  if (storedUsername == expectedUsername &&
                                      storedPassword == expectedPassword) {
                                    if (!mounted) return;
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const ConsentScreen()),
                                      );
                                    });
                                  } else {
                                    // If credentials are invalid, schedule showing the error dialog.

                                    if (!mounted) return;
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      showDialog(
                                        context: context,
                                        builder: (dialogCtx) {
                                          return AlertDialog(
                                            title: const Text(
                                                "Registration Error"),
                                            content: const Text(
                                              "Your registration details are not recognised.\n\n"
                                              "Please contact the research team for assistance.",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(dialogCtx),
                                                child: const Text("OK"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(
                                      color: Colors.pink, width: 2),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  'Continue   ►',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ),
                              ),
                            ),
                          ),

                        // If account info is missing, show a message + Register button.

                        if (!allCredentialsPresent)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Center(
                              child: SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Before',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                ' you begin the survey please record the registration details '
                                                'you have been provided with:',
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      width: 300,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  const CredentialsPage(),
                                            ),
                                          )
                                              .then((_) {
                                            _loadCredentials();
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                            color: Colors.pink,
                                            width: 2,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          "Register",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bottom image.
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Image.asset(
                      'assets/images/bottom_dot_one.png',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
