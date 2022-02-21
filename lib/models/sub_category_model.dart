import 'package:cloud_firestore/cloud_firestore.dart';

class SubCategories {
  String name, imageUrl, catId, uid;
  SubCategories(
      {required this.imageUrl,
      required this.name,
      required this.uid,
      required this.catId});
  @override
  List<Object?> get props => [name, imageUrl, uid, catId];

  static SubCategories fromSnapShot(DocumentSnapshot snap) {
    SubCategories subCategories = SubCategories(
        imageUrl: snap['imageUrl'],
        name: snap['name'],
        uid: snap.id,
        catId: snap['uid']);
    return subCategories;
  }
}
