// recipes_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:foodie/screens/add_recipe_screen.dart';
import 'package:foodie/screens/update_recipe_screen.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);
  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  Query dbRef = FirebaseDatabase.instance.ref().child('Recipes');
  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('Recipes');

  Widget listItem({required Map recipe}) {
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
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpdateRecipe(recipeKey: recipe['key']),
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
                reference.child(recipe['key']).remove();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
      ),
      body: Container(
        height: double.infinity,
        child: FirebaseAnimatedList(
          query: dbRef,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map recipe = snapshot.value as Map;
            recipe['key'] = snapshot.key;

            return listItem(recipe: recipe);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddRecipeScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
