import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qbazar/models/product_model.dart';
import 'package:qbazar/services/auth_service.dart';
import 'package:search_page/search_page.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline2!
                .copyWith(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                CollectionReference _collectionRef =
                    FirebaseFirestore.instance.collection('products');
                QuerySnapshot querySnapshot = await _collectionRef.get();
                final data = querySnapshot.docs
                    .map((doc) => Product.fromSnapshot(doc))
                    .toList();
                showSearch(
                    context: context,
                    delegate: SearchPage<Product>(
                      searchStyle:
                          const TextStyle(backgroundColor: Colors.white),
                      onQueryUpdate: (s) {
                        const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      items: data,
                      searchLabel: 'Search products',
                      suggestion: const Center(
                        child: Text('Search product by name'),
                      ),
                      failure: const Center(
                        child: Text('No Product found'),
                      ),
                      filter: (product) => [
                        product.name,
                        product.price.toString(),
                        product.uid.toString(),
                        product.srNo.toString(),
                      ],
                      builder: (product) => InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed('/details', arguments: product);
                        },
                        child: ListTile(
                          leading: Image.network(
                            product.imageUrl[0],
                            fit: BoxFit.contain,
                          ),
                          title: Text(product.name),
                          trailing: Text('PKR. ${product.price}'),
                        ),
                      ),
                    ));
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              )),
          const VerticalDivider(
            width: 5,
            color: Colors.transparent,
          ),
          CustomPopupMenu(
            barrierColor: Colors.black.withAlpha(50),
            arrowColor: Colors.white,
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(
                  right: 15,
                ),
                child: const Icon(
                  FontAwesomeIcons.ellipsisV,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            menuBuilder: () {
              return ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  color: Colors.white,
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.offAndToNamed('/');
                          },
                          child: const ListTile(
                            title: Text('Home'),
                            leading: Icon(CupertinoIcons.house_fill,
                                color: Colors.blue),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed('/cart');
                          },
                          child: const ListTile(
                            title: Text('Cart'),
                            leading: Icon(
                              CupertinoIcons.cart_fill,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (FirebaseAuth.instance.currentUser == null) {
                              Get.snackbar(
                                'Login Required',
                                'Please login to add to wishList',
                                backgroundColor: Colors.blueGrey,
                                colorText: Colors.white,
                              );
                            } else {
                              Get.toNamed('/wish');
                            }
                          },
                          child: const ListTile(
                            title: Text('WishList'),
                            leading: Icon(
                              CupertinoIcons.heart_fill,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed('/wrapper');
                          },
                          child: const ListTile(
                            title: Text('User Profile'),
                            leading: Icon(CupertinoIcons.profile_circled),
                          ),
                        ),
                        const Divider(
                          height: 10,
                        ),
                        (FirebaseAuth.instance.currentUser != null
                            ? InkWell(
                                onTap: () {
                                  FirebaseAuth.instance.signOut();
                                },
                                child: const ListTile(
                                  title: Text('Logout'),
                                  leading: Icon(
                                    Icons.logout,
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  Get.toNamed('/wrapper');
                                },
                                child: const ListTile(
                                  title: Text('Sign In'),
                                  leading: Icon(
                                    Icons.login,
                                    color: Colors.green,
                                  ),
                                ),
                              )),
                      ],
                    ),
                  ),
                ),
              );
            },
            pressType: PressType.singleClick,
            verticalMargin: -10,
          )
          // PopupMenuButton(
          //   //don't specify icon if you want 3 dot menu
          //   color: Colors.white10,

          //   itemBuilder: (context) => [
          // PopupMenuItem<int>(
          //   child: InkWell(
          //     onTap: () {
          //       Get.toEnd(() => '/');
          //     },
          //     child: const ListTile(
          //       title: Text('Home'),
          //       leading: Icon(CupertinoIcons.house_fill, color: Colors.blue),
          //     ),
          //   ),
          // ),
          // PopupMenuItem<int>(
          //   child: InkWell(
          //     onTap: () {
          //       Get.toNamed('/cart');
          //     },
          //     child: const ListTile(
          //       title: Text('Cart'),
          //       leading: Icon(
          //         CupertinoIcons.cart_fill,
          //         color: Colors.amber,
          //       ),
          //     ),
          //   ),
          // ),
          // PopupMenuItem<int>(
          //   child: InkWell(
          //     onTap: () {
          //       Get.toNamed('/wish');
          //     },
          //     child: const ListTile(
          //       title: Text('WishList'),
          //       leading: Icon(
          //         CupertinoIcons.heart_fill,
          //         color: Colors.red,
          //       ),
          //     ),
          //   ),
          // ),
          // PopupMenuItem<int>(
          //   child: InkWell(
          //     onTap: () {
          //       Get.toNamed('/wrapper');
          //     },
          //     child: const ListTile(
          //       title: Text('User Profile'),
          //       leading: Icon(CupertinoIcons.profile_circled),
          //     ),
          //   ),
          // ),
          //     PopupMenuItem<int>(
          //       child: (FirebaseAuth.instance.currentUser != null
          //           ? InkWell(
          //               onTap: () {
          //                 FirebaseAuth.instance.signOut();
          //               },
          //               child: const ListTile(
          //                 title: Text('Logout'),
          //                 leading: Icon(
          //                   Icons.logout,
          //                   color: Colors.red,
          //                 ),
          //               ),
          //             )
          //           : InkWell(
          //               onTap: () {
          //                 Get.toNamed('/wrapper');
          //               },
          //               child: const ListTile(
          //                 title: Text('Sign In'),
          //                 leading: Icon(
          //                   Icons.login,
          //                   color: Colors.green,
          //                 ),
          //               ),
          //             )),
          //     ),
          //   ],
          // ),
          //   ],
        ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
