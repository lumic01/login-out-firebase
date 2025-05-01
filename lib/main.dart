import 'package:bike/views/login_view.dart';
import 'package:bike/views/register_view.dart';
import 'package:bike/views/verify_email_view.dart';
import 'package:bike/views/homepage.dart'; // Create this file for HomePage
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget _getInitialPage() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const LoginView(); // Not logged in
    } else if (!user.emailVerified) {
      return const VerifyEmailView(); // Logged in but email not verified
    } else {
      return NotesView(); // Logged in and verified
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Auth Flow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: _getInitialPage(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(title: 'Register'),
        '/verify/': (context) => const VerifyEmailView(),
        '/home/': (context) => const NotesView(),
      },
    );
  }
}
