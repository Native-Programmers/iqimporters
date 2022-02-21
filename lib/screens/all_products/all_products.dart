import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qbazar/blocs/products/products_bloc.dart';
import 'package:qbazar/widgets/widgets.dart';

class AllProductsScreen extends StatelessWidget {
  static const String routeName = '/allproducts';
  const AllProductsScreen({Key? key}) : super(key: key);
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => const AllProductsScreen());
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const CustomAppBar(
        title: '',
      ),
      bottomNavigationBar: const custom_btmbar(),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ProductLoaded) {
            List products = state.products.toList();
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 100,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (kIsWeb && (width > height) ? 3 : 2),
                    childAspectRatio: 1.5),
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
