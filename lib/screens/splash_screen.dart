import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app/screens/home_screen.dart';
import 'package:note_app/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () async {
      checkUser(context);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      body: Center(
        child: Image(
            image: AssetImage('assets/NoteAppNewLogo-removebg-preview.png')),
      ),
    );
  }
}

void checkUser(BuildContext context) {
  if (FirebaseAuth.instance.currentUser != null) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (c) => const HomeScreen()));
  } else {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (c) => const LoginScreen()));
  }
}
