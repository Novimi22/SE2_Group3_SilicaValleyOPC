import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';

import 'package:image_picker/image_picker.dart';
import 'package:draft_screens/screens/histories/doc_act_history.dart';

import 'dart:io';

class TrackRecordScreen extends StatefulWidget {
  final String purchaseOrderNumber;
  final String clientName;

  const TrackRecordScreen({
    super.key,
    required this.purchaseOrderNumber,
    required this.clientName,
  });

  @override
  State<TrackRecordScreen> createState() => _TrackRecordScreenState();
}

class _TrackRecordScreenState extends State<TrackRecordScreen> {

  // Payment status
  String _paymentStatus = 'Pending';
  final List<String> _paymentOptions = ['Paid', 'Pending'];

  // Document titles (11 default + optional miscellaneous tiles)
  final List<String> _defaultDocumentTitles = [
    'Purchase Order (client) (P.O.)',
    'Truck Delivery Receipt (DR)',
    'Truck Acknowledgement Receipt (AR)',
    'Deposit slip (payment to truck)',
    'Silica Valley DR',
    'Cheque (client payment to SV)',
    'Deposit slip (^)',
    'Check voucher',
    'SV AR/Collection Receipt',
    'Sales Invoice',
  ];

  // Track expanded state, attached files, and status for each document
  List<bool> _isExpandedList = [];
  List<File?> _attachedFiles = [];
  List<bool> _hasFileList = []; // true = green line, false = red/gray line
  List<String> _documentTitles = [];
  List<String?> _lastUpdatedDates =
      []; // Track last updated dates for each document (nullable)

  // Track miscellaneous documents
  int _miscellaneousCount = 1;
  List<int> _miscellaneousIndices = []; // Store indices of miscellaneous docs

  // Image picker
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize with default documents
    _documentTitles = List.from(_defaultDocumentTitles);

    // horizontal line separator
    _documentTitles.add('[HORIZONTAL_LINE]');

    // Add first miscellaneous document
    _documentTitles.add('Miscellaneous 1');
    _miscellaneousIndices.add(_documentTitles.length - 1);

