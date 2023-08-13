import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PreLoadSQLPage extends StatefulWidget {
  const PreLoadSQLPage({super.key});

  @override
  State<PreLoadSQLPage> createState() => _PreLoadSQLPageState();
}

class _PreLoadSQLPageState extends State<PreLoadSQLPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preload SQLite')),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,

            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      DatabaseConnector.instance.getPreLoadDB();
                    },
                    child: const Text("Test DB")),
                FutureBuilder<List<MyPreLoadDBModel>>(
                  future: DatabaseConnector.instance.getPreLoadDB(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<MyPreLoadDBModel>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text('Loading'),
                      );
                    }
                    return snapshot.data!.isEmpty
                        ? const Center(child: Text('No Data'))
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * .3,
                            child: DataTable(
                              headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.amber,
                              ),

                              border: TableBorder(

                                verticalInside: const BorderSide(
                                  color: Colors.black,
                                  width: 3,
                                ),
                                top: const BorderSide(
                                  color: Colors.black,
                                  width: 3,
                                ),
                                bottom: const BorderSide(
                                  color: Colors.black,
                                  width: 3,
                                ),
                                left: const BorderSide(
                                  color: Colors.black,
                                  width: 3,
                                ),
                                right: const BorderSide(
                                  color: Colors.black,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                horizontalInside: const BorderSide(
                                  color: Colors.black,
                                  width: 3,
                                )
                              ),
                                columns: const [
                                  DataColumn(label: Text('ID')),
                                  DataColumn(label: Text('Name')),
                                ],
                                rows: snapshot.data!.map((myPreLoadDBModel) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(myPreLoadDBModel.id.toString())),
                                  DataCell(Text(myPreLoadDBModel.name)),

                                ],
                              );
                            }).toList()),
                  );
                    }
                )],
            ),
          ),
        ),
      ),
    );
  }
}

class MyPreLoadDBModel {
  final int? id;
  final String name;

  MyPreLoadDBModel({this.id, required this.name});

  factory MyPreLoadDBModel.fromMap(Map<String, dynamic> json) {
    return MyPreLoadDBModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}

class DatabaseConnector {
  DatabaseConnector._privateConstructor();

  static final DatabaseConnector instance =
      DatabaseConnector._privateConstructor();
  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final databasesPath = await getApplicationSupportDirectory();
    final path = join(databasesPath.path, "test.db");

    //if you want to rewrite database every time you have to keep this line if not you can comment it
    await deleteDatabase(path);

// Copy if doesn't exist
    if (!await databaseExists(path)) {
      ByteData data = await rootBundle.load(join("assets", "db/test.db"));
      List<int> bytes = data.buffer.asUint8List();
      File(path).writeAsBytesSync(bytes);
    }
    return await openDatabase(
      path,
      version: 2,
    );
  }

  Future<List<MyPreLoadDBModel>> getPreLoadDB() async {
    Database db = await instance.database;

    // To check if table is exists you can uncomment code below to check tables inside your database
//     final tables = await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table"');
//     print(tables);
// // Print out the table names
//     for (var table in tables) {
//       print(table['name']);
//     }
    final results = await db.query("mytable");
    print('results = ' + results.toString());

    var result = await db.query("mytable", orderBy: "name");
    print(result);
    List<MyPreLoadDBModel> preLoadDB = result.isNotEmpty
        ? result.map((c) => MyPreLoadDBModel.fromMap(c)).toList()
        : [];
    // return preLoadDB;
    return result.map((json) => MyPreLoadDBModel.fromMap(json)).toList();
  }
}
