import 'package:hive/hive.dart';
part 'recipe.g.dart';

enum Difficulty { easy, medium, hard }

enum Taste { sweet, salty }

enum Category { breakfast, lunch, dinner, dessert, snack }

@HiveType(typeId: 0)
class Recipe {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final List<String> steps;
  @HiveField(3)
  final List<Ingredient> ingredients;
  @HiveField(4)
  final Difficulty difficulty;
  @HiveField(5)
  final int timeOfMaking; // in minutes
  @HiveField(6)
  final int kcal;
  @HiveField(7)
  final int protein; // in grams
  @HiveField(8)
  final int carbohydrates; // in grams
  @HiveField(9)
  final int fats; // in grams
  @HiveField(10)
  final Category category;
  @HiveField(11)
  final Taste taste;
  @HiveField(12)
  final String authorEmail;

  Recipe(
      {required this.name,
      required this.description,
      required this.steps,
      required this.ingredients,
      required this.difficulty,
      required this.timeOfMaking,
      required this.kcal,
      required this.protein,
      required this.carbohydrates,
      required this.fats,
      required this.category,
      required this.taste,
      required this.authorEmail});
}

@HiveType(typeId: 1)
class Ingredient {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String amount;
  Ingredient({required this.name, required this.amount});
  Recipe({
    required this.name,
    required this.description,
  });
}
