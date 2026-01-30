import 'package:flutter/material.dart';
import 'package:draft_screens/constants/app_bars.dart';
import 'package:draft_screens/constants/order_list.dart';

import '../owner_only/owner_dashboard.dart';
import '../employee_only/employee_dashboard.dart';
import '../manage_order/update_order.dart';
import '../manage_order/view_order.dart';

class ManageOrderScreen extends StatefulWidget {
  final String userType;

  const ManageOrderScreen({super.key, required this.userType});

  @override
  State<ManageOrderScreen> createState() => _ManageOrderScreenState();
}

class _ManageOrderScreenState extends State<ManageOrderScreen> {
  // Sample data for orders
  final List<Map<String, String>> _allOrders = List.generate(10, (index) {
    final poNumber = (1000000 + index).toString().padLeft(8, '0');
    return {
      'poNumber': 'PO$poNumber',
      'lastUpdated': '01/${(index + 10).toString().padLeft(2, '0')}/2024',
      'clientName': 'Client ${index + 1}',
      'creationDate': '01/${(index + 5).toString().padLeft(2, '0')}/2024',
      'netPrice': '₱${(index + 1) * 1000}.00',
    };
  });

  void _handleBackNavigation() {
    if (widget.userType == 'owner') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OwnerDashboardScreen()),
      );
    } else if (widget.userType == 'employee') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const EmployeeDashboardScreen(),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _performDeleteOrder(String poNumber, String clientName) {
    setState(() {
      _allOrders.removeWhere((order) => order['poNumber'] == poNumber);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.green, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Successfully deleted order: $poNumber ($clientName)',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrderListWidget(
      screenTitle: 'Manage Order',
      appBar: CustomAppBars.defaultAppBar(
        context: context,
        title: 'Manage Order',
        onBackPressed: _handleBackNavigation,
      ),
      buttonText: 'View', // Not used when showMultipleButtons is true
      onButtonPressed: (order) {}, // Not used when showMultipleButtons is true
      initialOrders: _allOrders,
      showDeleteOption: true,
      onDelete: _performDeleteOrder,
      showMultipleButtons: true, 
      onUpdate: (order) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateOrderScreen(
              purchaseOrderNumber: order['poNumber']!,
              customerName: order['clientName']!,
              creationDate: order['creationDate']!,
              netPrice: order['netPrice']!,
            ),
          ),
        );
      },
      onView: (order) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewOrderScreen(
              purchaseOrderNumber: order['poNumber']!,
              customerName: order['clientName']!,
              creationDate: order['creationDate']!,
              netPrice: order['netPrice']!,
            ),
          ),
        );
      },
    );
  }
}