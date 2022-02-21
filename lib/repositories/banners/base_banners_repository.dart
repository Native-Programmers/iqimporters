import 'package:qbazar/models/models.dart';

abstract class BaseBannersRepository {
  Stream<List<Banners>> getAllBanners();
}
