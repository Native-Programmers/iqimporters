// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  Details(
      {Key? key,
      required this.status,
      required this.subtotal,
      required this.total,
      required this.uid})
      : super(key: key);
  String uid, total, subtotal, status;
  @override
  Widget build(BuildContext context) {
    const shadow = [
      BoxShadow(
        color: Colors.black,
        blurRadius: 2.0,
        spreadRadius: 0.0,
        offset: Offset(2.0, 2.0), // shadow direction: bottom right
      )
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.green,
              boxShadow: shadow),
          child: Row(
            children: [
              const Text(
                'ORDER ID : ',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(uid,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
        Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.green,
              boxShadow: shadow),
          child: Row(
            children: [
              const Text(
                'SUB-TOTAL : ',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(subtotal,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
        Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: shadow,
            color: Colors.green,
          ),
          child: Row(
            children: [
              const Text(
                'TOTAL : ',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(total,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
        Container(
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.green,
              boxShadow: shadow),
          child: Row(
            children: [
              const Text(
                'DELIVERY STATUS : ',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(status,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}
