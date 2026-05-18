class MealDetail {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;
  final String strCategory;
  final String strArea;
  final String strInstructions;
  final String strSource;

  MealDetail({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    required this.strSource,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    return MealDetail(
      idMeal: json['idMeal']?.toString() ?? '',
      strMeal: json['strMeal']?.toString() ?? '',
      strMealThumb: json['strMealThumb']?.toString() ?? '',
      strCategory: json['strCategory']?.toString() ?? '-',
      strArea: json['strArea']?.toString() ?? '-',
      strInstructions: json['strInstructions']?.toString() ?? '-',
      strSource: json['strSource']?.toString() ?? '',
    );
  }
}
