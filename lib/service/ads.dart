import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:foodmenu_hdhardwork/utils/restaurant_template.dart';

class Ads {
  Ads._privateConstructor();
  static final Ads _instance = Ads._privateConstructor();

  factory Ads() {
    return _instance;
  }

  DateTime latestFullADShowDate;

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  init() {
    FirebaseAdMob.instance.initialize(
        appId: Platform.isAndroid
            ? RestaurantTemplate().admobAppIdAndroid
            : RestaurantTemplate().admobAppIdios);
  }

  BannerAd createBannerAd() {
    if (Platform.isAndroid) {
      return BannerAd(
        adUnitId: RestaurantTemplate().admobUnitIdAndroid,
        size: AdSize.banner,
        targetingInfo: androidTargetingInfo,
        listener: (MobileAdEvent event) {},
      );
    } else {
      return BannerAd(
        adUnitId: RestaurantTemplate().admobUnitIdIos,
        size: AdSize.smartBanner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {},
      );
    }
  }

  InterstitialAd createInterstitialAd() {
    if (Platform.isAndroid) {
      return InterstitialAd(
        adUnitId: RestaurantTemplate().admobFullScreenIdAndroid,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {},
      );
    } else {
      return InterstitialAd(
        adUnitId: RestaurantTemplate().admobFullScreenIDIos,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {},
      );
    }
  }

  void showBanner() {
    if (_bannerAd == null) {
      _bannerAd = createBannerAd();
    }

    // print('@@@ load @@@');
    _bannerAd.load().then((load) {
      // print('@@@ show @@@');
      _bannerAd.show(anchorType: AnchorType.bottom);
    });
  }

  void hideBanner() {
    _bannerAd?.dispose();
  }

  void showFullAd() {
    if (latestFullADShowDate?.day == DateTime.now().day) return;

    if (_interstitialAd == null) {
      _interstitialAd = createInterstitialAd();
      _interstitialAd
        ..load()
        ..show(
          anchorType: AnchorType.bottom,
          anchorOffset: 0.0,
          horizontalCenterOffset: 0.0,
        );

      latestFullADShowDate = DateTime.now();
    }
  }

  void hideFullAd() {
    _interstitialAd?.dispose();
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    // testDevices: <String>["5729E8A35C13BBBAD9E1DBE06F7B1DE2"],
    keywords: <String>['식당', '현대', '포항', '중공업', '조선', '부동산'],
    //contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: false,
  );

  static const MobileAdTargetingInfo androidTargetingInfo = MobileAdTargetingInfo(
    testDevices:  ['E4B200C7136AD0708A2BF1FA76A2E94B',
                  'C688FB9C0634F2E6FF40ADFF71711FFF',
                  '70D53A4C46EFEAAA47D76A37CA7499DA',
                  '5729E8A35C13BBBAD9E1DBE06F7B1DE2',
                  'E734400E3568F17063613BBF53A2D239'],
  );

  // double getMargin() {

  //   return Platform.isIOS ? 55 : 50;

  // }
}
