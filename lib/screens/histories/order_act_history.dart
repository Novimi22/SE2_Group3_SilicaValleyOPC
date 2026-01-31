import 'package:flutter/material.dart';
import 'package:draft_screens/constants/app_bars.dart';
import 'package:draft_screens/constants/colors.dart';
import 'package:draft_screens/constants/search_bar.dart';
import 'package:draft_screens/constants/search_filter.dart';

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

  // sample data
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
            // Extract numbers from names for proper numeric sorting
            final numA = _extractNumberFromString(a['editedBy']!);
            final numB = _extractNumberFromString(b['editedBy']!);

            // If both have numbers, sort numerically
            if (numA != null && numB != null) {
              comparison = numA.compareTo(numB);
            } else {
              // Fallback to string comparison
              comparison = a['editedBy']!.compareTo(b['editedBy']!);
            }
            break;
          case 'Activity Type':
            // Extract numbers from activity types for proper numeric sorting
            final numA = _extractNumberFromString(a['activityType']!);
            final numB = _extractNumberFromString(b['activityType']!);

            // If both have numbers, sort numerically
            if (numA != null && numB != null) {
              comparison = numA.compareTo(numB);
            } else {
              // Fallback to string comparison
              comparison = a['activityType']!.compareTo(b['activityType']!);
            }
            break;
          case 'Modification Date':
          default:
            // Use proper date comparison
            comparison = _compareDates(a['date']!, b['date']!);
            break;
        }

        // Apply sort order
        return _selectedSortOrder == 'Descending' ? -comparison : comparison;
      });
    });
  }

  // Helper function for proper date comparison (MM/DD/YYYY format)
  int _compareDates(String dateA, String dateB) {
    try {
      // Parse dates in MM/DD/YYYY format
      final partsA = dateA.split('/');
      final partsB = dateB.split('/');

      if (partsA.length == 3 && partsB.length == 3) {
        final yearA = int.parse(partsA[2]);
        final monthA = int.parse(partsA[0]);
        final dayA = int.parse(partsA[1]);

        final yearB = int.parse(partsB[2]);
        final monthB = int.parse(partsB[0]);
        final dayB = int.parse(partsB[1]);

        // Compare year first
        if (yearA != yearB) return yearA.compareTo(yearB);
        // Then month
        if (monthA != monthB) return monthA.compareTo(monthB);
        // Then day
        return dayA.compareTo(dayB);
      }
    } catch (e) {
      // Fallback to string comparison if parsing fails
    }
    return dateA.compareTo(dateB);
  }

  // Helper function to extract numbers from strings
  int? _extractNumberFromString(String text) {
    try {
      // Find all sequences of digits
      final matches = RegExp(r'\d+').allMatches(text);
      if (matches.isNotEmpty) {
        // Take the first number found
        return int.parse(matches.first.group(0)!);
      }
    } catch (e) {
      // If parsing fails, return null
    }
    return null;
  }

  // Show filter dialog
  void _showFilterDialog(BuildContext context) {
    SearchFilterDialog.showFilterDialog(
      context: context,
      filterIconKey: _filterIconKey,
      selectedSortBy: _selectedSortBy,
      selectedSortOrder: _selectedSortOrder,
      selectedActivityType: _selectedActivityType,
      onApply: (sortBy, sortOrder, activityType) {
        setState(() {
          _selectedSortBy = sortBy;
          _selectedSortOrder = sortOrder;
          _selectedActivityType = activityType;
          _applyFiltersAndSorting();
        });
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
    return SafeArea(
      child: Scaffold(
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
              // Search bar section
              SearchBarWidget(
                searchController: _searchController,
                filterIconKey: _filterIconKey,
                onFilterPressed: _showFilterDialog,
                onClearSearch: _clearSearch,
                hintText:
                    'Search by name, activity type, or modification date...',
                showClearButton: _showClearButton,
                width: 700,
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
      ),
    );
  }
}
