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
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                height: 30,
                width: 70,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: highlight ? Colors.white : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                  // color: this.transparent ? Colors.transparent : Colors.black26,
                  color: Colors.black,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset("assets/images/chip.svg",
                              width: 12, height: 12, color: chipColor),
                          SizedBox(width: 2),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                potText == '' ? '0' : potText,
                                style: potTextStyle,
                                maxLines: 1,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )

                //   child: Expanded(
                //       child: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       // chip image
                //       // FittedBox(
                //       //   key: uiKey,
                //       //   alignment: Alignment.centerLeft,
                //       //   child: SvgPicture.asset("assets/images/chip.svg",
                //       //       width: 16.pw, height: 16.pw, color: chipColor),
                //       // ),

                //       // pot amount text

                //       Flexible(
                //           child: FittedBox(
                //               fit: BoxFit.scaleDown,
                //               child: Text(
                //                 potText,
                //                 style: potTextStyle,
                //               ))),
                //     ],
                //   )),
                )
          ],
        ),
      ),
    );
  }
}
