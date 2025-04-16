/// Credentials Page used in QA App.
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

import 'package:qapod/constants/secrets.dart';
import 'package:qapod/welcome.dart';
import 'package:qapod/questionnaire/welcome_back.dart'; // Assuming you have this screen

class CredentialsPage extends StatefulWidget {
  const CredentialsPage({super.key});

  @override
  State<CredentialsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends State<CredentialsPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _preferredNameController =
      TextEditingController();

  // Simulated method for checking credentials (replace with your own validation logic).

  Future<bool> validateCredentials(String username, String password) async {
    // Simulate an API check for username/password validation
    // For example, return true if username = 'admin' and password = 'password'

    return username == expectedUsername && password == expectedPassword;
  }

  Future<void> saveCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('qapod_username', _usernameController.text);
    await prefs.setString('qapod_password', _passwordController.text);
    await prefs.setString(
        'qapod_preferredName', _preferredNameController.text);
  }

  Future<Map<String, String?>> getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'qapod_username': prefs.getString('qapod_username'),
      'qapod_password': prefs.getString('qapod_password'),
      'qapod_preferredName': prefs.getString('qapod_preferredName'),
    };
  }

  Future<void> handleSaveCredentials() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    // Step 1: Validate credentials.

    bool isValid = await validateCredentials(username, password);

    if (!isValid) {
      // Show an error dialog if credentials are incorrect.

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text("Invalid Credentials"),
            content: const Text(
                "The username or password is incorrect.Please check and try again.\nIf you still encounter issues, please contact the research team."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    // Step 2: Save the credentials after validation.

    await saveCredentials();

    // Ensure we're still in the widget tree before proceeding.

    if (!mounted) return;

    // Step 3: Show success message and navigate to the appropriate screen.

    scaffoldMessenger.showSnackBar(
      const SnackBar(content: Text("Successfully registered")),
    );

    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('qapod_username');
    final savedPassword = prefs.getString('qapod_password');
    final savedPreferredName = prefs.getString('qapod_preferredName');

    // Navigate to different screens based on whether the user has credentials.

    if (savedUsername != null &&
        savedPassword != null &&
        savedPreferredName != null) {
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const WelcomeBackScreen()),
      );
    } else {
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _preferredNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Credentials"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _preferredNameController,
                decoration: const InputDecoration(
                  labelText: "Preferred Name",
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: handleSaveCredentials,
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
