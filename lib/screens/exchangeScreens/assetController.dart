// lib/controllers/asset_controller.dart

// ignore_for_file: file_names

import 'package:get/get.dart';

import '../../auth/firestore/firestoreService.dart';

class AssetController extends GetxController {
  final FirestoreService firestoreService = FirestoreService();
  var assets = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAssets();
  }

  void fetchAssets() {
    firestoreService.getExcAssetsStream().listen((newAssets) {
      assets.value = newAssets;
    });
  }

  Future<void> addAsset(
      String assetName, double amount, String assetIconPath) async {
    try {
      await firestoreService.saveExcAsset(assetName, amount, assetIconPath);
      fetchAssets();
    } catch (e) {
      Get.snackbar('Error', 'Failed to add asset: $e',
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> deleteAsset(String assetName) async {
    try {
      await firestoreService.deleteAssetEx(assetName);
      assets.removeWhere((asset) => asset['assetName'] == assetName);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete asset: $e',
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> updateAsset(String oldAssetName, String newAssetName,
      double newAmount, String iconPath) async {
    try {
      await firestoreService.updateAssetEx(
          oldAssetName, newAssetName, newAmount, iconPath);
      fetchAssets(); // Refresh the assets list after updating
    } catch (e) {
      Get.snackbar('Error', 'Failed to update asset: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
