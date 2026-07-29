import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/assets_upload_controller.dart';

class AssetsUploadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AssetsUploadController controller = Get.put(AssetsUploadController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Assets to Firebase'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Upload progress indicator
            Obx(() {
              if (controller.isUploading) {
                return Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Uploading to Firebase...',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: controller.uploadProgress,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                          minHeight: 8,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${(controller.uploadProgress * 100).toInt()}% Complete',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        if (controller.currentItem.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Currently uploading: ${controller.currentItem}',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            const SizedBox(height: 20),

            const Text(
              'Food Delivery App Setup',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Upload your food images and data from assets to Firebase',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Food items preview
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.foodItems.length,
                itemBuilder: (context, index) {
                  final item = controller.foodItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item['assetPath'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.fastfood, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['description'], maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text(
                            '\$${item['price']} • ${item['category']}',
                            style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text('${item['rating']}'),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ),

            const SizedBox(height: 20),

            // Upload buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: controller.isUploading ? null : () => controller.uploadRestaurants(),
                    icon: const Icon(Icons.store),
                    label: const Text('Upload Restaurants'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: controller.isUploading ? null : () => controller.uploadAllFoodItems(),
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Upload All Foods'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Info text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Before uploading:',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. Make sure your asset paths are correct\n'
                        '2. Check pubspec.yaml for declared assets\n'
                        '3. Ensure Firebase is properly configured\n'
                        '4. Upload will take a few minutes',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
