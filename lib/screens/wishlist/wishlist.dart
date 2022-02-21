import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qbazar/models/models.dart';
import 'package:qbazar/widgets/widgets.dart';

class WishListScreen extends StatelessWidget {
  static const String routeName = '/wish';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const WishListScreen());
  }

  const WishListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const CustomAppBar(title: 'WishList'),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('userinfo')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitChasingDots(
                  color: Colors.blue,
                ),
              );
            }
            if (!snapshot.hasData ||
                snapshot.hasError &&
                    snapshot.connectionState == ConnectionState.done) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 200,
                        width: 200,
                        child: Image.asset(
                          'assets/images/frustration.png',
                          fit: BoxFit.contain,
                        )),
                    const Divider(
                      height: 25,
                      color: Colors.transparent,
                    ),
                    const Text(
                      'Please Check Your Internet Connection',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ]);
            }

            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              List wishList = snapshot.data!['wishList'];
              if (wishList.isNotEmpty) {
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (kIsWeb && (width > height) ? 4 : 2),
                    ),
                    itemCount: wishList.length,
                    itemBuilder: (context, int index) {
                      return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('products')
                              .doc(wishList[index])
                              .get(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: SpinKitCubeGrid(
                                  color: Colors.blue,
                                ),
                              );
                            }
                            if (!snapshot.hasData || snapshot.hasError) {
                              return const Center(
                                child: Text('Something went wrong!'),
                              );
                            }
                            if (snapshot.hasData &&
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              return Center(
                                child: ProductCards(
                                  product: Product(
                                      uid: snapshot.data!.id,
                                      name: snapshot.data!['name'],
                                      category: snapshot.data!['category'],
                                      imageUrl: snapshot.data!['imageUrl'],
                                      price: snapshot.data!['price'],
                                      isRecommended:
                                          snapshot.data!['isRecommended'],
                                      isPopular: snapshot.data!['isPopular'],
                                      isActive: snapshot.data!['isActive'],
                                      desc: snapshot.data!['desc'],
                                      subCategory:
                                          snapshot.data!['subcategory'],
                                      quantity: snapshot.data!['quantity'],
                                      srNo: snapshot.data!['srNo'],
                                      discountedPrice:
                                          snapshot.data!['discount'],
                                      wishList: snapshot.data!['wishList']),
                                ),
                              );
                            } else {
                              return const Center(
                                child: SpinKitCubeGrid(
                                  color: Colors.blue,
                                ),
                              );
                            }
                          });
                    });
              } else {
                return const Center(
                  child: Text('WishList is empty'),
                );
              }
            } else {
              return const Center(
                child: Text('Something went wrong! Please try again'),
              );
            }
          }),
    );
  }
}
