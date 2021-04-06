import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_styles.dart';

class PotsView extends StatelessWidget {
  final List<int> potChips;
  final bool isBoardHorizontal;
  final bool showDown;
  final Key chipKey;
  PotsView(this.isBoardHorizontal, this.potChips, this.showDown, this.chipKey);

  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity: showDown ||
                (potChips == null || potChips.length == 0 || potChips[0] == 0)
            ? 0
            : 1,
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
                key: chipKey,
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

                // todo: at later point might need to support multiple pots - need to design UI

                child: Text(
                  (potChips == null || potChips.length == 0)
                      ? '0'
                      : potChips[0].toString(),
                  style: AppStyles.itemInfoTextStyleHeavy.copyWith(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}
