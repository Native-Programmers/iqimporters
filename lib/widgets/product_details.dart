import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: must_be_immutable
class ProductDetails extends StatelessWidget {
  ProductDetails({Key? key, required this.uid}) : super(key: key);
  String uid;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            FirebaseFirestore.instance.collection("products").doc(uid).get(),
        builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 75,
                          child: Image.network(
                            snapshot.data!['imageUrl'][0],
                            fit: BoxFit.fill,
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('PRODUCT NAME'),
                          Text('CATEGORY'),
                          Text('PRICE (PKR)'),
                        ],
                      ),
                      const VerticalDivider(
                        width: 15,
                        color: Colors.transparent,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data!['name']),
                          Text(snapshot.data!['category']),
                          Text(snapshot.data!['price'].toString()),
                        ],
                      )
                    ],
                  ),
                ),
                const Divider(
                  height: 5,
                  color: Colors.transparent,
                )
              ],
            );
          }
          return const Center(
            child: SpinKitWave(
              color: Colors.blueAccent,
            ),
          );
        });
  }
}
