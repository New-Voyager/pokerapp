import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_styles.dart';

class FooterView extends StatelessWidget {
  Widget _buildRoundButton({
    String text = 'Button',
    Function onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Container(
          height: 80.0,
          width: 80.0,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xff319ffe),
              width: 2.0,
            ),
          ),
          child: Center(
            child: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: AppStyles.clubItemInfoTextStyle.copyWith(
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      );

  void _fold() {}

  void _call100() {}

  void _raise() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildRoundButton(text: 'Fold', onTap: _fold),
          _buildRoundButton(
            text: 'call 100',
            onTap: _call100,
          ),
          _buildRoundButton(
            text: 'raise',
            onTap: _raise,
          ),
        ],
      ),
    );
  }
}
