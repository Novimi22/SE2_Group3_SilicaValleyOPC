import 'package:flutter/material.dart';
import 'package:draft_screens/constants/app_bars.dart';
import 'package:draft_screens/constants/colors.dart';
import 'package:draft_screens/constants/buttons/elevated_buttons.dart';

class OrderActivityHistoryScreen extends StatefulWidget {
  const OrderActivityHistoryScreen({super.key});

  @override
  State<OrderActivityHistoryScreen> createState() =>
      _OrderActivityHistoryScreenState();
}

class _OrderActivityHistoryScreenState
    extends State<OrderActivityHistoryScreen> {
  // Filter state
  String _selectedSortBy = 'Modification Date';
  String _selectedSortOrder = 'Ascending';
  String? _selectedActivityType;

  // Search controller
  final TextEditingController _searchController = TextEditingController();

  // Global key for filter icon position
  final GlobalKey _filterIconKey = GlobalKey();

  // Track search input for clear button visibility
  bool _showClearButton = false;

  // Original sample data for activity history
  final List<Map<String, String>> _allActivityHistory = List.generate(15, (
    index,
  ) {
    final poNumber = (1000000 + index).toString().padLeft(8, '0');
    return {
      'date': '01/${(index + 10).toString().padLeft(2, '0')}/2024',
      'poNumber': 'PO$poNumber',
      'editedBy': 'John Doe ${index + 1}',
      'activityType': 'Option ${(index % 3) + 1}',
    };
  });

  // Filtered data based on search
  List<Map<String, String>> _filteredActivityHistory = [];

  @override
  void initState() {
    super.initState();
    // Initialize filtered list with all data
    _filteredActivityHistory = List.from(_allActivityHistory);

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
      // Reset to all data, then apply filters
      _applyFiltersAndSorting();
    } else {
      setState(() {
        _filteredActivityHistory = _allActivityHistory.where((activity) {
          return activity['poNumber']!.toLowerCase().contains(searchText) ||
              activity['editedBy']!.toLowerCase().contains(searchText) ||
              activity['activityType']!.toLowerCase().contains(searchText);
        }).toList();

        // Apply sorting to filtered results
        _applySorting();
      });
    }
  }

  // Clear search input
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _showClearButton = false;
      // Reset to all data with current filters
      _applyFiltersAndSorting();
    });
  }

  // Apply both filtering and sorting
  void _applyFiltersAndSorting() {
    // Start with all data
    List<Map<String, String>> result = List.from(_allActivityHistory);

    // Apply activity type filter if selected
    if (_selectedActivityType != null && _selectedSortBy == 'Activity Type') {
      result = result.where((activity) {
        return activity['activityType'] == _selectedActivityType;
      }).toList();
    }

    setState(() {
      _filteredActivityHistory = result;
      _applySorting();
    });
  }

  // Apply sorting based on selected criteria
  void _applySorting() {
    setState(() {
      _filteredActivityHistory.sort((a, b) {
        int comparison = 0;

        switch (_selectedSortBy) {
          case 'Name':
            comparison = a['editedBy']!.compareTo(b['editedBy']!);
            break;
          case 'Activity Type':
            comparison = a['activityType']!.compareTo(b['activityType']!);
            break;
          case 'Modification Date':
          default:
            // For date comparison
            comparison = a['date']!.compareTo(b['date']!);
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
    String? dialogActivityType = _selectedActivityType;

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

                          // Name selection row
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Name',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: dialogSortBy == 'Name'
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                Radio<String>(
                                  value: 'Name',
                                  groupValue: dialogSortBy,
                                  onChanged: (value) {
                                    setDialogState(() {
                                      dialogSortBy = value!;
                                      dialogActivityType = null;
                                    });
                                  },
                                  activeColor: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ),

                          // Activity Type selection row
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Activity Type',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight:
                                            dialogSortBy == 'Activity Type'
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Radio<String>(
                                      value: 'Activity Type',
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

                                // Activity Type dropdown (shown when Activity Type is selected)
                                if (dialogSortBy == 'Activity Type')
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 8,
                                      left: 8,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.borderColor,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: DropdownButton<String>(
                                        value: dialogActivityType,
                                        hint: Text(
                                          'Select Activity Type',
                                          style: TextStyle(
                                            color: AppColors.grayColor,
                                          ),
                                        ),
                                        isExpanded: true,
                                        underline: const SizedBox(),
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black,
                                        ),
                                        items:
                                            [
                                              'Option 1',
                                              'Option 2',
                                              'Option 3',
                                            ].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                        onChanged: (String? newValue) {
                                          setDialogState(() {
                                            dialogActivityType = newValue;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Modification Date selection row
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Modification Date',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        dialogSortBy == 'Modification Date'
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                Radio<String>(
                                  value: 'Modification Date',
                                  groupValue: dialogSortBy,
                                  onChanged: (value) {
                                    setDialogState(() {
                                      dialogSortBy = value!;
                                      dialogActivityType = null;
                                    });
                                  },
                                  activeColor: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Sort Order section - Only title in gray box
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
                                  _selectedActivityType = dialogActivityType;
                                  _applyFiltersAndSorting();
                                });
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBars.defaultAppBar(
        context: context,
        title: 'Order Activity History',
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
                                  decoration: InputDecoration(
                                    hintText:
                                        'Search by name, activity type, or modification date...',
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

            // Activity history list (scrollable)
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: 762,
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
                        if (_filteredActivityHistory.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(40),
                            child: Text(
                              'No activity history found${_searchController.text.isNotEmpty ? ' for "${_searchController.text}"' : ''}',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.grayColor,
                              ),
                            ),
                          ),

                        // Generate activity history entries
                        ..._filteredActivityHistory.asMap().entries.map((
                          entry,
                        ) {
                          final index = entry.key;
                          final activity = entry.value;

                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
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
                              horizontal: 30,
                              vertical: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Date
                                Text(
                                  activity['date']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.grayColor,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // PO Number
                                Text(
                                  activity['poNumber']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Edited by
                                Text(
                                  'Edited by: ${activity['editedBy']!}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.grayColor,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                // Activity Type
                                Text(
                                  'Activity Type: ${activity['activityType']!}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.grayColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
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
}
