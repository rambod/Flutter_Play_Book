import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class SqlitePage extends StatefulWidget {
  const SqlitePage({super.key});

  @override
  State<SqlitePage> createState() => _SqlitePageState();
}

class _SqlitePageState extends State<SqlitePage> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SQLite Page")),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                Text("Sqlit testing area"),
                TextField(
                  decoration: InputDecoration(
                      labelText: "Enter text",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  controller: textController,
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
                FutureBuilder<List<Grocery>>(
                  future: DatabaseHelper.instance.getGroceries(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Grocery>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text('Loading'),
                      );
                    }
                    return snapshot.data!.isEmpty
                        ? const Center(child: Text('No Data'))
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * .3,
                            child: ListView(
                                children: snapshot.data!.map((grocery) {
                              return Row(
                                children: [
                                  Text(
                                    grocery.name,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        DatabaseHelper.instance.deleteGrocery(grocery.id!);
                                        textController.clear();
                                      });
                                    }

                                  ),
                                  IconButton(onPressed: (){
                                    setState(() {
                                      DatabaseHelper.instance.updateGrocery(grocery.id!, textController.text);
                                      textController.clear();
                                    });
                                  }, icon: const Icon(Icons.edit))
                                ],
                              );
                            }).toList()),
                          );
                  },
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(textController.text);
          await DatabaseHelper.instance
              .addGrocery(Grocery(name: textController.text));
          setState(() {
            textController.clear();
          });
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

class Grocery {
  final int? id;
  final String name;

  Grocery({this.id, required this.name});

  factory Grocery.fromMap(Map<String, dynamic> json) =>
      new Grocery(id: json['id'], name: json['name']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "grocery.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE grocery(id INTEGER PRIMARY KEY, name TEXT)");
  }

  Future<List<Grocery>> getGroceries() async {
    Database db = await instance.database;
    var result = await db.query("grocery", orderBy: "name");
    List<Grocery> groceries =
        result.isNotEmpty ? result.map((c) => Grocery.fromMap(c)).toList() : [];
    return groceries;
    // return result.map((json) => Grocery.fromMap(json)).toList();
  }

  Future<int> addGrocery(Grocery grocery) async {
    Database db = await instance.database;
    return await db.insert("grocery", grocery.toMap());
  }

  Future<int> deleteGrocery(int id) async {
    Database db = await instance.database;
    return await db.delete("grocery", where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateGrocery(int id, String name) async {
    Grocery grocery = Grocery(id: id, name: name);
    Database db = await instance.database;
    return await db.update("grocery", grocery.toMap(),
        where: "id = ?", whereArgs: [grocery.id]);
  }
}
