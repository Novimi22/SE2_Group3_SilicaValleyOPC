import 'package:flutter/material.dart';
import '../colors.dart';

import 'package:draft_screens/screens/all_logins/signin_screen.dart';

class CustomButtons {
  // Button style configuration
  static ButtonStyle _baseButtonStyle({
    Color? backgroundColor,
    Color? disabledColor,
    Color? foregroundColor = Colors.white,
    double elevation = 5.0,
    EdgeInsetsGeometry? padding,
    double borderRadius = 8,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? AppColors.primaryColor,
      disabledBackgroundColor: disabledColor ?? Colors.grey[400],
      foregroundColor: foregroundColor,
      elevation: elevation,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  //
  // 1. PRIMARY BUTTONS
  //

  /// Primary button with enabled/disabled state
  static Widget primaryButton({
    required BuildContext context,
    required String text,
    required VoidCallback? onPressed,
    bool isEnabled = true,
    Color? enabledColor,
    Color? disabledColor,
    EdgeInsetsGeometry? padding,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    double borderRadius = 8,
  }) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: _baseButtonStyle(
        backgroundColor: isEnabled
            ? (enabledColor ?? AppColors.primaryColor)
            : null,
        disabledColor: disabledColor,
        padding: padding,
        borderRadius: borderRadius,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      ),
    );
  }

  /// Primary button with validation logic (for forms)
  static Widget validationButton({
    required BuildContext context,
    required String text,
    required bool isEnabled,
    required VoidCallback onPressed,
    Color? enabledColor,
    EdgeInsetsGeometry? padding,
  }) {
    return primaryButton(
      context: context,
      text: text,
      onPressed: isEnabled ? onPressed : null,
      isEnabled: isEnabled,
      enabledColor: enabledColor,
      padding: padding,
    );
  }

  /// Primary button with custom validation logic
  static Widget conditionalValidationButton({
    required BuildContext context,
    required String text,
    required bool condition,
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
    Color? enabledColor,
  }) {
    return primaryButton(
      context: context,
      text: text,
      onPressed: condition ? onSuccess : onFailure,
      isEnabled: true,
      enabledColor: enabledColor,
    );
  }

  //
  // 2. NAVIGATION BUTTONS
  //

