import 'dart:async';

import 'package:gym_app_v2/Database/database_helper.dart';
import 'package:gym_app_v2/Models/Exercise.dart';
import 'package:flutter/material.dart';
import 'package:gym_app_v2/Screens/components/exerciseCard.dart';
import 'package:gym_app_v2/Services/fetchData.dart';

class Favourites extends StatefulWidget {
  const Favourites({
    super.key,
  });
  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Exercise>>(
      //initialData: [],
      future: fetchFavourites(),
      builder: (context, snapshot) {
        return RefreshIndicator(
          onRefresh: _pullRefresh,
          child: _gridView(snapshot),
        );
      },
    );
  }

  Future<void> _pullRefresh() async {
    await SavedDB.fetchFavourites();
    setState(() {});
  }

  FutureOr<void> reload(dynamic data) {
    _pullRefresh();
  }

  Widget _gridView(AsyncSnapshot snapshot) {
    if (!snapshot.hasData) {
      return const Scaffold(
        body: Center(
          child: Text(
            'No Data...',
            style: TextStyle(
              fontSize: 32.0,
            ),
          ),
        ),
      );
    } else {
      List<Exercise> exercises = snapshot.data! as List<Exercise>;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Your Favoured Exercises'),
        ),
        body: GridView.builder(
          itemCount: exercises.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.693,
          ),
          itemBuilder: (context, index) => ExerciseCard(
            exercise: exercises[index],
          ),
        ),
      );
    }
  }
}
