import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';
import 'package:draft_screens/constants/app_bars.dart';
import 'package:draft_screens/constants/buttons/elevated_buttons.dart';
import 'package:draft_screens/constants/buttons/text_buttons.dart';
import 'package:draft_screens/constants/base_dashboard.dart';

import '../histories/order_act_history.dart';
import '../histories/doc_act_history/doc_act_searchpage.dart';
import '../manage_order/gen_manage_order.dart';
import '../track_order/track_order_searchpage.dart';
import '../employee_only/create_order_dialog.dart';

class EmployeeDashboardScreen extends StatefulWidget {
  const EmployeeDashboardScreen({super.key});

  @override
  State<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen> {
  // hardcoded username
  final String userName = "Juan Dela Cruz";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBars.centeredAppBar(title: 'Employee Dashboard'),
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
                    buildWelcomeSection(userName, context, () {
                      showLogoutConfirmation(context);
                    }),

                    // Tiles section
                    Column(
                      children: [
                        // First tile - Create Order
                        SizedBox(
                          height: 120,
                          child: Center(
                            child: SizedBox(
                              width: 700,
                              child: buildDashboardTile(
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
                                            userType: 'employee',
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

  // Employee-specific dialog functions (UNCHANGED)
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
                  color: AppColors.dialogBgColor,
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
                      Text(
                        'CREATE ORDER',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 400,
                        child: Text(
                          'Enter a non-existing Purchase Order Number',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.grayColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
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
                            String formattedValue = value;
                            if (value.toLowerCase().startsWith('po')) {
                              formattedValue = 'PO${value.substring(2)}';
                            }

                            setState(() {
                              purchaseOrderNumber = formattedValue;
                              showError = false;
                              errorMessage = '';
                            });
                          },
                          onSubmitted: (value) {
                            String formattedValue = value;
                            if (value.toLowerCase().startsWith('po')) {
                              formattedValue = 'PO${value.substring(2)}';
                            }

                            setState(() {
                              purchaseOrderNumber = formattedValue;
                            });

                            if (purchaseOrderNumber.isEmpty) {
                              setState(() {
                                showError = true;
                                errorMessage =
                                    'Please enter a Purchase Order Number';
                              });
                              return;
                            }

                            final RegExp poPattern = RegExp(r'^PO\d{8}$');
                            if (!poPattern.hasMatch(purchaseOrderNumber)) {
                              setState(() {
                                showError = true;
                                errorMessage =
                                    'Purchase Order Number invalid/already exists';
                              });
                              return;
                            }

                            Navigator.of(context).pop();
                            _showCustomerNameDialog(
                              context,
                              purchaseOrderNumber,
                            );
                          },
                        ),
                      ),
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
                      SizedBox(
                        width: 200,
                        child: CustomButtons.dialogActionButton(
                          context: context,
                          text: 'Next',
                          onPressed: () {
                            if (purchaseOrderNumber.isEmpty) {
                              setState(() {
                                showError = true;
                                errorMessage =
                                    'Please enter a Purchase Order Number';
                              });
                              return;
                            }

                            final RegExp poPattern = RegExp(r'^PO\d{8}$');
                            if (!poPattern.hasMatch(purchaseOrderNumber)) {
                              setState(() {
                                showError = true;
                                errorMessage =
                                    'Purchase Order Number invalid/already exists';
                              });
                              return;
                            }

                            Navigator.of(context).pop();
                            _showCustomerNameDialog(
                              context,
                              purchaseOrderNumber,
                            );
                          },
                          verticalPadding: 16,
                          borderRadius: 10,
                        ),
                      ),
                      const SizedBox(height: 15),
                      CustomTextButtons.cancelButton(context: context),
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
                  color: AppColors.dialogBgColor,
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
                      Text(
                        'CREATE ORDER',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 400,
                        child: Text(
                          'Enter customer\'s name for $purchaseOrderNumber',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.grayColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
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
                          onSubmitted: (value) {
                            setState(() {
                              customerName = value;
                            });

                            if (customerName.isEmpty) {
                              setState(() {
                                showError = true;
                                errorMessage = 'Please enter customer name';
                              });
                              return;
                            }

                            Navigator.of(context).pop();
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
                      SizedBox(
                        width: 200,
                        child: CustomButtons.dialogActionButton(
                          context: context,
                          text: 'Create',
                          onPressed: () {
                            if (customerName.isEmpty) {
                              setState(() {
                                showError = true;
                                errorMessage = 'Please enter customer name';
                              });
                              return;
                            }

                            Navigator.of(context).pop();
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
                          verticalPadding: 16,
                          borderRadius: 10,
                        ),
                      ),
                      const SizedBox(height: 15),
                      CustomTextButtons.cancelButton(context: context),
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
}
