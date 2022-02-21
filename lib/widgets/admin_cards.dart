import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InfoCards extends StatelessWidget {
  String nature, info;
  InfoCards({Key? key, required this.nature, required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [Text(nature), Text(info)],
    ));
  }
}
