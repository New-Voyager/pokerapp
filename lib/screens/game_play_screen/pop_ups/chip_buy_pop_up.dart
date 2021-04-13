import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/screens/util_screens/numeric_keyboard.dart';
import 'package:pokerapp/services/game_play/graphql/game_service.dart';
import 'package:pokerapp/widgets/round_raised_button.dart';

class ChipBuyPopUp extends StatefulWidget {
  final String gameCode;
  final int maxBuyIn;
  final int minBuyIn;

  ChipBuyPopUp({
    @required this.gameCode,
    @required this.minBuyIn,
    @required this.maxBuyIn,
  }) : assert(minBuyIn != null && maxBuyIn != null);

  @override
  _ChipBuyPopUpState createState() => _ChipBuyPopUpState();
}

class _ChipBuyPopUpState extends State<ChipBuyPopUp> {
  String text;

  final TextEditingController _controller = TextEditingController();

  bool _valid(int amount) => widget.minBuyIn <= amount && amount <= widget.maxBuyIn;

  void _buy(BuildContext context) async {
    String amt = _controller.text.trim();

    if (amt.isEmpty) return;

    int amount = int.parse(amt);

    if (!_valid(amount)) return;

    // buy chips
    await GameService.buyIn(widget.gameCode, amount);

    // finally close the dialog
    Navigator.pop(context, true);
  }

  _onKeyboardTap(String value) {
    setState(() {
      text = text + value;
      _controller.text = text;
    });
  }            

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter the amount ${widget.minBuyIn} - ${widget.maxBuyIn}'),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              style: TextStyle(fontSize: 24),
              autofocus: true,
              showCursor: true,
              readOnly: false,
            ),                        
            RoundRaisedButton(
              color: Colors.black,
              onButtonTap: () => _buy(context),
              buttonText: 'Proceed',
            ),
          ],
        ),
      ),
    );
  }
}


Future<bool> showBuyinDialog(BuildContext context, GlobalKey<FormState> buyInKey, double minBuyIn, double maxBuyIn) async {
    bool ret = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
         return AlertDialog(
          content: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Form(
                key: buyInKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Enter the amount $minBuyIn - $maxBuyIn'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: Text("Buy In"),
                        onPressed: () {
                          if (buyInKey.currentState.validate()) {
                            buyInKey.currentState.save();
                          }
                          Navigator.of(context).pop(true);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }).then((exit) {
        if (exit == null) {
          ret = false;
          return;
        }
        ret = exit;
        if (ret) {
          // on submit
          // if buyin has timedout, then don't buyin 
          final gameState = GameState.getState(context);
          final me = gameState.me(context);
          log('Buyin dialog is submitted. ret: $ret');
          if (me.seatNo != null && me.seatNo != 0) {
            // buyin
          }          
        }
      });
    return ret;
}