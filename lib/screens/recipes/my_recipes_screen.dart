import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodie/app_styles.dart';
import 'package:foodie/components/recipeCard.dart';
import 'package:foodie/screens/home_screen.dart';
import 'package:foodie/components/menu.dart';
import 'package:foodie/screens/recipes/repice_details_screen.dart';
import 'recipe_form_screen.dart';

class MyRecipesScreen extends StatefulWidget {
  const MyRecipesScreen({Key? key}) : super(key: key);

  @override
  State<MyRecipesScreen> createState() => _MyRecipesScreenState();
}

class _MyRecipesScreenState extends State<MyRecipesScreen> {
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('Recipes');
  String? userEmail;

  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuth.instance.currentUser?.email;
  }

  Widget listItem({required Map recipe, required bool isOwner}) {
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeForm(recipeKey: recipe['key']),
                    ),
                  );
                },
                icon: Icon(
                  Icons.edit,
                  color: AppStyles.vistaBlue,
                ),
              ),
              IconButton(
                onPressed: () {
                  if (isOwner) {
                    reference.child(recipe['key']).remove();
                  }
                },
                icon: Icon(
                  Icons.delete,
                  color: AppStyles.ochre,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMyRecipesSection() {
    Query myRecipesQuery =
        reference.orderByChild('authorEmail').equalTo(userEmail);

    return Expanded(
      child: FirebaseAnimatedList(
        query: myRecipesQuery,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map recipe = snapshot.value as Map;
          recipe['key'] = snapshot.key;

          return listItem(recipe: recipe, isOwner: true);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8.0),
                Center(
                  child: Text(
                    'My Recipes',
                    style: AppStyles.heading1.copyWith(color: AppStyles.ochre),
                  ),
                ),
                SizedBox(height: 16.0),
                buildMyRecipesSection(),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RecipeForm()),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: AppStyles.carrotOrange,
            foregroundColor: AppStyles.white,
          ),
        ),
      ],
    );
  }
}
