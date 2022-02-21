import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

TextEditingController comments = TextEditingController();

// ignore: must_be_immutable
class NewComments extends StatelessWidget {
  final String? uid, pid;
  var ratings = 3.00;
  NewComments({Key? key, required this.uid, required this.pid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.00),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: TextField(
              controller: comments,
              decoration: InputDecoration(
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ),
          RatingBar.builder(
            allowHalfRating: false,
            initialRating: 3,
            itemCount: 5,
            itemSize: (kIsWeb ? 35.00 : 15),
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return const Icon(
                    Icons.sentiment_very_dissatisfied,
                    color: Colors.red,
                  );
                case 1:
                  return const Icon(
                    Icons.sentiment_dissatisfied,
                    color: Colors.redAccent,
                  );
                case 2:
                  return const Icon(
                    Icons.sentiment_neutral,
                    color: Colors.amber,
                  );
                case 3:
                  return const Icon(
                    Icons.sentiment_satisfied,
                    color: Colors.lightGreen,
                  );
                case 4:
                  return const Icon(
                    Icons.sentiment_very_satisfied,
                    color: Colors.green,
                  );
                default:
                  return const Text("Something went wring");
              }
            },
            onRatingUpdate: (rating) {
              ratings = rating;
            },
          ),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
                onPressed: () {
                  createComment(
                          context: context,
                          uid: uid.toString(),
                          pid: pid.toString(),
                          comment: comments.text,
                          date: DateFormat('dd-MM-yyyy')
                              .format(DateTime.now())
                              .toString(),
                          rating: ratings.toString())
                      .then((value) => Navigator.pop(context));
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }

  Future<void> createComment(
      {required BuildContext context,
      required String uid,
      required String pid,
      required String comment,
      required String date,
      required String rating}) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection("comments").add({
      'comment': comment,
      'product_id': pid,
      'user_id': FirebaseAuth.instance.currentUser!.email,
      'rating': rating,
      'date': date
    }).then((value) {
      comments.clear();
      return ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment Added Successfully')),
      );
    }).onError((error, stackTrace) =>
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Unable to add comment. Check your connection')),
        ));
  }
}
