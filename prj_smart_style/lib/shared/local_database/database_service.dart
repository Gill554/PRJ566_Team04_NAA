import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

class DatabaseService {
  final AppDatabase appDatabase;

  const DatabaseService({required this.appDatabase});

  Future<Database> get _db async {
    return appDatabase.database;
  }

  Future<int> insert({
    required String table,
    required Map<String, dynamic> values,
  }) async {
    final db = await _db;

    return db.insert(
      table,
      values,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> query({
    required String table,
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
  }) async {
    final db = await _db;

    return db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
  }

  Future<int> update({
    required String table,
    required Map<String, dynamic> values,
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final db = await _db;

    return db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete({
    required String table,
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final db = await _db;

    return db.delete(table, where: where, whereArgs: whereArgs);
  }
}
