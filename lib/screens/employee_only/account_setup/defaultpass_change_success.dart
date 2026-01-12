import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';
import 'package:draft_screens/screens/all_logins/signin_screen.dart';

class PasswordSuccessScreen2 extends StatefulWidget {
  const PasswordSuccessScreen2({super.key});

  @override
  State<PasswordSuccessScreen2> createState() => _PasswordSuccessScreen2State();
}

class _PasswordSuccessScreen2State extends State<PasswordSuccessScreen2> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.appBarColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back button 
              Container(
                height: 80,
                alignment: Alignment.center,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  padding:EdgeInsets.only(left: 30),
                  onPressed: () {
                    // Navigate back to SignInScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ),
                    );
                  },
                ),
              ),

              // Spacer
              const Expanded(child: SizedBox()),

              // Title 
              Container(
                height: 80,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    // Subtitle removed - no white text
                  ],
                ),
              ),

              // Spacer for balance
              const Expanded(child: SizedBox()),

              // Empty container to balance layout
              SizedBox(
                width: 48, 
                height: 80,
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top section with background image 
            Container(
              height: 200, // fixed height
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
                          padding: const EdgeInsets.fromLTRB(25.0, 60.0, 25.0, 20.0),
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
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grayColor,
              ),
            ),
          ),
          const SizedBox(height: 60),

          // Back to login button
          SizedBox(
            width: 350,
            child: ElevatedButton(
              onPressed: () {
                // Navigate back to SignInScreen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.grayColor,
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
                'Back to login',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),

          // Flexible spacer to push content up
          Flexible(
            child: Container(),
          ),
        ],
      ),
    );
  }
}