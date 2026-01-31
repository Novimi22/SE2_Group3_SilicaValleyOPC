// lib/widgets/base_dashboard.dart
import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';
import 'package:draft_screens/constants/app_bars.dart';
import 'package:draft_screens/constants/buttons/text_buttons.dart';
import '../screens/all_logins/signin_screen.dart';

// Common welcome section
Widget buildWelcomeSection(String userName, BuildContext context, VoidCallback onLogoutTap) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    margin: const EdgeInsets.only(bottom: 30),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 2,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome,',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.grayColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            GestureDetector(
              onTap: onLogoutTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$userName!',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
          overflow: TextOverflow.visible,
          maxLines: 2,
        ),
      ],
    ),
  );
}

// 2. Common dashboard tile widget
Widget buildDashboardTile({
  required String imagePath,
  required String smallText,
  required String largeText,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.tileColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.circleColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.business, size: 35, color: Colors.white);
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  smallText,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.smallTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  largeText,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.largeTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// 3. Common logout confirmation dialog
void showLogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          CustomTextButtons.grayCancelButton(context: context),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              performLogout(context);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

// 4. Common logout action
void performLogout(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const SignInScreen()),
    (route) => false,
  );
}