import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';
import 'package:draft_screens/constants/app_bars.dart';

import 'package:draft_screens/screens/histories/order_act_history.dart';
import 'package:draft_screens/screens/manage_order/gen_manage_order.dart';
import 'package:draft_screens/screens/owner_only/approve_order.dart';
import 'package:draft_screens/screens/track_order/track_order_searchpage.dart';
import 'package:draft_screens/screens/all_logins/signin_screen.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {

  // hardcoded username
  final String userName = "Juan Dela Cruz";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBars.defaultAppBar(
        context: context,
        title: 'Owner Dashboard',
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Welcome text section
                        Column(
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
                            const SizedBox(height: 8),
                            // Username
                            Text(
                              '$userName!',
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        // Logout button
                        GestureDetector(
                          onTap: () {
                            _showLogoutConfirmation(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.exit_to_app, color: Colors.red, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 16,
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
                  ),

                  // Tiles section
                  Column(
                    children: [
                      // First tile
                      SizedBox(
                        height: 120,
                        child: Center(
                          child: SizedBox(
                            width: 700, 
                            child: _buildDashboardTile(
                              imagePath: 'assets/images/approve_order.png',
                              smallText: 'Approve',
                              largeText: 'Order',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ApproveOrderScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Second tile
                      SizedBox(
                        height: 120,
                        child: Center(
                          child: SizedBox(
                            width: 700, 
                            child: _buildDashboardTile(
                              imagePath: 'assets/images/manage_order.png',
                              smallText: 'Manage',
                              largeText: 'Order',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ManageOrderScreen(userType: 'owner',),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Third tile
                      SizedBox(
                        height: 120,
                        child: Center(
                          child: SizedBox(
                            width: 700, 
                            child: _buildDashboardTile(
                              imagePath: 'assets/images/track_or.png',
                              smallText: 'Track',
                              largeText: 'Order Record',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TORSearchPage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Fourth tile
                      SizedBox(
                        height: 120,
                        child: Center(
                          child: SizedBox(
                            width: 700, 
                            child: _buildDashboardTile(
                              imagePath: 'assets/images/history.png',
                              smallText: 'View',
                              largeText: 'Order Record History',
                              onTap: () {
                                // TODO: add proper navigation later
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'View Order Record History tile tapped',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Fifth tile
                      SizedBox(
                        height: 120,
                        child: Center(
                          child: SizedBox(
                            width: 700,
                            child: _buildDashboardTile(
                              imagePath: 'assets/images/history.png',
                              smallText: 'View',
                              largeText: 'Order Activity History',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const OrderActivityHistoryScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
            // Text section
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Smaller text
                  Text(
                    smallText,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.smallTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Larger text
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

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: AppColors.grayColor)),
            ),
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

  void _performLogout(BuildContext context) {
    // Navigate back to SignInScreen and clear the navigation stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (route) => false,
    );
  }
}