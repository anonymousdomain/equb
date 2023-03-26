import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class Connection with ChangeNotifier {
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  bool _isFireInit = false;
  bool get isFireInit => _isFireInit;
  Connection() {
    initFirebase();

    checkInternetConectivity();
  }
  Future initFirebase() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isFireInit = true;
      notifyListeners();
    } catch (e) {
      print(e);
      _isFireInit = false;
      notifyListeners();
    }
  }

  Future<void> checkInternetConectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      _isConnected = false;
      notifyListeners();
    }
    Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        _isConnected = false;
        notifyListeners();
      } else {
        _isConnected = true;
        notifyListeners();
      }
    });
  }
}
