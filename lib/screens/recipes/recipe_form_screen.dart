import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:foodie/models/nutrition.dart';
import 'package:foodie/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

enum Difficulty { easy, medium, hard }

enum Taste { sweet, salty }

enum Category { breakfast, lunch, dinner, dessert, snack }

class RecipeForm extends StatefulWidget {
  final String? recipeKey;

  const RecipeForm({Key? key, this.recipeKey}) : super(key: key);

  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
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
  File? _image;
  final ImagePicker _picker = ImagePicker();

  late DatabaseReference dbRef;
  List<Map<String, String>> _stepsList = []; // Declare _stepsList here
  List<Map<String, String>> _ingredientsList = [];

  void initializeLists(Map recipe) {
    List<dynamic>? steps = recipe['steps'] as List<dynamic>?;
    List<dynamic>? ingredients = recipe['ingredients'] as List<dynamic>?;

    if (steps != null) {
      // Directly store steps as strings
      _stepsList = steps.map((step) => {'steps': step.toString()}).toList();
    } else {
      _stepsList = [];
    }

    if (ingredients != null) {
      _ingredientsList = ingredients.map((ingredient) {
        final ingredientMap = ingredient as Map<dynamic, dynamic>;
        return {
          'name': ingredientMap['name'].toString(),
          'amount': ingredientMap['amount'].toString(),
        };
      }).toList();
    } else {
      _ingredientsList = [];
    }
  }

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Recipes');
    getRecipeData();
    _stepsList = [];
    _ingredientsList = [];
  }

  Future<void> getRecipeData() async {
    DataSnapshot snapshot = await dbRef.child(widget.recipeKey!).get();
    Map recipe = snapshot.value as Map;

    setState(() {
      _nameController.text = recipe['name'];
      _descriptionController.text = recipe['description'];
      initializeLists(recipe);
      _difficulty = Difficulty.values.firstWhere(
          (e) => e.toString().split('.').last == recipe['difficulty']);
      _timeOfMaking = recipe['timeOfMaking'];
      _kcal = (recipe['kcal'] ?? 0).toInt();
      _protein = (recipe['protein'] ?? 0).toInt();
      _carbohydrates = (recipe['carbohydrates'] ?? 0).toInt();
      _fats = (recipe['fats'] ?? 0).toInt();

      _category = Category.values.firstWhere(
          (e) => e.toString().split('.').last == recipe['category']);
      _taste = Taste.values
          .firstWhere((e) => e.toString().split('.').last == recipe['taste']);
    });
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
      Nutrition nutrition = await fetchNutrition(_nameController.text);
      String? imageUrl;
      if (_image != null) {
        imageUrl = await _uploadImage(_image!);
      }

      List<String> stepsOnly =
          _stepsList.map((step) => step['steps']!).toList();

      List<Map<String, String>> ingredientsOnly = _ingredientsList
          .map((ingredient) =>
              {'name': ingredient['name']!, 'amount': ingredient['amount']!})
          .toList();

      Map<String, dynamic> recipeData = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'steps': stepsOnly,
        'ingredients': ingredientsOnly,
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

      if (widget.recipeKey != null) {
        await dbRef.child(widget.recipeKey!).update(recipeData);
      } else {
        await dbRef.push().set(recipeData);
      }

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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffdb7706),
                textStyle: const TextStyle(color: Colors.white),
              ),
              onPressed: _isLoading ? null : saveRecipe,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      widget.recipeKey != null ? 'Update Recipe' : 'Add Recipe',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              const Text(
                "Recipe name",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xffFA9D31),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              const Text(
                "Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xffFA9D31),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              const Text(
                "Steps",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xffFA9D31),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _stepsController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  FloatingActionButton(
                      heroTag: 'addButton',
                      onPressed: _addToList,
                      backgroundColor: const Color(0xffdb7706),
                      child: const Icon(Icons.add),
                      foregroundColor: Colors.white),
                ],
              ),
              const SizedBox(height: 32.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _stepsList.length ?? 0,
                itemBuilder: (context, index) {
                  final step = _stepsList[index];
                  final steps = step['steps'] ?? '';
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    color: const Color(0xffF2F3F4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            steps,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              _stepsList.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32.0),
              const Text(
                "Ingredients",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xffFA9D31),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _ingredientsNameController,
                      decoration: const InputDecoration(
                        labelText: 'Ingredient Name',
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: _ingredientsAmountController,
                      decoration: const InputDecoration(
                        labelText: 'Ingredient Amount',
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                        ),
                      ),
                    ),
                  ),
                  FloatingActionButton(
                      onPressed: _addToList,
                      backgroundColor: const Color(0xffdb7706),
                      child: const Icon(Icons.add),
                      foregroundColor: Colors.white),
                ],
              ),
              const SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: (_ingredientsList.length ?? 0),
                itemBuilder: (context, index) {
                  final ingredient = _ingredientsList[index];
                  final amount = ingredient['amount'] ?? '';
                  final name = ingredient['name'] ?? '';

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ListTile(
                      title: Text(
                        '${amount} ${name}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _ingredientsList.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32.0),
              const Text(
                "Difficulty",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xffFA9D31),
                ),
              ),
              const SizedBox(height: 8.0),
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
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              const Text(
                "Time of Making (minutes)",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xffFA9D31),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) =>
                          _timeOfMaking = int.tryParse(value) ?? 0,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              const Text(
                "Category",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xffFA9D31),
                ),
              ),
              const SizedBox(height: 8.0),
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
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              const Text(
                "Taste",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xffFA9D31),
                ),
              ),
              const SizedBox(height: 8.0),
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
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              _image == null
                  ? TextButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(
                        Icons.image,
                        color: Color(0xffFA9D31),
                      ),
                      label: const Text(
                        'Pick an Image',
                        style: TextStyle(color: Color(0xffdb7706)),
                      ),
                    )
                  : Image.file(_image!),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
