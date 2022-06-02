import 'dart:convert';

import 'package:gym_app_v2/Models/Exercise.dart';
import 'package:gym_app_v2/Database/database_helper.dart';
import 'package:http/http.dart' as http;

Future<List<Exercise>> connectWithAPI() async {
  String apiUrl = "https://exercisedb.p.rapidapi.com/exercises";
  const String apiKey = "e2ce9359famsh419723dd8318959p11c8f8jsn9a05d007b983";
  const String apiHost = "exercisedb.p.rapidapi.com";

  final response = await http.get(Uri.parse(apiUrl),
      headers: {'X-RapidAPI-Host': apiHost, 'X-RapidAPI-Key': apiKey});

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<Exercise> exercises = (json.decode(response.body) as List)
        .map((data) => Exercise.fromJson(data))
        .toList();
    //choose only 120 out of 1250 exercises
    List<Exercise> lessExercises = [];
    for (Exercise exercise in exercises.getRange(0, 119)) {
      lessExercises.add(exercise);
    }
    // Return list of products
    return lessExercises;
  } else {
    throw Error();
  }
}
