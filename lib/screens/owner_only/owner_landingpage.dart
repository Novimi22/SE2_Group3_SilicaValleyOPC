import 'package:flutter/material.dart';
import 'package:draft_screens/screens/owner_only/owner_dashboard.dart';

class EmployeeLandingPage extends StatefulWidget {
  const EmployeeLandingPage({super.key});

  @override
  State<EmployeeLandingPage> createState() => _EmployeeLandingPageState();
}

class _EmployeeLandingPageState extends State<EmployeeLandingPage> {
  // Color constants as specified
  static const Color circleColor = Color(0xFFFFD15E); // Circle color
  static const Color tileColor = Color(0xFFFFEAB5); // Tile background color
  static const Color smallTextColor = Color(0xFF5F5F5F); // Smaller text color
  static const Color largeTextColor = Color(0xFF202020); // Larger text color
  static const Color grayColor = Color(0xFF9E9E9E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

            // White container
            // Expanded makes this widget take all available vertical space
            Expanded(
              child: Material(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  width:
                      double.infinity, // This makes it expand to screen width
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
                              40.0,
                              25.0,
                              20.0,
                            ),
                            child: _buildTilesContent(constraints.maxHeight),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build the tiles content
  Widget _buildTilesContent(double availableHeight) {
    return SizedBox(
      height: availableHeight, // Use the available height
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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

          const SizedBox(height: 30),

          // Subtitle text
          Text(
            'Continue to:',
            style: TextStyle(fontSize: 14, color: grayColor),
          ),
          const SizedBox(height: 40),

          // First tile - Manage Employee Account
          GestureDetector(
            onTap: () {
              // TODO: Add navigation to Employee Account page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Employee Account tile tapped')),
              );
            },
            child: Container(
              width: 700,
              margin: const EdgeInsets.only(bottom: 50),
              padding: const EdgeInsets.all(40),
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
                  // Circle with employee icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: circleColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/employees.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Text section for first tile
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Smaller text "Manage"
                        Text(
                          'Manage',
                          style: TextStyle(
                            fontSize: 14,
                            color: smallTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        // Larger text "Employee Account"
                        Text(
                          'Employee Account',
                          style: TextStyle(
                            fontSize: 18,
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
          ),

          // Second tile - Owner Dashboard
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OwnerDashboardScreen(),
                ),
              );
            },
            child: Container(
              width: 700,
              padding: const EdgeInsets.all(40),
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
                  // Circle with dashboard icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: circleColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/dashboard.png',
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Text section for second tile
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Smaller text "Owner"
                        Text(
                          'Owner',
                          style: TextStyle(
                            fontSize: 14,
                            color: smallTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 5),
                        // Larger text "Dashboard"
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            fontSize: 18,
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
          ),

          const Spacer(),
        ],
      ),
    );
  }
}
