import 'package:flutter/material.dart';
import 'package:foodie/models/recipe.dart';
import 'package:hive/hive.dart';
import '/components/menu.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.account_circle_outlined),
        title: const Text('Živijo'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SearchWidget(),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Kategorije',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            CategoriesWidget(),
            const SizedBox(height: 20),
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
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Išči',
              labelStyle: TextStyle(
                color: const Color(0xffF2F3F4).withOpacity(0.5),
              ),
              prefixIcon: const Icon(Icons.search),
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
            onSubmitted: (value) {},
          ),
        ),
      ],
    );
  }
}

class CategoriesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: const SingleChildScrollView(
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
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Popularni recepti',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildLatestRecipesList(),
          ],
        ),
      ),
    );
  }
}

Widget _buildLatestRecipesList() {
  Box<Recipe> recipeBox = Hive.box<Recipe>('recipes');

  return Expanded(
    child: ListView.builder(
      itemCount: recipeBox.length,
      itemBuilder: (BuildContext context, int index) {
        Recipe recipe = recipeBox.getAt(index)!;

        return ListTile(
          title: Text(recipe.name),
          subtitle: Text(recipe.description),
          onTap: () {
            // TODO: Navigate to RecipeDetailsScreen when a recipe is tapped
          },
        );
      },
    ),
  );
}
