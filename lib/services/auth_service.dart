import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qbazar/models/user.dart';
import 'dart:developer' as developer;

class AuthService {
  GoogleSignInAccount? googleAccount;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  Users? _userFromFirebase(auth.User? user) {
    if (user == null) {
      return null;
    }
    return Users(user.uid, user.email);
  }

  Stream<Users?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Future<Users?> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(credential.user);
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'Email entered is not registered',
            backgroundColor: Colors.red[300]);
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Invalid password.',
            backgroundColor: Colors.red[300]);
      }
    }
  }

  Future<void> verifyemail(User user) {
    return user.sendEmailVerification();
  }

  Future<void> phoneVerification(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<Users?> createUserWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: SpinKitWave());
          });
      await credential.user?.sendEmailVerification().then((_) {
        Navigator.of(context).pop(true);
        Get.snackbar('Verification', 'Please verify your email address.');
        return _userFromFirebase(credential.user);
      });

      // return _userFromFirebase(credential.user);
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar('Error', 'Password is too weak',
            backgroundColor: Colors.red, colorText: Colors.white);
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'Email is already registered',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Some error occured. Please check your internet connection!')),
      );
    }
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  //Google signin
  Future<void> handleSignIn() async {
    FirebaseAuth.instance.signOut();

    if (!kIsWeb) {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      try {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        final user =
            (await _firebaseAuth.signInWithCredential(credential)).user;

        developer.log("User credentails : " + googleAccount.toString());
      } catch (error) {
        // ignore: avoid_print
        print('Error: $error');
      }
    } else {
      signInWithGoogle();
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@gmail.com'});

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithPopup(googleProvider);
  }
}
