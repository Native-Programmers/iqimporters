import 'package:cloud_firestore/cloud_firestore.dart';

class Comments {
  String uid;
  String pid;
  String comment;
  String rating;
  String date;

  Comments({
    required this.comment,
    required this.pid,
    required this.uid,
    required this.rating,
    required this.date,
  });

  static Comments fromSnapShot(DocumentSnapshot snap) {
    Comments comments = Comments(
      comment: snap['comment'],
      pid: snap['product_id'],
      uid: snap['user_id'],
      rating: snap['rating'],
      date: snap['date'],
    );
    return comments;
  }
}
