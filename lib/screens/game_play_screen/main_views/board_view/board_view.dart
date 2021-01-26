import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/footer_result.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/models/game_play_models/ui/user_object.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/animations/animating_shuffle_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/stack_card_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/animating_widgets/card_distribution_animating_widget.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/board_view_util_methods.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/board_view_util_widgets.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/decorative_views/table_view.dart';
import 'package:pokerapp/screens/game_play_screen/user_view/user_view.dart';
import 'package:provider/provider.dart';

const _widthMultiplier = 0.78;
const _heightMultiplier = 1.40;

const _centerViewOffset = const Offset(0.0, 60.0);
const _cardDistributionInitOffset = const Offset(0.0, 90.0);
const _noOffset = const Offset(0.0, 0.0);

class BoardView extends StatelessWidget {
  BoardView({
    @required this.onUserTap,
    @required this.onStartGame,
  });

  final Function(int index) onUserTap;
  final Function() onStartGame;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double heightOfBoard = width * _widthMultiplier * _heightMultiplier;
    double widthOfBoard = width * _widthMultiplier;

    bool isBoardHorizontal = Provider.of<BoardAttributesObject>(
      context,
      listen: false,
    ).isOrientationHorizontal;

    if (isBoardHorizontal) {
      widthOfBoard = MediaQuery.of(context).size.width;
      heightOfBoard = MediaQuery.of(context).size.height / 4;
    }

    /* finally the view */
    return Stack(
      alignment: isBoardHorizontal ? Alignment.topCenter : Alignment.center,
      children: [
        // game board view
        TableView(
          heightOfBoard,
          widthOfBoard,
        ),

        Consumer<Players>(
          builder: (_, Players players, __) {
            // dealing with players
            PlayerModel tmp = players.players.firstWhere(
              (u) => u.isMe,
              orElse: () => null,
            );
            bool isPresent = tmp != null;

            return Transform(
              transform: BoardViewUtilMethods.getTransformationMatrix(
                isBoardHorizontal: isBoardHorizontal,
              ),
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isBoardHorizontal ? 20.0 : 10.0,
                  vertical: isBoardHorizontal ? 120 : 30,
                ),
                child: Stack(
                  alignment: isBoardHorizontal
                      ? Alignment.topCenter
                      : Alignment.center,
                  children: [
                    // position the users
                    ...BoardViewUtilMethods.getUserObjects(players.players)
                        .asMap()
                        .entries
                        .map(
                          (var u) => BoardViewUtilMethods.positionUser(
                            isBoardHorizontal: isBoardHorizontal,
                            user: u.value,
                            heightOfBoard: heightOfBoard,
                            widthOfBoard: widthOfBoard,
                            seatPos:
                                BoardViewUtilMethods.getAdjustedSeatPosition(
                              u.key,
                              isPresent,
                              tmp?.seatNo,
                            ),
                            isPresent: isPresent,
                            onUserTap: onUserTap,
                          ),
                        )
                        .toList(),

                    // center view
                    Consumer2<TableState, ValueNotifier<FooterStatus>>(
                      builder: (
                        _,
                        TableState tableState,
                        ValueNotifier<FooterStatus> valueNotifierFooterStatus,
                        __,
                      ) =>
                          Transform.translate(
                        offset:
                            isBoardHorizontal ? _centerViewOffset : _noOffset,
                        child: BoardViewUtilWidgets.buildCenterView(
                          isBoardHorizontal: isBoardHorizontal,
                          cards: tableState.cards,
                          potChips: tableState.potChips,
                          potChipsUpdates: tableState.potChipsUpdates,
                          tableStatus: tableState.tableStatus,
                          showDown: valueNotifierFooterStatus.value ==
                              FooterStatus.Result,
                          onStartGame: onStartGame,
                        ),
                      ),
                    ),

                    /* distributing card animation widgets */
                    Transform.translate(
                      offset: isBoardHorizontal
                          ? _cardDistributionInitOffset
                          : _noOffset,
                      child: CardDistributionAnimatingWidget(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
