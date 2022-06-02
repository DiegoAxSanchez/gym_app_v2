import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:gym_app_v2/Database/database_helper.dart';
import 'package:gym_app_v2/Screens/Favourites.dart';
import 'package:gym_app_v2/Screens/categoryDetail.dart';
import 'package:gym_app_v2/Services/fetchData.dart';
import 'package:flutter/material.dart';

import 'Models/Exercise.dart';

//created by :
//  Diego Sanchez for Ahuntsic(School Project)
//  TODO add drawer for auth, +workouts where text to speech implements timer+reps+motivational msgs
//  TODO add calendar to plan workouts + alarms/reminders
void main() async {
  runApp(
    const MaterialApp(
      title: 'gym_app_v2',
      home: Home_page(),
      initialRoute: '/',
    ),
  );
}

class Home_page extends StatefulWidget {
  const Home_page({
    super.key,
  });
  @override
  State<Home_page> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home_page> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Exercise>>(
      //initialData: [],
      future: fetchCategories(),
      builder: (context, snapshot) {
        return RefreshIndicator(
          onRefresh: _pullRefresh,
          child: _listView(snapshot),
        );
      },
    );
  }

  Future<void> _pullRefresh() async {
    await SavedDB.fetchCategories();
    setState(() {});
  }

  FutureOr<void> reload(dynamic data) {
    _pullRefresh();
  }

  Widget _listView(AsyncSnapshot snapshot) {
    if (!snapshot.hasData) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              Image.asset('assets/ripple.gif'),
              const Text(
                'No Data...',
                style: TextStyle(
                  fontSize: 32.0,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      List<Exercise> exercises = snapshot.data! as List<Exercise>;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Categories'),
        ),
        body: ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: exercises.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CategoryScreen(categoryName: exercises[index].target),
                  ),
                );
                _pullRefresh();
              },
              title: Text(
                exercises[index].target,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text(
                exercises[index].bodyPart,
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: FadeInImage.assetNetwork(
                placeholder: 'assets/spinner.gif',
                image: exercises[index].gifUrl,
                fit: BoxFit.cover,
                imageErrorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.memory(
                    Uint8List.fromList(
                      base64.decode(exercises[index].gif),
                    ),
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: Wrap(
          //will break to another line on overflow
          direction: Axis.horizontal, //use vertical to show  on vertical axis
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(8),
              alignment: const Alignment(0.1, 0),
              child: FloatingActionButton(
                heroTag: "FavouritesButton",
                tooltip: "Go to Favourites",
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Favourites()),
                  ).then(reload);
                },
                backgroundColor: Colors.red[800],
                child: const Icon(
                  Icons.favorite_outline,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
