import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import '../Controller/assets_upload_controller.dart';
import '../Controller/popular_product_controller.dart';

Future<void> init() async {
  // Initialize Firebase
  await Firebase.initializeApp();

  // Register controllers
  Get.lazyPut(() => PopularProductController());
  Get.lazyPut(() => AssetsUploadController());
  print("Firebase initialized and dependencies loaded");
}

  // If you want to clear all dependencies (useful for logout, etc.)
  Future<void> clearDependencies() async {
    Get.reset();
    print("All dependencies cleared!");
}