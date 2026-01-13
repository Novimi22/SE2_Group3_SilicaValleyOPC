import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';

import 'package:flutter/services.dart';

class UpdateOrderScreen extends StatefulWidget {
  final String purchaseOrderNumber;
  final String customerName;
  final String creationDate;
  final String netPrice;

  const UpdateOrderScreen({
    super.key,
    required this.purchaseOrderNumber,
    required this.customerName,
    required this.creationDate,
    required this.netPrice,
  });

  @override
  State<UpdateOrderScreen> createState() => _UpdateOrderScreenState();
}

class _UpdateOrderScreenState extends State<UpdateOrderScreen> {

  // Order details
  DateTime orderDate = DateTime.now();
  double currentNetPrice = 0.0;

  // Table data
  List<Map<String, dynamic>> items = [];

  // Track editing state for each row
  List<bool> isEditingList = [];
  List<Map<String, TextEditingController>> controllersList = [];

  // Track pending action type for confirmation dialog
  String? _pendingActionType;
  int? _pendingActionIndex;
  Map<String, dynamic>? _pendingEditOldValues;

  // Track if a row was just added (so we don't show edit confirmation)
  bool _isNewlyAddedRow = false;
  int? _newlyAddedRowIndex;

  @override
  void initState() {
    super.initState();
    // Parse net price from string
    currentNetPrice =
        double.tryParse(
          widget.netPrice.replaceAll('₱', '').replaceAll(',', ''),
        ) ??
        0.0;

    // Initialize with sample data (in real app, this would come from API)
    _initializeSampleData();
  }

  void _initializeSampleData() {
    // Sample items for demonstration
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

    // Initialize controllers and editing states
    isEditingList = List.generate(items.length, (index) => false);
    controllersList = items.map((item) {
      return {
        'name': TextEditingController(text: item['name']),
        'qty': TextEditingController(text: item['qty']),
        'uom': TextEditingController(text: item['uom']),
        'unitPrice': TextEditingController(text: item['unitPrice']),
      };
    }).toList();

    // Add listeners for auto-calculation
    for (var controllers in controllersList) {
      controllers['qty']!.addListener(() => _calculateNetPrice());
      controllers['unitPrice']!.addListener(() => _calculateNetPrice());
    }
  }

  @override
  void dispose() {
    // Dispose all text controllers
    for (var controllers in controllersList) {
      controllers.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }

  // Add new item row - ONLY prepares for adding, doesn't add yet
  void _prepareAddItem() {
    _pendingActionType = 'add';
    _pendingActionIndex = null; // No index for add
    _showConfirmationDialog('add');
  }

  // Actually add the item after confirmation
  void _performAddItem() {
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

      // Track this as a newly added row
      _isNewlyAddedRow = true;
      _newlyAddedRowIndex = items.length - 1;
    });

