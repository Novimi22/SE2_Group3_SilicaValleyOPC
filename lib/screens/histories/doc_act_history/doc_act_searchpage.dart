import 'package:draft_screens/screens/employee_only/employee_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:draft_screens/constants/order_list.dart';
import 'package:draft_screens/constants/app_bars.dart';

class DoctActHisSearchPage extends StatelessWidget {
  const DoctActHisSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> orders = List.generate(10, (index) {
      final poNumber = (2000000 + index).toString().padLeft(8, '0');
      return {
        'poNumber': 'PO$poNumber',
        'lastUpdated': '02/${(index + 10).toString().padLeft(2, '0')}/2024',
        'clientName': 'Customer ${index + 1}',
        'creationDate': '02/${(index + 5).toString().padLeft(2, '0')}/2024',
        'netPrice': '₱${(index + 1) * 1500}.00',
      };
    });

    return OrderListWidget(
      screenTitle: 'New Screen',
            appBar: CustomAppBars.defaultAppBar(
        context: context,
        title: 'Document Activity History',
        navigationType: NavigationType.pop,
      ),
      buttonText: 'View', 
      onButtonPressed: (order) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeeDashboardScreen(
            ),
          ),
        );
      },
      initialOrders: orders,
      showDeleteOption: false, 
    );
  }
}