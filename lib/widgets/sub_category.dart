import 'package:flutter/material.dart';
import 'package:qbazar/models/sub_category_model.dart';
import 'package:qbazar/screens/catalog/subcategory_screen.dart';

class SubCategoryCard extends StatelessWidget {
  const SubCategoryCard({Key? key, required this.subCategories})
      : super(key: key);
  final SubCategories subCategories;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, SubCategoryScreen.routeName,
            arguments: subCategories);
      },
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 100,
              child: Image.network(
                subCategories.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            const Divider(
              height: 5,
              color: Colors.transparent,
            ),
            Text(
              subCategories.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
