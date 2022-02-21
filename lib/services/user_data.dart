import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserData extends GetxController {
  StreamController streamController = StreamController();
  @override
  FutureOr onClose() {
    streamController.close();
  }
}
