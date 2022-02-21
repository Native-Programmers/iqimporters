import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:restart_app/restart_app.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';

final toast = FToast();

class Error extends StatefulWidget {
  static const String routeName = '/errors';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const Error());
  }

  const Error({Key? key}) : super(key: key);

  @override
  _ErrorState createState() => _ErrorState();
}

class _ErrorState extends State<Error> {
  @override
  initState() {
    super.initState();
    toast.init(context);
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: (kIsWeb
                ? MediaQuery.of(context).size.width / 5
                : MediaQuery.of(context).size.width / 2),
            child: Image.asset(
              'assets/images/frustration.png',
              fit: BoxFit.contain,
            ),
          ),
          const Divider(
            height: 25,
            color: Colors.transparent,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: Colors.grey[400],
              ),
              const VerticalDivider(
                width: 25,
              ),
              Text(
                'PLEASE CHECK INTERNET CONNECTION',
                style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              )
            ],
          ),
          const Divider(
            height: 25,
            color: Colors.transparent,
          ),
          AnimatedButton(
            onPress: () {
              Restart.restartApp();
            },
            width: MediaQuery.of(context).size.width / 2.5,
            text: 'RESTART APP?',
            isReverse: true,
            selectedTextColor: Colors.black,
            transitionType: TransitionType.LEFT_TOP_ROUNDER,
            backgroundColor: Colors.black,
            selectedBackgroundColor: Colors.lightGreen,
            borderColor: Colors.white,
            textStyle: const TextStyle(
                fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
            borderWidth: 1,
          ),
          // ElevatedButton(
          //     onPressed: () {
          //       Restart.restartApp();
          //     },
          //     child: Text(
          //       'Restart Application',
          //       style: Theme.of(context)
          //           .textTheme
          //           .headline6!
          //           .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          //     ))
        ],
      ),
    );
  }

  void showToast() => toast.showToast(
      child: buildToast(),
      gravity: ToastGravity.SNACKBAR,
      fadeDuration: 100,
      toastDuration: const Duration(seconds: 3));

  Widget buildToast() => Container(
        decoration: const BoxDecoration(
          color: Colors.red,
        ),
        padding: const EdgeInsets.all(5.00),
        child: Row(
          children: const [
            Icon(
              Icons.error,
              color: Colors.white,
            ),
            VerticalDivider(
              width: 25,
              color: Colors.transparent,
            ),
            Text(
              'Error. Please check your connection',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
      );
}
