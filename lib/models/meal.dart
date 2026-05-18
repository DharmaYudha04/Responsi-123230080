import 'package:hive/hive.dart';

part 'meal.g.dart';

@HiveType(typeId: 1)
class Meal extends HiveObject {
  @HiveField(0)
  final String idMeal;

  @HiveField(1)
  final String strMeal;

  @HiveField(2)
  final String strMealThumb;

  @HiveField(3)
  final String strCountry;

  @HiveField(4)
  final String strCategory;

  Meal({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    required this.strCountry,
    this.strCategory = '',
  });

  factory Meal.fromFilterJson(Map<String, dynamic> json, String category) {
    return Meal(
      idMeal: json['idMeal']?.toString() ?? '',
      strMeal: json['strMeal']?.toString() ?? '',
      strMealThumb: json['strMealThumb']?.toString() ?? '',
      strCountry: json['strArea']?.toString() ?? 'Unknown',
      strCategory: category,
    );
  }

  factory Meal.fromDetailJson(Map<String, dynamic> json) {
    return Meal(
      idMeal: json['idMeal']?.toString() ?? '',
      strMeal: json['strMeal']?.toString() ?? '',
      strMealThumb: json['strMealThumb']?.toString() ?? '',
      strCountry: json['strArea']?.toString() ?? 'Unknown',
      strCategory: json['strCategory']?.toString() ?? '',
    );
  }
}
