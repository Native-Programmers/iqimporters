import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Banners extends Equatable {
  final String imageUrl;
  final String id;

  const Banners({
    required this.imageUrl,
    required this.id,
  });

  @override
  List<Object?> get props => [imageUrl];

  static Banners fromSnapshot(DocumentSnapshot snap) {
    Banners banner = Banners(id: snap.id, imageUrl: snap['imageUrl']);
    return banner;
  }

  static List<Banners> banner = [];
}
