import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/services/data/game_hive_store.dart';
import 'package:pokerapp/services/data/hive_models/player_state.dart';
import 'package:provider/provider.dart';

class NumDiamondWidget extends StatelessWidget {
  final GameHiveStore gameHiveStore;

  NumDiamondWidget(this.gameHiveStore);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Consumer<AppTheme>(
            builder: (_, theme, __) => Row(
              children: [
                //Text('You have '),
                Text(
                  '${playerState.diamonds}',
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
