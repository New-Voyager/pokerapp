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
  final bool isLargerScreen;

  PlayersOnTableViewNew({
    @required this.tableSize,
    @required this.onUserTap,
    @required this.gameComService,
    @required this.gameState,
    @required this.maxPlayers,
    this.isLargerScreen = false,
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
      seat.serverSeatPos = seatNo;

      final playerView = Transform.scale(
        scale: isLargerScreen ? 1.3 : 1.0,
        child: ListenableProvider<Seat>(
          create: (_) => seat,
          builder: (_, __) => Consumer<Seat>(builder: (_, __, ___) {
            return PlayerView(
              seat: seat,
              onUserTap: onUserTap,
              gameComService: gameComService,
              boardAttributes: boa,
              gameContextObject: gco,
              gameState: gameState,
            );
          }),
        ),
      );

      players.add(LayoutId(id: seat.seatPos, child: playerView));
    }

    return players;
  }

  Size getPlayerOnTableSize() {
    // If larger screen, then allow the multichild layout to spread a little
    // If smaller screen devices, then squeeze the multichild layout
    // Otherwise, do not change the factor of the tableSize

    // in case of larger screens - let the multichild layout be placed extra 1.10 factor
    if (isLargerScreen)
      return Size(
        tableSize.width * 1.10,
        tableSize.height * 1.25,
      );

    // TODO: DO WE NEED A CASE FOR SMALLER SCREEN DEVICES?

    // normal case
    return Size(tableSize.width, tableSize.height * 1.70);
  }

  @override
  Widget build(BuildContext context) {
    final ts = getPlayerOnTableSize();
    Provider.of<SeatsOnTableState>(context, listen: true);
    return Container(
      // color for debugging
      // color: Colors.red.withOpacity(0.20),
      width: ts.width,
      height: ts.height,
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

      positionChild(
        SeatPos.topLeft,
        Offset(0.0, 0.0),
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
        Offset(size.width - cs.width, 0.0),
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
    // 3/8 th from the left
    if (hasChild(SeatPos.topCenter1)) {
      final cs = layoutChild(
        SeatPos.topCenter1,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.topCenter1,
        Offset((3 * size.width / 8) - cs.width / 2, 0.0),
      );
    }

    // top center 2
    // 5/8 th from the left
    if (hasChild(SeatPos.topCenter2)) {
      final cs = layoutChild(
        SeatPos.topCenter2,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.topCenter2,
        Offset((5 * size.width / 8) - cs.width / 2, 0.0),
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
        Offset((size.width / 2) - cs.width / 2, 0),
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
    // 3/16 th from left -> 0   1/8   3/16   1/4    1/2 ...................... 1
    if (hasChild(SeatPos.bottomLeft)) {
      final cs = layoutChild(
        SeatPos.bottomLeft,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.bottomLeft,
        Offset(
          (3 * size.width / 16) - (cs.width / 2),
          size.height - cs.height * 1.05,
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
        Offset((size.width / 2) - cs.width / 2, size.height - cs.height * 1.10),
      );
    }

    // bottom right
    // 13/16 th from left
    if (hasChild(SeatPos.bottomRight)) {
      final cs = layoutChild(
        SeatPos.bottomRight,
        BoxConstraints.loose(size),
      );

      positionChild(
        SeatPos.bottomRight,
        Offset(
          (13 * size.width / 16) - (cs.width / 2),
          size.height - cs.height * 1.05,
        ),
      );
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }
}
