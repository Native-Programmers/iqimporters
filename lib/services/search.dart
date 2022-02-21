import 'package:cloud_firestore/cloud_firestore.dart';

class Search {
  searchByName(String query) {
    return FirebaseFirestore.instance
        .collection('products')
        .where('query', isEqualTo: query.substring(0, 1).toUpperCase())
        .get();
  }
}
