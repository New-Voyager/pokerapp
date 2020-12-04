import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerapp/widgets/round_button.dart';

class ChipAmountPopUp extends StatelessWidget {
  final titleText;

  ChipAmountPopUp({
    @required this.titleText,
  }) : assert(titleText != null);

  final TextEditingController _controller = TextEditingController();

  void _pop(BuildContext context) {
    String value = _controller.text;

    if (value.isEmpty) return;

    int amount = int.parse(value);

    Navigator.pop(context, amount);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(titleText),
            TextField(
              controller: _controller,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: 'Amount',
              ),
            ),
            RoundRaisedButton(
              color: Colors.black,
              onButtonTap: () => _pop(context),
              buttonText: 'Proceed',
            ),
          ],
        ),
      ),
    );
  }
}
