// lib/widgets/base_dashboard.dart
import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';
import 'package:draft_screens/constants/app_bars.dart';
import 'package:draft_screens/constants/buttons/text_buttons.dart';
import '../screens/all_logins/signin_screen.dart';

// Data class for dashboard tiles
class DashboardTile {
  final String imagePath;
  final String smallText;
  final String largeText;
  final Function(BuildContext) onTap;

  DashboardTile({
    required this.imagePath,
    required this.smallText,
    required this.largeText,
    required this.onTap,
  });
}

// Base widget that both dashboards will extend
abstract class BaseDashboardScreen extends StatefulWidget {
  final String userName;
  final String appBarTitle;
  final List<DashboardTile> tiles;

  const BaseDashboardScreen({
    super.key,
    required this.userName,
    required this.appBarTitle,
    required this.tiles,
  });
}

// Base state class with all common functionality
abstract class BaseDashboardScreenState<T extends BaseDashboardScreen>
    extends State<T> {
  // Common welcome section
  Widget _buildWelcomeSection(String userName) {
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
                onTap: () {
                  _showLogoutConfirmation(context);
                },
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

  // Common tile builder
  Widget _buildDashboardTile({
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

  // Common logout dialog
  void _showLogoutConfirmation(BuildContext context) {
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
                _performLogout(context);
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Common logout action
  void _performLogout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (route) => false,
    );
  }

  // Common scaffold structure
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBars.defaultAppBar(
          context: context,
          title: widget.appBarTitle,
          navigationType: NavigationType.pop,
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Welcome section
                    _buildWelcomeSection(widget.userName),

                    // Tiles section - dynamically built from the list
                    Column(
                      children: widget.tiles.map((tile) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: SizedBox(
                            height: 120,
                            child: Center(
                              child: SizedBox(
                                width: 700,
                                child: _buildDashboardTile(
                                  imagePath: tile.imagePath,
                                  smallText: tile.smallText,
                                  largeText: tile.largeText,
                                  onTap: () => tile.onTap(context),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}