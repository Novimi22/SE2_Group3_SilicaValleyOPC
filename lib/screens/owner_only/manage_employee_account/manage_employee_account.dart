import 'package:flutter/material.dart';
import 'package:draft_screens/constants/colors.dart';
import 'package:draft_screens/constants/app_bars.dart';
import 'package:draft_screens/constants/buttons/elevated_buttons.dart';
import 'package:draft_screens/constants/buttons/text_buttons.dart';

import 'package:draft_screens/screens/owner_only/owner_landingpage.dart';
import '../manage_employee_account/delete_employee_account_otp.dart';

class ManageEmployeeAccountScreen extends StatefulWidget {
  const ManageEmployeeAccountScreen({super.key});

  @override
  State<ManageEmployeeAccountScreen> createState() =>
      _ManageEmployeeAccountScreenState();
}

class _ManageEmployeeAccountScreenState
    extends State<ManageEmployeeAccountScreen> {
  // Sample employee data
  final List<Map<String, String>> employees = [
    {
      'name': 'Juan Dela Cruz',
      'email': 'juandelacruz@email.com',
      'role': 'Owner',
    },
    {'name': 'Will Byers', 'email': 'willbyers@email.com', 'role': 'Employee'},
    {
      'name': 'Mike Wheelers',
      'email': 'mikewheelers@email.com',
      'role': 'Employee',
    },
    {
      'name': 'Steve Harrington',
      'email': 'steve_har@email.com',
      'role': 'Employee',
    },
    {'name': 'Jim Hopper', 'email': 'jim_hopper@email.com', 'role': 'Employee'},
  ];

  void _showCreateEmployeeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateEmployeeDialog(
          onEmployeeCreated: (newEmployee) {
            setState(() {
              employees.add(newEmployee);
            });
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
                      child: const Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Created employee account: ${newEmployee['name']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBars.defaultAppBar(
          context: context,
          title: 'Manage Employee Account',
          destination: const OwnerLandingPage(),
          navigationType: NavigationType.push,
        ),
        body: Container(
          width: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  Container(
                    width: 700,
                    margin: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Employee List header
                        Text(
                          'Employee List',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),

                        // Create Employee Account button
                        Material(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () {
                              _showCreateEmployeeDialog(context);
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.add,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Create Employee Account',
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

                  // Employee tiles container
                  Container(
                    width: 700,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      border: Border.all(
                        color: AppColors.borderColor,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: employees.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, String> employee = entry.value;

                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.tile2Color,
                            border: index < employees.length - 1
                                ? Border(
                                    bottom: BorderSide(
                                      color: AppColors.borderColor,
                                      width: 1,
                                    ),
                                  )
                                : null,
                          ),
                          child: _buildEmployeeTile(
                            name: employee['name']!,
                            email: employee['email']!,
                            role: employee['role']!,
                            onDelete: () {
                              _showDeleteConfirmation(
                                context,
                                employee['name']!,
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeTile({
    required String name,
    required String email,
    required String role,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Employee info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.largeTextColor,
                  ),
                ),
                const SizedBox(height: 8),

                // Email row
                Row(
                  children: [
                    Text(
                      'Email: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.smallTextColor,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.smallTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Role row
                Row(
                  children: [
                    Text(
                      'Role: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.smallTextColor,
                      ),
                    ),
                    Text(
                      role,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.smallTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Delete button
          GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.redColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, String employeeName) {
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
                  Text(
                    'CONFIRM DELETE?',
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
                      'Are you sure you want to delete this employee account?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.grayColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Confirm button
                  SizedBox(
                    width: 200,
                    child: CustomButtons.confirmButton(
                      context: context,
                      onConfirm: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VerifyEmailScreen3(employeeName: employeeName),
                          ),
                        );
                      },
                      text: 'Confirm',
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

  // Keep this method for snackbar but not for actual deletion
  void _performDelete(String employeeName) {
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
              child: const Icon(Icons.close, color: Colors.red, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Deleted employee account: $employeeName',
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
      ),
    );

    // Remove from list
    setState(() {
      employees.removeWhere((employee) => employee['name'] == employeeName);
    });
  }
}

// Separate widget for the create employee dialog
class CreateEmployeeDialog extends StatefulWidget {
  final Function(Map<String, String>) onEmployeeCreated;

  const CreateEmployeeDialog({super.key, required this.onEmployeeCreated});

  @override
  State<CreateEmployeeDialog> createState() => _CreateEmployeeDialogState();
}

class _CreateEmployeeDialogState extends State<CreateEmployeeDialog> {
  // Form controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleInitialController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Form validation
  bool showFormError = false;

  @override
  void dispose() {
    firstNameController.dispose();
    middleInitialController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 20,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBFB),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header: CREATE EMPLOYEE ACCOUNT
                Text(
                  'CREATE EMPLOYEE ACCOUNT',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 15),

                // Gray paragraph text
                SizedBox(
                  width: 400,
                  child: Text(
                    'Enter employee details',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xFF9E9E9E)),
                  ),
                ),

                const SizedBox(height: 30),

                // First Name field
                SizedBox(
                  width: 400,
                  child: TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      label: const Text('First Name'),
                      hintText: 'Enter First Name',
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
                    onChanged: (_) {
                      setState(() {
                        showFormError = false;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Middle Initial field
                SizedBox(
                  width: 400,
                  child: TextField(
                    controller: middleInitialController,
                    maxLength: 1,
                    decoration: InputDecoration(
                      label: const Text('Middle Initial (Optional)'),
                      hintText: 'Enter Middle Initial',
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
                      counterText: '',
                    ),
                    onChanged: (value) {
                      if (value.length > 1) {
                        middleInitialController.text = value
                            .substring(0, 1)
                            .toUpperCase();
                        middleInitialController.selection =
                            TextSelection.fromPosition(
                              TextPosition(
                                offset: middleInitialController.text.length,
                              ),
                            );
                      } else if (value.isNotEmpty) {
                        middleInitialController.text = value.toUpperCase();
                        middleInitialController.selection =
                            TextSelection.fromPosition(
                              TextPosition(
                                offset: middleInitialController.text.length,
                              ),
                            );
                      }

                      setState(() {
                        showFormError = false;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Last Name field
                SizedBox(
                  width: 400,
                  child: TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      label: const Text('Last Name'),
                      hintText: 'Enter Last Name',
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
                    onChanged: (_) {
                      setState(() {
                        showFormError = false;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Email field
                SizedBox(
                  width: 400,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      label: const Text('Email'),
                      hintText: 'Enter Email',
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
                    onChanged: (_) {
                      setState(() {
                        showFormError = false;
                      });
                    },
                  ),
                ),

                // Error message if fields are empty
                if (showFormError)
                  SizedBox(
                    width: 400,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Fill out all fields. Middle Initial is optional.',
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 30),

                // Create button
                SizedBox(
                  width: 200,
                  child: CustomButtons.createEmployeeButton(
                    context: context,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    email: emailController.text,
                    middleInitial: middleInitialController.text,
                    onEmployeeCreated: (newEmployee) {
                      widget.onEmployeeCreated(newEmployee);
                      Navigator.of(context).pop();
                    },
                    onFormError: (hasError) {
                      setState(() {
                        showFormError = hasError;
                      });
                    },
                    backgroundColor: const Color(0xFFCC9304),
                  ),
                ),

                const SizedBox(height: 15),

                // Cancel button
                CustomTextButtons.cancelButton(context: context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
