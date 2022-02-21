// ignore_for_file: camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qbazar/screens/cart/cart_screen.dart';
import 'package:qbazar/screens/orders/order_history.dart';
import 'package:qbazar/wrapper/wrapper.dart';

const int maxFailedLoadAttempts = 3;

class custom_btmbar extends StatefulWidget {
  const custom_btmbar({Key? key}) : super(key: key);

  @override
  _custom_btmbarState createState() => _custom_btmbarState();
}

class _custom_btmbarState extends State<custom_btmbar> {
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  @override
  void initState() {
    super.initState();
    ad();
  }

  Future<void> ad() async {
    return (kIsWeb ? null : (_createInterstitialAd()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GNav(
      backgroundColor: Colors.grey.withAlpha(5),
      rippleColor: Colors.grey[300]!,
      hoverColor: Colors.grey[100]!,
      gap: 8,
      activeColor: Colors.black,
      iconSize: 24,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      duration: const Duration(milliseconds: 400),
      tabBackgroundColor: Colors.grey[100]!,
      // ignore: prefer_const_literals_to_create_immutables
      tabs: [
        GButton(
          icon: FontAwesomeIcons.home,
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
          text: "Home",
        ),
        GButton(
          icon: FontAwesomeIcons.cartArrowDown,
          onPressed: () {
            Navigator.pushNamed(context, CartScreen.routeName);
          },
          text: "Cart",
        ),
        GButton(
          icon: (FirebaseAuth.instance.currentUser != null
              ? Icons.history
              : Icons.login),
          onPressed: () {
            (FirebaseAuth.instance.currentUser != null
                ? Get.toNamed(OrderHistory.routeName)
                : Get.toNamed(Wrapper.routeName));
          },
          text: (FirebaseAuth.instance.currentUser != null
              ? 'Order History '
              : 'Login'),
        )
      ],
    );
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: InterstitialAd.testAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
