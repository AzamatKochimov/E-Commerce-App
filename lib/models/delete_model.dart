// To parse this JSON data, do
//
//     final deleteModel = deleteModelFromJson(jsonString);

import 'dart:convert';

DeleteModel deleteModelFromJson(String str) =>
    DeleteModel.fromJson(json.decode(str));

String deleteModelToJson(DeleteModel data) => json.encode(data.toJson());

class DeleteModel {
  int id;
  String title;
  String description;
  int price;
  double discountPercentage;
  double rating;
  int stock;
  String brand;
  String category;
  String thumbnail;
  List<String> images;
  bool isDeleted;
  DateTime deletedOn;

  DeleteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.category,
    required this.thumbnail,
    required this.images,
    required this.isDeleted,
    required this.deletedOn,
  });

  factory DeleteModel.fromJson(Map<String, dynamic> json) => DeleteModel(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        price: json["price"],
        discountPercentage: json["discountPercentage"]?.toDouble(),
        rating: json["rating"]?.toDouble(),
        stock: json["stock"],
        brand: json["brand"],
        category: json["category"],
        thumbnail: json["thumbnail"],
        images: List<String>.from(json["images"].map((x) => x)),
        isDeleted: json["isDeleted"],
        deletedOn: DateTime.parse(json["deletedOn"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "price": price,
        "discountPercentage": discountPercentage,
        "rating": rating,
        "stock": stock,
        "brand": brand,
        "category": category,
        "thumbnail": thumbnail,
        "images": List<dynamic>.from(images.map((x) => x)),
        "isDeleted": isDeleted,
        "deletedOn": deletedOn.toIso8601String(),
      };
}
