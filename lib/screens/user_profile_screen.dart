import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:foodie/components/recipeCard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodie/screens/home_screen.dart';
import 'package:foodie/screens/recipes/my_recipes_screen.dart';
import 'package:foodie/screens/recipes/saved_recipes_screen.dart';
import 'package:foodie/services/user_service.dart';
import 'package:foodie/components/menu.dart';
import 'package:foodie/app_styles.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: Stack(
        children: [
          const Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Icon(
                Icons.account_circle_rounded,
                size: 200,
                color: AppStyles.antiFlashWhite,
              ),
            ),
          ),
          Positioned(
            top: 260,
            left: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MyRecipesScreen()),
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: ShapeDecoration(
                      color: AppStyles.antiqueWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    child: const Text('My Recipes',
                        textAlign: TextAlign.center, style: AppStyles.heading4),
                  ),
                  Positioned(
                    right: 16,
                    child: Container(
                      width: 24,
                      height: 24,
                      child: const Icon(
                        Icons.arrow_forward,
                        size: 24,
                        color: Color(0xFF404040),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 340,
            left: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SavedRecipesScreen()),
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: ShapeDecoration(
                      color: AppStyles.antiFlashWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    child: const Text(
                      'Saved Recipes',
                      textAlign: TextAlign.center,
                      style: AppStyles.heading4,
                    ),
                  ),
                  Positioned(
                    right: 16,
                    child: Container(
                      width: 24,
                      height: 24,
                      child: const Icon(
                        Icons.arrow_forward,
                        size: 24,
                        color: Color(0xFF404040),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MenuComponent(),
    );
  }
}
