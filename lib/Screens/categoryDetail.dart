import 'package:gym_app_v2/Models/Exercise.dart';
import 'package:flutter/material.dart';
import 'package:gym_app_v2/Screens/components/exerciseCard.dart';
import 'package:gym_app_v2/Services/fetchData.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key, required this.categoryName});
  String categoryName;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Exercise>>(
      //initialData: [],
      future: fetchOneCategory(categoryName),
      builder: (context, snapshot) {
        return _gridView(snapshot);
      },
    );
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
          title: Text('All Exercises for $categoryName'),
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
