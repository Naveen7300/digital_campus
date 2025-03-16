import 'package:flutter/material.dart';
import 'navigation_service.dart';
import 'main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isKeyboardVisible = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    NavigationService.setCurrentRoute('/LoginPage');
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      _isKeyboardVisible = bottomInset > 0;
    });
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred during login.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is badly formatted.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      print(e);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xff49117e),
      body: SafeArea(
        child: Stack(
          children: [
            // Logo
            Positioned(
              top: screenHeight * 0.15, // Adjust top positioning
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: screenWidth * 0.25, // Adjust width
                  height: screenWidth * 0.25, // Adjust height (square)
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'LOGO',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),

            // Login Form
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              bottom: _isKeyboardVisible ? 20 : screenHeight * 0.2, // Adjust bottom positioning
              left: 30,
              right: 30,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff49117e),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'EMAIL',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onChanged: (value) => _email = value,
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'PASSWORD',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        onChanged: (value) => _password = value,
                      ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _signInWithEmailAndPassword();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff49117e),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                          child: Text(
                            'LOGIN',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: _isKeyboardVisible ? 30 : 70),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}