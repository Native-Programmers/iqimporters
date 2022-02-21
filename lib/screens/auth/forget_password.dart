import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:qbazar/services/auth_service.dart';

var email = TextEditingController();
var password = TextEditingController();
bool hide = true;

class ForgetPassword extends StatefulWidget {
  static const String routeName = '/forget';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => ForgetPassword());
  }

  ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: Container(
        color: const Color(0xFFFFFFFF),
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 65),
                  child: CircleAvatar(
                    backgroundColor: const Color(0xFF454E5F),
                    child: Center(
                      child: SizedBox(
                          height: 120,
                          width: 130,
                          child: Image.asset('assets/images/logo.png')),
                    ),
                    maxRadius: 80,
                    minRadius: 80,
                  ),
                ),
                SizedBox(
                  width: (kIsWeb
                      ? MediaQuery.of(context).size.width / 3
                      : MediaQuery.of(context).size.width),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(5, 30, 5, 20),
                        child: Card(
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(
                                color: Colors.black12, width: 1),
                          ),
                          elevation: 5,
                          color: Colors.white,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.00),
                            ),
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Center(
                                  child: Text(
                                    "FORGET PASSWORD",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey,
                                        fontSize: 24,
                                        fontFamily: 'Gemun',
                                        letterSpacing: 2.0),
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 30),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          child: TextFormField(
                                              controller: email,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: const InputDecoration(
                                                focusColor:
                                                    Colors.lightBlueAccent,
                                                hintText: "Enter Email",
                                                label: Text("Email"),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                  color: Colors.black,
                                                )),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Email Address is required';
                                                }
                                                return null;
                                              }),
                                        ),
                                        const Divider(
                                          height: 25,
                                          color: Colors.transparent,
                                        ),
                                        SizedBox(
                                            height: 40,
                                            child: SignInButtonBuilder(
                                              text: 'Send Reset Link',
                                              icon: Icons.email,
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                        content: Text(
                                                            'Processing Data')),
                                                  );
                                                  await authService
                                                      .resetPassword(email.text)
                                                      .then((value) =>
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            const SnackBar(
                                                                content: Text(
                                                                    'Email Reset Link has been sent')),
                                                          ))
                                                      .onError((error,
                                                              stackTrace) =>
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          'Email not registered'))));
                                                }
                                              },
                                              backgroundColor:
                                                  Colors.blueGrey[700]!,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
