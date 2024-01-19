
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:learn_http/models/delete_model.dart';
import 'package:learn_http/models/product_model.dart';
import 'package:learn_http/pages/detail_page.dart';
import 'package:learn_http/pages/login_page.dart';
import 'package:learn_http/services/network_service.dart';

class MyHomePage extends StatefulWidget {
  static const id = "/home_page";
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  List<ProductModel> productModel = [];
  late DeleteModel deletedItem;

  Future<void> getAllProducts() async {
    String result = await NetworkService.GET(NetworkService.api);
    productModel = productModelFromJson(result);
    isLoading = true;
    setState(() {});
  }
  
  Future<void> deletingItem(int index) async {
    String? result =
        await NetworkService.DELETE(NetworkService.api, index);
    if (result != null) {
      // deletedProduct = deletedProductFromJson(result);
      // log(result);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$index item was deleted")));
      await getAllProducts();
      setState(() {});
    } else {
      log("Null");
    }
  }

  void editProduct(ProductModel product) async {
    TextEditingController nameController =
        TextEditingController(text: product.title);
    TextEditingController brandController =
        TextEditingController(text: product.brand);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: "Product Name"),
              ),
              TextField(
                controller: brandController,
                decoration: const InputDecoration(hintText: "Brand"),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                updateProduct(
                    product.id, nameController.text, brandController.text);
                    
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateProduct(
      String productId, String newName, String newBrand) async {
    Map<String, dynamic> updateData = {
      'title': newName,
      'brand': newBrand,
    };

    String? result =
        await NetworkService.PUT('/products/DummyJson/$productId', {}, updateData);

    if (result != null) {
      await getAllProducts();
      setState(() {});
    } else {
      print("Error updating product!");
    }
  }

  void getInfo(ProductModel product) {
    Navigator.pushNamed(context, DetailPage.id, arguments: product);
  }

  @override
  void initState() {
    super.initState();
    getAllProducts();
  }
  
  void _logout(BuildContext context) async {
    var box = Hive.box('authBox');
    await box.delete('token');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        title: const Text("Product List"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              size: 30,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: isLoading
          ? GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 18),
              itemBuilder: (_, index) {
                ProductModel item = productModel[index];
                return InkWell(
                  onTap: () {
                    getInfo(item);
                  },
                  onLongPress: () {
                    editProduct(item);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20),
                      // boxShadow: <BoxShadow>[
                      //   BoxShadow(
                      //       color: Colors.amber
                      //           .withOpacity(0.6),
                      //       spreadRadius: 2,
                      //       blurRadius: 0.2,
                      //       offset: const Offset(2, 2)),
                      //   BoxShadow(
                      //       color: Colors.amber
                      //           .withOpacity(0.6),
                      //       spreadRadius: 2,
                      //       blurRadius: 0.2,
                      //       offset: const Offset(2, 2)),
                      // ],
                    ),
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 90,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(item.thumbnail),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          item.brand,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                deletingItem(int.parse(item.id));
                              },
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: productModel.length,
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
