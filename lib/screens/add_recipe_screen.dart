import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:foodie/models/recipe.dart';
import 'package:foodie/models/nutrition.dart';
import 'package:foodie/services/api_service.dart';

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
  Category _category = Category.breakfast;
  Taste _taste = Taste.sweet;

  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Recipes');
  }

  void saveRecipe() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch nutrition data for the main ingredient
      Nutrition nutrition = await fetchNutrition(_nameController.text);

      // Prepare recipe data with fetched nutrition information
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
        'kcal': nutrition.calories,
        'protein': nutrition.proteinG,
        'carbohydrates': nutrition.carbohydratesTotalG,
        'fats': nutrition.fatTotalG,
        'category': _category.toString().split('.').last,
        'taste': _taste.toString().split('.').last,
        'authorEmail': FirebaseAuth.instance.currentUser?.email ?? 'Unknown',
      };

      await dbRef.push().set(recipeData);

      // Navigate back after saving
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isLoading = false;
  String? _errorMessage;

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
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
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
                onPressed: _isLoading ? null : saveRecipe,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Add Recipe'),
              ),
              if (_errorMessage != null) ...[
                SizedBox(height: 16.0),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
