import 'package:flutter/material.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/screens/game_play_screen/main_views/board_view/decorative_views/table_view.dart';
import 'package:pokerapp/screens/layouts/delegates/poker_game_delegate.dart';
import 'package:pokerapp/screens/layouts/horizontal_layout/widgets/action_view.dart';
import 'package:pokerapp/screens/layouts/horizontal_layout/widgets/center_view_web.dart';
import 'package:pokerapp/screens/layouts/horizontal_layout/widgets/hole_cards_view.dart';
import 'package:pokerapp/screens/layouts/horizontal_layout/widgets/name_plate_view.dart';
import 'package:pokerapp/screens/layouts/horizontal_layout/widgets/players_on_table_view.dart';
import 'package:pokerapp/screens/layouts/horizontal_layout/widgets/table_image_view.dart';

class HorizontalLayoutDelegate extends PokerLayoutDelegate {
  @override
  Widget actionViewBuilder() {
    return const ActionView();
  }

  @override
  Widget tableBuilder(GameState gameState) {
    return TableView(gameState: gameState);
  }

  @override
  Widget centerViewBuilder(GameState gameState) {
    return WebCenterView(
      gameState: gameState,
    );
  }

  @override
  Widget holeCardsBuilder() {
    return HoleCardsView();
  }

  @override
  Widget playersOnTableBuilder(Size tableSize) {
    return PlayersOnTableView(tableSize: tableSize);
  }

  @override
  Widget tableImage() {
    return const TableImageView();
  }

  @override
  Widget namePlateBuilder() {
    return const NamePlateView();
  }
}
