import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/utils/formatter.dart';

class PotsView extends StatelessWidget {
  final bool highlight;
  final double potChip;
  final bool isBoardHorizontal;
  final GlobalKey uiKey;

  PotsView({
    this.isBoardHorizontal,
    this.potChip,
    this.uiKey,
    this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    String potText = '';
    if (potChip == null || potChip == 0) {
      return SizedBox.shrink(key: uiKey);
    } else {
      potText = DataFormatter.chipsFormat(potChip);
    }

    return Container(
      decoration: BoxDecoration(),
      margin: EdgeInsets.only(right: 5.0),
      child: Stack(
        children: [
          // // This transparent child is used for chips pulling animation
          // Container(
          //   width: 10,
          //   height: 10,
          //   color: Colors.transparent,
          // ),

          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(
                color: highlight ? Colors.white : Colors.transparent,
              ),
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
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    potText,
                    style: AppStyles.itemInfoTextStyleHeavy.copyWith(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
