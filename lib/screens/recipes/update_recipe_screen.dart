import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

enum Difficulty { easy, medium, hard }

enum Taste { sweet, salty }

enum Category { breakfast, lunch, dinner, dessert, snack }

class UpdateRecipe extends StatefulWidget {
  const UpdateRecipe({Key? key, required this.recipeKey}) : super(key: key);

  final String recipeKey;

  @override
  State<UpdateRecipe> createState() => _UpdateRecipeState();
}

class _UpdateRecipeState extends State<UpdateRecipe> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final stepsController = TextEditingController();
  final ingredientsNameController = TextEditingController();
  final ingredientsAmountController = TextEditingController();

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
    getRecipeData();
  }

  void getRecipeData() async {
    DataSnapshot snapshot = await dbRef.child(widget.recipeKey).get();

    Map recipe = snapshot.value as Map;

    nameController.text = recipe['name'];
    descriptionController.text = recipe['description'];
    stepsController.text = recipe['steps'];
    ingredientsNameController.text = recipe['ingredientsName'];
    ingredientsAmountController.text = recipe['ingredientsAmount'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Recipe'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: stepsController,
                decoration: InputDecoration(labelText: 'Steps'),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: ingredientsNameController,
                      decoration: InputDecoration(labelText: 'Ingredient Name'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: ingredientsAmountController,
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
                  Map<String, dynamic> updatedRecipe = {
                    'name': nameController.text,
                    'description': descriptionController.text,
                    'steps': stepsController.text,
                    'ingredientsName': ingredientsNameController.text,
                    'ingredientsAmount': ingredientsAmountController.text,
                    'difficulty': _difficulty.toString().split('.').last,
                    'timeOfMaking': _timeOfMaking,
                    'kcal': _kcal,
                    'protein': _protein,
                    'carbohydrates': _carbohydrates,
                    'fats': _fats,
                    'category': _category.toString().split('.').last,
                    'taste': _taste.toString().split('.').last,
                  };

                  dbRef
                      .child(widget.recipeKey)
                      .update(updatedRecipe)
                      .then((value) => Navigator.pop(context))
                      .catchError(
                          (error) => print("Failed to update recipe: $error"));
                },
                child: Text('Update Recipe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
