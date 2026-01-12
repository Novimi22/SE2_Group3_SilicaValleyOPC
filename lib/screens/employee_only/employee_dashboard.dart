import 'package:draft_screens/screens/histories/order_act_history.dart';
import 'package:draft_screens/screens/manage_order/gen_manage_order.dart';
import 'package:draft_screens/screens/track_order/track_order_searchpage.dart';
import 'package:flutter/material.dart';
import 'package:draft_screens/screens/all_logins/signin_screen.dart';
import 'package:draft_screens/screens/employee_only/create_order_dialog.dart';

class EmployeeDashboardScreen extends StatefulWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  State<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen> {
  // Color constants
  static const Color circleColor = Color(0xFFFFD15E);
  static const Color tileColor = Color(0xFFFFEAB5);
  static const Color smallTextColor = Color(0xFF5F5F5F);
  static const Color largeTextColor = Color(0xFF202020);
  static const Color grayColor = Color(0xFF9E9E9E);
  static const Color appBarColor = Color(0xFFE8B73A);
  static const Color primaryColor = Color(0xFFCC9304);
  static const Color dialogBackgroundColor = Color(0xFFFFFBFB);

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
              // Spacer
              const Expanded(child: SizedBox()),

              // Title
              Container(
                height: 80,
                alignment: Alignment.center,
                child: Text(
                  'Employee Dashboard',
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
              SizedBox(width: 48, height: 80),
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
                      borderRadius: BorderRadius.circular(
                        0,
                      ), 
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
                                Icon(
                                  Icons.exit_to_app,
                                  color: Colors.red,
                                  size: 20,
                                ),
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
                      // First tile - Create Order 
                      SizedBox(
                        height: 120,
                        child: Center(
                          child: SizedBox(
                            width: 700, 
                            child: _buildDashboardTile(
                              imagePath: 'assets/images/create_order.png',
                              smallText: 'Create',
                              largeText: 'Order',
                              onTap: () {
                                _showCreateOrderDialog(context);
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
                                        const ManageOrderScreen(userType: 'employee',),
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
                                // TODO: Correct navigation later
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

  // Show Create Order Dialog (First Dialog)
  void _showCreateOrderDialog(BuildContext context) {
    String purchaseOrderNumber = '';
    bool showError = false;
    String errorMessage = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: dialogBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Main Title
                      Text(
                        'CREATE ORDER',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Gray subtitle
                      SizedBox(
                        width: 400,
                        child: Text(
                          'Enter a non-existing Purchase Order Number',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: grayColor),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Purchase Order Number Text Field
                      SizedBox(
                        width: 400,
                        child: TextField(
                          decoration: InputDecoration(
                            label: const Text('Purchase Order Number'),
                            hintText: 'Enter Purchase Order Number',
                            hintStyle: const TextStyle(color: Colors.black26),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFF19191B),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFF19191B),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          onChanged: (value) {
                            // Automatically capitalize if user types in lowercase
                            String formattedValue = value;
                            if (value.toLowerCase().startsWith('po')) {
                              formattedValue = 'PO' + value.substring(2);
                            }

                            setState(() {
                              purchaseOrderNumber = formattedValue;
                              showError = false;
                              errorMessage = '';
                            });
                          },
                          // Handle Enter key press
                          onSubmitted: (value) {
                            // Format the value
                            String formattedValue = value;
                            if (value.toLowerCase().startsWith('po')) {
                              formattedValue = 'PO' + value.substring(2);
                            }

                            // Update the state
                            setState(() {
                              purchaseOrderNumber = formattedValue;
                            });

                            // Perform validation
                            if (purchaseOrderNumber.isEmpty) {
                              setState(() {
                                showError = true;
                                errorMessage =
                                    'Please enter a Purchase Order Number';
                              });
                              return;
                            }

                            // Validate PO format: PO followed by exactly 8 digits
                            final RegExp poPattern = RegExp(r'^PO\d{8}$');
                            if (!poPattern.hasMatch(purchaseOrderNumber)) {
                              setState(() {
                                showError = true;
                                errorMessage =
                                    'Purchase Order Number invalid/already exists';
                              });
                              return;
                            }

                            // TODO: Check if PO already exists in the data
                            // For now, we 'll assume it's validand proceed to next dialog
                            Navigator.of(context).pop();
                            _showCustomerNameDialog(
                              context,
                              purchaseOrderNumber,
                            );
                          },
                        ),
                      ),

                      // Error message if field is invalid or PO already exists
                      if (showError && errorMessage.isNotEmpty)
                        SizedBox(
                          width: 400,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    errorMessage,
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

                      const SizedBox(height: 30),

                      // Next button
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            if (purchaseOrderNumber.isEmpty) {
                              setState(() {
                                showError = true;
                                errorMessage =
                                    'Please enter a Purchase Order Number';
                              });
                              return;
                            }

                            // Validate PO format: PO followed by exactly 8 digits
                            final RegExp poPattern = RegExp(r'^PO\d{8}$');
                            if (!poPattern.hasMatch(purchaseOrderNumber)) {
                              setState(() {
                                showError = true;
                                errorMessage =
                                    'Purchase Order Number invalid/already exists';
                              });
                              return;
                            }

                            // TODO: Check if PO already exists in the data
                            // For now, we'll assume it's valid and proceed to next dialog
                            Navigator.of(context).pop();
                            _showCustomerNameDialog(
                              context,
                              purchaseOrderNumber,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 5.0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Cancel button
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Show Customer Name Dialog (Second Dialog)
  void _showCustomerNameDialog(
    BuildContext context,
    String purchaseOrderNumber,
  ) {
    String customerName = '';
    bool showError = false;
    String errorMessage = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: dialogBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Main Title
                      Text(
                        'CREATE ORDER',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Gray subtitle with dynamic PO number
                      SizedBox(
                        width: 400,
                        child: Text(
                          'Enter customer\'s name for $purchaseOrderNumber',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: grayColor),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Customer Name Text Field
                      SizedBox(
                        width: 400,
                        child: TextField(
                          decoration: InputDecoration(
                            label: const Text('Customer Name'),
                            hintText: 'Enter Customer Name',
                            hintStyle: const TextStyle(color: Colors.black26),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFF19191B),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFF19191B),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          onChanged: (value) {
                            setState(() {
                              customerName = value;
                              showError = false;
                              errorMessage = '';
                            });
                          },
                          // ADD THIS: Handle Enter key press
                          onSubmitted: (value) {
                            // Update the state
                            setState(() {
                              customerName = value;
                            });

                            // Perform validation
                            if (customerName.isEmpty) {
                              setState(() {
                                showError = true;
                                errorMessage = 'Please enter customer name';
                              });
                              return;
                            }

                            // Close the dialog
                            Navigator.of(context).pop();

                            // Close the dialog and navigate to full-screen order details dialog
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateOrderFullScreenDialog(
                                      purchaseOrderNumber: purchaseOrderNumber,
                                      customerName: customerName,
                                    ),
                                fullscreenDialog: true,
                              ),
                            );
                          },
                        ),
                      ),

                      // Error message if field is empty
                      if (showError && errorMessage.isNotEmpty)
                        SizedBox(
                          width: 400,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    errorMessage,
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

                      const SizedBox(height: 30),

                      // Create button
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            if (customerName.isEmpty) {
                              setState(() {
                                showError = true;
                                errorMessage = 'Please enter customer name';
                              });
                              return;
                            }

                            // Close the dialog
                            Navigator.of(context).pop();

                            // Close the dialog and navigate to full-screen order details dialog
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreateOrderFullScreenDialog(
                                      purchaseOrderNumber: purchaseOrderNumber,
                                      customerName: customerName,
                                    ),
                                fullscreenDialog: true,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 5.0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Create',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Cancel button
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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
