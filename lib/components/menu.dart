import 'package:flutter/material.dart';
import 'package:foodie/screens/search_screen.dart';
import 'package:foodie/screens/user_profile_screen.dart';
import '/screens/home_screen.dart';
import 'package:foodie/screens/recipes/categories_screen.dart';
import '../screens/recipes/recipes_screen.dart';

class MenuComponent extends StatefulWidget {
  @override
  _MenuComponentState createState() => _MenuComponentState();
}

int _activeIndex = 0;

class _MenuComponentState extends State<MenuComponent> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMenuItem(Icons.home, 'Home', 0, () {
            _updateActiveIndex(0);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }),
          _buildMenuItem(Icons.category, 'Categories', 1, () {
            _updateActiveIndex(1);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => CategoriesPage()));
          }),
          _buildMenuItem(Icons.search, 'Search', 2, () {
            _updateActiveIndex(2);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          }),
          _buildMenuItem(Icons.person, 'Profile', 3, () {
            _updateActiveIndex(3);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const UserProfileScreen()),
            );
          }),
        ],
      ),
    );
  }

  void _updateActiveIndex(int index) {
    setState(() {
      _activeIndex = index;
    });
  }

  Widget _buildMenuItem(
      IconData icon, String text, int index, Function() onPressed) {
    return InkWell(
      onTap: () {
        _updateActiveIndex(index); // Update active index before navigation
        onPressed(); // Perform navigation
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,
              color: _activeIndex == index
                  ? const Color(0xff80A1D4)
                  : const Color(0xffBFBFBF)),
          const SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(
                color: _activeIndex == index
                    ? const Color(0xff80A1D4)
                    : const Color(0xffBFBFBF)),
          ),
        ],
      ),
    );
  }
}
