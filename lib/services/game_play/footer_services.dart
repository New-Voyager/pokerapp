import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/game_info_model.dart';
import 'package:pokerapp/screens/game_play_screen/pop_ups/chip_buy_pop_up.dart';
import 'package:provider/provider.dart';

class FooterServices {
  FooterServices._();

  /*
  * BUY IN
  * Method that invokes a graphQL API for buying more chips
  * */
  static void promptBuyIn({
    @required BuildContext context,
  }) async {
    assert(context != null);

    GameInfoModel _gameInfoModel = Provider.of<ValueNotifier<GameInfoModel>>(
      context,
      listen: false,
    ).value;

    bool status = await showDialog(
      context: context,
      builder: (context) => ChipBuyPopUp(
        gameCode: _gameInfoModel.gameCode,
        minBuyIn: _gameInfoModel.buyInMin,
        maxBuyIn: _gameInfoModel.buyInMax,
      ),
    );

    // // change the footer view, if buy in is successful
    // if (status == true)
    //   Provider.of<ValueNotifier<FooterStatus>>(
    //     context,
    //     listen: false,
    //   ).value = FooterStatus.None;
  }
}
