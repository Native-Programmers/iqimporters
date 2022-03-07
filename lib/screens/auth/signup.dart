import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qbazar/services/auth_service.dart';

class SignUp extends StatefulWidget {
  static const String routeName = '/signup';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SignUp());
  }

  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  var con_password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: (kIsWeb && (width > height)
              ? MediaQuery.of(context).size.width / 3
              : MediaQuery.of(context).size.width),
          color: const Color(0xFFFFFFFF),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 50),
                      height: (kIsWeb && (width > height) ? 150 : 100),
                      width: (kIsWeb && (width > height) ? 150 : 100),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: const BorderSide(color: Colors.black12, width: 1),
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
                        child: SizedBox(
                          width: (kIsWeb
                              ? MediaQuery.of(context).size.width / 3
                              : MediaQuery.of(context).size.width),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  "SIGNUP HERE",
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
                                  autovalidateMode: AutovalidateMode.always,
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
                                        height: 20,
                                        color: Colors.transparent,
                                      ),
                                      SizedBox(
                                        child: TextFormField(
                                            controller: password,
                                            obscureText: true,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: const InputDecoration(
                                              focusColor:
                                                  Colors.lightBlueAccent,
                                              hintText: "Password",
                                              label: Text("Password"),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 0.5,
                                              )),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Password is required';
                                              }
                                              return null;
                                            }),
                                      ),
                                      const Divider(
                                        height: 20,
                                        color: Colors.transparent,
                                      ),
                                      SizedBox(
                                        child: TextFormField(
                                            controller: con_password,
                                            obscureText: true,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: const InputDecoration(
                                              focusColor:
                                                  Colors.lightBlueAccent,
                                              hintText: "Confirm Password",
                                              label: Text("Confirm Password"),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 0.5,
                                              )),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Confirm password is required';
                                              }
                                              return null;
                                            }),
                                      ),
                                      const Divider(
                                        height: 20,
                                        color: Colors.transparent,
                                      ),
                                      SizedBox(
                                        height: 40,
                                        child: SignInButtonBuilder(
                                          backgroundColor:
                                              Colors.blueGrey[700]!,
                                          text: 'Register with Email',
                                          icon: Icons.email,
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              if (password.text ==
                                                  con_password.text) {
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (_) =>
                                                        const AlertDialog(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          elevation: 0,
                                                          content:
                                                              SpinKitCubeGrid(
                                                            color: Colors
                                                                .blueAccent,
                                                          ),
                                                        ));
                                                await authService
                                                    .createUserWithEmailAndPassword(
                                                  email.text,
                                                  password.text,
                                                  context,
                                                )
                                                    .then((value) {
                                                  Navigator.pop(context);
                                                  email.text = '';
                                                  password.text = '';
                                                  con_password.text = '';
                                                  Navigator.pop(context);
                                                }).catchError((_) =>
                                                        // ignore: invalid_return_type_for_catch_error
                                                        Get.snackbar('Error',
                                                            'Unable to register user.',
                                                            backgroundColor:
                                                                Colors.red,
                                                            colorText:
                                                                Colors.white));
                                              } else {
                                                Navigator.pop(context);
                                                Get.snackbar('Error',
                                                    "Passwords don't match.",
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white);
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Center(
                                child: SizedBox(
                                  height: 40,
                                  child: SignInButton(
                                    Buttons.Google,
                                    onPressed: () async {
                                      await authService.handleSignIn();
                                    },
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 15,
                                color: Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already Registered? ",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 20,
                    color: Colors.transparent,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
