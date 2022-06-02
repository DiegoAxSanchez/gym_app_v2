import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:gym_app_v2/Models/Patient.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:http/http.dart' as http;

class SavedDB {
  // Open the database and store the reference.
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
        'CREATE TABLE bdhopital(id INTEGER PRIMARY KEY AUTOINCREMENT, nom TEXT,prenom TEXT)');
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase(
      'bdhopital.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
        await fillTables(database);
      },
    );
  }

  static Future<List<Patient>> fetchInfo() async {
    final db = await SavedDB.database();
    final List<Map<String, dynamic>> maps = await db.query('bdhopital');
    return List.generate(maps.length, (i) {
      return Patient(
        nom: maps[i]["nom"],
        prenom: maps[i]["prenom"],
      );
    });
  }

  static Future<String> addOne(Patient patient, String tableName) async {
    final db = await SavedDB.database();
    int response = await db.insert(tableName, patient.toMap(),
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return "Patient ${patient.nom}, ${patient.prenom} a ete ajoute avec le dossier num $response";
  }

  static Future<int> checkbyID(int id) async {
    final db = await SavedDB.database();
    final count = sql.Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM bdhopital WHERE id=$id"));
    return count!;
  }

  static Future<int> checkbyPatient(Patient patient) async {
    final db = await SavedDB.database();
    final List<Map<String, dynamic>> maps = await db.query('bdhopital',
        where: 'nom = ? AND prenom = ?',
        whereArgs: [patient.nom, patient.prenom]);
    List<int> ids = [];
    List.generate(maps.length, (i) {
      int id = maps[i]["id"];
      ids.add(id);
    });
    if (ids.length == 1) {
      return ids[0];
    } else {
      return 9999;
    }
  }

  static Future<String> delete(int id) async {
    if (id == 9999) {
      return "Multiple patients with same name, need more data";
    }
    final db = await SavedDB.database();
    try {
      await db.delete(
        'bdhopital',
        // Use a `where` clause to delete a specific dog.
        where: 'id = ?',
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [id],
      );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
    return "le patient numero $id a ete efface";
  }

  static Future<void> fillTables(sql.Database database) async {
    await database.rawInsert(
        'INSERT INTO bdhopital(nom, prenom) VALUES("Sanchez", "Diego")');
    await database.rawInsert(
        'INSERT INTO bdhopital(nom, prenom) VALUES("Perez", "Sebastian")');
    await database.rawInsert(
        'INSERT INTO bdhopital(nom, prenom) VALUES("Ashby", "Charles")');
    await database.rawInsert(
        'INSERT INTO bdhopital(nom, prenom) VALUES("Carranza", "Jose")');
    await database.rawInsert(
        'INSERT INTO bdhopital(nom, prenom) VALUES("Tavares", "Antonio")');
    await database.rawInsert(
        'INSERT INTO bdhopital(nom, prenom) VALUES("Condoriano", "Pepe")');
    await database.rawInsert(
        'INSERT INTO bdhopital(nom, prenom) VALUES("Messi", "Lionel")');
    await database.rawInsert(
        'INSERT INTO bdhopital(nom, prenom) VALUES("Ronaldo", "Cristiano")');
  }
}
