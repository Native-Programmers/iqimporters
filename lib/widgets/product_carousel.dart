
import 'package:flutter/material.dart';
import 'package:qbazar/models/models.dart';

import 'product_card.dart';

class Product_carousel extends StatelessWidget {
  final List<Product> products;
  const Product_carousel({
    Key? key, required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
          scrollDirection: Axis.horizontal,
          itemCount: products.length,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ProductCards(product: products[index]),
            );
          }),
    );
  }
}

