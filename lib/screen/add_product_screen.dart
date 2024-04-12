import 'dart:io';
import 'package:admin_panel/controllers/add_products_images_controller.dart';
import 'package:admin_panel/controllers/category_dropdown_controller.dart';
import 'package:admin_panel/controllers/is_sale_controller.dart';
import 'package:admin_panel/models/product-model.dart';
import 'package:admin_panel/service/generate_ids_service.dart';
import 'package:admin_panel/utils/app-constant.dart';
import 'package:admin_panel/widgets/dropdown_categories_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  AddProductImagesController addProductImagesController =
      Get.put(AddProductImagesController());

  CategoryDropDownController categoryDropDownController =
      Get.put(CategoryDropDownController());

  IsSaleController isSaleController = Get.put(IsSaleController());

  TextEditingController productNameController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController fullPriceController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Products",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
        backgroundColor: AppConstant.appMainColor,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Images",
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      addProductImagesController.showImagesPickerDialog();
                    },
                    child: const Text(
                      "Select Images",
                    ),
                  )
                ],
              ),
            ),

            GetBuilder<AddProductImagesController>(
              init: AddProductImagesController(),
              builder: (imageController) {
                return imageController.selectedIamges.isNotEmpty
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width - 20,
                        height: Get.height / 3.0,
                        child: GridView.builder(
                          itemCount: imageController.selectedIamges.length,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 10,
                          ),

                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              children: [
                                Image.file(
                                  File(addProductImagesController
                                      .selectedIamges[index].path),
                                  fit: BoxFit.cover,
                                  height: Get.height / 4,
                                  width: Get.width / 2,
                                ),
                                Positioned(
                                  right: 10,
                                  top: 0,
                                  child: InkWell(
                                    onTap: () {
                                      imageController.removeImages(index);
                                      print(imageController
                                          .selectedIamges.length);
                                    },
                                    child: const CircleAvatar(
                                      backgroundColor:
                                          AppConstant.appScendoryColor,
                                      child: Icon(
                                        Icons.close,
                                        color: AppConstant.appTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
            const DropDownCategoriesWiidget(),

            GetBuilder<IsSaleController>(
              init: IsSaleController(),
              builder: (isSaleController) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Is Sale"),
                        Switch(
                          value: isSaleController.isSale.value,
                          activeColor: AppConstant.appMainColor,
                          onChanged: (value) {
                            isSaleController.toggleIsSale(value);
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            //form
            const SizedBox(height: 10.0),
            Container(
              height: 65,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                cursorColor: AppConstant.appMainColor,
                textInputAction: TextInputAction.next,
                controller: productNameController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  hintText: "Product Name",
                  hintStyle: TextStyle(fontSize: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),

            Obx(() {
              return isSaleController.isSale.value
                  ? Container(
                      height: 65,
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        cursorColor: AppConstant.appMainColor,
                        textInputAction: TextInputAction.next,
                        controller: salePriceController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          hintText: "Sale Price",
                          hintStyle: TextStyle(fontSize: 12.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink();
            }),

            const SizedBox(height: 10.0),
            Container(
              height: 65,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                keyboardType: TextInputType.number,
                cursorColor: AppConstant.appMainColor,
                textInputAction: TextInputAction.next,
                controller: fullPriceController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  hintText: "Full Price",
                  hintStyle: TextStyle(fontSize: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10.0),
            Container(
              height: 65,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                cursorColor: AppConstant.appMainColor,
                textInputAction: TextInputAction.next,
                controller: deliveryTimeController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  hintText: "Delivery Time",
                  hintStyle: TextStyle(fontSize: 12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10.0),

            ElevatedButton(
              onPressed: () async {
                try {
                  EasyLoading.show();
                  await addProductImagesController.uploadFunction(
                      addProductImagesController.selectedIamges);
                  if (kDebugMode) {
                    print(addProductImagesController.arrImagesUrl);
                  }

                  String productId = GenerateIds().generateProductId();

                  ProductModel productModel = ProductModel(
                    productId: productId,
                    categoryId: categoryDropDownController.selectedCategoryId
                        .toString(),
                    productName: productNameController.text.trim(),
                    categoryName: categoryDropDownController
                        .selectedCategoryName
                        .toString(),
                    salePrice: salePriceController.text != ''
                        ? salePriceController.text.trim()
                        : '',
                    fullPrice: fullPriceController.text.trim(),
                    productImages: addProductImagesController.arrImagesUrl,
                    deliveryTime: deliveryTimeController.text.trim(),
                    isSale: isSaleController.isSale.value,
                      productDescription: "",
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );

                  await FirebaseFirestore.instance
                      .collection('products')
                      .doc(productId)
                      .set(productModel.toMap());
                  EasyLoading.dismiss();
                } catch (e) {
                  if (kDebugMode) {
                    print("error : $e");
                  }
                }
              },
              child: const Text("Upload"),
            ),
          ],
        ),
      ),
    );
  }
}
