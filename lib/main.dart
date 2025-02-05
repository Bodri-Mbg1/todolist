import 'package:examen_app/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDFgI_z9W5NQ0q1tKW2ExFV89p6ZQbRgas",
          authDomain: "todolist-e2d0b.firebaseapp.com",
          projectId: "todolist-e2d0b",
          storageBucket: "todolist-e2d0b.firebasestorage.app",
          messagingSenderId: "9318324827",
          appId: "1:9318324827:web:d3196ca9ffe4865f803d7e",
          measurementId: "G-38Y5PSS9F1"),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: const Welcome(),
    );
  }
}
