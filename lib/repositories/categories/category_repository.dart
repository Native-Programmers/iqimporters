import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qbazar/models/category_model.dart';
import 'package:qbazar/repositories/categories/base_category_repository.dart';

class CategoryRepository extends BaseCategoryRepository {
  final FirebaseFirestore _firebaseFirestore;

  CategoryRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Categories>> getAllCategories() {
    return _firebaseFirestore
        .collection('categories')
        .where('active', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Categories.fromSnapshot(doc)).toList();
    });
  }
}
