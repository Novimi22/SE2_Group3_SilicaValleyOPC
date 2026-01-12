import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:draft_screens/screens/all_logins/signin_screen.dart';
import 'package:draft_screens/screens/track_order/track_order_searchpage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Application for Silica Valley OPC',
      theme: ThemeData(
        textTheme: GoogleFonts.workSansTextTheme(
          Theme.of(context).textTheme, // Inherit other styles
      ),
    ),
      home: const TORSearchPage(),
    );
  }
}