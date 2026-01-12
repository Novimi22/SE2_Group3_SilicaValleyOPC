import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';

import 'package:draft_screens/screens/owner_only/owner_landingpage.dart'; 
import 'package:draft_screens/screens/employee_only/employee_dashboard.dart';
import 'package:draft_screens/screens/all_logins/forgotpass_step1.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key}); 

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // REMOVED: GlobalKey for the Form widget since form validation is removed (for now?)
  // final _formSignInKey = GlobalKey<FormState>();
  
  // Boolean variable to track whether password should be visible or hidden
  // true = password is hidden (shows dots), false = password is visible
  bool _obscurePassword = true;
  
  // Variables to track what user types in email and password fields
  String _emailValue = '';
  String _passwordValue = '';
  
  // Variable to track if login credentials are incorrect
  bool _showLoginError = false;
  
  // for checking - Hardcoded correct credentials for both owner and employee (for now)
  // Map structure to store multiple credentials
  static const Map<String, Map<String, String>> _userCredentials = {
    'owner@gmail.com': {
      'password': 'Owner123!',
      'userType': 'owner',
    },
    'employee@gmail.com': {
      'password': 'Employee123!',
      'userType': 'employee',
    }
  };
  
  // Check if both fields are filled (for enabling/disabling login button)
  bool get _isLoginEnabled => _emailValue.isNotEmpty && _passwordValue.isNotEmpty;

  // This is the main build method that creates the UI
  // It runs every time the widget needs to be rebuilt (when setState() is called)
  @override
  Widget build(BuildContext context) {
    // Scaffold is the basic material design layout structure
    // It provides app bars, drawers, snackbars, etc.
    return Scaffold(
      // SafeArea makes sure content isn't hidden by device notches or status bars
      body: SafeArea(
        child: Column(
          children: [
            // Top section with background image
            Container(
              height: 200, // fixed height
              width: double.infinity,  // Takes full available width
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg2.png'),  
                  fit: BoxFit.cover,  // image cover the entire container
                ),
              ),
            ),
            
            // White form container
            // Expanded makes this widget take all available vertical space
            Expanded(
              child: Material(
                // TODO: fix rounded top corners
                borderRadius: const BorderRadius.only( 
                  topLeft: Radius.circular(40.0),   
                  topRight: Radius.circular(40.0),  
                ),
                color: Colors.white,  
                clipBehavior: Clip.antiAlias,
                // LayoutBuilder gives us information about available space
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // 'constraints' tells us how much space is available
                    return SingleChildScrollView(
                      // Allows scrolling if content is taller than available space
                      child: ConstrainedBox(
                        // Forces minimum height to be the available height
                        // This helps with layout when content is shorter than screen
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        // Padding adds space inside the widget
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 20.0),
                          // Left: 25, Top: 40, Right: 25, Bottom: 20
                          // Calls separate method to build the form
                          child: _buildForm(constraints.maxHeight),
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

  // Separate method to build the form
  Widget _buildForm(double availableHeight) {
    // IntrinsicHeight makes Column try to be as tall as its tallest child
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Welcome!',
            style: TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.w900,  
              color: Colors.black,  
            ),
          ),
    
          const SizedBox(height: 10),
          
          // Subtitle text
          Text(
            'Sign into your account',
            style: TextStyle(
              fontSize: 14, 
              color: AppColors.grayColor, 
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
                hintStyle: const TextStyle(
                  color: Colors.black26,  
                ),
                
                // Border style when field is focused/active
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.borderColor, 
                  ),
                  borderRadius: BorderRadius.circular(10),  
                ),

                // Border style when field is not focused
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.borderColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),

                // Space inside the field (between text and borders)
                contentPadding: const EdgeInsets.all(16),
              ),
              
              // ADDED: Track what user types in email field
              onChanged: (value) {
                setState(() {
                  _emailValue = value;
                  // Hide error message when user starts typing again
                  _showLoginError = false;
                });
              },
            ),
          ),
          const SizedBox(height: 25),  
          
          // Password field 
          SizedBox(
            width: 450, 
            child: TextField(
              obscureText: _obscurePassword,  // Hides text with dots if true
              obscuringCharacter: '*',  // Character to show instead of text
              decoration: InputDecoration(
                label: const Text('Password'),
                hintText: 'Enter Password',  
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
                  // if _obscurePassword is true, show closed eye, else open eye
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.grayColor,
                  ),
                  onPressed: () {
                    // setState tells Flutter to rebuild the widget with new state
                    setState(() {
                      _obscurePassword = !_obscurePassword;  // Toggle true/false
                      // ! means "not" - turns true to false, false to true
                    });
                  },
                ),
              ),
              
              //Track what user types in password field
              onChanged: (value) {
                setState(() {
                  _passwordValue = value;
                  // Hide error message when user starts typing again
                  _showLoginError = false;
                });
              },
            ),
          ),
          
          // Show error message if login credentials are incorrect 
          if (_showLoginError)
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
                        'Email or password is invalid. Try again.',
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
          
          // Sign in button 
          SizedBox(
            width: 350, 
            child: ElevatedButton(
              // Button is only enabled when both fields have text
              onPressed: _isLoginEnabled ? () {
                // Check credentials against hardcoded values for both owner and employee
                if (_userCredentials.containsKey(_emailValue) &&
                    _userCredentials[_emailValue]!['password'] == _passwordValue) {
                  
                  // Get user type from credentials map
                  final userType = _userCredentials[_emailValue]!['userType'];
                  
                  if (userType == 'owner') {
                    // Owner goes to OwnerLandingPage
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OwnerLandingPage(),
                      ),
                    );
                  } else if (userType == 'employee') {
                    // Employee goes directly to EmployeeDashboardScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmployeeDashboardScreen(),
                      ),
                    );
                  }
                } else {
                  // Credentials are incorrect - show error message
                  setState(() {
                    _showLoginError = true;
                  });
                }
              } : null, // null means button is disabled
              
              style: ElevatedButton.styleFrom(
                backgroundColor: _isLoginEnabled ? AppColors.primaryColor : Colors.grey[400], 
                foregroundColor: Colors.white,  
                elevation: 5.0,  // Shadow depth
                // Internal padding (space inside button)
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,  // Left and right
                  vertical: 18,    // Top and bottom
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),  
                ),
              ),
              // Button text
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          
          // Flexible spacer - takes available space and pushes content down
          // This makes "Forgot password?" stay at bottom
          Flexible(
            child: Container(),  // Empty container that expands
          ),
          
          // Forgot password link at the bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 20),  // 20px from bottom
            child: Center(
              child: TextButton(
                onPressed: () { 
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                },
                child: Text(
                  'Forgot password?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,  
                    color: AppColors.grayColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}