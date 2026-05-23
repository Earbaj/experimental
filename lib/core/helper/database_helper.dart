import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/locations.db';

    return await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE locations(
            id TEXT PRIMARY KEY,
            latitude REAL,
            longitude REAL,
            timestamp INTEGER,
            accuracy REAL,
            speed REAL,
            userId TEXT,
            isSynced INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertLocation(Map<String, dynamic> location) async {
    final db = await database;
    await db.insert('locations', location,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getLocations() async {
    final db = await database;
    return await db.query('locations', orderBy: 'timestamp DESC');
  }

  Future<List<Map<String, dynamic>>> getUnsyncedLocations() async {
    final db = await database;
    return await db.query('locations', where: 'isSynced = 0');
  }

  Future<void> markLocationAsSynced(String id) async {
    final db = await database;
    await db.update('locations', {'isSynced': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteLocation(String id) async {
    final db = await database;
    await db.delete('locations', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAllLocations() async {
    final db = await database;
    await db.delete('locations');
  }
}