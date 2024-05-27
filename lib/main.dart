import 'package:flutter/material.dart';
import 'package:foodie/models/recipe.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodie/screens/splash_screen.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Hive.initFlutter();
    Hive.registerAdapter(RecipeAdapter());
    await Hive.openBox<Recipe>('recipes');
    runApp(const MyApp());
    Fluttertoast.showToast(msg: "Database connected");
  } catch (error) {
    print("error connection to the database: $error");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
