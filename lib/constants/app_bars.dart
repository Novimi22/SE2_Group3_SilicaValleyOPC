
import 'package:flutter/material.dart';
import '../constants/colors.dart';

enum NavigationType { pop, push, pushReplacement }

class CustomAppBars {
  // Type 1: AppBar with subtitle & back button
  static PreferredSizeWidget appBarWithSubtitle({
    required BuildContext context,
    required String title,
    String? subtitle,
    Widget? subtitleWidget,
    VoidCallback? onBackPressed,
    double height = 80,
  }) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
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
              height: height,
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                padding: const EdgeInsets.only(left: 30),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              ),
            ),
            const Expanded(child: SizedBox()),
            // Title with subtitle
            Container(
              height: height,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  subtitleWidget ??
                      (subtitle != null
                          ? Text(
                              subtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            )
                          : const SizedBox.shrink()),
                ],
              ),
            ),
            const Expanded(child: SizedBox()),
            // Balance container
            SizedBox(width: 48, height: height),
          ],
        ),
      ),
    );
  }

  // Type 2: Default app bar with back navigation 
  static PreferredSizeWidget defaultAppBar({
    required BuildContext context,
    required String title,
    Widget? destination,
    NavigationType navigationType = NavigationType.pop,
    VoidCallback? onBackPressed,
    double height = 80,
  }) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
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
              height: height,
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                padding: const EdgeInsets.only(left: 30),
                onPressed: onBackPressed ??
                    () {
                      _handleNavigation(context, destination, navigationType);
                    },
              ),
            ),
            const Expanded(child: SizedBox()),
            // Title
            Container(
              height: height,
              alignment: Alignment.center,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            // Balance container
            SizedBox(width: 48, height: height),
          ],
        ),
      ),
    );
  }

  static void _handleNavigation(
  BuildContext context,
  Widget? destination,
  NavigationType type,
) {
  if (destination == null) {
    Navigator.pop(context);
    return;
  }

  switch (type) {
    case NavigationType.pop:
      Navigator.pop(context);
      break;
    case NavigationType.push:
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
      break;
    case NavigationType.pushReplacement:
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
      break;
  }
}

  // Type 3: App bar with CANCEL/CONFIRM buttons 
  static PreferredSizeWidget orderAppBar({
    required BuildContext context,
    required String title,
    required bool isConfirmed,
    required VoidCallback onConfirm,
    required Widget dashboardScreen,
    double height = 80,
  }) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
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
            // CANCEL button
            if (!isConfirmed)
              Container(
                height: height,
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => dashboardScreen,
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(left: 30, right: 20),
                  ),
                  child: const Text(
                    'CANCEL',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Container(
                height: height,
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            // CONFIRM or CLOSE button
            if (!isConfirmed)
              Container(
                height: height,
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: onConfirm,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(right: 30, left: 20),
                  ),
                  child: const Text(
                    'CONFIRM',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            // CLOSE button
            else
              Container(
                height: height,
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => dashboardScreen,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 30,
                  ),
                  padding: const EdgeInsets.only(right: 30),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Type 4: title only, no back button 
  static PreferredSizeWidget centeredAppBar({
    required String title,
    double height = 80,
  }) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
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
            const Expanded(child: SizedBox()),
            Container(
              height: height,
              alignment: Alignment.center,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            SizedBox(width: 48, height: height),
          ],
        ),
      ),
    );
  }

  // Type 5: Title and close (X) button 
  static PreferredSizeWidget closeOnlyAppBar({
    required BuildContext context,
    required String title,
    VoidCallback? onClosePressed,
    double height = 80,
    bool showBottomBorder = true,
  }) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
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
          border: showBottomBorder
              ? Border(
                  bottom: BorderSide(color: AppColors.borderColor, width: 1),
                )
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox()),
            Container(
              height: height,
              alignment: Alignment.center,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                      fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
            // Close icon
            Container(
              height: height,
              alignment: Alignment.center,
              child: IconButton(
                onPressed: onClosePressed ?? () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.black, size: 30),
                padding: const EdgeInsets.only(right: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}