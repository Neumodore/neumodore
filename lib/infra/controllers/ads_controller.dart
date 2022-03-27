import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AdsController {
  String currentTarget;

  String myBanner;

  String myInterstitial;

  bool enabled = kReleaseMode && false;

  AdsController();

  showBanner() {}

  showInterstitial() {}
}
