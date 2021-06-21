import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:provider/provider.dart';

class NumDiamondWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        children: [
          Consumer<GameState>(
            builder: (_, gs, __) =>
                Text('You have ${gs.gameHiveStore.getDiamonds()}'),
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
