import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/buttons/text_buttons.dart';
import '../constants/buttons/elevated_buttons.dart';

class OrderListWidget extends StatefulWidget {
  final String screenTitle;
  final PreferredSizeWidget appBar;
  final String buttonText;
  final Function(Map<String, String> order) onButtonPressed;
  final List<Map<String, String>> initialOrders;
  final bool showDeleteOption;
  final Function(String, String)? onDelete;
  
  // NEW: For multiple buttons
  final bool showMultipleButtons;
  final Function(Map<String, String>)? onUpdate;
  final Function(Map<String, String>)? onView;
  final Function(Map<String, String>)? onTrack;

  const OrderListWidget({
    super.key,
    required this.screenTitle,
    required this.appBar,
    required this.buttonText,
    required this.onButtonPressed,
    required this.initialOrders,
    this.showDeleteOption = false,
    this.onDelete,
    
    this.showMultipleButtons = false,
    this.onUpdate,
    this.onView,
    this.onTrack,
  });

  @override
  State<OrderListWidget> createState() => _OrderListWidgetState();
}

class _OrderListWidgetState extends State<OrderListWidget> {
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

  // Filtered data based on search
  List<Map<String, String>> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    // Initialize filtered list with all data
    _filteredOrders = List.from(widget.initialOrders);
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
        _filteredOrders = List.from(widget.initialOrders);
        _applySorting();
      });
    } else {
      setState(() {
        _filteredOrders = widget.initialOrders.where((order) {
          return order['poNumber']!.toLowerCase().contains(searchText) ||
              order['clientName']!.toLowerCase().contains(searchText);
        }).toList();
        _applySorting();
      });
    }
    _updateExpandedStates();
  }

  void _updateExpandedStates() {
    setState(() {
      _isExpandedList = List.generate(_filteredOrders.length, (index) => false);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _showClearButton = false;
      _filteredOrders = List.from(widget.initialOrders);
      _applySorting();
      _updateExpandedStates();
    });
  }

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
            double priceA = double.tryParse(
                  a['netPrice']!.replaceAll('\₱', '').replaceAll(',', '').replaceAll('₱', ''),
                ) ??
                0.0;
            double priceB = double.tryParse(
                  b['netPrice']!.replaceAll('\₱', '').replaceAll(',', '').replaceAll('₱', ''),
                ) ??
                0.0;
            comparison = priceA.compareTo(priceB);
            break;
          default:
            comparison = a['creationDate']!.compareTo(b['creationDate']!);
            break;
        }

        return _selectedSortOrder == 'Descending' ? -comparison : comparison;
      });
    });
  }

  void _showFilterDialog(BuildContext context) {
    String dialogSortBy = _selectedSortBy;
    String dialogSortOrder = _selectedSortOrder;

    final renderBox =
        _filterIconKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final double dialogTop = position.dy + renderBox.size.height + 10;
    final double dialogLeft = position.dx - 200;

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(color: Colors.transparent),
              ),
            ),
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
                        border: Border.all(color: AppColors.darkGrayColor, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.lightGrayColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.darkGrayColor, width: 1),
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

                          _buildRadioRow('Client Name', dialogSortBy, (value) {
                            setDialogState(() => dialogSortBy = value!);
                          }),
                          _buildRadioRow('Purchase Order Number', dialogSortBy, (value) {
                            setDialogState(() => dialogSortBy = value!);
                          }),
                          _buildRadioRow('Creation Date', dialogSortBy, (value) {
                            setDialogState(() => dialogSortBy = value!);
                          }),
                          _buildRadioRow('Net Price', dialogSortBy, (value) {
                            setDialogState(() => dialogSortBy = value!);
                          }),

                          const SizedBox(height: 20),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.lightGrayColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.darkGrayColor, width: 1),
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

                          _buildRadioRow('Ascending', dialogSortOrder, (value) {
                            setDialogState(() => dialogSortOrder = value!);
                          }),
                          _buildRadioRow('Descending', dialogSortOrder, (value) {
                            setDialogState(() => dialogSortOrder = value!);
                          }),

                          const SizedBox(height: 20),

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

  Widget _buildRadioRow(String label, String groupValue, ValueChanged<String?> onChanged) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: groupValue == label ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
          Radio<String>(
            value: label,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(String poNumber, String clientName) {
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                        'CONFIRM DELETE?',
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
                          'Re-enter Purchase Order Number to confirm deletion',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: AppColors.grayColor),
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
                              borderSide: const BorderSide(color: Color(0xFF19191B)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xFF19191B)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          onChanged: (value) {
                            setState(() {
                              purchaseOrderNumber = value;
                              showError = false;
                              errorMessage = '';
                            });
                          },
                          onSubmitted: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                showError = true;
                                errorMessage = 'Please enter the Purchase Order Number';
                              });
                              return;
                            }
                            if (value != poNumber) {
                              setState(() {
                                showError = true;
                                errorMessage = 'Purchase Order Number does not match';
                              });
                              return;
                            }
                            Navigator.of(context).pop();
                            _performDeleteOrder(poNumber, clientName);
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
                                const Icon(Icons.error_outline, color: Colors.red, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    errorMessage,
                                    style: TextStyle(color: Colors.red, fontSize: 14),
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
                          text: 'Confirm',
                          onPressed: () {
                            if (purchaseOrderNumber.isEmpty) {
                              setState(() {
                                showError = true;
                                errorMessage = 'Please enter the Purchase Order Number';
                              });
                              return;
                            }
                            if (purchaseOrderNumber != poNumber) {
                              setState(() {
                                showError = true;
                                errorMessage = 'Purchase Order Number does not match';
                              });
                              return;
                            }
                            Navigator.of(context).pop();
                            _performDeleteOrder(poNumber, clientName);
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

  void _performDeleteOrder(String poNumber, String clientName) {
    if (widget.onDelete != null) {
      widget.onDelete!(poNumber, clientName);
    }

    setState(() {
      widget.initialOrders.removeWhere((order) => order['poNumber'] == poNumber);
      _filteredOrders.removeWhere((order) => order['poNumber'] == poNumber);
      _updateExpandedStates();
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 20.0),
              child: Center(
                child: Container(
                  width: 700,
                  child: Row(
                    children: [
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
                              const Icon(Icons.search, color: AppColors.grayColor, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Search by PO number or client name...',
                                    hintStyle: TextStyle(color: AppColors.grayColor),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  style: const TextStyle(fontSize: 16, color: Colors.black),
                                ),
                              ),
                              if (_showClearButton)
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: _clearSearch,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      margin: const EdgeInsets.only(right: 8),
                                      child: const Icon(Icons.close, color: AppColors.grayColor, size: 18),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
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
                            onTap: () => _showFilterDialog(context),
                            borderRadius: BorderRadius.circular(25),
                            child: const Icon(Icons.filter_list, color: Colors.black, size: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Orders list
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: 700,
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.borderColor, width: 1),
                    ),
                    child: Column(
                      children: [
                        if (_filteredOrders.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(40),
                            child: Text(
                              'No orders found${_searchController.text.isNotEmpty ? ' for "${_searchController.text}"' : ''}',
                              style: TextStyle(fontSize: 16, color: AppColors.grayColor),
                            ),
                          ),
                        ..._filteredOrders.asMap().entries.map((entry) {
                          final index = entry.key;
                          final order = entry.value;
                          final isExpanded = _isExpandedList[index];

                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.tile2Color,
                              border: index > 0
                                  ? const Border(top: BorderSide(color: AppColors.borderColor, width: 1))
                                  : null,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            order['poNumber']!,
                                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Last Updated: ${order['lastUpdated']!}',
                                            style: TextStyle(fontSize: 14, color: AppColors.grayColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: AppColors.darkGrayColor),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() => _isExpandedList[index] = !isExpanded);
                                          },
                                          borderRadius: BorderRadius.circular(20),
                                          child: Icon(
                                            isExpanded ? Icons.expand_less : Icons.expand_more,
                                            color: AppColors.darkGrayColor,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (isExpanded)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildDetailRow('Client:', order['clientName']!),
                                        _buildDetailRow('Created:', order['creationDate']!),
                                        _buildDetailRow('Net Price:', order['netPrice']!),
                                        const SizedBox(height: 10),
                                        // BUTTONS SECTION
                                        if (widget.showMultipleButtons)
                                          _buildMultipleButtons(order)
                                        else
                                          _buildSingleButton(order),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                        if (_filteredOrders.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(30),
                            child: Text(
                              '- END -',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.grayColor),
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
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.grayColor),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(fontSize: 14, color: AppColors.grayColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleButton(Map<String, String> order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 12),
          child: CustomTextButtons.actionButton(
            context: context,
            text: widget.buttonText,
            onPressed: () => widget.onButtonPressed(order),
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildMultipleButtons(Map<String, String> order) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (widget.showDeleteOption && widget.onDelete != null)
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: CustomTextButtons.deleteButton(
              context: context,
              onDelete: () => _showDeleteConfirmationDialog(order['poNumber']!, order['clientName']!),
            ),
          ),
        if (widget.onUpdate != null)
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: CustomTextButtons.updateButton(
              context: context,
              onUpdate: () => widget.onUpdate!(order),
            ),
          ),
        if (widget.onView != null)
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: CustomTextButtons.viewButton(
              context: context,
              onView: () => widget.onView!(order),
            ),
          ),
        if (widget.onTrack != null)
          Container(
            margin: const EdgeInsets.only(left: 12),
            child: CustomTextButtons.trackButton(
              context: context,
              onTrack: () => widget.onTrack!(order),
            ),
          ),
      ],
    );
  }
}