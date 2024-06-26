import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodie/services/auth_service.dart';
import 'package:foodie/screens/home_screen.dart';
import 'package:foodie/screens/authentication/login.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? errorMessage = '';
  bool isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> registerWithEmailAndPassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        errorMessage = "Passwords do not match";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      await AuthService().createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } finally {
      setState(() {
        isLoading = false;
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
                  'Registration',
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
                TextField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Repeat password',
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
                    onPressed: registerWithEmailAndPassword,
                    child: isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            'Register',
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
                  onPressed: navigateToLogin,
                  child: const Text('Already have an account? Login',
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
