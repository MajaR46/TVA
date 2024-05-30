import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final String recipeId;

  const RecipeDetailsScreen({required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Details'),
      ),
      body: FutureBuilder<DataSnapshot>(
        future: FirebaseDatabase.instance
            .ref()
            .child('Recipes')
            .child(recipeId)
            .once()
            .then((snapshot) =>
                snapshot.snapshot), // Return the DataSnapshot directly
        builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            Map<dynamic, dynamic>? recipeData =
                (snapshot.data?.value as Map<dynamic, dynamic>?);

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(recipeData?['image_url'] ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    recipeData?['name'] ?? 'No Name',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.access_time),
                      SizedBox(width: 4.0),
                      Text(
                        '${recipeData?['timeOfMaking']} min',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(width: 16.0),
                      Icon(Icons.star),
                      SizedBox(width: 4.0),
                      Text(
                        _getDifficultyText(recipeData?['difficulty']),
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Nutrition:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text('Kcal: ${recipeData?['kcal'] ?? 'N/A'}'),
                  Text('Protein: ${recipeData?['protein'] ?? 'N/A'} g'),
                  Text(
                      'Carbohydrates: ${recipeData?['carbohydrates'] ?? 'N/A'} g'),
                  Text('Fats: ${recipeData?['fats'] ?? 'N/A'} g'),
                  SizedBox(height: 16.0),
                  Text(
                    'Ingredients:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: (recipeData?['ingredients'] as List<dynamic>?)
                            ?.length ??
                        0,
                    itemBuilder: (context, index) {
                      final ingredients = recipeData?['ingredients'] as List?;
                      return ListTile(
                        title: Text(ingredients?[index]['name'] ?? ''),
                        subtitle: Text(ingredients?[index]['amount'] ?? ''),
                      );
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Steps:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        (recipeData?['steps'] as List<dynamic>?)?.length ?? 0,
                    itemBuilder: (context, index) {
                      final steps = recipeData?['steps'] as List?;
                      return ListTile(
                        title:
                            Text('${index + 1}. ${steps?[index] ?? 'No step'}'),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  String _getDifficultyText(String? difficulty) {
    switch (difficulty) {
      case 'easy':
        return 'Easy';
      case 'medium':
        return 'Medium';
      case 'hard':
        return 'Hard';
      default:
        return 'Unknown';
    }
  }
}
