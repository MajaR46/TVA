import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:foodie/models/recipe.dart';

class RecipesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Recipe>('recipes').listenable(),
        builder: (context, Box<Recipe> recipeBox, _) {
          return ListView.builder(
            itemCount: recipeBox.length,
            itemBuilder: (context, index) {
              final recipe = recipeBox.getAt(index);
              return ListTile(
                title: Text(recipe!.name),
                subtitle: Text(recipe.description),
                leading: CircleAvatar(
                  backgroundColor: Colors.indigo,
                  child: Icon(
                    Icons.food_bank_rounded,
                    color: Colors.white,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        recipeBox.deleteAt(index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _updateRecipe(context, recipe, index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add recipe screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecipeScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _updateRecipe(
      BuildContext context, Recipe recipe, int index) async {
    final editControllerName = TextEditingController(text: recipe.name);
    final editControllerDescription =
        TextEditingController(text: recipe.description);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Recipe'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: editControllerName),
              TextField(controller: editControllerDescription),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                final editedRecipe = Recipe(
                  name: editControllerName.text,
                  description: editControllerDescription.text,
                );
                Hive.box<Recipe>('recipes').putAt(index, editedRecipe);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class AddRecipeScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                _addRecipe(context);
              },
              child: Text('Add Recipe'),
            ),
          ],
        ),
      ),
    );
  }

  void _addRecipe(BuildContext context) {
    final String name = _nameController.text.trim();
    final String description = _descriptionController.text.trim();

    if (name.isNotEmpty && description.isNotEmpty) {
      final Recipe newRecipe = Recipe(
        name: name,
        description: description,
      );

      Hive.box<Recipe>('recipes').add(newRecipe);

      Navigator.pop(context); // Go back to previous screen
    } else {
      // Show error message if name or description is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter both name and description.'),
        ),
      );
    }
  }
}
