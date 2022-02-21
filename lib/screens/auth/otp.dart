import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum Status { Waiting, Error }

class PhoneAuth extends StatefulWidget {
  static const String routeName = '/auth';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const PhoneAuth());
  }

  const PhoneAuth({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final TextEditingController mobile = TextEditingController();
  final TextEditingController otp = TextEditingController();
  var _status = Status.Waiting;
  var verificationId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phone Verification"),
      ),
      body: Column(
        children: [
          const Text("Please Enter Mobile Number"),
          TextFormField(
            controller: mobile,
          ),
          ElevatedButton(
            onPressed: () {
              phonefetch(mobile.text);
            },
            child: const Text("Send Verification Code"),
          ),
          TextFormField(
            controller: otp,
          ),
        ],
      ),
    );
  }

  Future<void> phoneVerify() async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otp.text.toString());
  }

  Future<void> phonefetch(String phone) async {
    if (kDebugMode) {
      print("HELLO");
    }
    if (!kIsWeb) {
      FirebaseAuth.instance.currentUser?.uid;
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phone.toString(),
          timeout: (const Duration(seconds: 60)),
          verificationCompleted: (PhoneAuthCredential credentials) {
            if (kDebugMode) {
              print("Phone Number verified");
              print("credentails");
            }
          },
          verificationFailed: (FirebaseException e) {
            if (kDebugMode) {
              print("Verification Failed");
              print("Codes of exceptions " + e.code);
            }
          },
          codeSent: (String verificationId, int? resendingToken) async {
            setState(() {
              this.verificationId = verificationId;
            });
            print(phone + "  " + resendingToken.toString());
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            this.verificationId = verificationId;
          });
    } else {
      await FirebaseAuth.instance.signInWithPhoneNumber(phone);
    }
  }
}
