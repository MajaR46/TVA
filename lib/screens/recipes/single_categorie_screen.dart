import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:foodie/screens/recipes/recipe_form_screen.dart';

class SingleCategoryScreen extends StatefulWidget {
  final String category;

  const SingleCategoryScreen({Key? key, required this.category})
      : super(key: key);

  @override
  _SingleCategoryScreenState createState() => _SingleCategoryScreenState();
}

class _SingleCategoryScreenState extends State<SingleCategoryScreen> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('Recipes');

  List<Map<dynamic, dynamic>> _recipes = [];

  @override
  void initState() {
    super.initState();
    _getRecipesForCategory(widget.category); // Pass the category here
  }

  Future<void> _getRecipesForCategory(String category) async {
    try {
      DatabaseEvent event = await _databaseReference.once();
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? values = snapshot.value as Map<dynamic, dynamic>?;
      if (values != null) {
        values.forEach((key, value) {
          if (value['category'] == 'breakfast') {
            _recipes.add(value);
          }
        });
        setState(() {});
      }
    } catch (error) {
      print("Error fetching recipes: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: _recipes.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_recipes[index]['name']),
                  // You can customize the list tile as per your requirements
                );
              },
            ),
    );
  }
}
