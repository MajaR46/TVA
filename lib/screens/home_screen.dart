import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

//firebase baza
FirebaseDatabase database = FirebaseDatabase.instance;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home screen'),
      ),
      body: const Center(
        child: Text('Home screen'),
      ),
    );
  }
}
