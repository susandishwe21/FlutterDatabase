import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    //'path' package using join
    join(await getDatabasesPath(), 'dog_database.db'),
    onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE dogs(id INTEGER PRIMARY KEY,name TEXT,age INTEGER)");
    },
    version: 1,
  ); 

  Future<void> insertDog(Dog dog) async {
    //reference database
    final Database db = await database; //start create database

    await db.insert('dogs', dog.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Dog>> dogs() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('dogs');

    return List.generate(maps.length, (index) {
      return Dog(
          id: maps[index]['id'],
          name: maps[index]['name'],
          age: maps[index]['age']);
    });
  }

  Future<void> updateDog(Dog dog) async {
    final db = await database;

    await db.update('dogs', dog.toMap(), where: "id = ?", whereArgs: [dog.id]);
  }

  Future<void> deleteDog(int id) async {
    final db = await database;

    await db.delete('dogs', where: "id = ?", whereArgs: [id]);
  }

  var fido = Dog(id: 0, name: 'Fido', age: 35);

  await insertDog(fido);

  print(await dogs());
}

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({this.id, this.name, this.age});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'age': age};
  }

  @override
  String toString() {
    return 'Dog{id:$id,name:$name,age:$age}';
  }
}
