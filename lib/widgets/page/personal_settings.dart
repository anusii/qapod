/// PersonalSettings widget used in QA App.
///
// Time-stamp: <Wednesday 2025-04-16 20:29:39 +1000 Graham Williams>
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

import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:qapod/constants/secrets.dart';
import 'package:qapod/questionnaire/welcome_back.dart';
import 'package:qapod/welcome.dart';

class PersonalSettings extends StatefulWidget {
  const PersonalSettings({super.key});

  @override
  State<PersonalSettings> createState() => _PersonalSettingsState();
}

class _PersonalSettingsState extends State<PersonalSettings> {
  String? username;
  String? password;
  String? preferredName;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('qapod_username');
      password = prefs.getString('qapod_password');
      preferredName = prefs.getString('qapod_preferredName');
    });
  }

  Future<void> _clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('qapod_username');
    await prefs.remove('qapod_password');
    await prefs.remove('qapod_preferredName');

    setState(() {
      username = null;
      password = null;
      preferredName = null;
    });

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  Future<void> _showUpdateDialog() async {
    final usernameController = TextEditingController(text: username ?? "");
    final passwordController = TextEditingController(text: password ?? "");
    final preferredNameController =
        TextEditingController(text: preferredName ?? "");

    final updated = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        bool localShowPassword = false;
        return StatefulBuilder(
          builder: (ctx, setStateDialog) {
            return AlertDialog(
              title: const Text("Update Details"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(labelText: "Username"),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            localShowPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setStateDialog(() {
                              localShowPassword = !localShowPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: !localShowPassword,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: preferredNameController,
                      decoration:
                          const InputDecoration(labelText: "Preferred Name"),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final newUsername = usernameController.text.trim();
                    final newPassword = passwordController.text.trim();

                    // Validate credentials against expected values.

                    if (newUsername != expectedUsername ||
                        newPassword != expectedPassword) {
                      if (!mounted) return;
                      // Use the State's context (captured as currentContext) rather than dialogContext.

                      final currentContext = context;
                      await showDialog(
                        context: currentContext,
                        builder: (BuildContext errorDialogContext) {
                          return AlertDialog(
                            title: const Text("Invalid Credentials"),
                            content: const Text(
                              "The username or password you entered doesn't match our records.\nPlease check your details carefully and contact the research team if you continue to experience issues.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(errorDialogContext).pop();
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );

                      return;
                    }

                    // If credentials are valid, proceed with update.

                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('qapod_username', newUsername);
                    await prefs.setString('qapod_password', newPassword);
                    await prefs.setString(
                      'qapod_preferredName',
                      preferredNameController.text.trim(),
                    );

                    if (!mounted) return;
                    // Use the State's context to close the update dialog.

                    Navigator.pop(context, true);
                  },
                  child: const Text("Update"),
                ),
              ],
            );
          },
        );
      },
    );

    if (updated == true && mounted) {
      await _loadCredentials();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool allCredentialsPresent =
        (username != null && username!.isNotEmpty) &&
            (password != null && password!.isNotEmpty) &&
            (preferredName != null && preferredName!.isNotEmpty);

    String passwordDisplay;
    if (password == null || password!.isEmpty) {
      passwordDisplay = "Not set";
    } else {
      passwordDisplay = _showPassword ? password! : "******";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text('Account Details'),
        ),
        elevation: 0,
        toolbarHeight: 125,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0),
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.grey,
                size: 40,
              ),
              padding: EdgeInsets.zero,
              onPressed: () async {
                final navigator = Navigator.of(context);
                final prefs = await SharedPreferences.getInstance();
                if (!mounted) return;

                final username = prefs.getString('qapod_username') ?? "";
                final password = prefs.getString('qapod_password') ?? "";

                if (username == expectedUsername &&
                    password == expectedPassword) {
                  navigator.pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const WelcomeBackScreen(),
                    ),
                  );
                } else {
                  navigator.pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Username:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  username ?? "Not set",
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Password:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SelectableText(
                        passwordDisplay,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey.shade700,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  "Preferred Name:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  (preferredName == null || preferredName!.isEmpty)
                      ? "Not set"
                      : preferredName!,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (allCredentialsPresent)
                      ElevatedButton(
                        onPressed: _clearCredentials,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.red, width: 2),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Clear Details",
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      ),
                    if (allCredentialsPresent) const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _showUpdateDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.blue, width: 2),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Update Details",
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Support:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Gap(5),
                const Text(
                    'If you are experiencing any issues with the app, or need any support please contact, hanna.suominen@anu.edu.au'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
