part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  final String? fullname;
  final String? email;
  final String? address;
  final String? city;
  final String? country;
  final String? zipcode;
  final String? mobile_no;
  final List<Product>? products;
  final String? subtotal;
  final String? deliveryfee;
  final String? total;
  final Checkout checkout;
  final String? uid;

  CheckoutLoaded(
      {this.uid,
      this.fullname,
      this.email,
      this.address,
      this.city,
      this.country,
      this.zipcode,
      this.mobile_no,
      this.products,
      this.subtotal,
      this.deliveryfee,
      this.total})
      : checkout = Checkout(
          fullname: fullname,
          email: email,
          address: address,
          city: city,
          country: country,
          zipcode: zipcode,
          mobile_no: mobile_no,
          products: products,
          subtotal: subtotal,
          deliverfee: deliveryfee,
          total: total,
        );
  @override
  List<Object?> get props => [
        fullname,
        email,
        address,
        city,
        country,
        zipcode,
        mobile_no,
        products,
        subtotal,
        deliveryfee,
        total
      ];
}