    // Initialize states for all documents
    _initializeDocumentStates();
  }

  void _initializeDocumentStates() {
    _isExpandedList = List.generate(_documentTitles.length, (index) => false);
    _attachedFiles = List.generate(_documentTitles.length, (index) => null);
    _hasFileList = List.generate(_documentTitles.length, (index) => false);
    // Initialize last updated dates as null (initially blank)
    _lastUpdatedDates = List.generate(_documentTitles.length, (index) => null);
  }

  // Calculate document count (tiles with uploaded files)
  int get _documentCount {
    return _hasFileList.where((hasFile) => hasFile).length;
  }

  // Check if a document is miscellaneous
  bool _isMiscellaneous(int index) {
    return _miscellaneousIndices.contains(index);
  }

  // Get status indicator color for a document
  Color _getStatusIndicatorColor(int index) {
    if (_isMiscellaneous(index)) {
      return _hasFileList[index] ? AppColors.greenColor : AppColors.grayColor;
    } else {
      return _hasFileList[index] ? AppColors.greenColor : AppColors.redColor;
    }
  }

  // Show confirmation dialog for deleting file
  void _showDeleteConfirmationDialog(int index) {
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
                  const Text(
                    'CONFIRM CHANGES?',
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
                      'Are you sure you want to delete the file for this document?',
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
                        _deleteFile(index);
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
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
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
        );
      },
    );
  }

  // Show confirmation dialog for downloading report
  void _showDownloadConfirmationDialog() {
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
                  const Text(
                    'CONFIRM DOWNLOAD?',
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
                      'Are you sure you want to generate a report?',
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
                        _generateReport();
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
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
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
        );
      },
    );
  }

  // Generate report function
  void _generateReport() {
    // TODO: Implement report generation logic
    print('Generating report for PO: ${widget.purchaseOrderNumber}');

    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
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
                'Report generated successfully!',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Delete attached file
  void _deleteFile(int index) {
    setState(() {
      _attachedFiles[index] = null;
      _hasFileList[index] = false;
      // DO NOT clear the last updated date when file is deleted
      // Keep the date to show when it was last updated
    });

    // Show red snackbar with check icon
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.red, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'File deleted!',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Pick image from gallery or camera
  Future<void> _pickImage(int index, ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _attachedFiles[index] = File(pickedFile.path);
          _hasFileList[index] = true;
          // Set last updated date when file is attached (only if not set before)
          if (_lastUpdatedDates[index] == null) {
            _lastUpdatedDates[index] = _getFormattedDate();
          }

          // If this miscellaneous tile has a file, add another one
          if (_isMiscellaneous(index) &&
              index == _miscellaneousIndices.last &&
              _hasFileList[index]) {
            _addNewMiscellaneousDocument();
          }
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  // Add new miscellaneous document
  void _addNewMiscellaneousDocument() {
    setState(() {
      _miscellaneousCount++;
      final newTitle = 'Miscellaneous $_miscellaneousCount';

      // Insert before the END indicator if it exists
      if (_documentTitles.isNotEmpty && _documentTitles.last == '- END -') {
        _documentTitles.insert(_documentTitles.length - 1, newTitle);
        _miscellaneousIndices.add(_documentTitles.length - 2);
      } else {
        _documentTitles.add(newTitle);
        _miscellaneousIndices.add(_documentTitles.length - 1);
      }

      // Update all state lists
      _isExpandedList.add(false);
      _attachedFiles.add(null);
      _hasFileList.add(false);
      _lastUpdatedDates.add(null); // Start with null (blank) for new document
    });
  }

  // Show image source selection dialog
  void _showImageSourceDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(index, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(index, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Back button
              Container(
                height: 80,
                alignment: Alignment.center,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  padding: const EdgeInsets.only(left: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // Spacer
              const Expanded(child: SizedBox()),

              //
              Container(
                height: 80,
                alignment: Alignment.center,
                child: const Text(
                  'Track Order Record',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              // Spacer for balance
              const Expanded(child: SizedBox()),

              // Empty container to balance layout
              const SizedBox(width: 48, height: 80),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            // Top section with PO info, legends, and download button
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 20.0),
              child: Center(
                child: Container(
                  width: 700,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // PO Number and Document Count row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // PO Number and Payment Status
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Purchase Order Number
                              Text(
                                'Purchase Order Number:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grayColor,
                                ),
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

                              const SizedBox(height: 16),

                              // Payment Status row
                              Row(
                                children: [
                                  Text(
                                    'Payment Status:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.grayColor,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 150,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.borderColor),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _paymentStatus,
                                        isExpanded: true,
                                        items: _paymentOptions.map((
                                          String value,
                                        ) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _paymentStatus = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Document Count
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Document Count:',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grayColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _documentCount.toString(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Legends and Download Button row
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Legends
                            Row(
                              children: [
                                // First legend: "File attached"
                                Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: AppColors.redColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'File attached',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.grayColor,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(width: 20),

                                // Second legend: "No file attached"
                                Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: AppColors.greenColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'No file attached',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.grayColor,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(width: 20),

                                // Third legend: "Optional"
                                Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: AppColors.grayColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Optional',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.grayColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Download Report button
                            Material(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                onTap: () {
                                  _showDownloadConfirmationDialog();
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.download,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Generate Report',
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
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Document Tiles section (scrollable)
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
                      children: _documentTitles.asMap().entries.map((entry) {
                        final index = entry.key;
                        final title = entry.value;
                        final isExpanded = _isExpandedList[index];

                        // Handle horizontal line separator
                        if (title == '[HORIZONTAL_LINE]') {
                          return Container(
                            width: double.infinity,
                            height: 1,
                            color: AppColors.borderColor,
                            margin: const EdgeInsets.symmetric(vertical: 20),
                          );
                        }

                        // Handle END indicator
                        if (title == '- END -') {
                          return Container(
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
                          );
                        }

                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.tileColor,
                            border:
                                index > 0 &&
                                    _documentTitles[index - 1] !=
                                        '[HORIZONTAL_LINE]' &&
                                    _documentTitles[index - 1] != '- END -'
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
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // Navigate to DocumentActivityHistoryScreen when tile is clicked
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DocumentActivityHistoryScreen(
                                          documentTitle: title,
                                          purchaseOrderNumber:
                                              widget.purchaseOrderNumber,
                                          clientName: widget.clientName,
                                        ),
                                  ),
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Status Indicator Line
                                  Container(
                                    width: 4,
                                    height: 60,
                                    margin: const EdgeInsets.only(right: 16),
                                    decoration: BoxDecoration(
                                      color: _getStatusIndicatorColor(index),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Main row with title and expand button
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // Document info
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Document Title
                                                  Text(
                                                    title,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),

                                                  // Show "Last updated: MM/DD/YYYY" only if date is set
                                                  Text(
                                                    _lastUpdatedDates[index] !=
                                                            null
                                                        ? 'Last updated: ${_lastUpdatedDates[index]}'
                                                        : '', // Blank initially
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: AppColors.grayColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Action buttons
                                            Row(
                                              children: [
                                                // Delete button
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    border: Border.all(
                                                      color:
                                                          _attachedFiles[index] !=
                                                              null
                                                          ? AppColors.iconDarkGrayColor
                                                          : AppColors.iconDarkGrayColor
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                    ),
                                                  ),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        // Prevent tile navigation by handling it here
                                                        if (_attachedFiles[index] !=
                                                            null) {
                                                          _showDeleteConfirmationDialog(
                                                            index,
                                                          );
                                                        }
                                                      },
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                      child: Icon(
                                                        Icons.delete_outline,
                                                        color:
                                                            _attachedFiles[index] !=
                                                                null
                                                            ? AppColors.iconDarkGrayColor
                                                            : AppColors.iconDarkGrayColor
                                                                  .withOpacity(
                                                                    0.3,
                                                                  ),
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(width: 12),

                                                // Attach File button
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    border: Border.all(
                                                      color: AppColors.iconDarkGrayColor,
                                                    ),
                                                  ),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        // Prevent tile navigation by handling it here
                                                        _showImageSourceDialog(
                                                          index,
                                                        );
                                                      },
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                      child: Icon(
                                                        Icons.attach_file,
                                                        color: AppColors.iconDarkGrayColor,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(width: 12),

                                                // Expand button
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    border: Border.all(
                                                      color: AppColors.iconDarkGrayColor,
                                                    ),
                                                  ),
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    child: InkWell(
                                                      onTap: () {
                                                        // Prevent tile navigation by handling it here
                                                        setState(() {
                                                          _isExpandedList[index] =
                                                              !isExpanded;
                                                        });
                                                      },
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                      child: Icon(
                                                        isExpanded
                                                            ? Icons.expand_less
                                                            : Icons.expand_more,
                                                        color: AppColors.iconDarkGrayColor,
                                                        size: 24,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        // Expanded content (scrollable within expanded area)
                                        if (isExpanded)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 20,
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  if (_attachedFiles[index] !=
                                                      null)
                                                    Column(
                                                      children: [
                                                        Text(
                                                          'File attached: ${_attachedFiles[index]!.path.split('/').last}',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                AppColors.grayColor,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),

                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: 200,
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  AppColors.borderColor,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                            color: Colors
                                                                .grey[200],
                                                          ),
                                                          child:
                                                              _attachedFiles[index] !=
                                                                  null
                                                              ? _buildImagePreview(
                                                                  index,
                                                                )
                                                              : const Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .insert_drive_file,
                                                                    size: 48,
                                                                    color:
                                                                        AppColors.grayColor,
                                                                  ),
                                                                ),
                                                        ),
                                                      ],
                                                    )
                                                  else
                                                    // Message: no file is attached
                                                    Container(
                                                      width: double.infinity,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 20,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: AppColors.borderColor,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .insert_drive_file,
                                                            size: 48,
                                                            color:
                                                                AppColors.grayColor,
                                                          ),
                                                          const SizedBox(
                                                            height: 16,
                                                          ),
                                                          Text(
                                                            'No file attached',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  AppColors.grayColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
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

  // Helper function to get formatted date (MM/DD/YYYY)
  String _getFormattedDate() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final year = now.year.toString();
    return '$month/$day/$year';
  }

  // Helper function to build image preview
  Widget _buildImagePreview(int index) {
    // For web compatibility, use a fallback
    // In a real app, you would upload the file to a server and use Image.network (according sa gpt hehe)
    // For now, we'll show a placeholder with file info
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.insert_drive_file, size: 48, color: AppColors.iconDarkGrayColor),
          const SizedBox(height: 16),
          Text(
            'File: ${_attachedFiles[index]!.path.split('/').last}',
            style: TextStyle(fontSize: 14, color: AppColors.grayColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '(Image preview not available on web)',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.grayColor,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
