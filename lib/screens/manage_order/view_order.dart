import 'package:flutter/material.dart';
import 'package:draft_screens/screens/manage_order/gen_manage_order.dart';

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
  // Color constants 
  static const Color primaryColor = Color(0xFFCC9304);
  static const Color appBarColor = Color(0xFFE8B73A);
  static const Color grayColor = Color(0xFF9E9E9E);
  static const Color borderColor = Color(0xFFD0D0D0);
  static const Color infoBoxColor = Color(0xFFF3F3F8);
  static const Color tableHeaderColor = Color(0xFF258651);

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
            border: Border(bottom: BorderSide(color: borderColor, width: 1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child: SizedBox()),

              // Appbar Title
              Container(
                height: 80,
                alignment: Alignment.center,
                child: const Text(
                  'View Order', 
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              const Expanded(child: SizedBox()),

              // Close icon 
              Container(
                height: 80,
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 30,
                  ),
                  padding: const EdgeInsets.only(right: 30),
                ),
              ),
            ],
          ),
        ),
      ),
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
                  style: TextStyle(fontSize: 14, color: grayColor),
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
                    color: infoBoxColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
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
                                color: tableHeaderColor,
                              ),
                            ),
                            TextSpan(
                              text: '₱${currentNetPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: tableHeaderColor,
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
                            color: primaryColor,
                          ),
                        ),
                        // NO Add Item button here
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Table container 
                    Container(
                      width: screenWidth - 50,
                      child: Column(
                        children: [
                          // Table headers 
                          if (items.isNotEmpty)
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: borderColor),
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
                                  left: BorderSide(color: borderColor),
                                  right: BorderSide(color: borderColor),
                                  bottom: BorderSide(color: borderColor),
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
                                border: Border.all(color: borderColor),
                              ),
                              child: Text(
                                'No items added. Click "Add Item" to start.', // Keep same text
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: grayColor,
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