  /// Button that navigates to a screen
  static Widget navigationButton({
    required BuildContext context,
    required String text,
    required Widget destination,
    bool usePush = true,
    bool usePushReplacement = false,
    bool fullscreenDialog = false,
    Color? backgroundColor,
    EdgeInsetsGeometry? padding,
  }) {
    return primaryButton(
      context: context,
      text: text,
      onPressed: () {
        if (usePushReplacement) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => destination,
              fullscreenDialog: fullscreenDialog,
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => destination,
              fullscreenDialog: fullscreenDialog,
            ),
          );
        }
      },
      enabledColor: backgroundColor,
      padding: padding,
    );
  }

  /// Back to login button 
  static Widget backToLoginButton({
    required BuildContext context,
    Color backgroundColor = AppColors.primaryColor,
  }) {
    return navigationButton(
      context: context,
      text: 'Back to login',
      destination: const SignInScreen(),
      usePushReplacement: true,
      backgroundColor: backgroundColor,
    );
  }

  //
  // 3. FORM ACTION BUTTONS
  //

  /// OTP/Email verification button
  static Widget verifyButton({
    required BuildContext context,
    required bool isEnabled,
    required String enteredValue,
    required String correctValue,
    required Widget successDestination,
    required Function(bool) onError,
    String buttonText = 'Verify Email',
    Color verifyColor = const Color(0xFFCC9304),
  }) {
    return validationButton(
      context: context,
      text: buttonText,
      isEnabled: isEnabled,
      enabledColor: verifyColor,
      onPressed: () {
        if (enteredValue == correctValue) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => successDestination),
          );
        } else {
          onError(true);
        }
      },
    );
  }

  /// Password reset button with validation
  static Widget passwordResetButton({
    required BuildContext context,
    required bool isEnabled,
    required bool isNewPasswordValid,
    required bool passwordsMatch,
    required Function(bool) onNewPasswordError,
    required Function(bool) onConfirmPasswordError,
    required Widget successDestination,
  }) {
    return validationButton(
      context: context,
      text: 'Reset Password',
      isEnabled: isEnabled,
      onPressed: () {
        onNewPasswordError(!isNewPasswordValid);
        onConfirmPasswordError(!passwordsMatch);

        if (isNewPasswordValid && passwordsMatch) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => successDestination),
          );
        }
      },
    );
  }

  /// Login button with credential validation
  static Widget loginButton({
    required BuildContext context,
    required bool isEnabled,
    required String email,
    required String password,
    required Map<String, Map<String, dynamic>> credentials,
    required Function(bool) onLoginError,
    required Widget ownerDestination,
    required Widget employeeDestination,
  }) {
    return validationButton(
      context: context,
      text: 'Login',
      isEnabled: isEnabled,
      onPressed: () {
        if (credentials.containsKey(email) &&
            credentials[email]!['password'] == password) {
          final userType = credentials[email]!['userType'];

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  userType == 'owner' ? ownerDestination : employeeDestination,
            ),
          );
        } else {
          onLoginError(true);
        }
      },
    );
  }

  //
  // 4. DIALOG/ACTION BUTTONS
  //

  /// Generic dialog action button (Next, Create, Confirm, Apply)
  static Widget dialogActionButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
    Color backgroundColor = AppColors.primaryColor,
    double verticalPadding = 12,
    double horizontalPadding = 20,
    FontWeight fontWeight = FontWeight.w600,
    double borderRadius = 10,
  }) {
    return primaryButton(
      context: context,
      text: text,
      onPressed: onPressed,
      enabledColor: backgroundColor,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      fontWeight: fontWeight,
      borderRadius: borderRadius,
    );
  }

  /// Apply button for filters/sorting
  static Widget applyButton({
    required BuildContext context,
    required VoidCallback onApply,
  }) {
    return dialogActionButton(
      context: context,
      text: 'Apply',
      onPressed: onApply,
      verticalPadding: 12,
    );
  }

  /// Confirm button for actions
  static Widget confirmButton({
    required BuildContext context,
    required VoidCallback onConfirm,
    String text = 'Confirm',
    Color? backgroundColor,
  }) {
    return dialogActionButton(
      context: context,
      text: text,
      onPressed: onConfirm,
      backgroundColor: backgroundColor ?? AppColors.primaryColor,
      verticalPadding: 16,
    );
  }

  /// Next button for multi-step dialogs
  static Widget nextButton({
    required BuildContext context,
    required VoidCallback onNext,
  }) {
    return dialogActionButton(
      context: context,
      text: 'Next',
      onPressed: onNext,
      verticalPadding: 16,
    );
  }

  /// Create button for creation actions
  static Widget createButton({
    required BuildContext context,
    required VoidCallback onCreate,
    Color backgroundColor = AppColors.primaryColor,
  }) {
    return dialogActionButton(
      context: context,
      text: 'Create',
      onPressed: onCreate,
      backgroundColor: backgroundColor,
      verticalPadding: 16,
    );
  }

  //
  // 5. VALIDATION BUTTONS (with form validation)
  //

  /// Button with text field validation
  static Widget validatedButton({
    required BuildContext context,
    required String text,
    required String fieldValue,
    required String? Function(String) validator,
    required VoidCallback onSuccess,
    required Function(String) onError,
    Color backgroundColor = AppColors.primaryColor,
  }) {
    return primaryButton(
      context: context,
      text: text,
      onPressed: () {
        final validationError = validator(fieldValue);
        if (validationError != null) {
          onError(validationError);
        } else {
          onSuccess();
        }
      },
      enabledColor: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      fontWeight: FontWeight.w600,
    );
  }

  /// PO Number validation button
  static Widget poValidationButton({
    required BuildContext context,
    required String poNumber,
    required String correctPoNumber,
    required VoidCallback onSuccess,
    required Function(String) onError,
    String buttonText = 'Confirm',
  }) {
    return validatedButton(
      context: context,
      text: buttonText,
      fieldValue: poNumber,
      validator: (value) {
        if (value.isEmpty) return 'Please enter the Purchase Order Number';
        if (value != correctPoNumber) {
          return 'Purchase Order Number does not match';
        }
        return null;
      },
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// Form submission button with multiple field validation
  static Widget formSubmitButton({
    required BuildContext context,
    required String text,
    required List<String> requiredFields,
    required VoidCallback onSubmit,
    required Function(bool) onFormError,
    Color backgroundColor = AppColors.primaryColor,
  }) {
    return primaryButton(
      context: context,
      text: text,
      onPressed: () {
        final hasEmptyFields = requiredFields.any((field) => field.isEmpty);
        onFormError(hasEmptyFields);

        if (!hasEmptyFields) {
          onSubmit();
        }
      },
      enabledColor: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      fontWeight: FontWeight.w600,
    );
  }

  //
  // 6. SPECIFIC USE CASE BUTTONS
  //

  /// Delete account verification button with snackbar
static Widget deleteAccountVerifyButton({
  required BuildContext context,
  required bool isEnabled,
  required String enteredOtp,
  required String correctOtp,
  required String employeeName,
  required Widget destination,
  required Function(bool) onError,
}) {
  return primaryButton(
    context: context,
    text: 'Verify email',
    onPressed: isEnabled ? () {
      if (enteredOtp == correctOtp) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Deleted employee account: $employeeName',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        onError(true);
      }
    } : null,
    isEnabled: isEnabled,
    enabledColor: const Color(0xFFCC9304),
  );
}

  /// Employee creation button
  static Widget createEmployeeButton({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String email,
    String middleInitial = '',
    required Function(Map<String, String>) onEmployeeCreated,
    required Function(bool) onFormError,
    Color backgroundColor = const Color(0xFFCC9304),
  }) {
    return formSubmitButton(
      context: context,
      text: 'Create',
      requiredFields: [firstName, lastName, email],
      onSubmit: () {
        String middleInitialFormatted = middleInitial.isNotEmpty
            ? ' $middleInitial.'
            : '';
        String fullName = '$firstName$middleInitialFormatted $lastName';

        Map<String, String> newEmployee = {
          'name': fullName.trim(),
          'email': email,
          'role': 'Employee',
        };

        onEmployeeCreated(newEmployee);
      },
      onFormError: onFormError,
      backgroundColor: backgroundColor,
    );
  }
}
