import 'package:flutter/material.dart';

class DetailsMobile extends StatelessWidget {
  DetailsMobile(
      {Key? key,
      required this.status,
      required this.subtotal,
      required this.total,
      required this.uid})
      : super(key: key);
  String uid, total, subtotal, status;

  @override
  Widget build(BuildContext context) {
    final shadow = [
      BoxShadow(
        color: Colors.grey.shade500,
        blurRadius: 2.0,
        spreadRadius: 0.0,
        offset: const Offset(2.0, 2.0), // shadow direction: bottom right
      )
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
          margin: const EdgeInsets.symmetric(horizontal: 75),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.green,
              boxShadow: shadow),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'ORDER ID : ',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(uid,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
        const Divider(
          height: 10,
          color: Colors.transparent,
        ),
        Container(
          height: 20,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
          margin: const EdgeInsets.symmetric(horizontal: 75),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.green,
              boxShadow: shadow),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'SUB-TOTAL : ',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(subtotal,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
        const Divider(
          height: 10,
          color: Colors.transparent,
        ),
        Container(
          height: 20,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
          margin: const EdgeInsets.symmetric(horizontal: 75),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: shadow,
            color: Colors.green,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'TOTAL : ',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(total,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
        const Divider(
          height: 10,
          color: Colors.transparent,
        ),
        Container(
          height: 20,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
          margin: const EdgeInsets.symmetric(horizontal: 75),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.green,
              boxShadow: shadow),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'DELIVERY STATUS : ',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(status,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
        const Divider(
          height: 10,
          color: Colors.transparent,
        ),
      ],
    );
  }
}
