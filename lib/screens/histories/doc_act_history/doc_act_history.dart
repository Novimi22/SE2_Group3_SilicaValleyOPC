import 'package:flutter/material.dart';
import 'package:draft_screens/constants/app_bars.dart';
import 'package:draft_screens/constants/colors.dart';
import 'package:draft_screens/constants/buttons/elevated_buttons.dart';

class DocumentActivityHistoryScreen extends StatefulWidget {
  final String documentTitle;
  final String purchaseOrderNumber;
  final String clientName;

  const DocumentActivityHistoryScreen({
    super.key,
    required this.documentTitle,
    required this.purchaseOrderNumber,
    required this.clientName,
  });

  @override
  State<DocumentActivityHistoryScreen> createState() =>
      _DocumentActivityHistoryScreenState();
}

class _DocumentActivityHistoryScreenState
    extends State<DocumentActivityHistoryScreen> {
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

  // Sample data
  final List<Map<String, String>> _allDocumentHistory = [
    {
      'date': '01/15/2024',
      'editedBy': 'John Doe',
      'activityType': 'File Uploaded',
    },
    {
      'date': '01/14/2024',
      'editedBy': 'Michael Jackson',
      'activityType': 'File Edited',
    },
    {
      'date': '01/13/2024',
      'editedBy': 'Chris Hemsworth',
      'activityType': 'File Uploaded',
    },
    {
      'date': '01/12/2024',
      'editedBy': 'Michael V',
      'activityType': 'File Uploaded',
    },
    {
      'date': '01/11/2024',
      'editedBy': 'Jane Hopper',
      'activityType': 'File Deleted',
    },
    {
      'date': '01/10/2024',
      'editedBy': 'Jim Hopper',
      'activityType': 'File Uploaded',
    },
    {
      'date': '01/09/2024',
      'editedBy': 'Sarah Geronimo',
      'activityType': 'File Deleted',
    },
    {
      'date': '01/08/2024',
      'editedBy': 'Jang Wonyoung',
      'activityType': 'File Edited',
    },
    {
      'date': '01/07/2024',
      'editedBy': 'Lisa Manoban',
      'activityType': 'File Edited',
    },
    {
      'date': '01/06/2024',
      'editedBy': 'Kim Jennie',
      'activityType': 'File Uploaded',
    },
  ];

  // Filtered data based on search
  List<Map<String, String>> _filteredDocumentHistory = [];

  @override
  void initState() {
    super.initState();
    // Initialize filtered list with all data
    _filteredDocumentHistory = List.from(_allDocumentHistory);

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
        _filteredDocumentHistory = _allDocumentHistory.where((document) {
          return document['editedBy']!.toLowerCase().contains(searchText) ||
              document['activityType']!.toLowerCase().contains(searchText);
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
    List<Map<String, String>> result = List.from(_allDocumentHistory);

    // Apply activity type filter if selected
    if (_selectedActivityType != null && _selectedSortBy == 'Activity Type') {
      result = result.where((document) {
        return document['activityType'] == _selectedActivityType;
      }).toList();
    }

    setState(() {
      _filteredDocumentHistory = result;
      _applySorting();
    });
  }

  // Apply sorting based on selected criteria
  void _applySorting() {
    setState(() {
      _filteredDocumentHistory.sort((a, b) {
        int comparison = 0;

        switch (_selectedSortBy) {
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
                                              'File Uploaded',
                                              'File Edited',
                                              'File Deleted',
                                              'File Downloaded',
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
                            padding: const EdgeInsets.symmetric(vertical: 12),
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
      appBar: CustomAppBars.appBarWithSubtitle(
        context: context,
        title: 'Document Activity History',
        subtitle: widget.documentTitle,
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
                                        'Search by name or activity type...',
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

            // Document history list (scrollable)
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
                        if (_filteredDocumentHistory.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(40),
                            child: Text(
                              'No document history found${_searchController.text.isNotEmpty ? ' for "${_searchController.text}"' : ''}',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.grayColor,
                              ),
                            ),
                          ),

                        // Generate document history entries
                        ..._filteredDocumentHistory.asMap().entries.map((
                          entry,
                        ) {
                          final index = entry.key;
                          final document = entry.value;

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
                                  document['date']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.grayColor,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Edited by
                                Text(
                                  'Edited by: ${document['editedBy']!}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.grayColor,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                // Activity Type
                                Text(
                                  'Activity Type: ${document['activityType']!}',
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
