import 'dart:developer';

import 'package:pokerapp/resources/app_constants.dart';

class TextFiltering {
  TextFiltering._();

  // TODO: we can instantiate this class and pass on the masked words on application start up

  static const maskedWords = AppConstants.maskedList;

  // takes in a sentence and returns back a sentence after filtering out possible words
  static String mask(String s) {
    for (final word in maskedWords) {
      s = s.replaceAll(RegExp(word, caseSensitive: false), '*' * word.length);
    }

    log('TextFiltering :: mask :: $s');

    return s;
  }
}
