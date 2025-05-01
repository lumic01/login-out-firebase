import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key}); // ✅ Fixed constructor

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/login/', (_) => false);
                  }
                  devtools.log(shouldLogout.toString());
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: const Center(child: Text('Welcome to the Home Page!')),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Sign out'),
        content: Text('Are you sure you want to sign out'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Log out'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
