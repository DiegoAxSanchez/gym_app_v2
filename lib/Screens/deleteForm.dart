import 'package:gym_app_v2/DatabaseHelper/database_helper.dart';
import 'package:flutter/material.dart';

class DeleteForm extends StatefulWidget {
  const DeleteForm({super.key});

  @override
  DeleteFormState createState() {
    return DeleteFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class DeleteFormState extends State<DeleteForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    int? id = null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient : '),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('ID du patient a effacer'),
            ),
            TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Entrer un ID valide';
                }
                id = int.parse(value);
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    if (await SavedDB.checkbyID(id!) == 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Id invalide'),
                          backgroundColor: Color.fromARGB(255, 192, 19, 19),
                          duration: Duration(seconds: 10),
                        ),
                      );
                    } else {
                      String response = await SavedDB.delete(id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(response),
                          backgroundColor: Colors.blue[600],
                          duration: Duration(seconds: 5),
                        ),
                      );
                      Navigator.pop(context);
                    }
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
