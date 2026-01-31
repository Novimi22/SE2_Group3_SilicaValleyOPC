import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';
import 'package:draft_screens/constants/app_bars.dart';
import 'package:draft_screens/constants/buttons/elevated_buttons.dart';

import '../all_logins/passwordchange_success.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  // Track password values
  String _newPasswordValue = '';
  String _confirmPasswordValue = '';

  // Track if passwords should be visible or hidden
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  // Track validation errors
  bool _showNewPasswordError = false;
  bool _showConfirmPasswordError = false;

  // Check if both fields have text
  bool get _isResetPassButtonEnabled =>
      _newPasswordValue.isNotEmpty && _confirmPasswordValue.isNotEmpty;

  // Validate new password meets requirements
  bool get _isNewPasswordValid {
    if (_newPasswordValue.isEmpty) return true;

    // Check length
    if (_newPasswordValue.length < 8) return false;

    // Check for at least one number
    if (!RegExp(r'[0-9]').hasMatch(_newPasswordValue)) return false;

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(_newPasswordValue)) return false;

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(_newPasswordValue)) return false;

    // Check for at least one symbol
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_newPasswordValue)) {
      return false;
    }

    return true;
  }

  // Check if passwords match
  bool get _doPasswordsMatch {
    if (_newPasswordValue.isEmpty || _confirmPasswordValue.isEmpty) return true;
    return _newPasswordValue == _confirmPasswordValue;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBars.appBarWithSubtitle(
          context: context,
          title: 'Reset Password',
          subtitle: 'Create your password 3/3',
        ),
        body: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 100.0, 25.0, 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Instruction text
                        SizedBox(
                          width: 450,
                          child: Text(
                            'Create a new password for your account.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // New Password input field
                        SizedBox(
                          width: 450,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                obscureText: _obscureNewPassword,
                                obscuringCharacter: '*',
                                decoration: InputDecoration(
                                  label: const Text('New Password'),
                                  hintText: 'Enter New Password',
                                  hintStyle: const TextStyle(
                                    color: Colors.black26,
                                  ),
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
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureNewPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.grayColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureNewPassword =
                                            !_obscureNewPassword;
                                      });
                                    },
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _newPasswordValue = value;
                                    _showNewPasswordError = false;
                                  });
                                },
                              ),

                              // Gray helper text
                              if (_newPasswordValue.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Must be at least 8 characters.',
                                    style: TextStyle(
                                      color: AppColors.grayColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                              // Error message if password doesn't meet requirements
                              if (_showNewPasswordError && !_isNewPasswordValid)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
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
                                          'Password must be at least 8 characters, and contain 1 number, 1 uppercase, 1 lowercase, and 1 symbol',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        // Confirm Password input field
                        SizedBox(
                          width: 450,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                obscureText: _obscureConfirmPassword,
                                obscuringCharacter: '*',
                                decoration: InputDecoration(
                                  label: const Text('Confirm Password'),
                                  hintText: 'Enter Confirm Password',
                                  hintStyle: const TextStyle(
                                    color: Colors.black26,
                                  ),
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
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppColors.grayColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _confirmPasswordValue = value;
                                    _showConfirmPasswordError = false;
                                  });
                                },
                              ),

                              // Gray helper text
                              if (_confirmPasswordValue.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    'Both passwords must match.',
                                    style: TextStyle(
                                      color: AppColors.grayColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                              // Error message if passwords don't match
                              if (_showConfirmPasswordError &&
                                  !_doPasswordsMatch)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
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
                                          'Password mismatch',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Reset Password button
                        SizedBox(
                          width: 350,
                          child: CustomButtons.passwordResetButton(
                            context: context,
                            isEnabled: _isResetPassButtonEnabled,
                            isNewPasswordValid: _isNewPasswordValid,
                            passwordsMatch: _doPasswordsMatch,
                            onNewPasswordError: (showError) {
                              setState(() {
                                _showNewPasswordError = showError;
                              });
                            },
                            onConfirmPasswordError: (showError) {
                              setState(() {
                                _showConfirmPasswordError = showError;
                              });
                            },
                            successDestination: const PasswordSuccessScreen(),
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
      ),
    );
  }
}
