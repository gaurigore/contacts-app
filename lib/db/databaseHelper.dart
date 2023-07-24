import 'package:contact_app/model/contactModel.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = 'contacts.db';
  static final _databaseVersion = 1;

  static final table = 'contacts';

  static final columnId = 'id';
  static final columnName = 'name';
  static final columnEmail = 'email';
  static final columnPhone = 'phone';

  static Database? _database;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnEmail TEXT NOT NULL,
        $columnPhone TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await instance.database;
    return await db.insert(table, contact.toMap());
  }

  Future<int> updateContact(Contact contact, int id) async {
    Database db = await instance.database;
    return await db.update(table, contact.toMap(),
        where: '$columnId = ?', whereArgs: [id]);
  }

  Future<Contact?> queryContactById(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      return null;
    }
    return Contact.fromMap(maps.first);
  }

  Future<List<Contact>> queryAllContacts({
    String? orderBy,
  }) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> contactsResult =
        await db.query(table, orderBy: orderBy);
    print(contactsResult);
    return contactsResult.map((e) => Contact.fromMap(e)).toList();
  }
}
