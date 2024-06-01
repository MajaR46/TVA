import 'package:flutter/material.dart';
import 'package:foodie/app_styles.dart';
import 'package:foodie/screens/recipes/single_categorie_screen.dart';

class CategorySquare extends StatelessWidget {
  final String label;
  final String categoryType;

  const CategorySquare({
    required this.label,
    required this.categoryType,
    Key? key,
  }) : super(key: key);

  String _getImagePath() {
    switch (categoryType) {
      case 'Meal':
        if (label == 'Breakfast') return 'assets/images/breakfast.png';
        if (label == 'Lunch') return 'assets/images/lunch.jpeg';
        if (label == 'Dinner') return 'assets/images/dinner.jpg';
        if (label == 'Snack') return 'assets/images/snack.jpg';
        if (label == 'Dessert') return 'assets/images/dessert.jpg';
        break;
      case 'Taste':
        if (label == 'Sweet') return 'assets/images/sweet.jpg';
        if (label == 'Salty') return 'assets/images/salty.jpg';
        break;
      case 'Difficulty':
        if (label == 'Easy') return 'assets/images/easy.jpg';
        if (label == 'Medium') return 'assets/images/medium.jpg';
        if (label == 'Hard') return 'assets/images/hard.jpg';
        break;
    }
    return 'assets/images/Logo.png'; // Default image path if none match
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SingleCategoryScreen(
                    category: label,
                  )),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: 150.0,
        height: 150.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.dstATop,
                ),
                child: Image.asset(
                  _getImagePath(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppStyles.onyx,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
