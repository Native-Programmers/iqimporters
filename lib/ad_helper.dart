import 'dart:io';

class AdHelper {
  static String get interstatialAdsId {
    if (Platform.isAndroid) {
      return "ca-app-pub-9116206011690172/7445341253";
    } else if (Platform.isIOS) {
      return "ca-app-pub-9116206011690172~5829007255";
    } else {
      throw UnsupportedError("Web Platform is not supported");
    }
  }
}
