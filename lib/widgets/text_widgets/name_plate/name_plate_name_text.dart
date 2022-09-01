import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/debug_border_widget.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class NamePlateNameText extends StatelessWidget {
  final String text;
  final Seat seat;

  const NamePlateNameText(this.text, this.seat);

  @override
  Widget build(BuildContext context) {
    final theme = context.read<AppTheme>();
    TextStyle style =
        AppDecorators.getNameplateStyle(theme: theme).copyWith(fontSize: 10.dp);
    if (seat.player != null && seat.player.playerFolded) {
      style = style.copyWith(color: Colors.grey[600]);
    }
    return DebugBorderWidget(
        color: Colors.blue,
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.center,
          child: Text(
            text,
            style: style,
          ),
        ));
  }
}
