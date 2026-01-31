import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';
import 'package:draft_screens/constants/app_bars.dart';
import 'package:draft_screens/constants/buttons/elevated_buttons.dart';

import 'package:draft_screens/screens/all_logins/signin_screen.dart';

class PasswordSuccessScreen extends StatefulWidget {
  const PasswordSuccessScreen({super.key});

  @override
  State<PasswordSuccessScreen> createState() => _PasswordSuccessScreenState();
}

class _PasswordSuccessScreenState extends State<PasswordSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBars.defaultAppBar(
          context: context,
          title: 'Reset Password',
          destination: const SignInScreen(),
          navigationType: NavigationType.pushReplacement,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Top section with background image
              Container(
                height: 200,
                width: double.infinity, // Takes full available width
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg2.png'),
                    fit: BoxFit.cover, // image cover the entire container
                  ),
                ),
              ),

              // White form container
              Expanded(
                child: Material(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  color: Colors.white,
                  clipBehavior: Clip.antiAlias,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              25.0,
                              60.0,
                              25.0,
                              20.0,
                            ),
                            child: _buildSuccessContent(constraints.maxHeight),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessContent(double availableHeight) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Green tick image
          Image.asset(
            'assets/images/password_success.png',
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 40),

          Text(
            'Password Changed!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Success message text
          SizedBox(
            width: 450,
            child: Text(
              'Password has been changed successfully.\nUse your new password to log in.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.grayColor),
            ),
          ),
          const SizedBox(height: 60),

          // Back to login button
          SizedBox(
            width: 350,
            child: CustomButtons.backToLoginButton(
              context: context,
              backgroundColor: AppColors.primaryColor,
            ),
          ),

          // Flexible spacer to push content up
          Flexible(child: Container()),
        ],
      ),
    );
  }
}
