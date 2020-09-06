import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AdsController {
  MobileAdTargetingInfo currentTarget;

  BannerAd myBanner;

  InterstitialAd myInterstitial;

  bool enabled = true;

  AdsController() {
    if (enabled) {
      FirebaseAdMob.instance.initialize(
          appId: "ca-app-pub-2763884853307133~4059181894",
          analyticsEnabled: false);
      final String bannerAddId = kReleaseMode
          ? "ca-app-pub-2763884853307133/6657425079"
          : BannerAd.testAdUnitId;
      final String interstitialAddId = kReleaseMode
          ? "ca-app-pub-2763884853307133/7716367634"
          : BannerAd.testAdUnitId;
      currentTarget = MobileAdTargetingInfo(
        keywords: <String>[
          'productivity',
          'pomodore',
          'tasks',
          'time',
          'tracking',
          'timetracking'
        ],
        contentUrl: 'https://vinicios.dev',
        childDirected: false,
        testDevices: <
            String>[], // Android emulators are considered test devices
      );

      myBanner = BannerAd(
        // Replace the testAdUnitId with an ad unit id from the AdMob dash.
        // https://developers.google.com/admob/android/test-ads
        // https://developers.google.com/admob/ios/test-ads
        adUnitId: bannerAddId,
        size: AdSize.smartBanner,
        targetingInfo: currentTarget,
        listener: (MobileAdEvent event) {
          print("BannerAd event is $event");
        },
      );

      myInterstitial = InterstitialAd(
        // Replace the testAdUnitId with an ad unit id from the AdMob dash.
        // https://developers.google.com/admob/android/test-ads
        // https://developers.google.com/admob/ios/test-ads
        adUnitId: interstitialAddId,
        targetingInfo: currentTarget,
        listener: (MobileAdEvent event) {
          print("InterstitialAd event is $event");
        },
      );
    }
  }

  showBanner() {
    try {
      if (enabled) {
        myBanner
          // typically this happens well before the ad is shown
          ..load()
          ..show(
            // Positions the banner ad 60 pixels from the bottom of the screen
            anchorOffset: 20.0,
            // Positions the banner ad 10 pixels from the center of the screen to the right
            // Banner Position
            anchorType: AnchorType.bottom,
          );
      }
    } on PlatformException {
      return;
    } catch (e) {
      throw e;
    }
  }

  showInterstitial() {
    try {
      if (enabled) {
        myInterstitial
          ..load()
          ..show(
            anchorType: AnchorType.bottom,
            anchorOffset: 0.0,
            horizontalCenterOffset: 0.0,
          );
      }
    } on PlatformException {
      return;
    } catch (e) {
      throw e;
    }
  }
}
