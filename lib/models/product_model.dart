import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String uid;
  final String name;
  final String category;
  final List imageUrl;
  final List wishList;
  final String subCategory;
  final String srNo;
  final String desc;
  final int price;
  final int quantity;
  final int discountedPrice;
  final bool isRecommended;
  final bool isPopular;
  final bool isActive;

  const Product({
    required this.uid,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.subCategory,
    required this.price,
    required this.isRecommended,
    required this.isPopular,
    required this.isActive,
    required this.desc,
    required this.srNo,
    required this.quantity,
    required this.discountedPrice,
    required this.wishList,
  });

  @override
  List<Object?> get props => [
        uid,
        name,
        category,
        imageUrl,
        price,
        isRecommended,
        isPopular,
        subCategory,
        quantity,
        srNo,
        discountedPrice,
        wishList,
      ];

  static Product fromSnapshot(DocumentSnapshot snap) {
    Product product = Product(
      uid: snap.id,
      name: snap['name'],
      category: snap['category'],
      imageUrl: snap['imageUrl'],
      price: snap['price'],
      isRecommended: snap['isRecommended'],
      isPopular: snap['isPopular'],
      isActive: snap['isActive'],
      desc: snap['desc'],
      subCategory: snap['subcategory'],
      quantity: snap['quantity'],
      srNo: snap['srNo'],
      discountedPrice: snap['discount'],
      wishList: snap['wishList']
    );
    return product;
  }

  static List<Product> products = const [];
}
