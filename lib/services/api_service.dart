import 'package:dio/dio.dart';
import 'package:foodie/models/nutrition.dart';

Future<Nutrition> fetchNutrition(String meal) async {
  const String apiKey = '4rnxolmK38cgKdaEZoGDti15qBMTMZv1Sm0qo2qY';

  try {
    final response = await Dio().get(
      'https://api.api-ninjas.com/v1/nutrition?query=$meal',
      options: Options(
        headers: {'X-Api-Key': apiKey},
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      if (data.isNotEmpty) {
        return Nutrition.fromJson(data[0]);
      } else {
        throw Exception('No nutrition data found for $meal');
      }
    } else {
      throw Exception('Failed to load nutrition data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching nutrition data: $e');
  }
}
