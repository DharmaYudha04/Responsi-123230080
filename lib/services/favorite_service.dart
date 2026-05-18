import 'package:hive/hive.dart';
import '../models/meal.dart';

class FavoriteService {
  static const String boxName = 'favorite_meals';

  Box<Meal> get _box => Hive.box<Meal>(boxName);

  List<Meal> getAllFavorites() => _box.values.toList();

  bool isFavorite(String idMeal) => _box.containsKey(idMeal);

  Future<void> addFavorite(Meal meal) async => _box.put(meal.idMeal, meal);

  Future<void> removeFavorite(String idMeal) async => _box.delete(idMeal);

  Future<void> toggleFavorite(Meal meal) async {
    if (isFavorite(meal.idMeal)) {
      await removeFavorite(meal.idMeal);
    } else {
      await addFavorite(meal);
    }
  }
}
