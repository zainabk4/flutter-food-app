import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/pages/sign_in_page.dart';
import 'package:food_app/pages/profile_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isPasswordVisible = false;
  bool isLoading = false;
  bool isGoogleLoading = false;
  bool isFacebookLoading = false;

  // ---------------- Email Signup ----------------
  Future<void> _signUp() async {
    // Validate inputs
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Color(0xFFF67280), // Coral pink
        ),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;

      if (user != null) {
        // Update display name
        await user.updateDisplayName(nameController.text.trim());

        // Store user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'address': '',
          'createdAt': FieldValue.serverTimestamp(),
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred";
      switch (e.code) {
        case 'weak-password':
          errorMessage = "The password provided is too weak";
          break;
        case 'email-already-in-use':
          errorMessage = "An account already exists for this email";
          break;
        case 'invalid-email':
          errorMessage = "Please enter a valid email address";
          break;
        default:
          errorMessage = e.message ?? "An error occurred";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: const Color(0xFFF67280), // Coral pink
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: const Color(0xFFF67280), // Coral pink
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ---------------- Google Sign-In ----------------
  Future<void> _signInWithGoogle() async {
    try {
      setState(() => isGoogleLoading = true);

      // Sign out first to ensure account selection
      await GoogleSignIn().signOut();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => isGoogleLoading = false);
        return; // User canceled
      }

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null) {
        // Check if this is a new user or existing user
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        // Store/update user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'phone': user.phoneNumber ?? '',
          'address': userDoc.exists ? userDoc.get('address') ?? '' : '',
          'profilePicture': user.photoURL ?? '',
          'createdAt': userDoc.exists ? userDoc.get('createdAt') : FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Google Sign-In successful!"),
            backgroundColor: Color(0xFF6A4C93), // Deep purple
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Google Sign-In error: ${e.toString()}"),
          backgroundColor: const Color(0xFFF67280), // Coral pink
        ),
      );
    } finally {
      setState(() => isGoogleLoading = false);
    }
  }

  // ---------------- Facebook Sign-In ----------------
  Future<void> _signInWithFacebook() async {
    try {
      setState(() => isFacebookLoading = true);

      // Sign out first to ensure fresh login
      await FacebookAuth.instance.logOut();

      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken!.tokenString);

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        User? user = userCredential.user;

        if (user != null) {
          // Get Facebook user data
          final userData = await FacebookAuth.instance.getUserData();

          // Check if this is a new user or existing user
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'name': userData['name'] ?? user.displayName ?? '',
            'email': userData['email'] ?? user.email ?? '',
            'phone': user.phoneNumber ?? '',
            'address': userDoc.exists ? userDoc.get('address') ?? '' : '',
            'profilePicture': userData['picture']?['data']?['url'] ?? user.photoURL ?? '',
            'createdAt': userDoc.exists ? userDoc.get('createdAt') : FieldValue.serverTimestamp(),
            'lastLogin': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Facebook Sign-In successful!"),
              backgroundColor: Color(0xFF6A4C93), // Deep purple
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        }
      } else if (result.status == LoginStatus.cancelled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Facebook Sign-In was cancelled"),
            backgroundColor: Color(0xFFC06C84), // Rose pink
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Facebook Sign-In failed: ${result.message}"),
            backgroundColor: const Color(0xFFF67280), // Coral pink
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Facebook error: ${e.toString()}"),
          backgroundColor: const Color(0xFFF67280), // Coral pink
        ),
      );
    } finally {
      setState(() => isFacebookLoading = false);
    }
  }

  // ---------------- Instagram Sign-In (Alternative approach) ----------------
  Future<void> _signInWithInstagram() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF8F4E6), // Warm cream
          title: const Text(
            "Instagram Sign-In",
            style: TextStyle(
              color: Color(0xFF1A1A2E), // Dark navy
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            "Instagram sign-in requires additional setup with Instagram Basic Display API. "
                "Would you like to continue with Google or Facebook instead?",
            style: TextStyle(color: Color(0xFF1A1A2E)), // Dark navy
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Color(0xFFC06C84)), // Rose pink
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _signInWithGoogle();
              },
              child: const Text(
                "Use Google",
                style: TextStyle(color: Color(0xFF6A4C93)), // Deep purple
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _signInWithFacebook();
              },
              child: const Text(
                "Use Facebook",
                style: TextStyle(color: Color(0xFF6A4C93)), // Deep purple
              ),
            ),
          ],
        );
      },
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F4E6), // Warm cream background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60),

                // Logo
                Center(
                  child: Container(
                    width: 160,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6A4C93).withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.restaurant,
                            size: 60,
                            color: Color(0xFF6A4C93), // Deep purple
                          );
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                _buildInputField(nameController, 'Name', Icons.person_outline,
                    TextInputType.name),
                const SizedBox(height: 20),

                _buildInputField(emailController, 'Email',
                    Icons.email_outlined, TextInputType.emailAddress),
                const SizedBox(height: 20),

                // Password field
                Container(
                  height: 56,
                  decoration: _inputDecoration(),
                  child: TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    style: const TextStyle(color: Color(0xFF1A1A2E)), // Dark navy text
                    decoration: InputDecoration(
                      hintText: 'Password (min 6 characters)',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: Color(0xFF6A4C93)), // Deep purple
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF6A4C93), // Deep purple
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                _buildInputField(phoneController, 'Phone', Icons.phone_outlined,
                    TextInputType.phone),

                const SizedBox(height: 20),

                // Sign up button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A4C93), // Deep purple
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 3,
                      shadowColor: const Color(0xFF6A4C93).withOpacity(0.3),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()),
                    );
                  },
                  child: const Text(
                    "Already have an account? Sign In",
                    style: TextStyle(
                      color: Color(0xFF6A4C93), // Deep purple
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Or sign up using',
                  style: TextStyle(
                    color: Color(0xFF6A4C93), // Deep purple
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton(
                      'assets/images/google.jpg',
                      _signInWithGoogle,
                      isGoogleLoading,
                      'Google',
                    ),
                    const SizedBox(width: 20),
                    _socialButton(
                      'assets/images/ig.jpeg',
                      _signInWithInstagram,
                      false,
                      'Instagram',
                    ),
                    const SizedBox(width: 20),
                    _socialButton(
                      'assets/images/fb.jpeg',
                      _signInWithFacebook,
                      isFacebookLoading,
                      'Facebook',
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper UI widgets
  Widget _buildInputField(TextEditingController controller, String hintText,
      IconData icon, TextInputType type) {
    return Container(
      height: 56,
      decoration: _inputDecoration(),
      child: TextField(
        controller: controller,
        keyboardType: type,
        style: const TextStyle(color: Color(0xFF1A1A2E)), // Dark navy text
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(icon, color: const Color(0xFF6A4C93)), // Deep purple
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  BoxDecoration _inputDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFC06C84).withOpacity(0.3)), // Rose pink border
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF6A4C93).withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _socialButton(String assetPath, VoidCallback onTap, bool isLoading, String platform) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6A4C93).withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFC06C84).withOpacity(0.3), // Rose pink border
            width: 1,
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xFF6A4C93), // Deep purple
        )
            : ClipOval(
          child: Image.asset(
            assetPath,
            fit: BoxFit.cover,
            width: 35,
            height: 35,
            errorBuilder: (context, error, stackTrace) {
              // Fallback icons if images don't load
              IconData fallbackIcon;
              Color iconColor;
              switch (platform) {
                case 'Google':
                  fallbackIcon = Icons.g_mobiledata;
                  iconColor = const Color(0xFFF67280); // Coral pink
                  break;
                case 'Facebook':
                  fallbackIcon = Icons.facebook;
                  iconColor = const Color(0xFF6A4C93); // Deep purple
                  break;
                case 'Instagram':
                  fallbackIcon = Icons.camera_alt;
                  iconColor = const Color(0xFFC06C84); // Rose pink
                  break;
                default:
                  fallbackIcon = Icons.login;
                  iconColor = const Color(0xFF6A4C93); // Deep purple
              }
              return Icon(fallbackIcon, color: iconColor, size: 30);
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    nameController.dispose();
    super.dispose();
  }
}