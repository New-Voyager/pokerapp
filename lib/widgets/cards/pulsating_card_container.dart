import 'package:flutter/material.dart';

class PulsatingCardContainer extends StatefulWidget {
  final Widget child;
  final double height;
  final double width;
  final Color color;
  final double animationUpToWidth;

  PulsatingCardContainer({
    @required this.child,
    @required this.height,
    @required this.width,
    @required this.color,
    this.animationUpToWidth = 4.0,
  });

  @override
  _PulsatingCardContainerState createState() => _PulsatingCardContainerState();
}

class _PulsatingCardContainerState extends State<PulsatingCardContainer>
    with TickerProviderStateMixin {
  AnimationController _resizableController;

  @override
  void dispose() {
    _resizableController.stop(canceled: true);
    _resizableController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _resizableController = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _resizableController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _resizableController.reverse();
          break;
        case AnimationStatus.dismissed:
          _resizableController.forward();
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _resizableController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          /* main widget to display */
          widget.child,

          /* pulsating animation */
          AnimatedBuilder(
            animation: _resizableController,
            builder: (_, __) => Container(
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: widget.color,
                  width: _resizableController.value * widget.animationUpToWidth,
                ),
              ),
            ),
          ),
        ],
      );
}
