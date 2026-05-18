import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';
import '../models/meal_detail.dart';

class MealApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Meal>> getMealsByCategory(String category) async {
    final url = Uri.parse('$_baseUrl/filter.php?c=$category');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat daftar makanan/non-eksisten');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = (data['meals'] as List<dynamic>?) ?? [];

    final result = <Meal>[];
    for (final item in meals) {
      final basicMeal = Meal.fromFilterJson(item as Map<String, dynamic>, category);
      try {
        final detail = await getMealDetail(basicMeal.idMeal);
        result.add(Meal(
          idMeal: basicMeal.idMeal,
          strMeal: basicMeal.strMeal,
          strMealThumb: basicMeal.strMealThumb,
          strCountry: detail.strArea,
          strCategory: category,
        ));
      } catch (_) {
        result.add(basicMeal);
      }
    }
    return result;
  }

  Future<MealDetail> getMealDetail(String idMeal) async {
    final url = Uri.parse('$_baseUrl/lookup.php?i=$idMeal');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat detail makanan/non-eksisten');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = (data['meals'] as List<dynamic>?) ?? [];
    if (meals.isEmpty) {
      throw Exception('Data makanan tidak ditemukan/non-eksisten');
    }
    return MealDetail.fromJson(meals.first as Map<String, dynamic>);
  }
}
