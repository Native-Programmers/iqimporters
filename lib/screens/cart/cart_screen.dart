import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qbazar/blocs/cart/cart_bloc.dart';
import 'package:qbazar/widgets/widgets.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const CartScreen());
  }

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: 'Shopping Cart'),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blueAccent,
          child: SizedBox(
            height: (kIsWeb &&
                    MediaQuery.of(context).size.height <=
                        MediaQuery.of(context).size.width
                ? MediaQuery.of(context).size.height / 20
                : MediaQuery.of(context).size.height / 15),
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is CartLoaded) {
                    if (state.cart.products.isNotEmpty) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(''),
                          ElevatedButton(
                            child: Text(
                              'GO TO CHECKOUT',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/checkout');
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                            ),
                          ),
                          const Text(''),
                        ],
                      );
                    } else {
                      return Center(
                        child: Text(
                          'Please add some Products',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white),
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: Text('Something went Wrong. Try Again!'),
                    );
                  }
                },
              ),
            ),
          ),
        ),
        body: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CartLoaded) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                OrderSummary(),
              ],
            );
          } else {
            return const Text('Something went wrong');
          }
        }));
  }
}
