import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'database_tables.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._internal();

  AppDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'smartstyle.db');

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DatabaseTables.clothingItems} (
        id TEXT PRIMARY KEY,
        photoPath TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        userId TEXT NOT NULL,
        wardrobeId TEXT NOT NULL,
        aiDescription TEXT NOT NULL,
        aiStyleIds TEXT NOT NULL,
        aiColorIds TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DatabaseTables.preferenceProfiles} (
        id TEXT PRIMARY KEY,
        profileName TEXT NOT NULL,
        description TEXT NOT NULL,
        userId TEXT NOT NULL,
        preferencesStyleId TEXT NOT NULL,
        preferencesColorId TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ${DatabaseTables.favoriteOutfits} (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        createdAt TEXT NOT NULL,

        detailsId TEXT NOT NULL,
        occasion TEXT NOT NULL,
        weather TEXT NOT NULL,

        preferenceProfileId TEXT NOT NULL,
        preferenceProfileName TEXT NOT NULL,
        preferenceProfileDescription TEXT NOT NULL,
        preferenceStyleId TEXT NOT NULL,
        preferenceColorId TEXT NOT NULL,

        outfitId TEXT NOT NULL,
        outfitDate TEXT NOT NULL,
        outfitTitle TEXT NOT NULL,
        outfitDescription TEXT NOT NULL,
        outfitInputId TEXT NOT NULL,

        outfitImageId TEXT,
        outfitImagePath TEXT,

        selectedClothingItemsJson TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
