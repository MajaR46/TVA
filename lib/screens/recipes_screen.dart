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
                  steps: recipe.steps,
                  ingredients: recipe.ingredients,
                  difficulty: recipe.difficulty,
                  timeOfMaking: recipe.timeOfMaking,
                  kcal: recipe.kcal,
                  protein: recipe.protein,
                  carbohydrates: recipe.carbohydrates,
                  fats: recipe.fats,
                  category: recipe.category,
                  taste: recipe.taste,
                  authorEmail: recipe.authorEmail,
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

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _ingredientsNameController =
      TextEditingController();
  final TextEditingController _ingredientsAmountController =
      TextEditingController();
  Difficulty _difficulty = Difficulty.easy;
  int _timeOfMaking = 0;
  int _kcal = 0;
  int _protein = 0;
  int _carbohydrates = 0;
  int _fats = 0;
  Category _category = Category.breakfast;
  Taste _taste = Taste.sweet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              SizedBox(height: 16.0),
              TextField(
                controller: _stepsController,
                decoration: InputDecoration(labelText: 'Steps'),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ingredientsNameController,
                      decoration: InputDecoration(labelText: 'Ingredient Name'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: _ingredientsAmountController,
                      decoration:
                          InputDecoration(labelText: 'Ingredient Amount'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<Difficulty>(
                value: _difficulty,
                onChanged: (value) {
                  setState(() {
                    _difficulty = value!;
                  });
                },
                items: Difficulty.values
                    .map((difficulty) => DropdownMenuItem(
                          value: difficulty,
                          child: Text(difficulty.toString().split('.').last),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: 'Difficulty'),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          _timeOfMaking = int.tryParse(value) ?? 0,
                      decoration: InputDecoration(
                          labelText: 'Time of Making (minutes)'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _kcal = int.tryParse(value) ?? 0,
                      decoration: InputDecoration(labelText: 'Kcal'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _protein = int.tryParse(value) ?? 0,
                      decoration: InputDecoration(labelText: 'Protein (grams)'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          _carbohydrates = int.tryParse(value) ?? 0,
                      decoration:
                          InputDecoration(labelText: 'Carbohydrates (grams)'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _fats = int.tryParse(value) ?? 0,
                      decoration: InputDecoration(labelText: 'Fats (grams)'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: DropdownButtonFormField<Category>(
                      value: _category,
                      onChanged: (value) {
                        setState(() {
                          _category = value!;
                        });
                      },
                      items: Category.values
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child:
                                    Text(category.toString().split('.').last),
                              ))
                          .toList(),
                      decoration: InputDecoration(labelText: 'Category'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<Taste>(
                value: _taste,
                onChanged: (value) {
                  setState(() {
                    _taste = value!;
                  });
                },
                items: Taste.values
                    .map((taste) => DropdownMenuItem(
                          value: taste,
                          child: Text(taste.toString().split('.').last),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: 'Taste'),
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
      ),
    );
  }

  void _addRecipe(BuildContext context) {
    final String name = _nameController.text.trim();
    final String description = _descriptionController.text.trim();
    final List<String> steps = _stepsController.text
        .split('\n')
        .where((step) => step.trim().isNotEmpty)
        .toList();
    final List<Ingredient> ingredients = [
      Ingredient(
          name: _ingredientsNameController.text.trim(),
          amount: _ingredientsAmountController.text.trim())
    ];

    if (name.isNotEmpty &&
        description.isNotEmpty &&
        steps.isNotEmpty &&
        ingredients.isNotEmpty) {
      final Recipe newRecipe = Recipe(
        name: name,
        description: description,
        steps: steps,
        ingredients: ingredients,
        difficulty: _difficulty,
        timeOfMaking: _timeOfMaking,
        kcal: _kcal,
        protein: _protein,
        carbohydrates: _carbohydrates,
        fats: _fats,
        category: _category,
        taste: _taste,
        authorEmail: 'author@example.com', // Assuming author's email is fixed
      );

      Hive.box<Recipe>('recipes').add(newRecipe);

      Navigator.pop(context); // Go back to previous screen
    } else {
      // Show error message if any required field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields.'),
        ),
      );
    }
  }
}
