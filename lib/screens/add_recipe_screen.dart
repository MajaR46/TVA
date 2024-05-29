// add_recipe_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodie/models/recipe.dart';

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

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Recipes');
  }

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
                  Map<String, dynamic> recipeData = {
                    'name': _nameController.text,
                    'description': _descriptionController.text,
                    'steps': _stepsController.text,
                    'ingredients': {
                      'name': _ingredientsNameController.text,
                      'amount': _ingredientsAmountController.text,
                    },
                    'difficulty': _difficulty.toString().split('.').last,
                    'timeOfMaking': _timeOfMaking,
                    'kcal': _kcal,
                    'protein': _protein,
                    'carbohydrates': _carbohydrates,
                    'fats': _fats,
                    'category': _category.toString().split('.').last,
                    'taste': _taste.toString().split('.').last,
                    'authorEmail':
                        FirebaseAuth.instance.currentUser?.email ?? 'Unknown',
                  };

                  dbRef.push().set(recipeData).then((_) {
                    Navigator.pop(context);
                  });
                },
                child: Text('Add Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
