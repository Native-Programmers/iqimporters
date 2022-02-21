// ignore_for_file: must_be_immutable

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:qbazar/blocs/banners/banners_bloc.dart';
import 'package:qbazar/models/models.dart';
import 'package:qbazar/models/sub_category_model.dart';
import 'package:qbazar/screens/all_products/all_products.dart';
import 'package:qbazar/widgets/sub_category.dart';
import 'package:qbazar/widgets/widgets.dart';

var Instance = FirebaseFirestore.instance;

var subCategories =
    Instance.collection("subcategories").where('active', isEqualTo: true);

var products =
    Instance.collection("products").where('isActive', isEqualTo: true);

class CategoryProductScreen extends StatelessWidget {
  static const String routeName = '/customCategories';
  const CategoryProductScreen({Key? key, required this.category})
      : super(key: key);
  static Route route({required category}) {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => CategoryProductScreen(category: category));
  }

  final Categories category;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return FirestoreQueryBuilder(
        query: products.where('category', isEqualTo: category.name),
        builder: (context, snapshot, _) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData) {
            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: false,
                    centerTitle: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(category.name.toUpperCase()),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      width: double.infinity,
                      height: (kIsWeb && (width > height) ? 500 : 180),
                      child: BlocBuilder<BannersBloc, BannersState>(
                        builder: (context, state) {
                          if (state is BannersLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is BannersLoaded) {
                            return Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                return Image.network(
                                    state.banners[index].imageUrl,
                                    fit: BoxFit.fill,
                                    height: (kIsWeb ? 500 : 180),
                                    width: double.infinity);
                              },
                              autoplay: true,
                              itemCount: state.banners.length,
                              scrollDirection: Axis.horizontal,
                              pagination: const SwiperPagination(
                                  alignment: Alignment.centerRight),
                              control: const SwiperControl(),
                            );
                          } else {
                            return Center(
                              child: Text(
                                'Chech Your Network Connection',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SectionTitle(title: 'SUB-CATEGORIES'),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent),
                            child: const Text(
                              'View All Products',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AllProductsScreen.routeName);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: FirestoreListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          query: subCategories.where('uid',
                              isEqualTo: category.id),
                          itemBuilder: (context, snapshot) {
                            if (snapshot.exists) {
                              return SubCategoryCard(
                                subCategories:
                                    SubCategories.fromSnapShot(snapshot),
                              );
                            } else {
                              return const Center(
                                  child: Text('No Sub Categories Exist'));
                            }
                          }),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SectionTitle(title: 'PRODUCTS'),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: GridView.builder(
                        itemCount: snapshot.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: (kIsWeb && (width > height) ? 4 : 2),
                        ),
                        itemBuilder: (context, index) {
                          if (snapshot.hasMore &&
                              index + 1 == snapshot.docs.length) {
                            snapshot.fetchMore();
                          }

                          final product = snapshot.docs[index].data();

                          return Center(
                            child: ProductCards(
                              product:
                                  Product.fromSnapshot(snapshot.docs[index]),
                            ),
                            widthFactor: 2.2,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Something went wrong!'),
            );
          }
        });
  }
}
