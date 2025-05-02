import 'package:bike/services/auth/auth_exceptions.dart';
import 'package:bike/services/auth/auth_service.dart';
import 'package:bike/utilities/show_error_dialog.dart';
import 'package:flutter/material.dart';
// import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key, required this.title});

  final String title;

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _email,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: "Enter Your Email Here"),
          ),
          TextField(
            controller: _password,
            autocorrect: false,
            enableSuggestions: false,
            obscureText: true,
            decoration: InputDecoration(hintText: "Enter Your Password Here"),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                AuthService.firebase().sendEmailVerification();
                Navigator.of(context).pushNamed('/verify/');
              } on WeakPasswordAuthException {
                await showErrorDialog(context, 'Weak Password');
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(context, 'Email Already Exist');
              } on InvalidEmailAuthException {
                await showErrorDialog(context, 'Invalid Email');
              } on GenericAuthException {
                await showErrorDialog(context, 'Failed to register');
              }
            },
            child: Text("Register Now"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login/', (route) => false);
            },
            child: Text('Already registered? Login here!'),
          ),
        ],
      ),
    );
  }
}
