import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/game_state.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/debug_border_widget.dart';

import 'hole_card_view.dart';

class PlayerHoleCardView extends StatelessWidget {
  final CardObject card;
  final bool dim;
  final bool isCardVisible;
  final bool marked;
  final Function onMarkTapCallback;

  PlayerHoleCardView({
    @required this.card,
    this.onMarkTapCallback,
    this.marked = false,
    this.dim = false,
    this.isCardVisible = false,
  });

  Widget _buildCardUI(
    TextStyle cardTextStyle,
    TextStyle suitTextStyle,
    BuildContext context,
  ) {
    final gameState = GameState.getState(context);
    final cardAsset = SvgPicture.memory(gameState.assets
        .getHoleCard(card.cardNum, color: gameState.colorCards));
    //final cardAsset = SvgPicture.asset('assets/images/card_face/${card.cardNum}.svg');
    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        cardAsset,
        /* visible marker */
        CardEye(
          key: UniqueKey(),
          marked: marked,
          gameState: gameState,
          card: card,
        ),
      ],
    );
    //return Image.asset('assets/images/card_face/${card.cardNum}.png');
  }

  @override
  Widget build(BuildContext context) {
    final gameState = GameState.getState(context);
    final cardBackBytes = gameState.assets.getHoleCardBack();
    if (cardBackBytes == null) {
      return Container();
    }

    return HoleCardWidget(
      backCardBytes: cardBackBytes,
      highlight: false,
      card: card,
      dim: dim,
      shadow: true,
      isCardVisible: isCardVisible,
      cardBuilder: _buildCardUI,
      cardFace: isCardVisible ? CardFace.FRONT : CardFace.BACK,
    );
  }
}

class CardEye extends StatefulWidget {
  const CardEye({Key key, this.marked = false, this.card, this.gameState})
      : super(key: key);

  final bool marked;
  final CardObject card;
  final GameState gameState;

  @override
  State<CardEye> createState() => _CardEyeState();
}

class _CardEyeState extends State<CardEye> {
  GlobalKey _key = GlobalKey();

  var markedHeight;

  @override
  void initState() {
    super.initState();
    var cardWidth = widget.gameState.gameUIState.cardSize.width;
    markedHeight = cardWidth / 8.5;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = _key.currentContext.findRenderObject() as RenderBox;
      var position = box.localToGlobal(Offset(0, 0));
      widget.gameState.gameUIState.cardEyes[widget.card.cardNum] =
          Rect.fromLTWH(position.dx, position.dy, markedHeight, markedHeight);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: widget.gameState.gameUIState.cardSize.height / 2.5,
        // bottom: 30,
        left: widget.marked ? 8 : 12,
        child: DebugBorderWidget(
          color: Colors.transparent,
          child: Icon(
            Icons.visibility,
            key: _key,
            color: widget.marked ? Colors.green : Colors.grey,
            size: widget.marked ? markedHeight : markedHeight / 1.2,
          ),
        ));
  }
}
