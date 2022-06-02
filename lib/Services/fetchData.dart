// Fetch our patients from the database
import 'package:gym_app_v2/Database/database_helper.dart';
import 'package:gym_app_v2/Models/Exercise.dart';

Future<List<Exercise>> fetchCategories() async {
  return await SavedDB.fetchCategories();
}

Future<List<Exercise>> fetchOneCategory(String category) async {
  return await SavedDB.SearchbyCategory(category);
}

Future<List<Exercise>> fetchFavourites() async {
  return await SavedDB.fetchFavourites();
}
