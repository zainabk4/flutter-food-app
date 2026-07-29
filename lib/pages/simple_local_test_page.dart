import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SimpleLocalTestPage extends StatelessWidget {
  final SimpleController controller = Get.put(SimpleController());

  SimpleLocalTestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Local Test'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Simple buttons
            ElevatedButton(
              onPressed: () => controller.addSimpleData(),
              child: const Text('Add Simple Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => controller.loadSimpleData(),
              child: const Text('Load Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () => controller.clearData(),
              child: const Text('Clear Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // Loading indicator
            Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : const SizedBox.shrink()),

            const SizedBox(height: 20),

            // Simple list
            Expanded(
              child: Obx(() {
                if (controller.items.isEmpty) {
                  return const Center(
                    child: Text('No items loaded'),
                  );
                }

                return ListView.builder(
                  itemCount: controller.items.length,
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    return Card(
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getIconForCategory(item['category'] ?? ''),
                            color: Colors.grey[600],
                          ),
                        ),
                        title: Text(item['name'] ?? 'Unknown'),
                        subtitle: Text(item['category'] ?? 'No category'),
                        trailing: Text('\$${item['price'] ?? 0}'),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'pakistani':
        return Icons.rice_bowl;
      case 'italian':
        return Icons.local_pizza;
      case 'fast food':
        return Icons.fastfood;
      default:
        return Icons.restaurant;
    }
  }
}

class SimpleController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;

  // Add simple data without images
  Future<void> addSimpleData() async {
    try {
      isLoading.value = true;

      // Simple data without complex images
      List<Map<String, dynamic>> simpleItems = [
        {
          'name': 'Chicken Biryani',
          'price': 15.99,
          'category': 'Pakistani',
          'isPopular': true,
        },
        {
          'name': 'Margherita Pizza',
          'price': 12.99,
          'category': 'Italian',
          'isPopular': true,
        },
        {
          'name': 'Beef Burger',
          'price': 9.99,
          'category': 'Fast Food',
          'isPopular': true,
        },
        {
          'name': 'Chicken Karahi',
          'price': 13.99,
          'category': 'Pakistani',
          'isPopular': true,
        },
      ];

      print('🚀 Adding ${simpleItems.length} simple items...');

      // Clear existing data first
      // await clearData();

      // Add each item
      for (int i = 0; i < simpleItems.length; i++) {
        var item = simpleItems[i];
        print('📤 Adding: ${item['name']}');

        DocumentReference docRef = await _firestore
            .collection('food_items')
            .add(item);

        print('✅ Added ${item['name']} with ID: ${docRef.id}');
      }

      print('🎉 All items added successfully!');

      Get.snackbar(
        'Success',
        'Added ${simpleItems.length} items!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Auto load after adding
      await loadSimpleData();

    } catch (e) {
      print('❌ Error adding data: $e');
      Get.snackbar(
        'Error',
        'Failed to add data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load simple data
  Future<void> loadSimpleData() async {
    try {
      isLoading.value = true;

      print('📥 Loading data...');

      QuerySnapshot querySnapshot = await _firestore
          .collection('food_items')
          .where('isPopular', isEqualTo: true)
          .get();

      print('📊 Found ${querySnapshot.docs.length} documents');

      items.clear();

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        items.add(data);
        print('📄 Loaded: ${data['name']}');
      }

      print('🎯 Final count: ${items.length} items');

      Get.snackbar(
        'Success',
        'Loaded ${items.length} items!',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );

    } catch (e) {
      print('❌ Error loading data: $e');
      Get.snackbar(
        'Error',
        'Failed to load data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Clear all data
  Future<void> clearData() async {
    try {
      print('🧹 Clearing data...');

      QuerySnapshot querySnapshot = await _firestore
          .collection('food_items')
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      items.clear();
      print('✅ Data cleared');

    } catch (e) {
      print('❌ Error clearing data: $e');
    }
  }
}