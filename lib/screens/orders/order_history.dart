import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:qbazar/widgets/order_details(mobile).dart';
import 'package:qbazar/widgets/order_details.dart';
import 'package:qbazar/widgets/product_details.dart';
import 'package:qbazar/widgets/widgets.dart';

class OrderHistory extends StatelessWidget {
  static const String routeName = '/order-history';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const OrderHistory());
  }

  const OrderHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    const shadow = [
      BoxShadow(
        color: Colors.black,
        blurRadius: 2.0,
        spreadRadius: 0.0,
        offset: Offset(2.0, 2.0), // shadow direction: bottom right
      )
    ];
    return Scaffold(
      appBar: const CustomAppBar(title: 'ORDER HISTORY'),
      body: FirestoreListView(
          query: FirebaseFirestore.instance
              .collection('checkout')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid),
          itemBuilder: (context, snapshot) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.white12,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0), // shadow direction: bottom right
                )
              ]),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...snapshot['products_id']
                      .map((items) => ProductDetails(uid: items))
                      .toList(),
                  (kIsWeb && (width > height)
                      ? Details(
                          status: snapshot['status'],
                          subtotal: snapshot['subtotal'].toString(),
                          total: snapshot['total'].toString(),
                          uid: snapshot.id)
                      : DetailsMobile(
                          status: snapshot['status'],
                          subtotal: snapshot['subtotal'].toString(),
                          total: snapshot['total'].toString(),
                          uid: snapshot.id))
                ],
              ),
            );
          }),
    );
  }
}
