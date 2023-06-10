import 'dart:math';

import 'package:uuid/uuid.dart';

class TextRefGenerator {
  static String txtRef = '';
  static var  uuid = Uuid();
static  String generateTransactionRef() {
    return uuid.v4();
  }

  static String generate() {
    final random = Random();
    txtRef = 'equbpayR${random.nextInt(200)}';

    return txtRef;
  }
}
