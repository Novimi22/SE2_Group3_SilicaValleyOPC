import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController searchController;
  final GlobalKey filterIconKey;
  final Function(BuildContext) onFilterPressed;
  final String hintText;
  final bool showClearButton;
  final Function() onClearSearch;
  final double width;

  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.filterIconKey,
    required this.onFilterPressed,
    required this.onClearSearch,
    this.hintText = 'Search...',
    this.showClearButton = false,
    this.width = 700,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 20.0),
      child: Center(
        child: SizedBox(
          width: widget.width,
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
                          controller: widget.searchController,
                          decoration: InputDecoration(
                            hintText: widget.hintText,
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
                      if (widget.showClearButton)
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: widget.onClearSearch,
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
                key: widget.filterIconKey,
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
                      widget.onFilterPressed(context);
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
    );
  }
}