import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//DB to hold data about birthdays added from importing contacts. Make sure that the smae one isn't added twice.

class ContactsDB {
  static Database? _database;
  static final ContactsDB instance = ContactsDB._();

  ContactsDB._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'contacts.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts (
        id TEXT PRIMARY KEY
      )
    ''');
  }

  Future<int> insert(String id) async {
    Database db = await instance.database;
    return await db.insert('contacts', {'id': id});
  }

  Future<List<String>> getAll() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('contacts');
    return List.generate(maps.length, (i) {
      return maps[i]['id'];
    });
  }

   Future<int> update(String id) async {
    final db = await database;
    return await db.update(
      'contacts',
      {'id': id},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(String id) async {
    final db = await database;
    return await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}