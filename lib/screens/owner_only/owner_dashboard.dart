import 'package:draft_screens/screens/histories/order_act_history.dart';
import 'package:draft_screens/screens/manage_order/gen_manage_order.dart';
import 'package:draft_screens/screens/owner_only/approve_order.dart';
import 'package:draft_screens/screens/track_order/track_order_searchpage.dart';
import 'package:flutter/material.dart';
import 'package:draft_screens/screens/all_logins/signin_screen.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  // Color constants
  static const Color circleColor = Color(0xFFFFD15E);
  static const Color tileColor = Color(0xFFFFEAB5);
  static const Color smallTextColor = Color(0xFF5F5F5F);
  static const Color largeTextColor = Color(0xFF202020);
  static const Color grayColor = Color(0xFF9E9E9E);
  static const Color appBarColor = Color(0xFFE8B73A);

  // hardcoded username
  final String userName = "Juan Dela Cruz";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            color: appBarColor,
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
                  padding: const EdgeInsets.only(left: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // Spacer
              const Expanded(child: SizedBox()),

              // Title
              Container(
                height: 80,
                alignment: Alignment.center,
                child: Text(
                  'Owner Dashboard',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
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
                                color: grayColor,
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
          color: tileColor,
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
                color: circleColor,
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
                      color: smallTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Larger text
                  Text(
                    largeText,
                    style: TextStyle(
                      fontSize: 16,
                      color: largeTextColor,
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
              child: Text('Cancel', style: TextStyle(color: grayColor)),
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