import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';
import '../all_logins/forgotpass_step1.dart';

class CustomTextButtons {
  // Base text button style
  static ButtonStyle _baseTextButtonStyle({
    EdgeInsetsGeometry? padding,
    Color? foregroundColor,
  }) {
    return TextButton.styleFrom(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      foregroundColor: foregroundColor,
    );
  }

  // 
  // 1. NAVIGATION TEXT BUTTONS
  // 

  /// Text button that navigates to a screen
  static Widget navigationTextButton({
    required BuildContext context,
    required String text,
    required Widget destination,
    Color color = AppColors.primaryColor,
    FontWeight fontWeight = FontWeight.bold,
    double fontSize = 14,
    bool usePush = true,
  }) {
    return TextButton(
      onPressed: () {
        if (usePush) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      style: _baseTextButtonStyle(),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: fontWeight,
          color: color,
          fontSize: fontSize,
        ),
      ),
    );
  }

  //
  // 2. ACTION TEXT BUTTONS
  //

  /// Cancel button that closes dialog/popup
  static Widget cancelButton({
    required BuildContext context,
    String text = 'Cancel',
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w500,
    double fontSize = 16,
    EdgeInsetsGeometry? padding,
  }) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(),
      style: _baseTextButtonStyle(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        foregroundColor: color,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  /// Gray cancel button (specific use case)
  static Widget grayCancelButton({
    required BuildContext context,
    String text = 'Cancel',
  }) {
    return cancelButton(
      context: context,
      text: text,
      color: AppColors.grayColor,
    );
  }

  /// Logout button (red color)
  static Widget logoutButton({
    required BuildContext context,
    required VoidCallback onLogout,
    String text = 'Logout',
  }) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
        onLogout(context);
      },
      style: _baseTextButtonStyle(),
      child: Text(
        text,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }

  // 
  // 3. ACTION BUTTONS WITH CUSTOM ACTIONS
  // 

  /// Action button with custom callback
  static Widget actionButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    Color color = AppColors.primaryColor,
    FontWeight fontWeight = FontWeight.bold,
    double fontSize = 16,
    EdgeInsetsGeometry? padding,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: _baseTextButtonStyle(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
      ),
    );
  }

  /// Delete action button
  static Widget deleteButton({
    required BuildContext context,
    required VoidCallback onDelete,
    Color color = AppColors.primaryColor,
  }) {
    return actionButton(
      context: context,
      text: 'Delete',
      onPressed: onDelete,
      color: color,
    );
  }

  /// Update action button
  static Widget updateButton({
    required BuildContext context,
    required VoidCallback onUpdate,
    Color color = AppColors.primaryColor,
  }) {
    return actionButton(
      context: context,
      text: 'Update',
      onPressed: onUpdate,
      color: color,
    );
  }

  /// View action button
  static Widget viewButton({
    required BuildContext context,
    required VoidCallback onView,
    Color color = AppColors.primaryColor,
  }) {
    return actionButton(
      context: context,
      text: 'View',
      onPressed: onView,
      color: color,
    );
  }

  /// Track action button
  static Widget trackButton({
    required BuildContext context,
    required VoidCallback onTrack,
    Color color = AppColors.primaryColor,
  }) {
    return actionButton(
      context: context,
      text: 'Track',
      onPressed: onTrack,
      color: color,
    );
  }

  /// Approve action button (green)
  static Widget approveButton({
    required BuildContext context,
    required VoidCallback onApprove,
    Color color = Colors.green,
  }) {
    return actionButton(
      context: context,
      text: 'Approve',
      onPressed: onApprove,
      color: color,
    );
  }

  /// Reject action button (red)
  static Widget rejectButton({
    required BuildContext context,
    required VoidCallback onReject,
    Color color = Colors.red,
  }) {
    return actionButton(
      context: context,
      text: 'Reject',
      onPressed: onReject,
      color: color,
    );
  }

  // 
  // 4. SPECIAL USE CASES
  // 

  /// Forgot password button
  static Widget forgotPasswordButton({
    required BuildContext context,
    Color color = AppColors.grayColor,
  }) {
    return navigationTextButton(
      context: context,
      text: 'Forgot password?',
      destination: const ForgotPasswordScreen(),
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
  }
}