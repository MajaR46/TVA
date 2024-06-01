import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

void saveRecipe(BuildContext context, String recipeId) {
  String? userID = FirebaseAuth.instance.currentUser?.uid;
  if (userID != null) {
    try {
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userID)
          .child('savedRecipes')
          .child(recipeId);
      userRef.set(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recipe saved successfully!')),
      );
    } catch (e) {
      print('Error saving recipe: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving recipe')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User not authenticated')),
    );
  }
}

Future<List<String>> getSavedRecipes() async {
  List<String> savedRecipes = [];

  String? userID = FirebaseAuth.instance.currentUser?.uid;
  if (userID != null) {
    try {
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(userID)
          .child('savedRecipes');

      DataSnapshot snapshot = await userRef.get();

      if (snapshot.value != null) {
        Map<dynamic, dynamic>? recipesMap =
            snapshot.value as Map<dynamic, dynamic>?;
        if (recipesMap != null) {
          savedRecipes = recipesMap.keys.cast<String>().toList();
        }
      }
    } catch (e) {
      print('Error fetching saved recipes: $e');
    }
  }

  return savedRecipes;
}
