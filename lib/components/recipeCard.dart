import 'package:flutter/material.dart';
import 'package:foodie/app_styles.dart';

class RecipeCard extends StatelessWidget {
  final Map recipe;
  final VoidCallback onTap;

  const RecipeCard({required this.recipe, required this.onTap, Key? key})
      : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          height: 250.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Stack(
              children: [
                Image.network(
                  recipe['image_url'] ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 32,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16.0,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        '${recipe['timeOfMaking'] ?? 0} min',
                        style: AppStyles.paragraph3
                            .copyWith(color: AppStyles.white),
                      ),
                      SizedBox(width: 16.0),
                      Icon(
                        Icons.star,
                        size: 16.0,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4.0),
                      Text(_getDifficultyText(recipe['difficulty']),
                          style: AppStyles.paragraph3
                              .copyWith(color: AppStyles.white)),
                    ],
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 70,
                  child: Text(recipe['name'] ?? 'No Name',
                      style:
                          AppStyles.heading2.copyWith(color: AppStyles.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
