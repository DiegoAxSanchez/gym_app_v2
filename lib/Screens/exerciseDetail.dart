import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gym_app_v2/Database/database_helper.dart';
import 'package:gym_app_v2/Models/Exercise.dart';
import 'package:gym_app_v2/Screens/components/addForm.dart';

class ExerciseDetail extends StatelessWidget {
  Exercise exercise;

  ExerciseDetail({Key? key, required this.exercise}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String defaultText =
        'This Exercise targets ${exercise.target} it is great to develop your ${exercise.bodyPart}, you will need ${exercise.equipment} to perform it safely';
    if (exercise.description != '') {
      defaultText = exercise.description;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise id ${exercise.id}'),
      ),
      body: ListView(
        children: [
          FadeInImage.assetNetwork(
              fit: BoxFit.cover,
              image: exercise.gifUrl,
              placeholder: 'assets/spinner.gif',
              imageErrorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Image.memory(
                    Uint8List.fromList(base64.decode(exercise.gif)));
              }),
          Container(
            padding: const EdgeInsets.all(32),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(exercise.name.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                    ),
                    Text(exercise.bodyPart,
                        style: TextStyle(color: Colors.grey[500]))
                  ],
                )),
                Icon(Icons.fitness_center, color: Colors.blue[800]),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Save Exercise',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue[600]),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue[600]),
                    onPressed: () {
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => AddFormView(
                            exercise: exercise,
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Edit Exercise',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue[600]),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.blue[600]),
                    onPressed: () {
                      SavedDB.delete(int.parse(exercise.id), 'favourites');
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 5),
                          content:
                              Text('Exercise deleted from your favourites'),
                        ),
                      );
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Delete Exercise',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.blue[600]),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                  child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  defaultText,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 14,
                    letterSpacing: 1.6,
                    color: Colors.blue[600],
                  ),
                ),
              ))
            ],
          ),
        ],
      ),
    );
  }
}
