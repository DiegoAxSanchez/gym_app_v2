import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gym_app_v2/Models/Exercise.dart';
import 'package:gym_app_v2/Services/connectWithAPI.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:http/http.dart' as http;

class SavedDB {
  // Open the database and store the reference.
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
        'CREATE TABLE exercises(id INTEGER PRIMARY KEY, bodyPart TEXT, equipment TEXT, gifUrl TEXT, name TEXT, target TEXT, gif TEXT)');
    await database.execute(
        'CREATE TABLE categories(id INTEGER PRIMARY KEY, bodyPart TEXT, equipment TEXT, gifUrl TEXT, name TEXT, target TEXT, gif TEXT)');
    await database.execute(
        'CREATE TABLE favourites(id INTEGER PRIMARY KEY, bodyPart TEXT, equipment TEXT, gifUrl TEXT, name TEXT, target TEXT, gif TEXT, description TEXT)');
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase(
      'gym_app_v2.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
        await fillTables(database);
      },
    );
  }

  static Future<void> fillTables(sql.Database database) async {
    List<Exercise> exercises = await connectWithAPI();
    await addAll(exercises, database);
  }

  static Future<List<Exercise>> fetchAll() async {
    final db = await SavedDB.database();
    final List<Map<String, dynamic>> maps = await db.query('exercises');
    return List.generate(maps.length, (i) {
      return Exercise(
        bodyPart: maps[i]["bodyPart"],
        equipment: maps[i]["equipment"],
        gifUrl: maps[i]["gifUrl"],
        id: (maps[i]["id"]).toString(),
        name: maps[i]["name"],
        target: maps[i]["target"],
        gif: maps[i]["gif"],
      );
    });
  }

  static Future<List<Exercise>> fetchCategories() async {
    final db = await SavedDB.database();
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) {
      return Exercise(
        bodyPart: maps[i]["bodyPart"],
        equipment: maps[i]["equipment"],
        gifUrl: maps[i]["gifUrl"],
        id: (maps[i]["id"]).toString(),
        name: maps[i]["name"],
        target: maps[i]["target"],
        gif: maps[i]["gif"],
      );
    });
  }

  static Future<List<Exercise>> fetchFavourites() async {
    final db = await SavedDB.database();
    final List<Map<String, dynamic>> maps = await db.query('favourites');
    return List.generate(maps.length, (i) {
      return Exercise(
        bodyPart: maps[i]["bodyPart"],
        equipment: maps[i]["equipment"],
        gifUrl: maps[i]["gifUrl"],
        id: (maps[i]["id"]).toString(),
        name: maps[i]["name"],
        target: maps[i]["target"],
        gif: maps[i]["gif"],
        description: maps[i]["description"],
      );
    });
  }

  static Future<String> addOne(Exercise exercise, String tableName) async {
    final db = await SavedDB.database();
    await db.insert(tableName, exercise.toMapFavourites(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return "${exercise.id}, a ete ajoute avec succes";
  }

  // static Future<int> searchByName(Exercise exercise) async {
  //   //TODO
  //   final db = await SavedDB.database();
  //   final List<Map<String, dynamic>> maps = await db
  //       .query('exercises', where: 'name = ?', whereArgs: [exercise.name]);
  //   List<int> ids = [];
  //   List.generate(maps.length, (i) {
  //     int id = maps[i]["id"];
  //     ids.add(id);
  //   });
  //   if (ids.length == 1) {
  //     return ids[0];
  //   } else {
  //     return 9999;
  //   }
  // }

  static Future<String> delete(int id, String tableName) async {
    final db = await SavedDB.database();
    try {
      await db.delete(
        tableName,
        // Use a `where` clause to delete a specific dog.
        where: 'id = ?',
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [id],
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
    return "Exercise ${id} efface avec succes";
  }

  static Future<void> addAll(
      List<Exercise> exercises, sql.Database database) async {
    for (Exercise exercise in exercises) {
      await database.insert('exercises', exercise.toMap(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }
    //when we have our complete list of text
    await addCategories(database);
  }

  static Future<void> addCategories(sql.Database database) async {
    final List<Map<String, dynamic>> maps =
        await database.rawQuery('SELECT * FROM exercises GROUP BY target');
    List<Exercise> categories = List.generate(maps.length, (i) {
      return Exercise(
        bodyPart: maps[i]["bodyPart"],
        equipment: maps[i]["equipment"],
        gifUrl: maps[i]["gifUrl"],
        id: (maps[i]["id"]).toString(),
        name: maps[i]["name"],
        target: maps[i]["target"],
        gif: maps[i]["gif"],
      );
    });
    for (Exercise exercise in categories) {
      try {
        http.Response response = await http.get(Uri.parse(exercise.gifUrl));
        exercise.gif = base64.encode(response.bodyBytes);
      } catch (err) {
        print('No internet mah dude');
      }
      await database.insert('categories', exercise.toMap(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace);
    }
  }

  static Future<List<Exercise>> SearchbyCategory(String search) async {
    final db = await SavedDB.database();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM exercises WHERE target = \'$search\'');
    return List.generate(maps.length, (i) {
      return Exercise(
        bodyPart: maps[i]["bodyPart"],
        equipment: maps[i]["equipment"],
        gifUrl: maps[i]["gifUrl"],
        id: (maps[i]["id"]).toString(),
        name: maps[i]["name"],
        target: maps[i]["target"],
        gif: maps[i]["gif"],
      );
    });
  }
}
