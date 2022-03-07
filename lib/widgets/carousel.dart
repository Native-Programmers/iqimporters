import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  final String image;
  var type;
  Carousel({
    required this.image,
    required this.type,
  });
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          child: ClipRRect(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Stack(
                children: <Widget>[
                  Image.network(image,
                      fit: type,
                      height: (kIsWeb && (width > height) ? 500 : 215),
                      width: double.infinity),
                ],
              )),
        ),
      ],
    );
  }
}
