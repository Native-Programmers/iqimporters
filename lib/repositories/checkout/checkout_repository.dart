import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qbazar/models/checkout_model.dart';
import 'package:qbazar/repositories/checkout/base_checkout_repository.dart';

class CheckoutRepository extends BaseCheckoutRepository {
  final FirebaseFirestore _firebaseFirestore;
  CheckoutRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;
  @override
  Future<void> addCheckout(Checkout checkout) {
    var data = FirebaseFirestore.instance.collection('length').doc('orders');
    data.get().then((value) => FirebaseFirestore.instance
        .collection('length')
        .doc('orders')
        .update({'length': value['length'] + 1}));
    return _firebaseFirestore.collection('checkout').add(checkout.toDocument());
  }
}
