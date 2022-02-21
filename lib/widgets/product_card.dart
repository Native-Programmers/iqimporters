// ignore_for_file: non_constant_identifier_names, prefer_const_declarations

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:qbazar/blocs/cart/cart_bloc.dart';
import 'package:qbazar/blocs/wishlist/wishlist_bloc.dart';
import 'package:qbazar/models/models.dart';
import 'package:qbazar/screens/screens.dart';

final bool colors = true;
final Finstance = FirebaseFirestore.instance;
final Uinstance = FirebaseAuth.instance.currentUser;
Future<List> UserWishList = Finstance.collection('userinfo')
    .doc(Uinstance!.uid)
    .get()
    .then((value) => value.data()!['wishList']);

class ProductCards extends StatelessWidget {
  final Product product;
  final double widthFactor;
  final double factor;
  final BoxFit styles;
  final bool isWishList;
  const ProductCards({
    Key? key,
    required this.product,
    this.widthFactor = 2.5,
    this.factor = 2.5,
    this.styles = BoxFit.cover,
    this.isWishList = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final shadow = [
      BoxShadow(
        color: Colors.grey.shade500,
        blurRadius: 2.0,
        spreadRadius: 0.0,
        offset: const Offset(1.0, 1.0), // shadow direction: bottom right
      )
    ];
    return Container(
      margin: const EdgeInsets.only(left: 20),
      width: 250,
      decoration: BoxDecoration(boxShadow: shadow, color: Colors.white),
      child: InkWell(
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: () {
          // Navigator.pushNamed(context, '/details', arguments: product);
          Get.to(DetailsScreen(product: product));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Serail No.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  product.srNo,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  color: Colors.white,
                  height: 150,
                  width: 250,
                  child: Image.network(
                    product.imageUrl[0],
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  right: -60,
                  top: -60,
                  child: InkWell(
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onTap: () {
                        if (FirebaseAuth.instance.currentUser == null) {
                          Get.snackbar(
                              'Error', 'Pleae login to access wishlist');
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
                      child: AvatarGlow(
                        glowColor: Colors.red,
                        endRadius: 90.0,
                        duration: const Duration(milliseconds: 2000),
                        repeat: (product.wishList.contains(Uinstance!.uid)
                            ? false
                            : true),
                        showTwoGlows: (product.wishList.contains(Uinstance!.uid)
                            ? false
                            : true),
                        repeatPauseDuration: const Duration(milliseconds: 100),
                        child: Material(
                          // Replace this child with your own
                          elevation: 8.0,
                          shape: const CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[100],
                            child: Icon(
                              Icons.favorite,
                              size: 10,
                              color: (product.wishList.contains(Uinstance!.uid)
                                  ? Colors.red
                                  : Colors.grey),
                            ),
                            radius: 20.0,
                          ),
                        ),
                      )),
                ),
              ],
            ),
            const Divider(
              height: 7.5,
              color: Colors.transparent,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: 250,
              child: Column(
                children: [
                  Text(
                    product.name,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const Divider(
                    height: 7.5,
                    color: Colors.transparent,
                  ),
                  Text(
                    (product.desc.length > 20
                        ? '${product.desc.substring(0, 20)}...'
                        : product.desc),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            const Divider(
              height: 7.5,
              color: Colors.transparent,
            ),
            Column(
              children: [
                Text(
                  'PKR ${product.price.toString()}',
                  style: Theme.of(context).textTheme.headline3?.copyWith(
                      color: Colors.grey, fontWeight: FontWeight.w100),
                ),
                Container(
                  height: 1,
                  width: 200,
                  color: Colors.black,
                ),
                Text(
                  'PKR${product.discountedPrice.toString()}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[300],
                    decoration: TextDecoration.lineThrough,
                  ),
                )
              ],
            ),
            const Divider(
              height: 7.5,
              color: Colors.transparent,
            ),
            BlocBuilder<CartBloc, CartState>(
              builder: (context, state) {
                return AnimatedButton.strip(
                  onPress: () {
                    (product.quantity >= 1
                        ? {addProduct(product, context)}
                        : {
                            Get.snackbar('Error', 'Product is not available!',
                                colorText: Colors.white,
                                backgroundColor: Colors.red)
                          });
                  },
                  width: double.infinity,
                  height: 35,
                  text: 'ADD TO CART',
                  isReverse: true,
                  stripColor: Colors.transparent,
                  selectedTextColor: Colors.white,
                  stripTransitionType: StripTransitionType.LEFT_TO_RIGHT,
                  backgroundColor:
                      (product.quantity >= 1 ? Colors.blue : Colors.grey),
                  selectedGradientColor: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.blue,
                      Colors.red,
                    ],
                  ),
                  textStyle: const TextStyle(
                      fontSize: 12,
                      letterSpacing: 5,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                );
              },
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

  void addProduct(Product product, BuildContext context) {
    context.read<CartBloc>().add(CartProductAdded(product));
    Get.snackbar(
      'Product Added',
      'Product has been added to your cart.',
    );
    Get.to(const CartScreen());
  }
}
