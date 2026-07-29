import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/pages/profile_page.dart';
import 'package:food_app/pages/sign_in_page.dart';

class ProfileWrapper extends StatelessWidget {
  const ProfileWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF9294cc),
              ),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in → show profile page
          return const ProfilePage();
        } else {
          // No user → show sign-in page
          return const SignInPage();
        }
      },
    );
  }
}