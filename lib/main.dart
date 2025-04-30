import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Register"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: null,
              decoration: InputDecoration(
                hintText: "Enter Your Email Here"
              ),
            ),
            TextField(
              autocorrect: false,
              enableSuggestions: false,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Enter Your Password Here"
              ),
            ),
            TextButton(onPressed: () {
              
            }, child: Text("Register Now"))
          ]
        ),
      ),
      
    );
  }
}
