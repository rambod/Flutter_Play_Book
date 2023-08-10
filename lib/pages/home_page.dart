import 'package:flutter/material.dart';
import 'package:flutter_play_book/sqlite/sqlite_page.dart';

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
      body:  SafeArea(
        child: Center(
          child: Column(
            children: [
              Text("Welcome to My Flutter Playbook"),
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SqlitePage()));
              }, child: Text("Sqlite"))
            ],
          ),
        ),
      ),
    );
  }
}
