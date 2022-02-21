import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qbazar/blocs/checkout/checkout_bloc.dart';
import 'package:qbazar/models/user.dart';
import 'package:qbazar/screens/auth/login.dart';
import 'package:qbazar/services/auth_service.dart';
import 'package:qbazar/widgets/widgets.dart';

class CheckoutScreen extends StatefulWidget {
  static const String routeName = '/checkout';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const CheckoutScreen());
  }

  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: const CustomAppBar(title: 'CHECK OUT'),
      bottomNavigationBar: BottomAppBar(
        child: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            if (state is CheckoutLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is CheckoutLoaded) {
              return StreamBuilder<Users?>(
                  stream: authService.user,
                  builder: (_, AsyncSnapshot<Users?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      final Users? user = snapshot.data;
                      return user != null
                          ? Container(
                              color: Colors.blueAccent,
                              // ignore: prefer_const_constructors
                              padding: EdgeInsets.symmetric(
                                  horizontal: (kIsWeb ? 100 : 50)),
                              width: (kIsWeb
                                  ? MediaQuery.of(context).size.width / 4
                                  : MediaQuery.of(context).size.width / 2),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                ),
                                child: Text(
                                  'ORDER NOW',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                onPressed: () {
                                  if (FirebaseAuth
                                      .instance.currentUser!.emailVerified) {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<CheckoutBloc>().add(
                                          ConfirmCheckout(
                                              checkout: state.checkout));
                                      context.read<CheckoutBloc>().close();
                                    } else {
                                      Get.snackbar('Error',
                                          'Complete form before submission');
                                    }
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Email Verification'),
                                            content: Row(
                                              children: [
                                                const Text(
                                                  'Your Email is not verified!',
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    FirebaseAuth
                                                        .instance.currentUser!
                                                        .sendEmailVerification()
                                                        .then((value) {
                                                      Get.snackbar('Email Sent',
                                                          'A verification link has been sent ${user.email}');
                                                    });
                                                  },
                                                  child: const Text(
                                                    'Click here to recieve verification link.',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.blueAccent),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                  }
                                },
                              ),
                            )
                          : (const Login());
                    } else {
                      return const Text(
                          "Something went wrong. Please try again");
                    }
                  });
            } else {
              return const Center(
                child: Text('Something went Wrong. Try Again!'),
              );
            }
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.00),
            child: BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                if (state is CheckoutLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is CheckoutLoaded) {
                  final authService = Provider.of<AuthService>(context);
                  CollectionReference users =
                      FirebaseFirestore.instance.collection('userinfo');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CUSTOMER INFORMATION',
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      _buildTextFormFiled((value) {
                        context
                            .read<CheckoutBloc>()
                            .add(UpdateCheckout(fullname: value));
                      }, context, 'Full Name'),
                      Padding(
                        padding: const EdgeInsets.all(8.00),
                        child: TextFormField(
                          style: Theme.of(context).textTheme.headline6,
                          initialValue:
                              FirebaseAuth.instance.currentUser!.email,
                          enabled: false,
                          decoration: InputDecoration(
                              labelText: "Email Address",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(0))),
                          onChanged: (value) {
                            context.read<CheckoutBloc>().add(UpdateCheckout(
                                email:
                                    FirebaseAuth.instance.currentUser!.email));
                          },
                        ),
                      ),
                      Text(
                        'DELIVERY INFORMATION',
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      _buildTextFormFiled((value) {
                        context
                            .read<CheckoutBloc>()
                            .add(UpdateCheckout(address: value));
                      }, context, 'Address'),
                      _buildTextFormFiled((value) {
                        context
                            .read<CheckoutBloc>()
                            .add(UpdateCheckout(city: value));
                      }, context, 'City'),
                      _buildTextFormFiled((value) {
                        context
                            .read<CheckoutBloc>()
                            .add(UpdateCheckout(zipcode: value));
                      }, context, 'City Zip Code'),
                      _buildTextFormFiled((value) {
                        context
                            .read<CheckoutBloc>()
                            .add(UpdateCheckout(country: value));
                      }, context, 'Country'),
                      _buildTextFormFiled((value) {
                        context
                            .read<CheckoutBloc>()
                            .add(UpdateCheckout(mobile_no: value));
                      }, context, 'Mobile phone.'),
                      const Divider(
                        height: 12.5,
                        color: Colors.transparent,
                      ),
                      Container(
                        color: Colors.black,
                        height: (kIsWeb ? 90 : 60),
                        width: (kIsWeb
                            ? MediaQuery.of(context).size.width / 4
                            : MediaQuery.of(context).size.width / 1),
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {},
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Select Payment Methods',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(color: Colors.white),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 12.5,
                        color: Colors.transparent,
                      ),
                      Text(
                        'ORDER SUMMARY',
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const OrderSummary(),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text("Something went wrong! Please try again"),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

Padding _buildTextFormFiled(
    Function(String)? onTextChanged, BuildContext context, String labelText) {
  return Padding(
    padding: const EdgeInsets.all(8.00),
    child: TextFormField(
      style: Theme.of(context).textTheme.headline6,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(0))),
      onChanged: onTextChanged,
    ),
  );
}
