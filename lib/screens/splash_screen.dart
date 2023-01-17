import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mafi_menu/screens/menu_catagory_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return MenuCatagoryScreen();
        },
      ), );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(118, 255, 172, 7),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(
                  "images/logo.png"),
            ),
          ),
        ),
      ),
    );
  }
}
