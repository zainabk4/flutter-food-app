import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadSamplePage extends StatefulWidget {
  @override
  _UploadSamplePageState createState() => _UploadSamplePageState();
}

class _UploadSamplePageState extends State<UploadSamplePage> {
  bool isUploading = false;

  List<Map<String, dynamic>> foodItems = [
    {
      'name': 'Korean Side',
      'description': 'Delicious Korean cuisine',
      'assetPath': 'assets/images/food1.jpg',
    },
    {
      'name': 'Fruit Meal',
      'description': 'Nutritious fruit meal',
      'assetPath': 'assets/images/food10.jpg',
    },
    // 3 food
    {
      'name': 'Sweet Dessert',
      'description': 'Delightful sweet dessert to end your meal',
      'assetPath': 'assets/images/food6.jpg', // Update with your path
    },
    // 4 food
    {
      'name': 'Chicken Biryani',
      'description': 'Aromatic basmati rice with tender chicken pieces',
      'assetPath': 'assets/images/food12.jpg', // Update with your path
    },
    // 5 food
    {
      'name': 'Butter Chicken',
      'description': 'Creamy Butter Chicken with fresh naan',
      'assetPath': 'assets/images/food9.jpg', // Update with your path
    },
    // 6 food
    {
      'name': 'Fried Chicken & Rice',
      'description': 'Crispy fried chicken with boiled rice',
      'assetPath': 'assets/images/food7.jpg', // Update with your path
    },  
    // 7 food
    {
      'name': 'Pizza Margherita',
      'description': 'Classic Italian pizza with fresh mozzarella',
      'assetPath': 'assets/images/food8.jpg', // Update with your path
    },
    // 8 food
    {
      'name': 'Soup Dumplings',
      'description': 'Dumplings with chilli oil spinkled with sesame seeds',
      'assetPath': 'assets/images/food4.jpg', // Update with your path
    },
    // 9 food
    {
      'name': 'Spicy Ramen',
      'description': 'Delicious Spicy Ramen with fried egg',
      'assetPath': 'assets/images/food3.jpg', // Update with your path
    },
    // 10 food
    {
      'name': 'Masala Dosa',
      'description': 'Traditional Indian dish with spices',
      'assetPath': 'assets/images/food2.jpg', // Update with your path
    },
    // 11 food
    {
      'name': 'Alfredo Fettucine Pasta',
      'description': 'Creamy Alfredo Fettucine Pasta with chicken & parmesan cheese',
      'assetPath': 'assets/images/food11.jpg', // Update with your path
    },
  ];

  Future<void> uploadFoodItems() async {
    setState(() => isUploading = true);

    for (var item in foodItems) {
      try {
        ByteData byteData = await rootBundle.load(item['assetPath']);
        Uint8List imageData = byteData.buffer.asUint8List();

        String fileName = '${DateTime.now().millisecondsSinceEpoch}_${item['name']}.jpg';
        Reference ref = FirebaseStorage.instance.ref().child('food_images/$fileName');
        UploadTask uploadTask = ref.putData(imageData);

        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('food_items').add({
          'name': item['name'],
          'description': item['description'],
          'imageUrl': downloadUrl,
          'createdAt': FieldValue.serverTimestamp(),
        });

        print('✅ Uploaded ${item['name']}');
      } catch (e) {
        print('❌ Error uploading ${item['name']}: $e');
      }
    }

    setState(() => isUploading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload Complete')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Food Items')),
      body: Center(
        child: isUploading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: uploadFoodItems,
          child: Text('Upload Now'),
        ),
      ),
    );
  }
}
