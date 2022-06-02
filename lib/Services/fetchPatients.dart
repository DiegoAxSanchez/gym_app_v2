// Fetch our patients from the database
import 'package:gym_app_v2/DatabaseHelper/database_helper.dart';
import 'package:gym_app_v2/Models/Patient.dart';

Future<List<Patient>> fetchPatients() async {
  return await SavedDB.fetchInfo();
}
