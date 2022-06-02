import 'package:gym_app_v2/Models/Exercise.dart';
import 'package:gym_app_v2/Database/database_helper.dart';
import 'package:flutter/material.dart';

class AddFormView extends StatelessWidget {
  const AddFormView({Key? key, required this.exercise}) : super(key: key);
  final Exercise exercise;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AddForm(exercise: exercise),
    );
  }
}

class AddForm extends StatefulWidget {
  const AddForm({super.key, required this.exercise});
  final Exercise exercise;

  @override
  AddFormState createState() {
    return AddFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class AddFormState extends State<AddForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    String newName = 'ERROR';
    String newDescription = 'ERROR';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise : '),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('New Exercise name'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  newName = value;
                  return null;
                },
              ),
            ),
            const Text('New exercise description'),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
              child: TextFormField(
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  newDescription = value;
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    widget.exercise.id = '${widget.exercise.id}123';
                    widget.exercise.description = newDescription;
                    widget.exercise.name = newName;
                    SavedDB.addOne(widget.exercise, 'favourites');
                    Navigator.pop(context);
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 5),
                        content: Text('Exercise added to your favourites'),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
