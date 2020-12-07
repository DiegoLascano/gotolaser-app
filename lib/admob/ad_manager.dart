import 'dart:io';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-3940256099942544~4354546703';
      // appid de prueba
      return 'ca-app-pub-3940256099942544~3347511713';
    } else if (Platform.isIOS) {
      // return 'ca-app-pub-3940256099942544~2594085930';
      // appid de prueba
      return 'ca-app-pub-3940256099942544~3347511713';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-3940256099942544/8865242552';
      // ad de prueba
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      // return 'ca-app-pub-3940256099942544/4339318960';
      // ad de prueba
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-3940256099942544/7049598008';
      // ad de prueba
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      // return 'ca-app-pub-3940256099942544/3964253750';
      // ad de prueba
      return 'ca-app-pub-3940256099942544/4411468910';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-3940256099942544/2247696110';
      // ad de prueba
      return 'ca-app-pub-3940256099942544/2247696110';
    } else if (Platform.isIOS) {
      // return 'ca-app-pub-3940256099942544/3986624511';
      // ad de prueba
      return 'ca-app-pub-3940256099942544/3986624511';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      // return 'ca-app-pub-3940256099942544/8673189370';
      // ad de prueba
      return 'ca-app-pub-3940256099942544/5224354917';
    } else if (Platform.isIOS) {
      // return 'ca-app-pub-3940256099942544/7552160883';
      // ad de prueba
      return 'ca-app-pub-3940256099942544/2521693316';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
