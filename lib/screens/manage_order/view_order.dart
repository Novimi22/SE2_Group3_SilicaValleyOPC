import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';
import 'package:draft_screens/constants/app_bars.dart';

class ViewOrderScreen extends StatefulWidget {
  final String purchaseOrderNumber;
  final String customerName;
  final String creationDate;
  final String netPrice;

  const ViewOrderScreen({
    super.key,
    required this.purchaseOrderNumber,
    required this.customerName,
    required this.creationDate,
    required this.netPrice,
  });

  @override
  State<ViewOrderScreen> createState() => _ViewOrderScreenState();
}

class _ViewOrderScreenState extends State<ViewOrderScreen> {

  // Order details
  double currentNetPrice = 0.0;

  // Table data 
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    // Parse net price
    currentNetPrice = double.tryParse(widget.netPrice.replaceAll('₱', '').replaceAll(',', '')) ?? 0.0;
    
    // Initialize with sample data
    _initializeSampleData();
  }

  void _initializeSampleData() {
    items = [
      {
        'name': 'Product A',
        'qty': '10',
        'uom': 'pcs',
        'unitPrice': '100.00',
        'total': 1000.0,
      },
      {
        'name': 'Product B',
        'qty': '5',
        'uom': 'boxes',
        'unitPrice': '200.00',
        'total': 1000.0,
      },
      {
        'name': 'Product C',
        'qty': '20',
        'uom': 'units',
        'unitPrice': '50.00',
        'total': 1000.0,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBars.closeOnlyAppBar(
        context: context, 
        title: 'View Order'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Purchase Order Number section 
                Text(
                  'Purchase Order Number:',
                  style: TextStyle(fontSize: 14, color: AppColors.grayColor),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.purchaseOrderNumber,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 30),

                // Customer Information box 
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.infoBoxColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderColor, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Name row
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Name: ',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: widget.customerName,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Creation Date row
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Creation Date: ',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: widget.creationDate,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Net Price row
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Net Price: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.tableHeaderColor,
                              ),
                            ),
                            TextSpan(
                              text: '₱${currentNetPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.tableHeaderColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Order Details section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Details header 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Table container 
                    SizedBox(
                      width: screenWidth - 50,
                      child: Column(
                        children: [
                          // Table headers 
                          if (items.isNotEmpty)
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.borderColor),
                              ),
                              child: Table(
                                columnWidths: {
                                  0: FlexColumnWidth(2.5), // Name 
                                  1: FlexColumnWidth(0.8), // Qty 
                                  2: FlexColumnWidth(0.8), // UoM 
                                  3: FlexColumnWidth(1.2), // Unit Price 
                                  // NO Actions column here
                                },
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                    ),
                                    children: [
                                      _buildTableHeaderCell('Name', compact: true),
                                      _buildTableHeaderCell('Qty', compact: true),
                                      _buildTableHeaderCell('UoM', compact: true),
                                      _buildTableHeaderCell('Unit Price', compact: true),
                                      // NO Actions header cell
                                    ],
                                  ),
                                ],
                              ),
                            ),

                          // Table rows 
                          if (items.isNotEmpty)
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(color: AppColors.borderColor),
                                  right: BorderSide(color: AppColors.borderColor),
                                  bottom: BorderSide(color: AppColors.borderColor),
                                ),
                              ),
                              child: Column(
                                children: items.asMap().entries.map((entry) {
                                  final item = entry.value;

                                  return Container(
                                    decoration: entry.key > 0
                                        ? const BoxDecoration(
                                            border: Border(
                                              top: BorderSide(color: Color(0xFFD0D0D0)),
                                            ),
                                          )
                                        : null,
                                    child: Table(
                                      columnWidths: {
                                        0: FlexColumnWidth(2.5), // Name
                                        1: FlexColumnWidth(0.8), // Qty
                                        2: FlexColumnWidth(0.8), // UoM
                                        3: FlexColumnWidth(1.2), // Unit Price
                                        // NO Actions column width
                                      },
                                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                      children: [
                                        TableRow(
                                          children: [
                                            // Name cell 
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                item['name']?.toString() ?? '',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),

                                            // Qty cell 
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                item['qty']?.toString() ?? '',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),

                                            // UoM cell 
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                item['uom']?.toString() ?? '',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),

                                            // Unit Price cell
                                            Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                item['unitPrice']?.toString() ?? '',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),

                                            // NO Actions cell here
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                          // Empty state message (SAME as update screen)
                          if (items.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(40),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.borderColor),
                              ),
                              child: Text(
                                'No items added. Click "Add Item" to start.', // Keep same text
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.grayColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
  Widget _buildTableHeaderCell(String text, {bool compact = false}) {
    return Padding(
      padding: compact ? const EdgeInsets.all(8) : const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}