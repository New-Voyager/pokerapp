// import 'package:flutter/material.dart';
//
// import 'package:pokerapp/models/game_play_models/business/player_model.dart';
// import 'hole_cards_view_and_footer_action_view.dart';
//
// class GameAction extends StatelessWidget {
//   final PlayerModel playerModel;
//   final bool showActionWidget;
//
//   const GameAction({Key key, this.playerModel, this.showActionWidget})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         playerModel != null
//             ? Positioned(
//                 top: 20.0,
//                 child: HoleCardsView(
//                   playerModel: playerModel,
//                   showActionWidget: showActionWidget,
//                 ),
//               )
//             : Container(),
//       ],
//     );
//   }
// }
