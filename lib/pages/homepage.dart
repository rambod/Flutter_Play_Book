import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  String title = '';

  HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: Colors.amber),
      body: const SafeArea(
        child: Center(
          child: Text("Welcome to My Flutter Playbook"),
        ),
      ),
    );
  }
}
