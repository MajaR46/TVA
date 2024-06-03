import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:foodie/components/recipeCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodie/screens/home_screen.dart';
import 'package:foodie/screens/recipes/repice_details_screen.dart';
import 'package:foodie/services/user_service.dart';
import 'package:foodie/components/menu.dart';
import 'recipe_form_screen.dart';
import 'package:foodie/app_styles.dart';

class SavedRecipesScreen extends StatefulWidget {
  const SavedRecipesScreen({Key? key}) : super(key: key);

  @override
  State<SavedRecipesScreen> createState() => _SavedRecipesScreenState();
}

class _SavedRecipesScreenState extends State<SavedRecipesScreen> {
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('Recipes');
  Future<List<String>>? savedRecipesFuture;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuth.instance.currentUser?.email;
    loadSavedRecipes();
  }

  Future<void> loadSavedRecipes() async {
    savedRecipesFuture = getSavedRecipes();
    await savedRecipesFuture;
    setState(() {});
  }

  Widget listItem({required Map recipe, required bool isOwner}) {
    String name = recipe['name'] ?? 'No Name';
    String description = recipe['description'] ?? 'No Description';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          RecipeCard(
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
          )
        ],
      ),
    );
  }

  Future<void> removeSavedRecipe(String recipeKey) async {
    String? userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID != null) {
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userID)
          .child('savedRecipes')
          .child(recipeKey);
      await userRef.remove();
      loadSavedRecipes();
    }
  }

  Widget buildSavedRecipesSection(List<String> savedRecipesKeys) {
    return FutureBuilder<List<DataSnapshot>>(
      future: Future.wait(
          savedRecipesKeys.map((key) => reference.child(key).get()).toList()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No saved recipes found.'));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Map recipe = snapshot.data![index].value as Map;
              recipe['key'] = snapshot.data![index].key;
              return listItem(recipe: recipe, isOwner: false);
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 8.0),
              Center(
                child: Text(
                  'Saved Recipes',
                  style: AppStyles.heading1.copyWith(color: AppStyles.ochre),
                ),
              ),
              SizedBox(height: 16.0),
              savedRecipesFuture != null
                  ? FutureBuilder<List<String>>(
                      future: savedRecipesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No saved recipes found.'));
                        } else {
                          return buildSavedRecipesSection(snapshot.data!);
                        }
                      },
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MenuComponent(),
    );
  }
}
