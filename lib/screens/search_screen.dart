import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodie/app_styles.dart';
import 'package:foodie/components/recipeCard.dart';
import 'package:foodie/screens/home_screen.dart';
import 'package:foodie/components/menu.dart';
import 'package:foodie/components/searchWidget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:foodie/screens/recipes/repice_details_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('Recipes');

  final Query dbRef =
      FirebaseDatabase.instance.ref().child('Recipes').orderByKey();

  List<Map<dynamic, dynamic>> _recipes = [];
  String _searchText = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() async {
    try {
      DatabaseEvent event = await _databaseReference.once();
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? values = snapshot.value as Map<dynamic, dynamic>?;

      if (values != null) {
        values.forEach((key, value) {
          _recipes.add(value);
        });
      }

      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print("Error fetching recipes: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchTextChanged(String text) {
    setState(() {
      _searchText = text;
    });
  }

  List<Map<dynamic, dynamic>> _filteredRecipes() {
    if (_searchText.isEmpty) {
      return _recipes;
    }

    List<Map<dynamic, dynamic>> filteredList = _recipes.where((recipe) {
      String name = recipe['name'].toString().toLowerCase();
      return name.contains(_searchText.toLowerCase());
    }).toList();

    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<dynamic, dynamic>> displayedRecipes = _filteredRecipes();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 8.0),
            Center(
              child: Text(
                'Search',
                style: AppStyles.heading1.copyWith(color: AppStyles.ochre),
              ),
            ),
            SizedBox(height: 16.0),
            SearchWidget(
              onChanged: _onSearchTextChanged,
              onClear: () {
                _onSearchTextChanged('');
              },
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: displayedRecipes.length,
                itemBuilder: (BuildContext context, int index) {
                  Map recipe = displayedRecipes[index];
                  return RecipeCard(
                    recipe: recipe,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailsScreen(
                            recipeId: recipe['key'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MenuComponent(),
    );
  }
}
