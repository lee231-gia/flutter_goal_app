import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/goal.dart';

class LocalGoalDb {
  static Database? _db;

  Future<Database> get database async {
    _db ??= await openDatabase(
      join(await getDatabasesPath(), 'goals.db'),
      version: 1,
      onCreate: (db, version) => db.execute('CREATE TABLE goals(id INTEGER PRIMARY KEY, title TEXT, category TEXT, term TEXT, status TEXT, notes TEXT)'),
    );
    return _db!;
  }

  Future<void> saveAll(List<Goal> goals) async {
    final db = await database;
    await db.delete('goals');
    for (final goal in goals) {
      await db.insert('goals', goal.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}
