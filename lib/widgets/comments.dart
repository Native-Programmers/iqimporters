import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String uid, date, comment, rating;
  const Comment(
      {Key? key,
      required this.uid,
      required this.date,
      required this.comment,
      required this.rating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.blue.withAlpha(95),
      ),
      width: (kIsWeb
          ? MediaQuery.of(context).size.width / 4
          : MediaQuery.of(context).size.width),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (uid.length > 5 ? '${uid.substring(0, 4)}***' : uid),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Container(
                child: rate(double.parse(rating)),
              ),
            ],
          ),
          const Divider(
            height: 5,
            color: Colors.transparent,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            height: 90,
            width: (kIsWeb
                    ? MediaQuery.of(context).size.width / 4
                    : MediaQuery.of(context).size.width) /
                1.1,
            child: SingleChildScrollView(
              child: Text(
                comment,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rate(double number) {
    if (number == 1) {
      return const Icon(
        Icons.sentiment_very_dissatisfied,
        color: Colors.red,
      );
    } else if (number == 2) {
      return const Icon(
        Icons.sentiment_dissatisfied,
        color: Colors.amber,
      );
    } else if (number == 3) {
      return const Icon(
        Icons.sentiment_neutral,
        color: Colors.amberAccent,
      );
    } else if (number == 4) {
      return const Icon(
        Icons.sentiment_satisfied,
        color: Colors.greenAccent,
      );
    } else if (number == 5) {
      return const Icon(
        Icons.sentiment_very_satisfied,
        color: Colors.green,
      );
    } else {
      return const Icon(
        Icons.sentiment_very_dissatisfied,
        color: Colors.grey,
      );
    }
  }
}
