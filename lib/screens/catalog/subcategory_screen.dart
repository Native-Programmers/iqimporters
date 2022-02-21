import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:qbazar/blocs/products/products_bloc.dart';
import 'package:qbazar/models/product_model.dart';
import 'package:qbazar/widgets/widgets.dart';
import 'package:qbazar/models/sub_category_model.dart';

var Instance = FirebaseFirestore.instance;

var products =
    Instance.collection("products").where('isActive', isEqualTo: true);

class SubCategoryScreen extends StatelessWidget {
  static const String routeName = '/subCategory';
  const SubCategoryScreen({Key? key, required this.subCategory})
      : super(key: key);
  static Route route({required subCategory}) {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => SubCategoryScreen(subCategory: subCategory));
  }

  final SubCategories subCategory;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return FirestoreQueryBuilder(
        query: products.where('subCategory', isEqualTo: subCategory.name),
        builder: (context, snapshot, _) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData) {
            return Scaffold(
              appBar: CustomAppBar(title: (subCategory.name.toUpperCase())),
              bottomNavigationBar: const custom_btmbar(),
              body: GridView.builder(
                itemCount: snapshot.docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (kIsWeb && (width > height) ? 4 : 2),
                ),
                itemBuilder: (context, index) {
                  if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                    snapshot.fetchMore();
                  }

                  final product = snapshot.docs[index].data();

                  return Center(
                    child: ProductCards(
                      product: Product.fromSnapshot(snapshot.docs[index]),
                    ),
                    widthFactor: 2.2,
                  );
                },
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: Text('Something went wrong!'),
              ),
            );
          }
        });
  }
}
