import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/business/player_model.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_context.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';
import 'package:pokerapp/models/game_play_models/ui/board_attributes_object/board_attributes_object.dart';
import 'package:pokerapp/screens/game_play_screen/seat_view/player_view.dart';
import 'package:pokerapp/services/game_play/game_com_service.dart';
import 'package:provider/provider.dart';

class PlayersOnTableViewNew extends StatelessWidget {
  final Size tableSize;
  final Function(Seat seat) onUserTap;
  final GameComService gameComService;
  final GameState gameState;
  final int maxPlayers;

  PlayersOnTableViewNew({
    @required this.tableSize,
    @required this.onUserTap,
    @required this.gameComService,
    @required this.gameState,
    @required this.maxPlayers,
  });

  PlayerModel _findPlayerAtSeat(int seatNo) {
    for (final player in gameState.playersInGame)
      if (player.seatNo == seatNo) return player;

    return null;
  }

  List<Widget> _getPlayers(BuildContext context) {
    final gameState = context.read<GameState>();
    final boa = context.read<BoardAttributesObject>();
    final gco = context.read<GameContextObject>();

    final List<Widget> players = [];

    for (int seatNo = 1; seatNo <= maxPlayers; seatNo++) {
      final seat = gameState.seatPlayer(seatNo, _findPlayerAtSeat(seatNo));

      final playerView = PlayerView(
        seat: seat,
        onUserTap: onUserTap,
        gameComService: gameComService,
        boardAttributes: boa,
        gameContextObject: gco,
      );

      // final playerView = Container(
      //   color: Colors.amber,
      //   width: 100,
      //   height: 76.0,
      // );

      players.add(LayoutId(id: seat.seatPos, child: playerView));
    }

    return players;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: tableSize.width,
      height: tableSize.height,
      // color: Colors.red.withOpacity(0.50),
      child: CustomMultiChildLayout(
        delegate: PlayerPlacementDelegate(),
        children: _getPlayers(context),
      ),
    );
  }
}

class PlayerPlacementDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    // top left
    if (hasChild(SeatPos.topLeft)) {
      final cs = layoutChild(
        SeatPos.topLeft,
        BoxConstraints.loose(size),
      );
      print('topLeft: cs: $cs');

      positionChild(
        SeatPos.topLeft,
        Offset(0.0, -cs.width / 10),
      );
    }

    // top right
    if (hasChild(SeatPos.topRight)) {
      final cs = layoutChild(
        SeatPos.topRight,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.topRight,
        Offset(size.width - cs.width, -cs.width / 10),
      );
    }

    // middle left
    if (hasChild(SeatPos.middleLeft)) {
      final cs = layoutChild(
        SeatPos.middleLeft,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.middleLeft,
        Offset(0.0, size.height / 2 - cs.height / 1.5),
      );
    }

    // top center 1
    if (hasChild(SeatPos.topCenter1)) {
      final cs = layoutChild(
        SeatPos.topCenter1,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.topCenter1,
        Offset((size.width / 2) - cs.width / 2 - cs.width / 2, -cs.width / 5),
      );
    }

    // top center 2
    if (hasChild(SeatPos.topCenter2)) {
      final cs = layoutChild(
        SeatPos.topCenter2,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.topCenter2,
        Offset((size.width / 2) - cs.width / 2 + cs.width / 2, -cs.width / 5),
      );
    }

    // top center
    if (hasChild(SeatPos.topCenter)) {
      final cs = layoutChild(
        SeatPos.topCenter,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.topCenter,
        Offset((size.width / 2) - cs.width / 2, -cs.width / 5),
      );
    }

    // middle right
    if (hasChild(SeatPos.middleRight)) {
      final cs = layoutChild(
        SeatPos.middleRight,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.middleRight,
        Offset(size.width - cs.width, size.height / 2 - cs.height / 1.5),
      );
    }

    // bottom left
    if (hasChild(SeatPos.bottomLeft)) {
      final cs = layoutChild(
        SeatPos.bottomLeft,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.bottomLeft,
        Offset(
          (size.width / 2) - (cs.width / 2) - cs.width * 1.4,
          size.height - cs.height * 1.0,
        ),
      );
    }

    // bottom center
    if (hasChild(SeatPos.bottomCenter)) {
      final cs = layoutChild(
        SeatPos.bottomCenter,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.bottomCenter,
        Offset((size.width / 2) - cs.width / 2, size.height - cs.width * 0.70),
      );
    }

    // bottom right
    if (hasChild(SeatPos.bottomRight)) {
      final cs = layoutChild(
        SeatPos.bottomRight,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.bottomRight,
        Offset(
          (size.width / 2) - (cs.width / 2) + cs.width * 1.4,
          size.height - cs.height * 1.0,
        ),
      );
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}
