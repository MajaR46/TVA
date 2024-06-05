import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:foodie/app_styles.dart';
import 'package:foodie/services/user_service.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final String recipeId;

  const RecipeDetailsScreen({required this.recipeId});

  @override
  _RecipeDetailsScreenState createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  int servings = 1;

  void increaseServings() {
    setState(() {
      servings++;
    });
  }

  void decreaseServings() {
    setState(() {
      if (servings > 1) {
        servings--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recipe Details'),
            IconButton(
              onPressed: () {
                saveRecipe(context, widget.recipeId);
              },
              icon: Icon(Icons.save_outlined),
            ),
          ],
        ),
      ),
      body: FutureBuilder<DataSnapshot>(
        future: FirebaseDatabase.instance
            .ref()
            .child('Recipes')
            .child(widget.recipeId)
            .once()
            .then((snapshot) => snapshot.snapshot),
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

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: RecipeDetailsContent(
                recipeData: recipeData,
                servings: servings,
                onIncreaseServings: increaseServings,
                onDecreaseServings: decreaseServings,
              ),
            );
          }
        },
      ),
    );
  }
}

class RecipeDetailsContent extends StatelessWidget {
  final Map<dynamic, dynamic>? recipeData;
  final int servings;
  final VoidCallback onIncreaseServings;
  final VoidCallback onDecreaseServings;

  const RecipeDetailsContent({
    Key? key,
    required this.recipeData,
    required this.servings,
    required this.onIncreaseServings,
    required this.onDecreaseServings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
          RecipeInfo(recipeData: recipeData),
          SizedBox(height: 16.0),
          RecipeNutrition(recipeData: recipeData),
          SizedBox(height: 16.0),
          RecipeIngredients(
            recipeData: recipeData,
            servings: servings,
            onIncreaseServings: onIncreaseServings,
            onDecreaseServings: onDecreaseServings,
          ),
          SizedBox(height: 16.0),
          RecipeSteps(recipeData: recipeData),
        ],
      ),
    );
  }
}

class RecipeInfo extends StatelessWidget {
  final Map<dynamic, dynamic>? recipeData;
  const RecipeInfo({Key? key, required this.recipeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            recipeData?['name'] ?? 'No Name',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Title color
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.access_time, color: AppStyles.silver), // Icon color
            SizedBox(width: 4.0),
            Text(
              '${recipeData?['timeOfMaking']} min',
              style: TextStyle(
                  fontSize: 16.0, color: AppStyles.silver), // Text color
            ),
            SizedBox(width: 16.0),
            Icon(Icons.fastfood_outlined,
                color: AppStyles.silver), // Fire icon color
            SizedBox(width: 4.0),
            Text(
              'Kcal: ${recipeData?['kcal'] ?? 'N/A'}',
              style: TextStyle(
                  fontSize: 16.0, color: AppStyles.silver), // Text color
            ),
            SizedBox(width: 16.0),
            Icon(Icons.star_border, color: AppStyles.silver), // Icon color
            SizedBox(width: 4.0),
            Text(
              _getDifficultyText(recipeData?['difficulty']),
              style: TextStyle(
                  fontSize: 16.0, color: AppStyles.silver), // Text color
            ),
          ],
        ),
      ],
    );
  }
}

class RecipeNutrition extends StatelessWidget {
  final Map<dynamic, dynamic>? recipeData;

  const RecipeNutrition({Key? key, required this.recipeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: _buildNutritionBox(Icons.energy_savings_leaf_outlined,
                  '${recipeData?['protein'] ?? 'N/A'} g'),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: _buildNutritionBox(Icons.local_pizza_outlined,
                  '${recipeData?['carbohydrates'] ?? 'N/A'} g'),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: _buildNutritionBox(
                  Icons.kitchen_outlined, '${recipeData?['fats'] ?? 'N/A'} g'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNutritionBox(IconData icon, String value) {
    return Container(
      decoration: BoxDecoration(
        color: AppStyles.antiFlashWhite,
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.symmetric(
          vertical: 22.0, horizontal: 16.0), // Adjusted padding
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppStyles.ochre, size: 30.0),
          SizedBox(width: 8.0), // Increased width
          Text(value, style: TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}

class RecipeIngredients extends StatelessWidget {
  final Map<dynamic, dynamic>? recipeData;
  final int servings;
  final VoidCallback onIncreaseServings;
  final VoidCallback onDecreaseServings;

  const RecipeIngredients({
    Key? key,
    required this.recipeData,
    required this.servings,
    required this.onIncreaseServings,
    required this.onDecreaseServings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ingredients:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: onDecreaseServings,
                  icon: Icon(Icons.remove),
                ),
                Text(
                  '$servings',
                  style: TextStyle(fontSize: 18.0),
                ),
                IconButton(
                  onPressed: onIncreaseServings,
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8.0),
        ListView.builder(
          shrinkWrap: true,
          itemCount:
              (recipeData?['ingredients'] as List<dynamic>?)?.length ?? 0,
          itemBuilder: (context, index) {
            final ingredients = recipeData?['ingredients'] as List?;
            String name = ingredients?[index]['name'] ?? '';
            String amount = ingredients?[index]['amount'] ?? '';
            String updatedAmount = _scaleAmount(amount, servings);

            return ListTile(
              title: Text(
                name,
                style: AppStyles.paragraph1.copyWith(color: AppStyles.black),
              ),
              trailing: Text(
                updatedAmount,
                style: AppStyles.paragraph1.copyWith(color: AppStyles.gray),
              ),
            );
          },
        ),
      ],
    );
  }

  String _scaleAmount(String amount, int servings) {
    RegExp regExp = RegExp(r'\d+');
    Iterable<Match> matches = regExp.allMatches(amount);

    if (matches.isEmpty) {
      return amount;
    }

    String scaledAmount = amount;
    for (Match match in matches) {
      String matchText = match.group(0) ?? '';
      int originalAmount = int.parse(matchText);
      int newAmount = originalAmount * servings;
      scaledAmount = scaledAmount.replaceFirst(matchText, newAmount.toString());
    }

    return scaledAmount;
  }
}

class RecipeSteps extends StatelessWidget {
  final Map<dynamic, dynamic>? recipeData;

  const RecipeSteps({Key? key, required this.recipeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          itemCount: (recipeData?['steps'] as List<dynamic>?)?.length ?? 0,
          itemBuilder: (context, index) {
            final steps = recipeData?['steps'] as List?;
            final stepDescription = steps?[index].toString();

            return Container(
              margin: EdgeInsets.symmetric(vertical: 4.0),
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                title: Text(
                  '${index + 1}. $stepDescription',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
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
