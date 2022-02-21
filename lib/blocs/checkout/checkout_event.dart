// ignore_for_file: non_constant_identifier_names

part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class UpdateCheckout extends CheckoutEvent {
  final String? fullname;
  final String? email;
  final String? address;
  final String? city;
  final String? country;
  final String? zipcode;
  final String? mobile_no;
  final Cart? cart;

  const UpdateCheckout(
      {this.fullname,
      this.email,
      this.address,
      this.city,
      this.country,
      this.zipcode,
      this.mobile_no,
      this.cart});

  @override
  List<Object?> get props =>
      [fullname, email, address, city, country, zipcode, mobile_no, cart];
}

class ConfirmCheckout extends CheckoutEvent {
  final Checkout checkout;
  const ConfirmCheckout({required this.checkout});
  @override
  List<Object?> get props => [checkout];
}

class EmptyCheckout extends CheckoutEvent {
  @override
  List<Object> get props => [];
}
