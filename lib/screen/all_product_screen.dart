import 'package:admin_panel/screen/product_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product-model.dart';
import '../utils/app-constant.dart';
import 'add_product_screen.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Products"),
        actions: [
          GestureDetector(
            onTap: () async {
              await FirebaseAnalytics.instance.logEvent(name: "Add Order");
              Get.to(() => AddProductScreen());
            },
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.add),
            ),
          )

        ],
        backgroundColor: AppConstant.appMainColor,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .orderBy('createdAt', descending: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: const Center(
                child: Text('Error occurred while fetching products!'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: const Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Container(
              child: const Center(
                child: Text('No products found!'),
              ),
            );
          }

          if (snapshot.data != null && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                final productData = snapshot.data!.docs[index];

                List<String> productImages = [];
                if (productData['productImages'] != null && productData['productImages'] is List<dynamic>) {
                  productImages = List<String>.from(productData['productImages'].map((image) => image.toString()));
                } else {
                  productImages = [''];
                }

                ProductModel productModel = ProductModel(
                  productId: data['productId'],
                  categoryId: data['categoryId'],
                  productName: data['productName'],
                  categoryName: data['categoryName'],
                  salePrice: data['salePrice'],
                  fullPrice: data['fullPrice'],
                  productImages: productImages,
                  deliveryTime: data['deliveryTime'],
                  productDescription: data['productDescription'],
                  isSale: data['isSale'] == null ? false : data['isSale'] == 'true',
                  createdAt: data['createdAt'],
                  updatedAt: data['updatedAt'],
                );

                return Card(
                elevation: 5,
                child: ListTile(
                onTap: () {
                Get.to(() => SingleProductDetailScreen(
                productModel: productModel)
                );
                },
                leading: CircleAvatar(
                backgroundColor: AppConstant.appScendoryColor,
                backgroundImage: CachedNetworkImageProvider(
                productModel.productImages.isNotEmpty ? productModel.productImages[0] : '',
                errorListener: (err) {

                print('Error loading image');
                const Icon(Icons.error);
                },
                ),
                ),
                title: Text(productModel.productName),
                subtitle: Text(productModel.productId),
                trailing: const Icon(Icons.arrow_forward_ios),
                ),
                );
              },
            );
          } else {
            return Container(
              child: const Center(
                child: Text('No products found!'),
              ),
            );
          }
        },
      ),
    );
  }
}