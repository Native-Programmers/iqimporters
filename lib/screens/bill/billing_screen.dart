import 'package:flutter/material.dart';
import 'package:qbazar/widgets/widgets.dart';

class BillingScreen extends StatelessWidget {
  static const String routeName = '/billing';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const BillingScreen());
  }

  const BillingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Bill/Payment'),
      bottomNavigationBar: custom_btmbar(),
    );
  }
}
