import 'package:flutter/material.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';

class CenterButtonView extends StatelessWidget {
  void _onResumePress() {}

  void _onTerminatePress() {}

  void _onRearrangeSeatsPress() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.black.withOpacity(0.50),
      ),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          CustomTextButton(
            text: 'Resume',
            onTap: _onResumePress,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: CustomTextButton(
              text: 'Terminate',
              onTap: _onTerminatePress,
            ),
          ),
          CustomTextButton(
            split: true,
            text: 'Rearrange Seats',
            onTap: _onRearrangeSeatsPress,
          ),
        ],
      ),
    );
  }
}
