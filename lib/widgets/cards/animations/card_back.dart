import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'dart:typed_data';

class CardBack {
  final GlobalKey<_CardBackWidgetState> _key = GlobalKey();
  Uint8List cardBackBytes;
  double dx;
  double dy;

  double xTarget;
  double yTarget;

  /* delay in milliseconds */
  int delay;

  CardBack({
    @required this.xTarget,
    @required this.yTarget,
    @required this.cardBackBytes,
    this.dx = 0,
    this.dy = 0,
    this.delay = 0,
  });

  void animate() => _key.currentState?.animate();
  void animateReverse() => _key.currentState?.animateReverse();
  void animateDispose() => _key.currentState?.animateDispose();

  double getNewDx() => _key.currentState.getNewDx();
  double getNewDy() => _key.currentState.getNewDy();

  Widget get widget => _CardBackWidget(
        key: _key,
        cardBack: this,
      );
}

class _CardBackWidget extends StatefulWidget {
  final CardBack cardBack;
  _CardBackWidget({
    Key key,
    this.cardBack,
  }) : super(key: key);

  @override
  _CardBackWidgetState createState() => _CardBackWidgetState();
}

class _CardBackWidgetState extends State<_CardBackWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  double getNewDx() =>
      widget.cardBack.dx +
      (_animation.value * (widget.cardBack.dx + widget.cardBack.xTarget));

  double getNewDy() =>
      widget.cardBack.dy +
      (_animation.value * (widget.cardBack.dy + widget.cardBack.yTarget));

  void animate() =>
      Future.delayed(Duration(milliseconds: widget.cardBack.delay)).then((_) {
        if (_controller == null) {
          return;
        }
        _controller.forward();
      });

  void animateReverse() => _controller.reverse();

  void animateDispose() => _controller.dispose();

  Widget _buildCardBack({
    double dx,
    double dy,
  }) =>
      Transform.translate(
        offset: Offset(
          dx,
          dy,
        ),
        child: Container(
          height: AppDimensions.cardHeight,
          width: AppDimensions.cardWidth,
          decoration: BoxDecoration(
//            boxShadow: [
//              const BoxShadow(
//                color: Colors.black12,
//                blurRadius: 0.10,
//                offset: Offset(-2.0, 2.0),
//              )
//            ],
              ),
          child: Image.memory(
            widget.cardBack.cardBackBytes,
          ),
        ),
      );

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: AppConstants.cardShufflingAnimationDuration,
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutQuad,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => _buildCardBack(
        dx: getNewDx(),
        dy: getNewDy(),
      ),
    );
  }
}
