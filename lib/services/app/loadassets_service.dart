import 'dart:developer';

import 'package:flutter_svg/flutter_svg.dart';


class LoadAssets {
  loadCards() async {
    for(int i = 1; i <= 200; i++) {
      String card = 'assets/images/card_face/{i}.svg';
      try {
        log('Loading $card');
        SvgPicture.asset(card);
        log('Loaded $card');
      } catch(err) {
        log('Failed to load $card');
      }
    }
  }

  load() {
    loadCards();
  }
}

LoadAssets assetLoader = LoadAssets();