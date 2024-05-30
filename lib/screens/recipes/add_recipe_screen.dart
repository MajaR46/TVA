import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:foodie/models/nutrition.dart';
import 'package:foodie/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

enum Difficulty { easy, medium, hard }

enum Taste { sweet, salty }

enum Category { breakfast, lunch, dinner, dessert, snack }

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  Difficulty _difficulty = Difficulty.easy;
  int _timeOfMaking = 0;
  Category _category = Category.breakfast;
  Taste _taste = Taste.sweet;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  late DatabaseReference dbRef;
  List<Map<String, String>> _ingredientsList = [];
  List<Map<String, String>> _stepsList = [];

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Recipes');
  }

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('recipe_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _addToList() {
    setState(() {
      if (_stepsController.text.isNotEmpty) {
        _stepsList.add({'steps': _stepsController.text});
        _stepsController.clear();
      }
      if (_ingredientsNameController.text.isNotEmpty &&
          _ingredientsAmountController.text.isNotEmpty) {
        _ingredientsList.add({
          'name': _ingredientsNameController.text,
          'amount': _ingredientsAmountController.text,
        });
        _ingredientsNameController.clear();
        _ingredientsAmountController.clear();
      }
    });
  }

  void saveRecipe() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl;
      if (_image != null) {
        imageUrl = await _uploadImage(_image!);
      }

      Nutrition nutrition = await fetchNutrition(_nameController.text);

      Map<String, dynamic> recipeData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'steps': _stepsList,
        'ingredients': _ingredientsList,
        'difficulty': _difficulty.toString().split('.').last,
        'timeOfMaking': _timeOfMaking,
        'kcal': nutrition.calories,
        'protein': nutrition.proteinG,
        'carbohydrates': nutrition.carbohydratesTotalG,
        'fats': nutrition.fatTotalG,
        'category': _category.toString().split('.').last,
        'taste': _taste.toString().split('.').last,
        'authorEmail': FirebaseAuth.instance.currentUser?.email ?? 'Unknown',
        if (imageUrl != null) 'image_url': imageUrl,
      };

      await dbRef.push().set(recipeData);

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
  final TextEditingController _ingredientsNameController =
      TextEditingController();
  final TextEditingController _ingredientsAmountController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Recipe')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name')),
              SizedBox(height: 16.0),
              TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description')),
              SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _stepsList.length,
                itemBuilder: (context, index) {
                  return Row(children: [
                    Expanded(child: Text(_stepsList[index]['steps'] ?? ''))
                  ]);
                },
              ),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: _stepsController,
                          decoration: InputDecoration(labelText: 'Step'))),
                  SizedBox(width: 16.0),
                  ElevatedButton(onPressed: _addToList, child: Text('Add')),
                ],
              ),
              SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _ingredientsList.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                          child: Text(_ingredientsList[index]['name'] ?? '')),
                      SizedBox(width: 16.0),
                      Expanded(
                          child: Text(_ingredientsList[index]['amount'] ?? '')),
                    ],
                  );
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                          controller: _ingredientsNameController,
                          decoration:
                              InputDecoration(labelText: 'Ingredient Name'))),
                  SizedBox(width: 16.0),
                  Expanded(
                      child: TextField(
                          controller: _ingredientsAmountController,
                          decoration:
                              InputDecoration(labelText: 'Ingredient Amount'))),
                  SizedBox(width: 16.0),
                  ElevatedButton(onPressed: _addToList, child: Text('Add')),
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
                        child: Text(difficulty.toString().split('.').last)))
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
                              child: Text(category.toString().split('.').last)))
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
                        child: Text(taste.toString().split('.').last)))
                    .toList(),
                decoration: InputDecoration(labelText: 'Taste'),
              ),
              SizedBox(height: 32.0),
              _image == null
                  ? TextButton.icon(
                      onPressed: _pickImage,
                      icon: Icon(Icons.image),
                      label: Text('Pick an Image'),
                    )
                  : Image.file(_image!),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : saveRecipe,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Add Recipe'),
              ),
              if (_errorMessage != null) ...[
                SizedBox(height: 16.0),
                Text(_errorMessage!, style: TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
