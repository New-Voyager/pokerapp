import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_dimenstions_new.dart';
import 'package:pokerapp/screens/club_screen/club_action_screens/club_member_detailed_view/club_member_detailed_view.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/profile_popup.dart';
import 'package:pokerapp/widgets/custom_icon_button.dart';
import 'package:pokerapp/widgets/num_diamond_widget.dart';
import 'package:provider/provider.dart';

class NamePlateDailog extends StatefulWidget {
  final GameState gameState;
  const NamePlateDailog({Key key, this.gameState}) : super(key: key);

  @override
  _NamePlateDailogState createState() => _NamePlateDailogState();
}

class _NamePlateDailogState extends State<NamePlateDailog> {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.getTheme(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Cnu Federer",
              style: AppDecorators.getHeadLine3Style(theme: theme),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconAndTitleWidget(
                icon: Icons.ac_unit,
                text: "Kick",
                onTap: () {},
                child: CircleAvatar(
                  child: Icon(
                    Icons.exit_to_app,
                    color: theme.primaryColorWithDark(),
                  ),
                  backgroundColor: theme.accentColor,
                ),
              ),
              AppDimensionsNew.getHorizontalSpace(16),
              IconAndTitleWidget(
                icon: Icons.ac_unit,
                text: "Host",
                onTap: () {},
                child: CircleAvatar(
                  child: Icon(
                    Icons.horizontal_split_outlined,
                    color: theme.primaryColorWithDark(),
                  ),
                  backgroundColor: theme.accentColor,
                ),
              ),
              AppDimensionsNew.getHorizontalSpace(16),
              IconAndTitleWidget(
                icon: Icons.ac_unit,
                text: "Mute",
                onTap: () {},
                child: CircleAvatar(
                  child: Icon(
                    Icons.volume_mute,
                    color: theme.primaryColorWithDark(),
                  ),
                  backgroundColor: theme.accentColor,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Avaialable diamonds : 12")],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // diamond widget
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     IconButton(
              //       onPressed: () => Navigator.of(context).pop(),
              //       icon: Icon(
              //         Icons.cancel,
              //         color: theme.accentColor,
              //       ),
              //     ),
              //     Consumer<ValueNotifier<bool>>(
              //         builder: (_, __, ___) =>
              //             NumDiamondWidget(widget.gameState.gameHiveStore)),
              //   ],
              // ),

              // sep
              const SizedBox(height: 8.0),
              /* hand number */

              ProfilePopup(),
              AppDimensionsNew.getVerticalSizedBox(16),

              // show REVEAL button / share button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                    "Note : For each animation, 2 diamonds will be deducted!"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
