import 'package:equatable/equatable.dart';
import 'package:qbazar/models/product_model.dart';

class Cart extends Equatable {
  final List<Product> products;
  const Cart({this.products = const <Product>[]});
  double get subtotal =>
      products.fold(0, (total, current) => total + current.price);
  String get subtotalString => subtotal.toStringAsFixed(2);
  String get deliveryFeeString => deliveryFee(subtotal).toStringAsFixed(2);
  String get freeDeliveryString => freeDelivery(subtotal);
  String get totalString => total(subtotal).toStringAsFixed(2);
  String freeDelivery(subtotal) {
    if (subtotal >= 2500) {
      return 'You have Free Delivery ';
    } else {
      double missing = 2500.0 - subtotal;
      return 'Add Rs.${missing.toStringAsFixed(2)} to get free shipping';
    }
  }

  double deliveryFee(subtotal) {
    if (subtotal >= 2500) {
      return 0.0;
    } else {
      if (subtotal != 0) {
        return subtotal / 10;
      } else {
        return 0.00;
      }
    }
  }

  double total(subtotal) {
    return (subtotal + deliveryFee(subtotal));
  }

  @override
  List<Object?> get props => [products];
  Map productQuantity(products) {
    var quantity = {};
    products.forEach((product) {
      if (!quantity.containsKey(product)) {
        quantity[product] = 1;
      } else {
        quantity[product] += 1;
      }
    });
    return quantity;
  }
}
