// GENERATED CODE - dibuat manual agar tidak perlu menjalankan build_runner.

part of 'meal.dart';

class MealAdapter extends TypeAdapter<Meal> {
  @override
  final int typeId = 1;

  @override
  Meal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meal(
      idMeal: fields[0] as String,
      strMeal: fields[1] as String,
      strMealThumb: fields[2] as String,
      strCountry: fields[3] as String,
      strCategory: fields[4] as String? ?? '',
    );
  }

  @override
  void write(BinaryWriter writer, Meal obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.idMeal)
      ..writeByte(1)
      ..write(obj.strMeal)
      ..writeByte(2)
      ..write(obj.strMealThumb)
      ..writeByte(3)
      ..write(obj.strCountry)
      ..writeByte(4)
      ..write(obj.strCategory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
