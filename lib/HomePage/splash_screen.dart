import 'package:flutter/material.dart';
import 'package:food_app/pages/bottom_nav_bar.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F4E6),
      body: Center(
        child: Lottie.asset(
          'assets/animations/splash_animation.json',
          onLoaded: (composition) {
            Future.delayed(
              composition.duration + Duration(seconds: 1), // animation + 1 extra second
                  () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavBar()),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
