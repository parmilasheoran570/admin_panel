
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CategoryDropDownController extends GetxController {
  RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;

  RxString? selectedCategoryId;
  RxString? selectedCategoryName;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('categories').get();

      List<Map<String, dynamic>> categoriesList = [];

      querySnapshot.docs
          .forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        categoriesList.add({
          'categoryId': document.id,
          'categoryName': document['categoryName'],
          'categoryImg': document['categoryImg'],
        });
      });

      categories.value = categoriesList;
      if (kDebugMode) {
        print(categories);
      }
      update();
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching categories: $e");
      }
    }
  }
  void setSelectedCategory(String? categoryId) {
    selectedCategoryId = categoryId?.obs;
    if (kDebugMode) {
      print('selectedCategoryId $selectedCategoryId');
    }
    update();
  }
  Future<String?> getCategoryName(String? categoryId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('categories')
          .doc(categoryId)
          .get();
      if (snapshot.exists) {
        return snapshot.data()?['categoryName'];
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching category name: $e");
      }
      return null;
    }
  }

  // set categoryName
  void setSelectedCategoryName(String? categoryName) {
    selectedCategoryName = categoryName?.obs;
    if (kDebugMode) {
      print('selectedCategoryName $selectedCategoryName');
    }
    update();
  }
}


