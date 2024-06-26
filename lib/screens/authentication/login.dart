import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodie/services/auth_service.dart';
import 'package:foodie/screens/home_screen.dart';
import 'package:foodie/screens/authentication/registration.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage = '';
  bool login = true;
  bool isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void navigateToRegister() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await AuthService().signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 120, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Poppins',
                    color: Color(0xffdb7706),
                  ),
                ),
                const SizedBox(height: 64.0),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    labelStyle: TextStyle(color: Color(0xffdb7706)),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Color(0xffdb7706)),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffBFBFBF), width: 2.0),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffdb7706),
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                    onPressed: signInWithEmailAndPassword,
                    child: isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                if (errorMessage != null && errorMessage!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                TextButton(
                  onPressed: navigateToRegister,
                  child: const Text(
                      'You don' 't have and account? Registration',
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
