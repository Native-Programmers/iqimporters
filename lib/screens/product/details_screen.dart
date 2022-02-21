import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:qbazar/blocs/cart/cart_bloc.dart';
import 'package:qbazar/blocs/wishlist/wishlist_bloc.dart';
import 'package:qbazar/models/product_model.dart';
import 'package:qbazar/screens/cart/cart_screen.dart';
import 'package:qbazar/widgets/widgets.dart';

var rating = 3.00;

class DetailsScreen extends StatelessWidget {
  static const String routeName = '/details';
  static Route route({required Product product}) {
    return GetPageRoute(settings: const RouteSettings(name: routeName));
  }

  const DetailsScreen({Key? key, required this.product}) : super(key: key);

  final Product product;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> comments = FirebaseFirestore.instance
        .collection("comments")
        .where('product_id', isEqualTo: product.uid)
        .snapshots();
    return Scaffold(
      appBar: CustomAppBar(
          title: (kIsWeb
              ? (product.name.length > 10
                  ? product.name.substring(0, 11) + '...'
                  : product.name)
              : product.name.length > 20
                  ? product.name.substring(0, 20) + '...'
                  : product.name)),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        child: SizedBox(
          height: (kIsWeb &&
                  MediaQuery.of(context).size.height <=
                      MediaQuery.of(context).size.width
              ? MediaQuery.of(context).size.height / 20
              : MediaQuery.of(context).size.height / 15),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                      text:
                          Get.currentRoute + Get.parameters['id'].toString()));
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: (product.wishList.contains(Uinstance!.uid)
                      ? Colors.red
                      : Colors.white),
                ),
                onPressed: () {
                  if (FirebaseAuth.instance.currentUser == null) {
                    Get.snackbar('Error', 'Pleae login to access wishlist');
                  } else {
                    if (product.wishList.contains(Uinstance!.uid)) {
                      removeFromWishList(
                        product.uid,
                        Uinstance!.uid,
                        product.wishList,
                        UserWishList,
                      );
                    } else {
                      addToWishList(
                        product.uid,
                        Uinstance!.uid,
                        product.wishList,
                        UserWishList,
                      );
                    }
                  }
                },
              ),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 70)),
                    child: Text(
                      'Add to Cart',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    onPressed: () {
                      if (product.quantity >= 1) {
                        context.read<CartBloc>().add(CartProductAdded(product));
                        const snackBar = SnackBar(
                          content: Text('Added to Cart Successfully!'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pushNamed(context, CartScreen.routeName);
                      } else {
                        Get.snackbar('Error', 'Product not available!');
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                color: Colors.grey[100],
                padding: const EdgeInsets.symmetric(vertical: 10),
                width: (kIsWeb
                    ? MediaQuery.of(context).size.width / 1
                    : MediaQuery.of(context).size.width),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 1.8,
                      viewportFraction: 1,
                      disableCenter: true,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: true,
                      height: (kIsWeb ? 500 : 250),
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 10),
                    ),
                    items: product.imageUrl.map((item) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Carousel(
                            image: item,
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    color: Colors.black.withAlpha(50),
                    alignment: Alignment.bottomCenter,
                  ),
                  Container(
                    margin: const EdgeInsets.all(5.00),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width - 10,
                    height: 60,
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: Colors.white),
                        ),
                        const Divider(
                          height: 5,
                          color: Colors.transparent,
                        ),
                        Text(
                          'PKR ${product.price}',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  'Product Information',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                children: [
                  ListTile(
                    title: Text(
                      product.desc,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  'Delivery Information',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                children: [
                  ListTile(
                    title: Text(
                      product.desc,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  'Comment Section',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: comments,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text("Error. Please Check Your Netword");
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      final data = snapshot.requireData;
                      return SizedBox(
                        height: 400,
                        child: ListView.builder(
                            itemCount: data.size,
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Comment(
                                    date: data.docs[index]['date'],
                                    comment: data.docs[index]['comment'],
                                    uid: data.docs[index]['user_id'],
                                    rating: data.docs[index]['rating'],
                                  ),
                                  const Divider(
                                    height: 10,
                                    color: Colors.transparent,
                                  ),
                                ],
                              );
                            }),
                      );
                    },
                  ),
                  Center(
                    child: SizedBox(
                      width: (kIsWeb
                          ? MediaQuery.of(context).size.width / 3
                          : MediaQuery.of(context).size.width / 2),
                      child: ElevatedButton(
                        child: const Text(
                          'Add comment',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent,
                        ),
                        onPressed: () {
                          (kIsWeb
                              ? showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return (FirebaseAuth.instance.currentUser !=
                                            null
                                        ? SizedBox(
                                            height: 200,
                                            child: (NewComments(
                                              uid: FirebaseAuth
                                                  .instance.currentUser!.email,
                                              pid: product.uid,
                                            )),
                                          )
                                        : (const Text(
                                            "Please login to post comments")));
                                  },
                                )
                              : showCommentBox(context));
                        },
                      ),
                    ),
                  ),
                  const Divider(
                    height: 25,
                    color: Colors.transparent,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addToWishList(String productId, String uid, List productWishList,
      Future<List> userWishList) async {
    var items;
    productWishList.add(uid);
    //remove data from product wishlist
    await Finstance.collection('products')
        .doc(productId)
        .update({'wishList': productWishList}).then((value) async {
      await Finstance.collection('userinfo')
          .doc(Uinstance!.uid)
          .get()
          .then((value) {
        if (value.exists) {
          items = value.data()!['wishList'];
          items.add(productId);
          Finstance.collection('userinfo')
              .doc(Uinstance!.uid)
              .update({'wishList': items})
              .then((value) => Get.snackbar('Success', 'Added to wishlist',
                  backgroundColor: Colors.green, colorText: Colors.white))
              .onError((error, stackTrace) => Get.snackbar(
                  'Error', 'Unable to add to wishlist',
                  backgroundColor: Colors.red, colorText: Colors.white));
        } else {
          Get.snackbar('Error', 'Please add profile data to access wishlist');
        }
      });
    });
  }

  Future<void> removeFromWishList(String productId, String uid,
      List productWishList, Future<List> userWishList) async {
    var items;
    productWishList.remove(uid);
    //remove data from product wishlist
    await Finstance.collection('products')
        .doc(productId)
        .update({'wishList': productWishList}).then((value) async {
      await Finstance.collection('userinfo')
          .doc(Uinstance!.uid)
          .get()
          .then((value) {
        if (value.exists) {
          items = value.data()!['wishList'];
          items.remove(productId);
          Finstance.collection('userinfo')
              .doc(Uinstance!.uid)
              .update({'wishList': items})
              .then((value) => Get.snackbar('Success', 'Removed from wishlist',
                  backgroundColor: Colors.green, colorText: Colors.white))
              .onError((error, stackTrace) => Get.snackbar(
                  'Error', 'Unable to remove from wishlist',
                  backgroundColor: Colors.red, colorText: Colors.white));
        } else {
          Get.snackbar('Error', 'Please add profile data to access wishlist');
        }
      });
    });
  }

  Future<void> showCommentBox(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: (FirebaseAuth.instance.currentUser != null
                  ? SizedBox(
                      height: 200,
                      child: (NewComments(
                        uid: FirebaseAuth.instance.currentUser!.uid,
                        pid: product.uid,
                      )),
                    )
                  : (const Text("Please login to post comments"))));
        });
  }
}
