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
  late Query _categoryQuery;

  @override
  void initState() {
    super.initState();
    _initializeQuery();
  }

  void _initializeQuery() {
    String categoryKey;
    switch (widget.categoryType) {
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
    _categoryQuery = FirebaseDatabase.instance
        .ref()
        .child('Recipes')
        .orderByChild(categoryKey)
        .equalTo(widget.categoryLabel.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
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
                style: AppStyles.heading1.copyWith(color: AppStyles.ochre),
              ),
            ),
            const SizedBox(height: 38.0),
            Expanded(
              child: FirebaseAnimatedList(
                query: _categoryQuery,
                defaultChild: const Center(
                  child: CircularProgressIndicator(),
                ),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
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
