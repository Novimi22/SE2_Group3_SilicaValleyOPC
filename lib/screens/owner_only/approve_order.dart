import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';
import 'package:draft_screens/constants/app_bars.dart';
import 'package:draft_screens/constants/buttons/elevated_buttons.dart';
import 'package:draft_screens/constants/buttons/text_buttons.dart';

class ApproveOrderScreen extends StatefulWidget {
  const ApproveOrderScreen({super.key});

  @override
  State<ApproveOrderScreen> createState() => _ApproveOrderScreenState();
}

class _ApproveOrderScreenState extends State<ApproveOrderScreen> {
  static const Color snackbarGreenColor = Color(0xFF4CAF50);

  // Filter state
  String _selectedSortBy = 'Creation Date';
  String _selectedSortOrder = 'Ascending';

  // Search controller
  final TextEditingController _searchController = TextEditingController();

  // Global key for filter icon position
  final GlobalKey _filterIconKey = GlobalKey();

  // Track search input for clear button visibility
  bool _showClearButton = false;

  // Track expanded state for each order tile
  List<bool> _isExpandedList = [];

  // Sample data for orders pending review
  final List<Map<String, String>> _allOrders = List.generate(10, (index) {
    final poNumber = (2000000 + index).toString().padLeft(8, '0');
    return {
      'poNumber': 'PO$poNumber',
      'lastUpdated': '01/${(index + 10).toString().padLeft(2, '0')}/2024',
      'clientName': 'Client ${index + 1}',
      'creationDate': '01/${(index + 5).toString().padLeft(2, '0')}/2024',
      'netPrice': '₱${(index + 1) * 1000}.00',
    };
  });

  // Filtered data based on search
  List<Map<String, String>> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    // Initialize filtered list with all data
    _filteredOrders = List.from(_allOrders);
    // Apply initial sorting
    _applySorting();
    // Initialize expanded states
    _isExpandedList = List.generate(_filteredOrders.length, (index) => false);

