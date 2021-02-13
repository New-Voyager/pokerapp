import 'package:flutter/material.dart';
import 'package:pokerapp/enums/game_play_enums/footer_status.dart';
import 'package:pokerapp/models/game_play_models/provider_models/players.dart';
import 'package:pokerapp/models/game_play_models/provider_models/table_state.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/animating_widgets/card_distribution_animating_widget.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/center_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/decorative_views/table_view.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/players_on_table_view.dart';
import 'package:pokerapp/screens/game_play_screen/player_view/animating_widgets/stack_switch_seat_animating_widget.dart';
import 'package:provider/provider.dart';

const _centerViewOffset = const Offset(0.0, 90.0);
const _cardDistributionInitOffset = const Offset(0.0, 90.0);
const _noOffset = const Offset(0.0, 0.0);

class BoardView extends StatelessWidget {
  BoardView({
    @required this.onUserTap,
    @required this.onStartGame,
  });

  final Function(int index) onUserTap;
  final Function() onStartGame;

  static Size dimensions(BuildContext context, bool isHorizontal) {
    var _widthMultiplier = 0.78;
    var _heightMultiplier = 2.0;
    double width = MediaQuery.of(context).size.width;
    double heightOfBoard = width * _widthMultiplier * _heightMultiplier;
    double widthOfBoard = width * _widthMultiplier;

    bool isBoardHorizontal = isHorizontal;

    if (isBoardHorizontal) {
      widthOfBoard = MediaQuery.of(context).size.width;
      heightOfBoard = MediaQuery.of(context).size.height / 2.5;
    }
    return Size(widthOfBoard, heightOfBoard);
  }

  @override
  Widget build(BuildContext context) {
    bool isBoardHorizontal = Provider.of<BoardAttributesObject>(
      context,
      listen: false,
    ).isOrientationHorizontal;
    var dimensions = BoardView.dimensions(context, isBoardHorizontal);
    var widthOfBoard = dimensions.width;
    var heightOfBoard = dimensions.height;

    /* finally the view */
    return Stack(
      alignment: Alignment.center,
      children: [
        // Container(
        //   color: Colors.red,
        //   width: MediaQuery.of(context).size.width,
        //   height: dimensions.height,
        // ),
        // game board view
        Align(
          alignment: Alignment.center,
          child: TableView(
            dimensions.height,
            dimensions.width,
          ),
        ),

        Consumer<Players>(builder: (
          BuildContext context,
          Players players,
          Widget child,
        ) {
          return PlayersOnTableView(
              players: players,
              isBoardHorizontal: isBoardHorizontal,
              widthOfBoard: widthOfBoard,
              heightOfBoard: heightOfBoard,
              onUserTap: onUserTap);
        }),

        // center view
        Align(
            alignment: Alignment.center,
            child: Consumer2<TableState, ValueNotifier<FooterStatus>>(
              builder: (
                _,
                TableState tableState,
                ValueNotifier<FooterStatus> valueNotifierFooterStatus,
                __,
              ) =>
                  Transform.translate(
                offset: isBoardHorizontal ? _centerViewOffset : _noOffset,
                child: CenterView(
                  isBoardHorizontal,
                  tableState.cards,
                  tableState.potChips,
                  double.parse(tableState.potChipsUpdates != null
                      ? tableState.potChipsUpdates.toString()
                      : '0.0'),
                  tableState.tableStatus,
                  valueNotifierFooterStatus.value == FooterStatus.Result,
                  onStartGame,
                ),
              ),
            )),

        /* distributing card animation widgets */
        Align(
          alignment: Alignment.center,
          child: Transform.translate(
            offset: isBoardHorizontal ? _cardDistributionInitOffset : _noOffset,
            child: CardDistributionAnimatingWidget(),
          ),
        ),

        /* this widget is used to show animating of stacks in case user changes seats */
        Align(
          child: StackSwitchSeatAnimatingWidget(),
        ),
      ],
    );
  }
}
