import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:provider/provider.dart';

class NumDiamondWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Consumer2<GameState, AppTheme>(
            builder: (_, gs, theme, __) => Row(
              children: [
                //Text('You have '),
                Text(
                  '${gs.gameHiveStore.getDiamonds()}',
                  style: AppDecorators.getHeadLine3Style(theme: theme)
                      .copyWith(color: theme.accentColor),
                ),
              ],
            ),
          ),

          // sep
          SizedBox(width: 5.0),

          SvgPicture.asset(
            AppAssets.diamond,
            width: 22.0,
            color: Colors.cyan,
          ),
        ],
      );
}
