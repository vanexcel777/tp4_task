import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({
    required this.id,
    required this.name,
    required this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}

class DogDatabase {
  late final Future<Database> _database;

  DogDatabase() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'doggie_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertDog(Dog dog) async {
    final db = await _database;
    return await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dog>> getAllDogs() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('dogs');
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  Future<Dog?> getDog(int id) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query(
      'dogs',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      return null;
    }
    return Dog(
      id: maps.first['id'],
      name: maps.first['name'],
      age: maps.first['age'],
    );
  }

  Future<int> updateDog(Dog dog) async {
    final db = await _database;
    return await db.update(
      'dogs',
      dog.toMap(),
      where: 'id = ?',
      whereArgs: [dog.id],
    );
  }

  Future<int> deleteDog(int id) async {
    final db = await _database;
    return await db.delete(
      'dogs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
