// search_filter.dart
import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';
import 'package:draft_screens/constants/buttons/elevated_buttons.dart';

class SearchFilterDialog {

  static void showFilterDialog({
    required BuildContext context,
    required GlobalKey filterIconKey,
    required String selectedSortBy,
    required String selectedSortOrder,
    required String? selectedActivityType,
    required Function(String, String, String?) onApply,
  }) {
    // Local variables for dialog state
    String dialogSortBy = selectedSortBy;
    String dialogSortOrder = selectedSortOrder;
    String? dialogActivityType = selectedActivityType;

    // Get the position of the filter icon
    final renderBox =
        filterIconKey.currentContext?.findRenderObject() as RenderBox?;
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
                                onApply(dialogSortBy, dialogSortOrder, dialogActivityType);
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

  // For OrderListWidget (Generic version from your ManageOrderScreen)
  static void showOrderFilterDialog({
    required BuildContext context,
    required GlobalKey filterIconKey,
    required String selectedSortBy,
    required String selectedSortOrder,
    required Function(String, String) onApply,
  }) {
    // Local variables for dialog state
    String dialogSortBy = selectedSortBy;
    String dialogSortOrder = selectedSortOrder;

    // Get the position of the filter icon
    final renderBox =
        filterIconKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);

    // Calculate position for the dialog - exactly like original
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
                                onApply(dialogSortBy, dialogSortOrder);
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
}