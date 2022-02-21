import 'package:qbazar/models/category_model.dart';

abstract class BaseCategoryRepository {
  Stream<List<Categories>> getAllCategories();
}
