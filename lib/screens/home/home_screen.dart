import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:qbazar/blocs/banners/banners_bloc.dart';
import 'package:qbazar/models/models.dart';
import 'package:qbazar/screens/all_products/all_products.dart';
import 'package:qbazar/widgets/category_card.dart';
import 'package:qbazar/widgets/widgets.dart';
import 'package:card_swiper/card_swiper.dart';

var Instance = FirebaseFirestore.instance;

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => HomeScreen());
  }

  var recommended = Instance.collection("products")
      .where('isActive', isEqualTo: true)
      .where('isRecommended', isEqualTo: true);

  var popular = Instance.collection("products")
      .where('isActive', isEqualTo: true)
      .where('isPopular', isEqualTo: true);

  var categories =
      Instance.collection("categories").where('active', isEqualTo: true);

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const CustomAppBar(title: 'IQ Importer'),
      bottomNavigationBar: const custom_btmbar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: (kIsWeb && (width > height) ? 500 : 180),
              child: BlocBuilder<BannersBloc, BannersState>(
                builder: (context, state) {
                  if (state is BannersLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is BannersLoaded) {
                    if (state.banners.isNotEmpty) {
                      return Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return CachedNetworkImage(
                            imageUrl: state.banners[index].imageUrl,
                            fit: BoxFit.fill,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          );
                        },
                        autoplay: true,
                        autoplayDelay: 5000,
                        itemCount: state.banners.length,
                        scrollDirection: Axis.horizontal,
                        pagination: const SwiperPagination(
                            alignment: Alignment.centerRight),
                        control: const SwiperControl(),
                      );
                    } else {
                      return SizedBox(
                        width: double.infinity,
                        height: (kIsWeb && (width > height) ? 500 : 180),
                        child: Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.cover,
                        ),
                      );
                    }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionTitle(title: 'CATEGORIES'),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                    child: const Text(
                      'View All Products',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, AllProductsScreen.routeName);
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 100,
              width: double.infinity,
              child: FirestoreListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  query: categories,
                  itemBuilder: (context, snapshot) {
                    return InkWell(
                      enableFeedback: false,
                      onHover: (onHover) {},
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      onTap: () {
                        Navigator.pushNamed(context, '/catalog',
                            arguments: categories);
                      },
                      child: CategoryCard(
                        categories: Categories.fromSnapshot(snapshot),
                      ),
                    );
                  }),
            ),
            const SectionTitle(title: 'RECOMMENDED'),
            SizedBox(
              height: 321,
              width: double.infinity,
              child: FirestoreListView(
                  scrollDirection: Axis.horizontal,
                  query: recommended,
                  itemBuilder: (context, snapshot) {
                    return ProductCards(
                        product: Product.fromSnapshot(snapshot));
                  }),
            ),
            const SectionTitle(title: 'POPULAR'),
            SizedBox(
              height: 321,
              width: double.infinity,
              child: FirestoreListView(
                  scrollDirection: Axis.horizontal,
                  query: popular,
                  itemBuilder: (context, snapshot) {
                    return ProductCards(
                        product: Product.fromSnapshot(snapshot));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
