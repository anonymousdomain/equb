import 'dart:math';

class TextRefGenerator {
  static String txtRef = '';
  static String generate() {
    final random = Random();
    txtRef = 'equbpay-${random.nextInt(200)}';

    return txtRef;
  }
}
