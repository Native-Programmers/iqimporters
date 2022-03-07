// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:qbazar/services/auth_service.dart';
import 'package:qbazar/widgets/restart.dart';
import 'package:restart_app/restart_app.dart';

var email = TextEditingController();
var password = TextEditingController();
bool hide = true;

class Login extends StatefulWidget {
  static const String routeName = '/login';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const Login());
  }

  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  var remember = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 50),
                    height: (kIsWeb && (width > height) ? 150 : 100),
                    width: (kIsWeb && (width > height) ? 150 : 100),
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                SizedBox(
                  width: (kIsWeb && (width > height)
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
                                    "LOGIN HERE",
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
                                          height: 20,
                                          color: Colors.transparent,
                                        ),
                                        SizedBox(
                                          child: TextFormField(
                                              controller: password,
                                              textInputAction:
                                                  TextInputAction.done,
                                              obscureText: hide,
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      hide = !hide;
                                                    });
                                                  },
                                                  icon: Icon(hide
                                                      ? Icons.visibility
                                                      : Icons.visibility_off),
                                                ),
                                                focusColor:
                                                    Colors.lightBlueAccent,
                                                hintText: "Password",
                                                label: const Text("Password"),
                                                border:
                                                    const OutlineInputBorder(
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
                                          height: 10,
                                          color: Colors.transparent,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/forget');
                                            },
                                            child: const Text(
                                              "Forgot Password ?",
                                              style: TextStyle(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          height: 20,
                                          color: Colors.transparent,
                                        ),
                                        SizedBox(
                                            height: 40,
                                            child: SignInButtonBuilder(
                                              text: 'Sign in with Email',
                                              icon: Icons.email,
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
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
                                                      .signInWithEmailAndPassword(
                                                    email.text,
                                                    password.text,
                                                    context,
                                                  )
                                                      .then((value) {
                                                    Navigator.pop(context);
                                                    email.text = '';
                                                    password.text = '';
                                                    RestartWidget.restartApp(
                                                        context);
                                                    Restart.restartApp();
                                                  }).onError(
                                                          (error, stackTrace) {
                                                    Navigator.pop(context);

                                                    Get.snackbar('Error',
                                                        error.toString());
                                                  });
                                                }
                                              },
                                              backgroundColor:
                                                  Colors.blueGrey[700]!,
                                            )),
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
                                        await authService
                                            .handleSignIn()
                                            .then((value) {
                                          RestartWidget.restartApp(context);
                                        });
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
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text(
                          "Register Now",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
