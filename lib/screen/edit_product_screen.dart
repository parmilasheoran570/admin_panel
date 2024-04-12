import 'package:admin_panel/controllers/edit_product_controller.dart';
import 'package:admin_panel/models/product-model.dart';
import 'package:admin_panel/utils/app-constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class EditProductScreen extends StatelessWidget {
  ProductModel productModel;
  EditProductScreen({
    super.key,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProductController>(
      init: EditProductController(productModel: productModel),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConstant.appMainColor,
            title: Text("Edit Product ${productModel.productName}"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 20,
                    height: Get.height / 4.0,
                    child: GridView.builder(
                      itemCount: controller.images.length,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: controller.images[index],
                              fit: BoxFit.contain,
                              height: Get.height / 4,
                              width: Get.width / 2,
                              placeholder: (context, url) =>
                                  const Center(child: CupertinoActivityIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            Positioned(
                              right: 10,
                              top: 0,
                              child: InkWell(
                                onTap: () async {
                                  EasyLoading.show();
                                  await controller.deleteImagesFromStorage(
                                      controller.images[index].toString());
                                  await controller.deleteImageFromFireStore(
                                      controller.images[index].toString(),
                                      productModel.productId);
                                  EasyLoading.dismiss();
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
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}