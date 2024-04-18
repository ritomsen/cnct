import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cnct/models/reminder.dart';

//DB that stores birthday list in sql db

class DBHelper {
  static Database? _database;
  static final DBHelper instance = DBHelper._();

  DBHelper._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'reminders.db');
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  void _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY,
        name TEXT,
        msg TEXT,
        date TEXT,
        time TEXT,
        number TEXT,
        isContact INTEGER,
        contactID TEXT
      )
    ''');
  }

  Future<int> insertReminder(Reminder reminder) async {
    Database db = await instance.database;
    return await db.insert('reminders', reminder.toMap());
  }

  Future<List<Reminder>> getAllReminders() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('reminders');
    return List.generate(maps.length, (i) {
      return Reminder(
        id: maps[i]['id'],
        name: maps[i]['name'],
        msg: maps[i]['msg'],
        date: maps[i]['date'],
        time: maps[i]['time'],
        number: maps[i]['number'],
        isContact: (maps[i]['isContact'] == 1) ? true: false,
        contactID: maps[i]['contactID']
      );
    });
  }

   Future<int> updateRem(Reminder reminder) async {
    final db = await database;
    return await db.update(
      'reminders',
      reminder.toMap(),
      where: 'id = ?',
      whereArgs: [reminder.id],
    );
  }

  Future<int> deleteRem(int id) async {
    final db = await database;
    return await db.delete(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}