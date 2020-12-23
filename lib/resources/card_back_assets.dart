import 'dart:math';

class CardBackAssets {
  CardBackAssets._();

  static String getRandomFromSet1() =>
      assets_set_1[Random().nextInt(assets_set_1.length)];

  static String getRandomFromSet2() =>
      assets_set_2[Random().nextInt(assets_set_2.length)];

  static String getRandom() => (assets_set_1 + assets_set_2)[
      Random().nextInt(assets_set_1.length + assets_set_2.length)];

  // set1
  static const String asset1_1 = 'assets/images/card_back/set1/Asset 1.svg';
  static const String asset1_2 = 'assets/images/card_back/set1/Asset 2.svg';
  static const String asset1_3 = 'assets/images/card_back/set1/Asset 3.svg';
  static const String asset1_4 = 'assets/images/card_back/set1/Asset 4.svg';
  static const String asset1_5 = 'assets/images/card_back/set1/Asset 5.svg';
  static const String asset1_6 = 'assets/images/card_back/set1/Asset 6.svg';
  static const String asset1_7 = 'assets/images/card_back/set1/Asset 7.svg';
  static const String asset1_8 = 'assets/images/card_back/set1/Asset 8.svg';
  static const String asset1_9 = 'assets/images/card_back/set1/Asset 9.svg';
  static const String asset1_10 = 'assets/images/card_back/set1/Asset 10.svg';
  static const String asset1_11 = 'assets/images/card_back/set1/Asset 11.svg';
  static const String asset1_12 = 'assets/images/card_back/set1/Asset 12.svg';

  static const List<String> assets_set_1 = [
    asset1_1,
    asset1_2,
    asset1_3,
    asset1_4,
    asset1_5,
    asset1_6,
    asset1_7,
    asset1_8,
    asset1_9,
    asset1_10,
    asset1_11,
    asset1_12,
  ];

  // set2
  static const String asset2_1 = 'assets/images/card_back/set2/Asset 1.svg';
  static const String asset2_2 = 'assets/images/card_back/set2/Asset 2.svg';
  static const String asset2_3 = 'assets/images/card_back/set2/Asset 3.svg';
  static const String asset2_4 = 'assets/images/card_back/set2/Asset 4.svg';
  static const String asset2_5 = 'assets/images/card_back/set2/Asset 5.svg';
  static const String asset2_6 = 'assets/images/card_back/set2/Asset 6.svg';
  static const String asset2_7 = 'assets/images/card_back/set2/Asset 7.svg';
  static const String asset2_8 = 'assets/images/card_back/set2/Asset 8.svg';

  static const List<String> assets_set_2 = [
    asset2_1,
    asset2_2,
    asset2_3,
    asset2_4,
    asset2_5,
    asset2_6,
    asset2_7,
    asset2_8,
  ];
}