    // Add listener to search controller
    _searchController.addListener(() {
      setState(() {
        _showClearButton = _searchController.text.isNotEmpty;
        _filterData();
      });
    });
  }

  // Filter data based on search text
  void _filterData() {
    final searchText = _searchController.text.toLowerCase();

    if (searchText.isEmpty) {
      setState(() {
        _filteredOrders = List.from(_allOrders);
        _applySorting(); // Apply current sorting to all data
      });
    } else {
      setState(() {
        _filteredOrders = _allOrders.where((order) {
          return order['poNumber']!.toLowerCase().contains(searchText) ||
              order['clientName']!.toLowerCase().contains(searchText);
        }).toList();
        _applySorting(); // Apply current sorting to filtered data
      });
    }
    // Reset expanded states for filtered items
    _updateExpandedStates();
  }

  // Update expanded states based on filtered orders
  void _updateExpandedStates() {
    setState(() {
      _isExpandedList = List.generate(_filteredOrders.length, (index) => false);
    });
  }

  // Clear search input
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _showClearButton = false;
      _filteredOrders = List.from(_allOrders);
      _applySorting(); // Apply current sorting when clearing search
      _updateExpandedStates();
    });
  }

  // Apply sorting based on current filter state
  void _applySorting() {
    setState(() {
      _filteredOrders.sort((a, b) {
        int comparison = 0;

        switch (_selectedSortBy) {
          case 'Client Name':
            comparison = a['clientName']!.compareTo(b['clientName']!);
            break;
          case 'Purchase Order Number':
            comparison = a['poNumber']!.compareTo(b['poNumber']!);
            break;
          case 'Creation Date':
            comparison = a['creationDate']!.compareTo(b['creationDate']!);
            break;
          case 'Net Price':
            double priceA =
                double.tryParse(
                  a['netPrice']!.replaceAll('₱', '').replaceAll(',', ''),
                ) ??
                0.0;
            double priceB =
                double.tryParse(
                  b['netPrice']!.replaceAll('₱', '').replaceAll(',', ''),
                ) ??
                0.0;
            comparison = priceA.compareTo(priceB);
            break;
          default:
            comparison = a['creationDate']!.compareTo(b['creationDate']!);
            break;
        }

        // Apply sort order
        return _selectedSortOrder == 'Descending' ? -comparison : comparison;
      });
    });
  }

  // Show filter dialog
  void _showFilterDialog(BuildContext context) {
    // Local variables for dialog state
    String dialogSortBy = _selectedSortBy;
    String dialogSortOrder = _selectedSortOrder;

    // Get the position of the filter icon
    final renderBox =
        _filterIconKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);

    // Calculate position for the dialog
    final double dialogTop = position.dy + renderBox.size.height + 10;
    final double dialogLeft = position.dx - 200;

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Click outside to close
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(color: Colors.transparent),
              ),
            ),
            // Filter dialog positioned below the icon
            Positioned(
              top: dialogTop,
              left: dialogLeft,
              child: StatefulBuilder(
                builder: (context, setDialogState) {
                  return Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 300,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.darkGrayColor,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sort By section
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.lightGrayColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.darkGrayColor,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Sort By',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          // Client Name selection row
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Client Name',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: dialogSortBy == 'Client Name'
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                Radio<String>(
                                  value: 'Client Name',
                                  groupValue: dialogSortBy,
                                  onChanged: (value) {
                                    setDialogState(() {
                                      dialogSortBy = value!;
                                    });
                                  },
                                  activeColor: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ),

                          // Purchase Order Number selection row
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Purchase Order Number',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        dialogSortBy == 'Purchase Order Number'
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                Radio<String>(
                                  value: 'Purchase Order Number',
                                  groupValue: dialogSortBy,
                                  onChanged: (value) {
                                    setDialogState(() {
                                      dialogSortBy = value!;
                                    });
                                  },
                                  activeColor: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ),

                          // Creation Date selection row
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Creation Date',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: dialogSortBy == 'Creation Date'
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                Radio<String>(
                                  value: 'Creation Date',
                                  groupValue: dialogSortBy,
                                  onChanged: (value) {
                                    setDialogState(() {
                                      dialogSortBy = value!;
                                    });
                                  },
                                  activeColor: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ),

                          // Net Price selection row
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Net Price',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: dialogSortBy == 'Net Price'
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                Radio<String>(
                                  value: 'Net Price',
                                  groupValue: dialogSortBy,
                                  onChanged: (value) {
                                    setDialogState(() {
                                      dialogSortBy = value!;
                                    });
                                  },
                                  activeColor: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Sort Order section
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.lightGrayColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.darkGrayColor,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Sort Order',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          // Ascending selection row
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ascending',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: dialogSortOrder == 'Ascending'
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                Radio<String>(
                                  value: 'Ascending',
                                  groupValue: dialogSortOrder,
                                  onChanged: (value) {
                                    setDialogState(() {
                                      dialogSortOrder = value!;
                                    });
                                  },
                                  activeColor: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ),

                          // Descending selection row
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Descending',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: dialogSortOrder == 'Descending'
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                Radio<String>(
                                  value: 'Descending',
                                  groupValue: dialogSortOrder,
                                  onChanged: (value) {
                                    setDialogState(() {
                                      dialogSortOrder = value!;
                                    });
                                  },
                                  activeColor: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Apply button
                          SizedBox(
                            width: double.infinity,
                            child: CustomButtons.applyButton(
                              context: context,
                              onApply: () {
                                setState(() {
                                  _selectedSortBy = dialogSortBy;
                                  _selectedSortOrder = dialogSortOrder;
                                });
                                _applySorting();
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // Show Approve Confirmation Dialog
  void _showApproveConfirmationDialog(String poNumber, String clientName) {
    _showConfirmationDialog(
      context: context,
      title: 'CONFIRM APPROVE?',
      message:
          'Are you sure you want to approve this purchase order?\n\nOnce approved, it will be marked as an active order.',
      confirmButtonText: 'Confirm',
      confirmButtonColor: AppColors.primaryColor,
      onConfirm: () {
        _performApproveOrder(poNumber, clientName);
      },
    );
  }

  // Show Reject Confirmation Dialog
  void _showRejectConfirmationDialog(String poNumber, String clientName) {
    _showConfirmationDialog(
      context: context,
      title: 'CONFIRM REJECT?',
      message: 'Are you sure you want to reject this order?',
      confirmButtonText: 'Confirm',
      confirmButtonColor: AppColors.primaryColor,
      onConfirm: () {
        _performRejectOrder(poNumber, clientName);
      },
    );
  }

  // Generic Confirmation Dialog
  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String confirmButtonText,
    required Color confirmButtonColor,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                  // Main Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Message text
                  SizedBox(
                    width: 300,
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.grayColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Confirm button with dynamic color
                  SizedBox(
                    width: 200,
                    child: CustomButtons.dialogActionButton(
                      context: context,
                      text: confirmButtonText,
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm();
                      },
                      backgroundColor: confirmButtonColor,
                      verticalPadding: 16,
                      borderRadius: 10,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Cancel button
                  CustomTextButtons.cancelButton(context: context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // NEW: Perform Approve Order
  void _performApproveOrder(String poNumber, String clientName) {
    // Remove order from list (or mark as approved in real app)
    setState(() {
      _allOrders.removeWhere((order) => order['poNumber'] == poNumber);
      _filteredOrders.removeWhere((order) => order['poNumber'] == poNumber);
      _updateExpandedStates();
    });

    // Show success snackbar
    _showSuccessSnackbar('$poNumber approved!');
  }

  // NEW: Perform Reject Order
  void _performRejectOrder(String poNumber, String clientName) {
    // Remove order from list (or mark as rejected in real app)
    setState(() {
      _allOrders.removeWhere((order) => order['poNumber'] == poNumber);
      _filteredOrders.removeWhere((order) => order['poNumber'] == poNumber);
      _updateExpandedStates();
    });

    // Show success snackbar
    _showSuccessSnackbar('$poNumber rejected!');
  }

  // NEW: Show Success Snackbar
  void _showSuccessSnackbar(String message) {
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
              child: const Icon(
                Icons.check,
                color: snackbarGreenColor,
                size: 20,
              ),
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
        backgroundColor: snackbarGreenColor,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBars.defaultAppBar(
          context: context,
          title: 'Approve Order',
          navigationType: NavigationType.pop,
        ),
        body: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              // Search bar section (fixed at top)
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 20.0),
                child: Center(
                  child: SizedBox(
                    width: 700,
                    child: Row(
                      children: [
                        // Search field
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: AppColors.borderColor),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                const Icon(
                                  Icons.search,
                                  color: AppColors.grayColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    decoration: const InputDecoration(
                                      hintText:
                                          'Search by PO number or client name...',
                                      hintStyle: TextStyle(
                                        color: AppColors.grayColor,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                // Clear button
                                if (_showClearButton)
                                  MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: _clearSearch,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        margin: const EdgeInsets.only(right: 8),
                                        child: const Icon(
                                          Icons.close,
                                          color: AppColors.grayColor,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Filter search icon button
                        Container(
                          key: _filterIconKey,
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: AppColors.borderColor),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                            child: InkWell(
                              onTap: () {
                                _showFilterDialog(context);
                              },
                              borderRadius: BorderRadius.circular(25),
                              child: const Icon(
                                Icons.filter_list,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Orders list (scrollable)
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: 700,
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          // Show message if no results
                          if (_filteredOrders.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(40),
                              child: Text(
                                'No orders found${_searchController.text.isNotEmpty ? ' for "${_searchController.text}"' : ''}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.grayColor,
                                ),
                              ),
                            ),

                          // Generate order tiles
                          ..._filteredOrders.asMap().entries.map((entry) {
                            final index = entry.key;
                            final order = entry.value;
                            final isExpanded = _isExpandedList[index];

                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.tile2Color,
                                border: index > 0
                                    ? const Border(
                                        top: BorderSide(
                                          color: AppColors.borderColor,
                                          width: 1,
                                        ),
                                      )
                                    : null,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Main row with PO number and expand button
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Order info
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // PO Number
                                            Text(
                                              order['poNumber']!,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 8),

                                            // Last Updated
                                            Text(
                                              'Last Updated: ${order['lastUpdated']!}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppColors.grayColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Expand button (centered vertically)
                                      Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: AppColors.darkGrayColor,
                                          ),
                                        ),
                                        child: Material(
                                          color: Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                _isExpandedList[index] =
                                                    !isExpanded;
                                              });
                                            },
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: Icon(
                                              isExpanded
                                                  ? Icons.expand_less
                                                  : Icons.expand_more,
                                              color: AppColors.darkGrayColor,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Expanded content (shown when expanded)
                                  if (isExpanded)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Additional order details
                                          Row(
                                            children: [
                                              Text(
                                                'Client: ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.grayColor,
                                                ),
                                              ),
                                              Text(
                                                order['clientName']!,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.grayColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),

                                          Row(
                                            children: [
                                              Text(
                                                'Created: ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.grayColor,
                                                ),
                                              ),
                                              Text(
                                                order['creationDate']!,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.grayColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),

                                          Row(
                                            children: [
                                              Text(
                                                'Net Price: ',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.grayColor,
                                                ),
                                              ),
                                              Text(
                                                order['netPrice']!,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.grayColor,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // Action buttons (Approve, Reject, View)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                // Approve button
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    left: 12,
                                                  ),
                                                  child: CustomTextButtons.approveButton(
                                                    context: context,
                                                    onApprove: () {
                                                      _showApproveConfirmationDialog(
                                                        order['poNumber']!,
                                                        order['clientName']!,
                                                      );
                                                    },
                                                  ),
                                                ),

                                                // Reject button
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    left: 12,
                                                  ),
                                                  child: CustomTextButtons.rejectButton(
                                                    context: context,
                                                    onReject: () {
                                                      _showRejectConfirmationDialog(
                                                        order['poNumber']!,
                                                        order['clientName']!,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),

                          // END indicator (outside the last tile)
                          if (_filteredOrders.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(30),
                              child: Text(
                                '- END -',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.grayColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
