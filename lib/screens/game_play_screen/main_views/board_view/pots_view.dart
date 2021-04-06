import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_styles.dart';

class PotsView extends StatelessWidget {
  final double potChips;
  final bool isBoardHorizontal;
  final bool showDown;
  final GlobalKey uiKey;
  PotsView(this.isBoardHorizontal, this.potChips, this.showDown, this.uiKey);

  @override
  Widget build(BuildContext context) {
    bool showPot = !(showDown || (potChips == null || potChips == 0));
    String potText = '';
    if (potChips == null || potChips == 0) {
      potText = '0';
    } else {
      potText = potChips.toString();
    }
    return Stack(children: [
      // This transparent child is used for chips pulling animation
      Container(
        width: 10,
        height: 10,
        color: Colors.transparent,
      ),
      Opacity(
        opacity: showPot ? 1 : 0,
        child: Container(
          margin: EdgeInsets.only(bottom: 10.0),
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.black26,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // chip image
              Align(
                key: uiKey,
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
                  potText,
                  style: AppStyles.itemInfoTextStyleHeavy.copyWith(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }
}
