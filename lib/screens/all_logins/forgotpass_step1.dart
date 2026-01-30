import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';
import 'package:draft_screens/constants/app_bars.dart';
import 'package:draft_screens/constants/buttons/elevated_buttons.dart';

import '../all_logins/forgotpass_step2.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Track email value
  String _emailValue = '';

  // Track if email doesn't exist
  bool _showEmailError = false;

  // Hardcoded correct email
  static const String _correctEmail = 'employee@gmail.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBars.appBarWithSubtitle(
        context: context,
        title: 'Reset Password',
        subtitle: 'Add your email 1/3',
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25.0, 120.0, 25.0, 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Instruction text
                      SizedBox(
                        width: 450,
                        child: Text(
                          'We will email you a link to reset your password.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Email input field
                      SizedBox(
                        width: 450,
                        child: TextField(
                          decoration: InputDecoration(
                            label: const Text('Email'),
                            hintText: 'Enter Email',
                            hintStyle: const TextStyle(color: Colors.black26),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.borderColor,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.borderColor,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _emailValue = value;
                              _showEmailError = false;
                            });
                          },
                        ),
                      ),

                      // Error message if email doesn't exist
                      if (_showEmailError)
                        SizedBox(
                          width: 450,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Email does not exist',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 40),

                      // Send button
                      SizedBox(
                        width: 350,
                        child: CustomButtons.conditionalValidationButton(
                          context: context,
                          text: 'Send',
                          condition: _emailValue == _correctEmail,
                          onSuccess: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const VerifyEmailScreen(),
                              ),
                            );
                          },
                          onFailure: () {
                            setState(() {
                              _showEmailError = true;
                            });
                          },
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
    );
  }
}
