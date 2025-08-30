import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '/firebase_options.dart';
import '/screens/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: UltrafastSMMApp()));
}

class UltrafastSMMApp extends StatelessWidget {
  const UltrafastSMMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UltrafastSMM',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6E41E2),
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 1,
        ),
      ),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}
