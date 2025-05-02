import 'package:bike/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify email')),
      body: Column(
        children: [
          Text(
            "We've sent an email verification. Please check your email address",
          ),
          Text("If you haven't recieved it, Press the button below"),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: Text('Send Email Verification'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login/', (route) => false);
            },
            child: Text('Email Verified? Login here!'),
          ),
        ],
      ),
    );
  }
}
