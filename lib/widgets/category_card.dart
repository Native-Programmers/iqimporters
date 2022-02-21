import 'package:flutter/material.dart';
import 'package:qbazar/models/category_model.dart';
import 'package:qbazar/screens/catalog/category_product_screen.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({Key? key, required this.categories}) : super(key: key);
  final Categories categories;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, CategoryProductScreen.routeName,
            arguments: categories);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 100,
              child: Image.network(
                categories.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            const Divider(
              height: 5,
              color: Colors.transparent,
            ),
            Text(
              categories.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
