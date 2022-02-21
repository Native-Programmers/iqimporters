import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qbazar/blocs/cart/cart_bloc.dart';
import 'package:qbazar/models/models.dart';

class CartProductCard extends StatelessWidget {
  final Product product;
  final int quantity;
  const CartProductCard(
      {Key? key, required this.product, required this.quantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              children: [
                Image.network(
                  product.imageUrl[0],
                  width: 100,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                const VerticalDivider(
                  width: 10,
                  color: Colors.transparent,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rs. ${product.price}',
                        style: Theme.of(context).textTheme.headline6,
                      )
                    ],
                  ),
                ),
                const VerticalDivider(
                  width: 10,
                  color: Colors.transparent,
                ),
                Row(
                  children: [
                    BlocBuilder<CartBloc, CartState>(
                      builder: (context, state) {
                        return IconButton(
                          icon: const Icon(Icons.add_circle),
                          onPressed: () {
                            context
                                .read<CartBloc>()
                                .add(CartProductAdded(product));
                          },
                        );
                      },
                    ),
                    Text(
                      '$quantity',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle),
                      onPressed: () {
                        context
                            .read<CartBloc>()
                            .add(CartProductRemoved(product));
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          const Divider(
            height: 5,
          )
        ],
      ),
    );
  }
}
