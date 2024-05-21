import 'package:flutter/material.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Image.asset(
          'assets/images/boarding1.png',
          fit: BoxFit.contain,
          width: 300,
        ),
        const Text("Shranjujte",
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins')),
        const Text(
          "Shranite in organizirajte svoje najljubše recepte na enem mestu",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
        )
      ],
    )));
  }
}
