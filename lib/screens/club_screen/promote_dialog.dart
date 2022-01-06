import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class PromoteDialog {
  /* method available to the outside */
  static Future<int> prompt({
    @required BuildContext context,
    @required String clubCode,
    @required String playerUuid,
    @required String name,
  }) async {
    final int ret = await showDialog<int>(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          AppTheme theme = AppTheme.getTheme(context);
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              content: PromoteDialogWidget(
                theme,
                clubCode,
                playerUuid,
                name,
              ),
            );
          });
        });
    return ret;
  }
}

class PromoteDialogWidget extends StatefulWidget {
  final AppTheme theme;
  final String clubCode;
  final String playerUuid;
  final String name;

  PromoteDialogWidget(
    this.theme,
    this.clubCode,
    this.playerUuid,
    this.name,
  );

  @override
  State<PromoteDialogWidget> createState() => _PromoteDialogWidgetState();
}

class _PromoteDialogWidgetState extends State<PromoteDialogWidget> {
  String notes;
  List<bool> isSelected = [];
  bool closed = false;

  @override
  void initState() {
    super.initState();
    isSelected.add(false);
    isSelected.add(true);
  }

  @override
  void dispose() {
    closed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Do you want to promote member?';
    return Container(
      // height: MediaQuery.of(context).size.height * 0.5,
      // margin: EdgeInsets.all(16),
      padding: EdgeInsets.only(bottom: 24, top: 8, right: 8, left: 8),
      decoration: AppDecorators.bgRadialGradient(widget.theme).copyWith(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: widget.theme.accentColor, width: 3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // sep
          SizedBox(height: 5.ph),
          Text(widget.name,
              style: AppDecorators.getHeadLine4Style(theme: widget.theme)),
          SizedBox(height: 5.ph),
          Text(
            title,
            style: TextStyle(
              fontSize: 10.dp,
            ),
          ),
          SizedBox(height: 5.ph),
          SizedBox(height: 5.ph),
          ToggleButtons(
            children: [
              Text('  Manager  ',
                  style: AppDecorators.getHeadLine5Style(theme: widget.theme)),
              Text('  Co-Owner  ',
                  style: AppDecorators.getHeadLine5Style(theme: widget.theme)),
            ],
            borderRadius: BorderRadius.all(Radius.circular(20)),
            isSelected: isSelected,
            selectedColor: Colors.black,
            fillColor: widget.theme.accentColor,
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < isSelected.length; i++) {
                  isSelected[i] = false;
                }
                isSelected[index] = true;
              });
            },
          ),
          SizedBox(height: 15.ph),

          /* yes / no button */
          Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /* no button */
                RoundRectButton(
                  onTap: () {
                    Navigator.pop(
                      context,
                      0,
                    );
                  },
                  text: "Cancel",
                  theme: widget.theme,
                ),

                /* divider */
                SizedBox(width: 5.ph),

                /* true button */
                RoundRectButton(
                  onTap: () {
                    if (isSelected[0]) {
                      // manager
                      Navigator.pop(
                        context,
                        1,
                      );
                    } else if (isSelected[1]) {
                      // co-owner
                      Navigator.pop(
                        context,
                        2,
                      );
                    }
                  },
                  text: "Promote",
                  theme: widget.theme,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
