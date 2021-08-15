import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/utils/formatter.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class PotsView extends StatelessWidget {
  final bool highlight;
  final bool dim;
  final double potChip;
  final bool isBoardHorizontal;
  final GlobalKey uiKey;
  final bool transparent;
  PotsView({
    this.isBoardHorizontal,
    this.potChip,
    this.uiKey,
    this.highlight,
    this.dim,
    this.transparent = false,
  });

  @override
  Widget build(BuildContext context) {
    bool isPotChipEmpty = potChip == null || potChip == 0;

    String potText = '';
    if (!isPotChipEmpty) {
      potText = DataFormatter.chipsFormat(potChip);
    }
    TextStyle potTextStyle = AppStylesNew.itemInfoTextStyleHeavy.copyWith(
      fontSize: 12.dp,
    );
    Color chipColor = Colors.yellow;
    if (dim ?? false) {
      potTextStyle = AppStylesNew.itemInfoTextStyleHeavy.copyWith(
        color: Colors.white24,
        fontSize: 12.dp,
      );
      chipColor = Colors.white24;
    }

    return Opacity(
      opacity: isPotChipEmpty ? 0.0 : 1.0,
      child: Container(
        decoration: BoxDecoration(),
        margin: EdgeInsets.only(right: 5.0),
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(
                  color: highlight ? Colors.white : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(10.0),
                color: this.transparent ? Colors.transparent : Colors.black26,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // chip image
                  Align(
                    key: uiKey,
                    alignment: Alignment.centerLeft,
                    child: SvgPicture.asset("assets/images/chip.svg",
                        width: 15.pw, height: 15.pw, color: chipColor),

                    // Image.asset(
                    //   'assets/images/chips.png',
                    //   height: 15.pw,
                    //   width: 15.pw,
                    // ),
                  ),

                  // pot amount text
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text(
                      potText,
                      style: potTextStyle,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
