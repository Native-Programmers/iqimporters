// ignore_for_file: prefer_collection_literals, non_constant_identifier_names, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:qbazar/models/models.dart';

class Checkout extends Equatable {
  final String? fullname;
  final String? email;
  final String? address;
  final String? city;
  final String? country;
  final String? zipcode;
  final String? mobile_no;
  final List<Product>? products;
  final String? subtotal;
  final String? deliverfee;
  final String? total;

  const Checkout(
      {required this.fullname,
      required this.email,
      required this.address,
      required this.city,
      required this.country,
      required this.zipcode,
      required this.mobile_no,
      required this.products,
      required this.subtotal,
      required this.deliverfee,
      required this.total});
  @override
  List<Object?> get props => [
        fullname,
        email,
        address,
        city,
        country,
        zipcode,
        mobile_no,
        products,
        subtotal,
        deliverfee,
        total
      ];
  Map<String, Object> toDocument() {
    Map customerAddress = Map();
    customerAddress['address'] = address;
    customerAddress['city'] = city;
    customerAddress['country'] = country;
    customerAddress['zipcode'] = zipcode;
    Map customerDetails = Map();
    customerDetails['fullname'] = fullname;
    customerDetails['email'] = email;
    customerDetails['mobile'] = mobile_no;
    Map productDetails = Map();
    List<Map> myData = [];
    products!.map((item) {
      productDetails['category'] = item.category;
      productDetails['name'] = item.name;
      productDetails['price'] = item.price;
      productDetails['imageUrl'] = item.imageUrl;
      myData.add(productDetails);
    });
    return {
      'status': 'Processing',
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'email': FirebaseAuth.instance.currentUser!.email.toString(),
      'customerAddress': customerAddress,
      'customerDetails': customerDetails,
      'products_id': products!.map((product) => product.uid).toList(),
      'product_details': productDetails,
      'subtotal': subtotal!,
      'delivery': deliverfee!,
      'total': total!,
    };
  }
}
