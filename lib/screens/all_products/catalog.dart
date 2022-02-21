import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qbazar/blocs/products/products_bloc.dart';
import 'package:qbazar/models/models.dart';
import 'package:qbazar/widgets/widgets.dart';

class CatalogScreen extends StatelessWidget {
  static const String routeName = '/catalog';
  const CatalogScreen({Key? key, required this.category}) : super(key: key);
  static Route route({required category}) {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => CatalogScreen(category: category));
  }

  final Categories category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: ((kIsWeb
                  ? category.name
                  : category.name.length > 10
                      ? category.name.substring(0, 11) + '...'
                      : category.name)
              .toUpperCase())),
      bottomNavigationBar: const custom_btmbar(),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProductLoaded) {
            List products = state.products
                .where((element) =>
                    element.category.toLowerCase() ==
                    category.name.toLowerCase())
                .toList();
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (kIsWeb ? 3 : 2), childAspectRatio: 1.5),
                itemCount: products.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: ProductCards(
                      product: products[index],
                    ),
                    widthFactor: 2.2,
                  );
                },
              ),
            );
          } else {
            return Center(
              child: Text(
                "No Products Found",
                style: Theme.of(context).textTheme.headline5,
              ),
            );
          }
        },
      ),
    );
  }
}
