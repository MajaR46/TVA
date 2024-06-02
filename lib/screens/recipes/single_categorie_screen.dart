import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:foodie/components/recipeCard.dart';
import 'package:foodie/screens/recipes/repice_details_screen.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:foodie/app_styles.dart';
import 'package:foodie/components/menu.dart';

class SingleCategoryScreen extends StatefulWidget {
  final String categoryType;
  final String categoryLabel;
  final String category;

  const SingleCategoryScreen({
    Key? key,
    required this.categoryType,
    required this.categoryLabel,
    required this.category,
  }) : super(key: key);

  @override
  _SingleCategoryScreenState createState() => _SingleCategoryScreenState();
}

class _SingleCategoryScreenState extends State<SingleCategoryScreen> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('Recipes');

  final Query dbRef =
      FirebaseDatabase.instance.ref().child('Recipes').orderByKey();

  List<Map<dynamic, dynamic>> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getRecipesForCategory(
        widget.categoryType, widget.categoryLabel, widget.category);
  }

  Future<void> _getRecipesForCategory(
      String categoryType, String categoryLabel, String category) async {
    try {
      DatabaseEvent event = await _databaseReference.once();
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? values = snapshot.value as Map<dynamic, dynamic>?;

      if (values != null) {
        values.forEach((key, value) {
          String categoryKey;

          switch (categoryType) {
            case 'Meal':
              categoryKey = 'category';
              break;
            case 'Taste':
              categoryKey = 'taste';
              break;
            case 'Difficulty':
              categoryKey = 'difficulty';
              break;
            default:
              categoryKey = 'category';
              break;
          }

          String categoryValue =
              value[categoryKey]?.toString().toLowerCase() ?? '';

          if (categoryValue == categoryLabel.toLowerCase()) {
            _recipes.add(value);
          }
        });
      }

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print("Error fetching recipes: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _recipes.isEmpty
              ? const Center(
                  child: Text('No recipes found for this category.'),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          widget.categoryLabel,
                          textAlign: TextAlign.center,
                          style: AppStyles.heading1
                              .copyWith(color: AppStyles.ochre),
                        ),
                      ),
                      const SizedBox(height: 38.0),
                      Expanded(
                        child: FirebaseAnimatedList(
                          query: dbRef,
                          itemBuilder: (BuildContext context,
                              DataSnapshot snapshot,
                              Animation<double> animation,
                              int index) {
                            Map recipe = snapshot.value as Map;
                            recipe['key'] = snapshot.key;

                            return RecipeCard(
                              recipe: recipe,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RecipeDetailsScreen(
                                      recipeId: recipe['key'],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: MenuComponent(),
    );
  }
}
