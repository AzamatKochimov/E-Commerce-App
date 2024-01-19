import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_http/models/product_model.dart';

class DetailPage extends StatefulWidget {
  static const id = "/detail_page";
  final ProductModel? product;
  const DetailPage({super.key, this.product});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    ProductModel product = ModalRoute.of(context)?.settings.arguments as ProductModel;
    return Scaffold(
      backgroundColor: Colors.amberAccent,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        title: Text(product.title),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 48),
            child: Column(
              children: <Widget>[
                SizedBox(
                    child: CarouselSlider.builder(
                  itemCount: product.images.length,
                  itemBuilder: (BuildContext context, int index,
                          int pageViewIndex) =>
                      Container(
                          child: Image(
                              image:
                                  Image.network(product.images[index]).image)),
                              options: CarouselOptions(
                                height: 200,
                                aspectRatio: 16 / 9,
                                viewportFraction: 0.8,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                enlargeCenterPage: true,
                                enlargeFactor: 0.3,
                                scrollDirection: Axis.horizontal,
                  ),
                )),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Brand: ${product.brand}",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      spacer(30),
                      // Name and rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Text(
                              product.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.yellow, size: 30),
                              Text(
                                "(${product.rating})",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      spacer(30),
                      // Price and stock
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Price:"),
                              Row(
                                children: [
                                  Text(
                                    "\$${(product.price - (product.price * product.discountPercentage / 100)).toInt()}.00",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "\$${product.price}.00",
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            "Stock: ${product.stock}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.greenAccent[700],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  color: Colors.orange[100],
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      const Icon(CupertinoIcons.checkmark_circle),
                      const SizedBox(width: 5),
                      Text(
                          "${product.discountPercentage.toInt() * 2} products have been sold in last 3 days!")
                    ],
                  ),
                ),
                spacer(30),
                // Description
                Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(CupertinoIcons.question_circle, size: 18),
                          SizedBox(width: 5),
                          Text("About: "),
                        ],
                      ),
                      spacer(10),
                      Text(product.description),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Add to cart button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 30, bottom: 10, top: 10, right: 30),
              height: 70,
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Price: "),
                      Text(
                        "\$${(product.price - (product.price * product.discountPercentage / 100)).toInt()}.00",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.greenAccent[700]),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Add to cart",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  spacer(double height) {
    return SizedBox(height: height);
  }
}
