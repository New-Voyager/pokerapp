import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/services/game_play/game_play_utils/buy_in_service.dart';
import 'package:pokerapp/widgets/round_button.dart';

class ChipBuyPopUp extends StatelessWidget {
  final String gameCode;
  final int maxBuyIn;
  final int minBuyIn;

  ChipBuyPopUp({
    @required this.gameCode,
    @required this.minBuyIn,
    @required this.maxBuyIn,
  }) : assert(minBuyIn != null && maxBuyIn != null);

  final TextEditingController _controller = TextEditingController();

  bool _valid(int amount) => minBuyIn <= amount && amount <= maxBuyIn;

  void _buy(BuildContext context) async {
    String amt = _controller.text.trim();

    if (amt.isEmpty) return;

    int amount = int.parse(amt);

    if (!_valid(amount)) return;

    // buy chips
    await BuyInService.buyIn(gameCode, amount);

    // finally close the dialog
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Buy In Chips'),
            TextField(
              controller: _controller,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: 'Amount ($minBuyIn - $maxBuyIn)',
              ),
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
