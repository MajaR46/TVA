import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodie/screens/recipes/my_recipes_screen.dart';
import 'package:foodie/screens/recipes/saved_recipes_screen.dart';
import 'package:foodie/services/user_service.dart';
import '/components/menu.dart';
import 'recipe_form_screen.dart';

//TODO: spedenat design, logika je

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('Recipes');
  Future<List<String>>? savedRecipesFuture;
  String selectedSection = 'myRecipes'; // Default to 'myRecipes'
  String? userEmail;

  @override
  void initState() {
    super.initState();
    userEmail = FirebaseAuth.instance.currentUser?.email;
    savedRecipesFuture = getSavedRecipes();
  }

  Widget listItem({required Map recipe, required bool isOwner}) {
    String name = recipe['name'] ?? 'No Name';
    String description = recipe['description'] ?? 'No Description';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: TextStyle(fontSize: 16),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isOwner)
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeForm(
                          recipeKey:
                              recipe['key']), // Use RecipeForm for updating
                    ),
                  );
                },
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            IconButton(
              onPressed: () {
                if (isOwner) {
                  reference.child(recipe['key']).remove();
                } else {
                  removeSavedRecipe(recipe['key']);
                }
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red[700],
              ),
            ),
          ],
        ),
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
      setState(() {
        savedRecipesFuture = getSavedRecipes();
      });
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

  Widget buildMyRecipesSection() {
    Query myRecipesQuery =
        reference.orderByChild('authorEmail').equalTo(userEmail);

    return Container(
      height: 400,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MyRecipesScreen()),
                  );
                },
                child: Text('My Recipes'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SavedRecipesScreen()),
                  );
                },
                child: Text('My Saved Recipes'),
              ),
            ],
          ),
          Expanded(
            child: selectedSection == 'myRecipes'
                ? buildMyRecipesSection()
                : FutureBuilder<List<String>>(
                    future: savedRecipesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No saved recipes found.'));
                      } else {
                        return buildSavedRecipesSection(snapshot.data!);
                      }
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RecipeForm()),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: MenuComponent(),
    );
  }
}
