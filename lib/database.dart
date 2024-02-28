import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'character.dart';

class DatabaseService {
  static Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'characters_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE characters(id INTEGER PRIMARY KEY, name TEXT, gender TEXT, image TEXT)",
        );
      },
      version: 1,
    );
  }

  static Future<void> insertCharacter(Character character) async {
    final Database db = await database();
    await db.insert(
      'characters',
      character.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Character>> characters() async {
    final Database db = await database();
    final List<Map<String, dynamic>> maps = await db.query('characters');
    return List.generate(maps.length, (i) {
      return Character(
        name: maps[i]['name'],
        gender: maps[i]['gender'],
        image: maps[i]['image'],
      );
    });
  }

  static Future<void> deleteCharacter(String name) async {
    final db = await database();
    await db.delete(
      'characters',
      where: "name = ?",
      whereArgs: [name],
    );
  }
}
