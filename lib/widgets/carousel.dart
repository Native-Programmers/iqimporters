import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  final String image;
  Carousel({
    required this.image,
  });
  @override
  Widget build(BuildContext context) {
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
                      fit: (kIsWeb ? BoxFit.fill : BoxFit.cover),
                      height: (kIsWeb ? 500 : 215),
                      width: double.infinity),
                ],
              )),
        ),
      ],
    );
  }
}
