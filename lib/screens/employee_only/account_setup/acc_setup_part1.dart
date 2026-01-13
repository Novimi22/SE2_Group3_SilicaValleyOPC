import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';
import 'package:draft_screens/constants/app_bars.dart';

import '../account_setup/acc_setup_part2.dart';

class VerifyEmailScreen2 extends StatefulWidget {
  const VerifyEmailScreen2({super.key});

  @override
  State<VerifyEmailScreen2> createState() => _VerifyEmailScreen2State();
}

class _VerifyEmailScreen2State extends State<VerifyEmailScreen2> {

  // Track OTP values
  final List<String> _otpValues = ['', '', '', '', ''];
  final List<TextEditingController> _controllers = List.generate(
    5,
    (_) => TextEditingController(),
  );

  // Track if OTP is incorrect
  bool _showOtpError = false;

  // Hardcoded correct OTP (for testing)
  static const String _correctOtp = '12345';

  // Timer variables
  int _timerSeconds = 0;
  bool _timerStarted = false;

  // Check if all OTP fields have text
  bool get _isVerifyEnabled => _otpValues.every((value) => value.isNotEmpty);

  // Check if resend email is enabled
  bool get _isResendEnabled => _timerSeconds == 0;

  @override
  void dispose() {
    // Dispose controllers
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleOtpChange(int index, String value) {
    setState(() {
      _otpValues[index] = value;
      _showOtpError = false;
    });

    // Move to next field when typing
    if (value.isNotEmpty && index < 4) {
      FocusScope.of(context).nextFocus();
    }

    // Move to previous field when backspacing on empty field
    if (value.isEmpty && index > 0) {
      FocusScope.of(context).previousFocus();
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
        _startTimer();
      }
    });
  }

  void _resendEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Resending verification email...')),
    );

    // Start timer when Resend Email is tapped
    setState(() {
      _timerStarted = true;
      _timerSeconds = 30;
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBars.appBarWithSubtitle(
        context: context,
        title: 'Account Setup',
        subtitle: 'Verify your email 1/2',
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ScrollConfiguration(
                // This hides the scrollbar
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
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
                            'Your current default password requires to be changed.\n\nWe just sent a 5-digit verification code to\njuandelacruz@gmail.com, enter the OTP below.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Label for OTP
                        SizedBox(
                          width: 450,
                          child: Text(
                            'Code',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // OTP input boxes
                        SizedBox(
                          width: 450,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(5, (index) {
                              return SizedBox(
                                width: 60,
                                height: 60,
                                child: TextField(
                                  controller: _controllers[index],
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF19191B),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF19191B),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFCC9304),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  onChanged: (value) =>
                                      _handleOtpChange(index, value),
                                ),
                              );
                            }),
                          ),
                        ),

                        // Error message if OTP is incorrect
                        if (_showOtpError)
                          SizedBox(
                            width: 450,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Incorrect code',
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

                        // TODO: Use flexible container
                        const SizedBox(height: 40),

                        // Verify button
                        SizedBox(
                          width: 350,
                          child: ElevatedButton(
                            onPressed: _isVerifyEnabled
                                ? () {
                                    String enteredOtp = _otpValues.join('');
                                    if (enteredOtp == _correctOtp) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CreatePasswordScreen2(),
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        _showOtpError = true;
                                      });
                                    }
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isVerifyEnabled
                                  ? const Color(0xFFCC9304)
                                  : Colors.grey[400],
                              foregroundColor: Colors.white,
                              elevation: 5.0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Verify email',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Resend email text
                        SizedBox(
                          width: 450,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Haven\'t gotten the email yet? ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: _isResendEnabled ? _resendEmail : null,
                                  child: Text(
                                    'Resend email',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: _isResendEnabled
                                          ? const Color(0xFFCC9304)
                                          : const Color(0xFF9E9E9E),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // TODO: add flexible container like in sign in screen
                        // Timer at the bottom
                        const SizedBox(height: 150),
                        Text(
                          _timerStarted && _timerSeconds > 0
                              ? 'Resend in 0:${_timerSeconds.toString().padLeft(2, '0')}'
                              : '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.grayColor,
                          ),
                        ),
                      ],
                    ),
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
