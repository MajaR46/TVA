import 'package:hive/hive.dart';
part 'recipe.g.dart';

@HiveType(typeId: 0)
class Recipe {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String description;
  Recipe({
    required this.name,
    required this.description,
  });
}
