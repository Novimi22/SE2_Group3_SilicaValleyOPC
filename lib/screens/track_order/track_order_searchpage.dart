import 'package:flutter/material.dart';
import 'package:draft_screens/constants/order_list.dart';
import 'package:draft_screens/constants/app_bars.dart';
import 'track_order.dart';

class TORSearchPage extends StatelessWidget {
  const TORSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data
    final List<Map<String, String>> orders = List.generate(10, (index) {
      final poNumber = (1000000 + index).toString().padLeft(8, '0');
      return {
        'poNumber': 'PO$poNumber',
        'lastUpdated': '01/${(index + 10).toString().padLeft(2, '0')}/2024',
        'clientName': 'Client ${index + 1}',
        'creationDate': '01/${(index + 5).toString().padLeft(2, '0')}/2024',
        'netPrice': '₱${(index + 1) * 1000}.00',
      };
    });

    return SafeArea(
      child: OrderListWidget(
        screenTitle: 'Track Order Record',
        appBar: CustomAppBars.defaultAppBar(
          context: context,
          title: 'Track Order Record',
          navigationType: NavigationType.pop,
        ),
        buttonText: 'Track',
        onButtonPressed: (order) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackRecordScreen(
                purchaseOrderNumber: order['poNumber']!,
                clientName: order['clientName']!,
              ),
            ),
          );
        },
        initialOrders: orders,
        /*showDeleteOption: true,
      onDelete: (poNumber, clientName) {
      },*/
      ),
    );
  }
}
