import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/pages/sign_in_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  bool isLoading = true;
  bool isEditing = false;
  bool isUploadingImage = false;
  Map<String, dynamic> userData = {};
  String? profileImageUrl;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      setState(() => isLoading = true);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          userData = doc.data() as Map<String, dynamic>;
          nameController.text = userData['name'] ?? '';
          phoneController.text = userData['phone'] ?? '';
          emailController.text = userData['email'] ?? user.email ?? '';
          addressController.text = userData['address'] ?? '';
          profileImageUrl = userData['profileImageUrl'];
        } else {
          emailController.text = user.email ?? '';
          nameController.text = user.displayName ?? '';
          profileImageUrl = user.photoURL;
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _selectImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 70,
      );

      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting image: $e')),
      );
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      setState(() => isUploadingImage = true);

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final String fileName = 'profile_${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(fileName);

      final UploadTask uploadTask = storageRef.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null;
    } finally {
      setState(() => isUploadingImage = false);
    }
  }

  Future<void> _removeImage() async {
    setState(() {
      selectedImage = null;
      profileImageUrl = null;
    });
  }

  Future<void> _updateUserData() async {
    try {
      setState(() => isLoading = true);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? imageUrl = profileImageUrl;

        // Upload new image if selected
        if (selectedImage != null) {
          imageUrl = await _uploadImage(selectedImage!);
          if (imageUrl != null) {
            setState(() {
              profileImageUrl = imageUrl;
              selectedImage = null;
            });
          }
        }

        // Update Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
          'email': emailController.text.trim(),
          'address': addressController.text.trim(),
          'profileImageUrl': imageUrl,
        }, SetOptions(merge: true));

        // Update Firebase Auth profile
        if (nameController.text.trim() != user.displayName) {
          await user.updateDisplayName(nameController.text.trim());
        }

        if (imageUrl != user.photoURL) {
          await user.updatePhotoURL(imageUrl);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Color(0xFF6A4C93), // Royal Plum primary
          ),
        );

        setState(() => isEditing = false);
        await _fetchUserData();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SignInPage()),
            (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFF8F4E6), // Royal Plum background
          title: Text('Logout', style: TextStyle(color: Color(0xFF1A1A2E))),
          content: Text('Are you sure you want to logout?', style: TextStyle(color: Color(0xFF1A1A2E))),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Color(0xFF1A1A2E).withOpacity(0.7))),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout();
              },
              style: TextButton.styleFrom(foregroundColor: Color(0xFFC06C84)), // Royal Plum secondary
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFFF8F4E6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Color(0xFF6A4C93).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Profile Photo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildImageOption(
                    icon: Icons.photo_library,
                    label: 'Select Photo',
                    onTap: () {
                      Navigator.pop(context);
                      _selectImage();
                    },
                  ),
                  if (profileImageUrl != null || selectedImage != null)
                    _buildImageOption(
                      icon: Icons.delete,
                      label: 'Remove Photo',
                      onTap: () {
                        Navigator.pop(context);
                        _removeImage();
                      },
                    ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFF6A4C93).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Color(0xFF6A4C93),
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF1A1A2E),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0xFF6A4C93), // Royal Plum primary
              width: 3,
            ),
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFF6A4C93), // Royal Plum primary
            backgroundImage: selectedImage != null
                ? FileImage(selectedImage!)
                : (profileImageUrl != null && profileImageUrl!.isNotEmpty)
                ? NetworkImage(profileImageUrl!)
                : null,
            child: (selectedImage == null && (profileImageUrl == null || profileImageUrl!.isEmpty))
                ? Text(
              nameController.text.isNotEmpty
                  ? nameController.text[0].toUpperCase()
                  : 'U',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
                : null,
          ),
        ),
        if (isEditing)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _showImageOptions,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Color(0xFF6A4C93),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: isUploadingImage
                    ? Padding(
                  padding: const EdgeInsets.all(6),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFFF8F4E6), // Royal Plum background
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6A4C93), // Royal Plum primary
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFF8F4E6), // Royal Plum background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF1A1A2E), // Royal Plum text
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (isEditing) {
                _updateUserData();
              } else {
                setState(() => isEditing = true);
              }
            },
            icon: Icon(
              isEditing ? Icons.save : Icons.edit,
              color: Color(0xFF6A4C93), // Royal Plum primary
            ),
          ),
          if (isEditing)
            IconButton(
              onPressed: () {
                setState(() {
                  isEditing = false;
                  selectedImage = null; // Reset selected image on cancel
                });
                _fetchUserData();
              },
              icon: Icon(
                Icons.close,
                color: Color(0xFFC06C84), // Royal Plum secondary
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              _buildProfileAvatar(),

              const SizedBox(height: 8),

              Text(
                nameController.text.isNotEmpty ? nameController.text : 'User',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E), // Royal Plum text
                ),
              ),

              Text(
                emailController.text,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1A1A2E).withOpacity(0.7), // Royal Plum text
                ),
              ),

              const SizedBox(height: 40),

              _buildProfileField(
                controller: nameController,
                icon: Icons.person,
                label: 'Full Name',
                hint: 'Enter your full name',
              ),

              const SizedBox(height: 20),

              _buildProfileField(
                controller: phoneController,
                icon: Icons.phone,
                label: 'Phone Number',
                hint: 'Enter your phone number',
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 20),

              _buildProfileField(
                controller: emailController,
                icon: Icons.email,
                label: 'Email Address',
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              _buildProfileField(
                controller: addressController,
                icon: Icons.location_on,
                label: 'Address',
                hint: 'Enter your address',
                maxLines: 2,
              ),

              const SizedBox(height: 40),

              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _showLogoutDialog,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC06C84), // Royal Plum secondary
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6A4C93).withOpacity(0.1), // Royal Plum shadow
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 12, right: 16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Color(0xFF6A4C93), // Royal Plum primary
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6A4C93), // Royal Plum primary
                  ),
                ),
              ],
            ),
          ),
          TextField(
            controller: controller,
            enabled: isEditing,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(
              fontSize: 16,
              color: isEditing ? Color(0xFF1A1A2E) : Color(0xFF1A1A2E).withOpacity(0.7), // Royal Plum text
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Color(0xFF1A1A2E).withOpacity(0.4), // Royal Plum hint
                fontWeight: FontWeight.w400,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }
}