    _showSnackbar('Item added', AppColors.greenColor);
  }

  // Delete item row
  void _deleteItem(int index) {
    _pendingActionType = 'delete';
    _pendingActionIndex = index;
    _showConfirmationDialog('delete');
  }

  // Save all rows that are in edit mode
  void _saveAllEditingRows() {
    bool anySaved = false;

    for (int i = 0; i < items.length; i++) {
      if (isEditingList[i]) {
        _saveRow(
          i,
          skipConfirmation: _isNewlyAddedRow && i == _newlyAddedRowIndex,
        );
        anySaved = true;
      }
    }

    if (anySaved) {
      setState(() {});
    }
  }

  // Save a specific row
  void _saveRow(int index, {bool skipConfirmation = false}) {
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

    // If this was a newly added row, clear the flag
    if (_isNewlyAddedRow && index == _newlyAddedRowIndex) {
      _isNewlyAddedRow = false;
      _newlyAddedRowIndex = null;
    }
  }

  // Edit item row - only prepares for editing, doesn't save yet
  void _editItem(int index) {
    setState(() {
      // First save any other rows that are being edited
      _saveAllEditingRows();

      // Save old values for confirmation (only save reference, not start editing yet)
      _pendingEditOldValues = Map.from(items[index]);
      _pendingActionType = 'edit';
      _pendingActionIndex = index;

      // Start editing this row immediately
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
      currentNetPrice = total;
    });
  }

  // Show confirmation dialog
  void _showConfirmationDialog(String actionType) {
    String dialogTitle = 'Confirm Changes?';
    String dialogMessage = '';

    switch (actionType) {
      case 'add':
        dialogMessage =
            'Are you sure you want to add a new item in this order?';
        break;
      case 'edit':
        dialogMessage =
            'Are you sure you want to edit this item in this order?';
        break;
      case 'delete':
        dialogMessage =
            'Are you sure you want to delete this item in this order?';
        break;
      default:
        dialogMessage = 'Are you sure you want to perform this action?';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Shortcuts(
          shortcuts: {
            LogicalKeySet(LogicalKeyboardKey.enter): _ConfirmActionIntent(),
          },
          child: Actions(
            actions: {
              _ConfirmActionIntent: CallbackAction<_ConfirmActionIntent>(
                onInvoke: (intent) {
                  Navigator.of(context).pop();
                  _performPendingAction();
                  return null;
                },
              ),
            },
            child: Focus(
              autofocus: true,
              onKeyEvent: (node, event) {
                // Handle Enter key press
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.enter) {
                  Navigator.of(context).pop();
                  _performPendingAction();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: Dialog(
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
                        // Main Title
                        Text(
                          dialogTitle,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Gray paragraph text
                        SizedBox(
                          width: 300,
                          child: Text(
                            dialogMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: AppColors.grayColor),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Confirm button
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _performPendingAction();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
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
                              'Confirm',
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
                            _clearPendingAction();
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
              ),
            ),
          ),
        );
      },
    );
  }

  // Perform the pending action after confirmation
  void _performPendingAction() {
    if (_pendingActionType == null) return;

    switch (_pendingActionType) {
      case 'add':
        // Actually add the item
        _performAddItem();
        break;

      case 'edit':
        // For edit, we just show snackbar (saving happens when clicking outside or pressing Enter in the field)
        if (_pendingActionIndex != null) {
          final index = _pendingActionIndex!;
          _saveRow(index);
          _showSnackbar('Item edited', AppColors.greenColor);
        }
        break;

      case 'delete':
        // Perform delete
        final index = _pendingActionIndex!;
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
        _showSnackbar('Item deleted', AppColors.redColor);
        break;
    }

    _clearPendingAction();
  }

  // Clear pending action
  void _clearPendingAction() {
    _pendingActionType = null;
    _pendingActionIndex = null;
    _pendingEditOldValues = null;
  }

  // Show snackbar
  void _showSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: backgroundColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }

  // Handle edit confirmation when clicking outside or pressing Enter
  void _handleEditConfirmation(int index) {
    if (isEditingList[index]) {
      // If this is a newly added row, just save it without confirmation
      if (_isNewlyAddedRow && index == _newlyAddedRowIndex) {
        _saveRow(index);
        _isNewlyAddedRow = false;
        _newlyAddedRowIndex = null;
      } else {
        // For existing items, show confirmation dialog
        _pendingActionType = 'edit';
        _pendingActionIndex = index;
        _pendingEditOldValues = Map.from(items[index]);
        _showConfirmationDialog('edit');
      }
    }
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
              // Spacer for balance
              const Expanded(child: SizedBox()),

              // Title
              Container(
                height: 80,
                alignment: Alignment.center,
                child: Text(
                  'Update Order',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              // Spacer for balance
              const Expanded(child: SizedBox()),

              // Close icon
              Container(
                height: 80,
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, color: Colors.black, size: 30),
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
            for (int i = 0; i < items.length; i++) {
              if (isEditingList[i]) {
                _handleEditConfirmation(i);
                break; // Only handle first editing row
              }
            }
          },
          behavior: HitTestBehavior.opaque,
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

                        // Creation Date row
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Creation Date: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: widget.creationDate,
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

                          // Add Item button
                          Material(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              onTap: _prepareAddItem,
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
                                          3: FlexColumnWidth(1.2), // Unit Price
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
                                                              hintStyle:
                                                                  TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                            ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                        onSubmitted: (_) {
                                                          _handleEditConfirmation(
                                                            index,
                                                          );
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
                                                            TextInputType.numberWithOptions(
                                                              decimal: true,
                                                            ),
                                                        decoration:
                                                            const InputDecoration(
                                                              hintText: 'Qty',
                                                              hintStyle:
                                                                  TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                            ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                        onChanged: (_) {
                                                          _calculateNetPrice();
                                                        },
                                                        onSubmitted: (_) {
                                                          _handleEditConfirmation(
                                                            index,
                                                          );
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
                                                              hintStyle:
                                                                  TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                            ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                        onSubmitted: (_) {
                                                          _handleEditConfirmation(
                                                            index,
                                                          );
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
                                                        controller:
                                                            controllers['unitPrice'],
                                                        keyboardType:
                                                            TextInputType.numberWithOptions(
                                                              decimal: true,
                                                            ),
                                                        decoration:
                                                            const InputDecoration(
                                                              hintText: 'Price',
                                                              hintStyle:
                                                                  TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                            ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                        onChanged: (_) {
                                                          _calculateNetPrice();
                                                        },
                                                        onSubmitted: (_) {
                                                          _handleEditConfirmation(
                                                            index,
                                                          );
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

                                              // Actions cell
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // Pencil icon - disabled when editing, enabled when saved
                                                    IconButton(
                                                      onPressed: isEditing
                                                          ? null // Disabled during editing
                                                          : () {
                                                              _editItem(index);
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
                                  'No items added. Click "Add Item" to start.',
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

// Intent class for dialog shortcuts
class _ConfirmActionIntent extends Intent {
  const _ConfirmActionIntent();
}
