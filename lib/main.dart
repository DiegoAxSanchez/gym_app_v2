import 'dart:async';

import 'package:gym_app_v2/Screens/addForm.dart';
import 'package:gym_app_v2/Screens/deleteForm.dart';
import 'package:gym_app_v2/Screens/detail.dart';
import 'package:gym_app_v2/Services/fetchPatients.dart';
import 'package:gym_app_v2/databaseHelper/database_helper.dart';
import 'package:flutter/material.dart';

import 'Models/Patient.dart';

void main() async {
  runApp(
    MaterialApp(title: 'examFlutter', home: Home_page()),
  );
}

class Home_page extends StatefulWidget {
  Home_page({
    super.key,
  });
  @override
  State<Home_page> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home_page> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Patient>>(
      //initialData: [],
      future: fetchPatients(),
      builder: (context, snapshot) {
        return RefreshIndicator(
          child: _listView(snapshot),
          onRefresh: _pullRefresh,
        );
      },
    );
  }

  Future<void> _pullRefresh() async {
    await SavedDB.fetchInfo();
    setState(() {});
  }

  FutureOr<void> reload(dynamic data) {
    _pullRefresh();
  }

  Widget _listView(AsyncSnapshot snapshot) {
    if (!snapshot.hasData) {
      return Scaffold(
        body: Center(
          child: Text(
            'Pull down to refresh...',
            style: TextStyle(
              fontSize: 32.0,
            ),
          ),
        ),
      );
    } else {
      List<Patient> patients = snapshot.data! as List<Patient>;
      return Scaffold(
        appBar: AppBar(
          title: const Text('Page Principale'),
        ),
        body: ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: patients.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailScreen(patient: patients[index])),
                );
                _pullRefresh();
              },
              title: Text(
                patients[index].nom,
                style: Theme.of(context).textTheme.headline3,
              ),
              subtitle: Text(
                patients[index].prenom,
                style: Theme.of(context).textTheme.headline5,
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                tooltip: "Effacer ce patient",
                onPressed: () async {
                  int id = await SavedDB.checkbyPatient(patients[index]);
                  String response = await SavedDB.delete(id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(response),
                      backgroundColor: Colors.grey[800],
                    ),
                  );
                  _pullRefresh();
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
              margin: EdgeInsets.all(8),
              alignment: Alignment(0.1, 0),
              child: FloatingActionButton(
                heroTag: "AddButton",
                tooltip: "Ajouter un patient",
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddForm()),
                  ).then(reload);
                },
                backgroundColor: Colors.blue[900],
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ), //button first

            // Container(
            //   margin: EdgeInsets.fromLTRB(8, 8, 50, 8),
            //   child: FloatingActionButton(
            //     mini: true,
            //     heroTag: "DeleteButton",
            //     tooltip: "Effacer un Patient",
            //     onPressed: () async {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => const DeleteForm()),
            //       ).then(reload);
            //     },
            //     backgroundColor: Colors.redAccent[700],
            //     child: Icon(
            //       Icons.delete,
            //       color: Colors.white,
            //     ),
            //   ),
            // ), // button second
          ],
        ),
      );
    }
  }
}
