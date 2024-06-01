import 'package:flutter/material.dart';
import 'package:foodie/components/categorySquare.dart';
import 'package:foodie/app_styles.dart';
import 'package:foodie/screens/home_screen.dart';

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 16.0),
              Center(
                child: Text(
                  'Categories',
                  style: AppStyles.heading1.copyWith(color: AppStyles.ochre),
                ),
              ),
              SizedBox(height: 38.0),
              Text('Meal', style: AppStyles.heading3),
              SizedBox(height: 10.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    CategorySquare(label: 'Breakfast', categoryType: 'Meal'),
                    CategorySquare(label: 'Lunch', categoryType: 'Meal'),
                    CategorySquare(label: 'Dinner', categoryType: 'Meal'),
                    CategorySquare(label: 'Dessert', categoryType: 'Meal'),
                    CategorySquare(label: 'Snack', categoryType: 'Meal'),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Taste',
                style: AppStyles.heading3,
              ),
              SizedBox(height: 10.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    CategorySquare(label: 'Sweet', categoryType: 'Taste'),
                    CategorySquare(label: 'Salty', categoryType: 'Taste'),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Text('Difficulty', style: AppStyles.heading3),
              SizedBox(height: 10.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    CategorySquare(label: 'Easy', categoryType: 'Difficulty'),
                    CategorySquare(label: 'Medium', categoryType: 'Difficulty'),
                    CategorySquare(label: 'Hard', categoryType: 'Difficulty'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
