import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:foodie/screens/recipes/categories_screen.dart';
import 'package:foodie/screens/recipes/my_recipes_screen.dart';
import 'package:foodie/screens/recipes/recipe_form_screen.dart';
import 'package:foodie/screens/recipes/repice_details_screen.dart';
import 'package:foodie/components/menu.dart';
import 'package:foodie/components/recipeCard.dart';
import 'package:foodie/components/searchWidget.dart';
import 'package:foodie/screens/recipes/saved_recipes_screen.dart';
import 'package:foodie/screens/recipes/single_categorie_screen.dart';
import 'package:foodie/app_styles.dart';

//TO DO: add navigation to the menu component

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: Container(
              padding: EdgeInsets.only(top: 16.0),
              child: AppBar(
                backgroundColor: AppStyles.white,
                leading: FittedBox(
                  fit: BoxFit.contain,
                  child: Image.asset(
                    'assets/images/Logo.png',
                    width: 40.0, // Set the desired width
                    height: 40.0, // Set the desired height
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text('Foodie',
                      style:
                          AppStyles.heading3.copyWith(color: AppStyles.gray)),
                ),
              ),
            ),
          ),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Categories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                CategoriesWidget(),
                const SizedBox(height: 32),
                Expanded(child: LatestRecipesWidget()),
              ],
            ),
          ),
          bottomNavigationBar: MenuComponent(),
        ),
        Positioned(
          top: 42,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                            leading: Icon(Icons.food_bank),
                            title: Text('My Recipes'),
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyRecipesScreen()));
                            }),
                        ListTile(
                            leading: Icon(Icons.save),
                            title: Text('Saved Recipes'),
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SavedRecipesScreen()));
                            }),
                        ListTile(
                            leading: Icon(Icons.add),
                            title: Text('Add Recipe'),
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RecipeForm()));
                            }),
                      ],
                    ),
                  );
                },
              );
            },
            child: Icon(Icons.menu),
            backgroundColor: AppStyles.carrotOrange,
            foregroundColor: AppStyles.white,
          ),
        ),
      ],
    );
  }
}

class CategoriesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 10),
            CategoryItem(
                text: 'Breakfast',
                categoryType: 'Meal',
                categoryLabel: 'Breakfast'),
            const SizedBox(width: 10),
            CategoryItem(
                text: 'Lunch', categoryType: 'Meal', categoryLabel: 'Lunch'),
            const SizedBox(width: 10),
            CategoryItem(
                text: 'Dinner', categoryType: 'Meal', categoryLabel: 'Dinner'),
            const SizedBox(width: 10),
            CategoryItem(
                text: 'Dessert',
                categoryType: 'Meal',
                categoryLabel: 'Dessert'),
            const SizedBox(width: 10),
            CategoryItem(
                text: 'Sweet', categoryType: 'Taste', categoryLabel: 'Sweet'),
            const SizedBox(width: 10),
            CategoryItem(
                text: 'Salty', categoryType: 'Taste', categoryLabel: 'Salty'),
            const SizedBox(width: 10),
            CategoryItem(
                text: 'Easy',
                categoryType: 'Difficulty',
                categoryLabel: 'Easy'),
            const SizedBox(width: 10),
            CategoryItem(
                text: 'Medium',
                categoryType: 'Difficulty',
                categoryLabel: 'Medium'),
            const SizedBox(width: 10),
            CategoryItem(
                text: 'Hard',
                categoryType: 'Difficulty',
                categoryLabel: 'Hard'),
          ],
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String text;
  final String categoryType;
  final String categoryLabel;

  const CategoryItem({
    required this.text,
    required this.categoryType,
    required this.categoryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleCategoryScreen(
              categoryType: categoryType,
              categoryLabel: categoryLabel,
              category: text,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: AppStyles.powderBlue),
        child: Text(
          text,
          style: AppStyles.button1.copyWith(color: AppStyles.white),
        ),
      ),
    );
  }
}

class LatestRecipesWidget extends StatelessWidget {
  final Query dbRef = FirebaseDatabase.instance
      .ref()
      .child('Recipes')
      .orderByKey()
      .limitToLast(10);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Popular Recipes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FirebaseAnimatedList(
              query: dbRef,
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
    );
  }
}
