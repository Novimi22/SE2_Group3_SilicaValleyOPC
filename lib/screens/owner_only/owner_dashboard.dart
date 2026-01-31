import 'package:flutter/material.dart';
import 'package:draft_screens/constants/app_bars.dart';
import 'package:draft_screens/constants/base_dashboard.dart'; 

import '../histories/doc_act_history/doc_act_searchpage.dart';
import '../histories/order_act_history.dart';
import '../manage_order/gen_manage_order.dart';
import '../owner_only/approve_order.dart';
import '../track_order/track_order_searchpage.dart';


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
    return SafeArea(
      child: Scaffold(
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
                    buildWelcomeSection(
                      userName,
                      context,
                      () {
                        showLogoutConfirmation(context);
                      },
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
                              child: buildDashboardTile(
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
                              child: buildDashboardTile(
                                imagePath: 'assets/images/manage_order.png',
                                smallText: 'Manage',
                                largeText: 'Order',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ManageOrderScreen(
                                            userType: 'owner',
                                          ),
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
                              child: buildDashboardTile(
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
                              child: buildDashboardTile(
                                imagePath: 'assets/images/history.png',
                                smallText: 'View',
                                largeText: 'Document Activity History',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DoctActHisSearchPage(),
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
                              child: buildDashboardTile(
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
      ),
    );
  }
}