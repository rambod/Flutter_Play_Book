## SQLite Page Documentation
Welcome to the documentation for the SqlitePage class! In this guide, you'll learn how to use SQLite for local data storage within a Flutter app. The SqlitePage class showcases a simple example of how to implement CRUD (Create, Read, Update, Delete) operations using the sqflite package.

### Table of Contents
- [Introduction](#introduction)
- [Getting Started](#getting-started)
- [Widget Overview](#widget-overview)
- [DatabaseHelper](#databasehelper)
- [Conclusion](#conclusion)

The SqlitePage class demonstrates the implementation of a local SQLite database within a Flutter app. The purpose of this page is to showcase how to add, retrieve, update, and delete data using SQLite. The UI allows users to enter a grocery item, save it to the database, view existing items, edit them, and delete them.

#### Getting Started
To get started with the SqlitePage functionality, you need to follow these steps:

#### Import Dependencies:
Import the required dependencies at the top of your Dart file.

```
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
```
#### Create a StatefulWidget:
Define the SqlitePage class as a StatefulWidget with its associated _SqlitePageState class.

```
class SqlitePage extends StatefulWidget {
const SqlitePage({Key? key}) : super(key: key);

@override
State<SqlitePage> createState() => _SqlitePageState();
}
```
#### Widget Overview
The SqlitePage widget is organized into different sections, allowing users to interact with the SQLite database. Let's break down the structure of the widget:

- AppBar: Displays the title "SQLite Page" on top of the page.

- TextField: Allows users to enter a grocery item.

- FutureBuilder: Retrieves a list of groceries from the database and displays them.

- ListView: Lists the retrieved groceries along with delete and edit buttons.

- FloatingActionButton: Saves the entered grocery item to the database.

#### DatabaseHelper 
The DatabaseHelper class handles the creation and management of the SQLite database. It includes methods for adding, retrieving, updating, and deleting grocery items. Here's an overview of the key methods:

- _initDatabase: Initializes the SQLite database and creates a table named "grocery" with an "id" and "name" column.

- getGroceries: Retrieves a list of grocery items from the database.

- addGrocery: Adds a new grocery item to the database.

- deleteGrocery: Deletes a grocery item based on its ID.

- updateGrocery: Updates the name of a grocery item based on its ID.

#### Conclusion
The SqlitePage class provides a hands-on demonstration of using SQLite for local data storage in a Flutter app. It covers basic CRUD operations and showcases how to integrate SQLite into your application's UI. This example serves as a foundation for building more complex data storage solutions using the sqflite package.

Feel free to explore and modify the code provided to suit your specific needs. Happy coding!

