import 'package:flutter/material.dart';
import 'navigation_service.dart';
import 'main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _mobileNumber = '';
  String _otp = '';
  bool _isKeyboardVisible = false;
  bool isStudent = true;
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
      backgroundColor: const Color(0xff026A75),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: _isKeyboardVisible? screenHeight*0.07 : screenHeight * 0.2,
              left: 0, right: 0, bottom: 0,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Color(0xFFEBEFEE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(43),
                      topRight: Radius.circular(43),
                    ),
                  ),
                ),
              )
            ), //the background rounded bex container
            Positioned(
              left: 0,
              right: 0,
              bottom: _isKeyboardVisible? screenHeight * 0.38 : screenHeight * 0.6,
              child: SizedBox(
                child: Text(
                  "LOGIN",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 75,
                    fontFamily: "Source Serif Pro",
                    fontWeight: FontWeight.w600,
                    color: Color(0xff026A75),
                  ),
                ),
              ),
            ), //LOGIN Text
            Positioned(
              left: 0,
              right: 0,
              bottom: _isKeyboardVisible? screenHeight * 0.33 : screenHeight * 0.53,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RadioListTile(
                        value: true,
                        groupValue: isStudent,
                        onChanged: (value) => setState(() => isStudent = true),
                        title: Text(
                            'Student',
                            style: TextStyle(
                                fontSize: screenWidth * 0.07,
                                color: Color(0xff026A75)
                            )
                        ),
                        contentPadding: EdgeInsets.only(
                          left: screenWidth * 0.05,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        value: false,
                        groupValue: isStudent,
                        onChanged: (value) => setState(() => isStudent = false),
                        title: Text(
                            'Parent',
                            style: TextStyle(
                                fontSize: screenWidth * 0.07,
                                color: Color(0xff026A75)
                            )
                        ),
                        contentPadding: EdgeInsets.only(
                          right: screenWidth * 0.05,
                        ), // Removes default padding
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
              )
            ), //Radio buttons for student and parent
            Positioned(
              bottom: _isKeyboardVisible ? 20 : screenHeight * 0.2,
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
                      if (isStudent)
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
                      if (isStudent)
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

                      if (!isStudent)
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'EMAIL / MOBILE NUMBER',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email/mobile number';
                            }
                            return null;
                          },
                          onChanged: (value) => _mobileNumber = value,
                        ),
                      if (!isStudent)
                        const SizedBox(height: 16.0),
                      if (!isStudent)
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'OTP',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => _otp = value,
                        ),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _signInWithEmailAndPassword();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff026A75),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                          child: Text(
                              'LOGIN',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFEBEFEE)
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ), // login form with button
          ],
        ),
      ),
    );
  }
}