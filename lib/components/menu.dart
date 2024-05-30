import 'package:flutter/material.dart';
import '/screens/home_screen.dart';
import '../screens/recipes/recipes_screen.dart';

class MenuComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.blue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMenuItem(Icons.home, 'Home', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }),
          _buildMenuItem(Icons.category, 'Categories', () {
            // Navigate to categories page
          }),
          _buildMenuItem(Icons.search, 'Search', () {
            // Navigate to search page
          }),
          _buildMenuItem(Icons.person, 'Profile', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RecipesScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String text, Function() onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
