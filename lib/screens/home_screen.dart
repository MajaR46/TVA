import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:foodie/models/recipe.dart';
import 'package:foodie/screens/recipes_screen.dart';
import 'package:hive/hive.dart';
import '/components/menu.dart';

// Firebase database instance
final FirebaseDatabase database = FirebaseDatabase.instance;

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.account_circle_outlined),
        title: Text('Živijo'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SearchWidget(),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Kategorije',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            CategoriesWidget(),
            SizedBox(height: 20),
            LatestRecipesWidget(),
          ],
        ),
      ),
      bottomNavigationBar: MenuComponent(),
    );
  }
}

class SearchWidget extends StatefulWidget {
  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: 'Išči',
          labelStyle: TextStyle(
            color: Color(0xffF2F3F4).withOpacity(0.5),
          ),
          prefixIcon: Icon(Icons.search),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          setState(() {
            // Add your search logic here
          });
        },
      ),
    );
  }
}

class CategoriesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: 10),
            CategoryItem(text: 'Vse'),
            SizedBox(width: 10),
            CategoryItem(text: 'Zajtrk'),
            SizedBox(width: 10),
            CategoryItem(text: 'Kosilo'),
            // Add more CategoryItems as needed
          ],
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String text;

  const CategoryItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.grey[300],
      ),
      child: Text(text),
    );
  }
}

class LatestRecipesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Popularni recepti',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildLatestRecipesList(),
          ],
        ),
      ),
    );
  }
}

Widget _buildLatestRecipesList() {
  // Get the box containing recipes
  Box<Recipe> recipeBox = Hive.box<Recipe>('recipes');

  return Expanded(
    child: ListView.builder(
      itemCount: recipeBox.length,
      itemBuilder: (BuildContext context, int index) {
        // Get the recipe at the current index
        Recipe recipe = recipeBox.getAt(index)!; // Add null check for safety

        // Build a ListTile for each recipe
        return ListTile(
          title: Text(recipe.name),
          subtitle: Text(recipe.description),
          onTap: () {
            // Navigate to RecipeDetailsScreen when a recipe is tapped
          },
        );
      },
    ),
  );
}
