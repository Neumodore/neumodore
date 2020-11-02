import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uni_links/uni_links.dart';

class DeepLinkService {
  BehaviorSubject<Uri> uriSubjectReplay;
  StreamSubscription<Uri> _sub;

  DeepLinkService() {
    uriSubjectReplay = new BehaviorSubject<Uri>();
  }

  Future<Null> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // Parse the link and warn the user, if it is not correct,
      // but keep in mind it could be `null`.
      Uri initialLink = await getInitialUri();
      notifyListeners(initialLink);
    } on PlatformException catch (e) {
      // Handle exception by warning the user their action did not succeed
      // return?
      print(e);
    }
    // Attach a listener to the stream
    _sub = getUriLinksStream().listen((Uri uri) {
      notifyListeners(uri);
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });
  }

  void notifyListeners(Uri initialLink) {
    if (initialLink != null) {
      uriSubjectReplay.add(initialLink);
    }
  }
}
