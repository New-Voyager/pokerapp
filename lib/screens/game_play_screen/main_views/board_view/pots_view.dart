import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_styles.dart';

class PotsView extends StatelessWidget {
  final List<int> potChips;
  final bool isBoardHorizontal;
  final bool showDown;
  PotsView(this.isBoardHorizontal, this.potChips, this.showDown);

  @override
  Widget build(BuildContext context) {
    if (potChips == null || potChips.length == 0 || potChips[0] == 0) {
      return SizedBox.shrink();
    }

    return // pot value
        Opacity(
      opacity: showDown ? 0 : 1,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.black26,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // chip image
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/images/chips.png',
                height: 15.0,
              ),
            ),

            // pot amount text
            Padding(
              padding: const EdgeInsets.only(
                right: 15.0,
                top: 5.0,
                bottom: 5.0,
                left: 5.0,
              ),
              child: Text(
                '${potChips[0]}', // todo: at later point might need to show multiple pots - need to design UI
                style: AppStyles.itemInfoTextStyleHeavy.copyWith(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
