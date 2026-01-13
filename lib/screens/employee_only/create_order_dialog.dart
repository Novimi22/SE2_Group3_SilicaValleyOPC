import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';
import '../employee_only/employee_dashboard.dart';

class CreateOrderFullScreenDialog extends StatefulWidget {
  final String purchaseOrderNumber;
  final String customerName;

  const CreateOrderFullScreenDialog({
    super.key,
    required this.purchaseOrderNumber,
    required this.customerName,
  });

  @override
  State<CreateOrderFullScreenDialog> createState() =>
      _CreateOrderFullScreenDialogState();
}

class _CreateOrderFullScreenDialogState
    extends State<CreateOrderFullScreenDialog> {

  // Order details
  DateTime orderDate = DateTime.now();
  double netPrice = 0.0;

  // Table data
  List<Map<String, dynamic>> items = [];

  // Track editing state for each row
  List<bool> isEditingList = [];
  List<Map<String, TextEditingController>> controllersList = [];

  // Track if order has been confirmed
  bool isConfirmed = false;

  @override
  void initState() {
    super.initState();
    // Format date as MM-DD-YYYY
    orderDate = DateTime.now();

    // Initialize empty items list
    items = [];
    isEditingList = [];
    controllersList = [];
  }

  @override
  void dispose() {
    // Dispose all text controllers
    for (var controllers in controllersList) {
      controllers.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }

  // Add new item row
  void _addNewItem() {
    setState(() {
      final newControllers = {
        'name': TextEditingController(),
        'qty': TextEditingController(),
        'uom': TextEditingController(),
        'unitPrice': TextEditingController(),
      };

      // Add listeners to controllers for auto-calculation
      newControllers['qty']!.addListener(() => _calculateNetPrice());
      newControllers['unitPrice']!.addListener(() => _calculateNetPrice());

      items.add({
        'name': '',
        'qty': '',
        'uom': '',
        'unitPrice': '',
        'total': 0.0,
      });
      isEditingList.add(true); // Start in edit mode for new row
      controllersList.add(newControllers);
    });
  }

  // Delete item row
  void _deleteItem(int index) {
    setState(() {
      // Dispose controllers for this row
      controllersList[index].values.forEach((controller) {
        controller.dispose();
      });

      // Remove item
      items.removeAt(index);
      isEditingList.removeAt(index);
      controllersList.removeAt(index);

      // Recalculate net price
      _calculateNetPrice();
    });
  }

  // Save all rows that are in edit mode
  void _saveAllEditingRows() {
    bool anySaved = false;

    for (int i = 0; i < items.length; i++) {
      if (isEditingList[i]) {
        _saveRow(i);
        anySaved = true;
      }
    }

    if (anySaved) {
      setState(() {});
    }
  }

  // Save a specific row
  void _saveRow(int index) {
    isEditingList[index] = false;

    // Update item data from controllers
    items[index]['name'] = controllersList[index]['name']!.text;
    items[index]['qty'] = controllersList[index]['qty']!.text;
    items[index]['uom'] = controllersList[index]['uom']!.text;
    items[index]['unitPrice'] = controllersList[index]['unitPrice']!.text;

    // Calculate total for this item
    final qty = double.tryParse(controllersList[index]['qty']!.text) ?? 0;
    final unitPrice =
        double.tryParse(controllersList[index]['unitPrice']!.text) ?? 0;
    items[index]['total'] = qty * unitPrice;

    // Recalculate net price
    _calculateNetPrice();
  }

  // Edit item row
  void _editItem(int index) {
    setState(() {
      // First save any other rows that are being edited
      _saveAllEditingRows();

      // Then start editing this row
      isEditingList[index] = true;
    });
  }

  // Calculate net price from all items
  void _calculateNetPrice() {
    double total = 0.0;

    // Calculate from current editing values
    for (int i = 0; i < items.length; i++) {
      double itemTotal = 0.0;

      if (isEditingList[i]) {
        // If editing, calculate from controller values
        final qty = double.tryParse(controllersList[i]['qty']!.text) ?? 0;
        final unitPrice =
            double.tryParse(controllersList[i]['unitPrice']!.text) ?? 0;
        itemTotal = qty * unitPrice;
        items[i]['total'] = itemTotal; // Update the item total
      } else {
        // If not editing, use saved total
        itemTotal = (items[i]['total'] as double?) ?? 0.0;
      }

      total += itemTotal;
    }

    setState(() {
      netPrice = total;
    });
  }

  // Confirm order
  void _confirmOrder() {
    // Save any rows that are still being edited
    _saveAllEditingRows();

    setState(() {
      isConfirmed = true;
    });

    // Show success snackbar
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
            const Expanded(
              child: Text(
                'Order successfully created! Awaiting approval.',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Format date as MM-DD-YYYY
  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$month-$day-$year';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.appBarColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border(bottom: BorderSide(color: AppColors.borderColor, width: 1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // CANCEL button 
              if (!isConfirmed)
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmployeeDashboardScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(left: 30, right: 20),
                    ),
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

              // Spacer
              Expanded(
                child: Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: Text(
                    'Create Order',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              // CONFIRM button 
              if (!isConfirmed)
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: _confirmOrder,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(right: 30, left: 20),
                    ),
                    child: Text(
                      'CONFIRM',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              else
                // After confirmation: X button to close and return to employee dashboard
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EmployeeDashboardScreen(),
                        ),
                      );
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
        child: GestureDetector(
          onTap: () {
            // Save all editing rows when tapping outside the table area
            FocusScope.of(context).unfocus(); // Also hide keyboard
            _saveAllEditingRows();
          },
          behavior: HitTestBehavior
              .opaque, // This ensures taps pass through to children
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
                    style: TextStyle(
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
                        // Customer Information header
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
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: widget.customerName,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Date Ordered row
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Date Ordered: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: _formatDate(orderDate),
                                style: TextStyle(
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
                                text: '₱${netPrice.toStringAsFixed(2)}',
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

                          // Add Item button - only show if not confirmed
                          if (!isConfirmed)
                            Material(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                onTap: () {
                                  // Save any rows that are being edited before adding new item
                                  _saveAllEditingRows();
                                  _addNewItem();
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.add,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Add Item',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Table container with fixed width to prevent overflow
                      Container(
                        width:
                            screenWidth -
                            50, // Account for padding on both sides
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
                                    4: FixedColumnWidth(80), // Actions
                                  },
                                  defaultVerticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  children: [
                                    TableRow(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                      ),
                                      children: [
                                        _buildTableHeaderCell(
                                          'Name',
                                          compact: true,
                                        ),
                                        _buildTableHeaderCell(
                                          'Qty',
                                          compact: true,
                                        ),
                                        _buildTableHeaderCell(
                                          'UoM',
                                          compact: true,
                                        ),
                                        _buildTableHeaderCell(
                                          'Unit Price',
                                          compact: true,
                                        ),
                                        // Only show Actions header if not confirmed
                                        if (!isConfirmed)
                                          _buildTableHeaderCell(
                                            'Actions',
                                            compact: true,
                                          ),
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
                                    final index = entry.key;
                                    final item = entry.value;
                                    final isEditing = isEditingList[index];
                                    final controllers = controllersList[index];

                                    return Container(
                                      decoration: BoxDecoration(
                                        border: index > 0
                                            ? const Border(
                                                top: BorderSide(
                                                  color: Color(0xFFD0D0D0),
                                                ),
                                              )
                                            : null,
                                      ),
                                      child: Table(
                                        columnWidths: {
                                          0: FlexColumnWidth(2.5), // Name
                                          1: FlexColumnWidth(0.8), // Qty
                                          2: FlexColumnWidth(0.8), // UoM
                                          3: FlexColumnWidth(
                                              1.2), // Unit Price
                                          4: FixedColumnWidth(80), // Actions
                                        },
                                        defaultVerticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        children: [
                                          TableRow(
                                            children: [
                                              // Name cell
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                child: isEditing
                                                    ? TextField(
                                                        controller:
                                                            controllers['name'],
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText:
                                                              'Enter item name',
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                        onSubmitted: (_) {
                                                          _saveRow(index);
                                                        },
                                                      )
                                                    : Text(
                                                        item['name']
                                                                ?.toString() ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                              ),

                                              // Qty cell
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                child: isEditing
                                                    ? TextField(
                                                        controller:
                                                            controllers['qty'],
                                                        keyboardType:
                                                            TextInputType
                                                                .numberWithOptions(
                                                          decimal: true,
                                                        ),
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText: 'Qty',
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                        onChanged: (_) {
                                                          _calculateNetPrice();
                                                        },
                                                        onSubmitted: (_) {
                                                          _saveRow(index);
                                                        },
                                                      )
                                                    : Text(
                                                        item['qty']
                                                                ?.toString() ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                              ),

                                              // UoM cell
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                child: isEditing
                                                    ? TextField(
                                                        controller:
                                                            controllers['uom'],
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText: 'UoM',
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                        onSubmitted: (_) {
                                                          _saveRow(index);
                                                        },
                                                      )
                                                    : Text(
                                                        item['uom']
                                                                ?.toString() ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                              ),

                                              // Unit Price cell
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                child: isEditing
                                                    ? TextField(
                                                        controller: controllers[
                                                            'unitPrice'],
                                                        keyboardType:
                                                            TextInputType
                                                                .numberWithOptions(
                                                          decimal: true,
                                                        ),
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText: 'Price',
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets.zero,
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                        onChanged: (_) {
                                                          _calculateNetPrice();
                                                        },
                                                        onSubmitted: (_) {
                                                          _saveRow(index);
                                                        },
                                                      )
                                                    : Text(
                                                        item['unitPrice']
                                                                ?.toString() ??
                                                            '',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                              ),

                                              // Actions cell - only show if not confirmed
                                              if (!isConfirmed)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      // Pencil icon - disabled when editing, enabled when saved
                                                      IconButton(
                                                        onPressed: isEditing
                                                            ? null // Disabled during editing
                                                            : () {
                                                                _editItem(
                                                                  index,
                                                                ); // Click to start editing
                                                              },
                                                        icon: Icon(
                                                          Icons.edit,
                                                          color: isEditing
                                                              ? AppColors.iconGrayColor
                                                                  .withOpacity(
                                                                    0.3,
                                                                  )
                                                            : AppColors.iconGrayColor,
                                                          size: 18,
                                                        ),
                                                        padding: EdgeInsets.zero,
                                                        constraints:
                                                            const BoxConstraints(
                                                          minWidth: 24,
                                                          minHeight: 24,
                                                        ),
                                                      ),

                                                      const SizedBox(width: 4),

                                                      // Trash bin icon (always enabled)
                                                      IconButton(
                                                        onPressed: () {
                                                          _deleteItem(index);
                                                        },
                                                        icon: Icon(
                                                          Icons.delete_outline,
                                                          color: AppColors.iconGrayColor,
                                                          size: 18,
                                                        ),
                                                        padding: EdgeInsets.zero,
                                                        constraints:
                                                            const BoxConstraints(
                                                          minWidth: 24,
                                                          minHeight: 24,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),

                            // Empty state message
                            if (items.isEmpty)
                              Container(
                                padding: const EdgeInsets.all(40),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.borderColor),
                                ),
                                child: Text(
                                  isConfirmed
                                      ? 'No items in this order.'
                                      : 'No items added. Click "Add Item" to start.',
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
      ),
    );
  }

  Widget _buildTableHeaderCell(String text, {bool compact = false}) {
    return Padding(
      padding: compact ? const EdgeInsets.all(8) : const EdgeInsets.all(12),
      child: Text(
        text,
        style: TextStyle(
          fontSize: compact ? 14 : 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}