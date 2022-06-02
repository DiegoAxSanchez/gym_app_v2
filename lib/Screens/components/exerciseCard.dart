import 'dart:convert';
import 'dart:typed_data';
import 'package:gym_app_v2/Database/database_helper.dart';
import 'package:gym_app_v2/Screens/exerciseDetail.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:gym_app_v2/Models/Exercise.dart';

class ExerciseCard extends StatelessWidget {
  ExerciseCard({super.key, required this.exercise});
  Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise ${exercise.id}'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () async {
            try {
              http.Response response =
                  await http.get(Uri.parse(exercise.gifUrl));
              exercise.gif = base64.encode(response.bodyBytes);
              SavedDB.loadGif(exercise, 'exercises');
            } catch (err) {
              print('No internet mah dude');
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExerciseDetail(
                  exercise: exercise,
                ),
              ),
            );
          },
          child: Column(
            children: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite, color: Colors.blue[600]),
                    onPressed: () async {
                      exercise.id = exercise.id + '123';
                      SavedDB.addOne(exercise, 'favourites');
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 5),
                          content: Text('Exercise added to your favourites'),
                        ),
                      );
                    },
                  ),
                  CircleAvatar(
                    foregroundImage: NetworkImage(exercise.gifUrl),
                    backgroundImage: MemoryImage(
                        Uint8List.fromList(base64.decode(exercise.gif))),
                    radius: 100,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Text(
                      exercise.equipment,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 241, 241, 241),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                exercise.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
// #enddocregion Stack
}
