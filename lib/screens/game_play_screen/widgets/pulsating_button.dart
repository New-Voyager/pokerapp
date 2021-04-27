import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';

class PulsatingCircleIconButton extends StatefulWidget {
  const PulsatingCircleIconButton({
    Key key,
    @required this.onTap,
    @required this.child,
  }) : super(key: key);

  final Function onTap;
  final Widget child;

  @override
  _PulsatingCircleIconButtonState createState() =>
      _PulsatingCircleIconButtonState();
}

class _PulsatingCircleIconButtonState extends State<PulsatingCircleIconButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween(begin: 0.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          return Container(
            padding: const EdgeInsets.all(12),
            /*  decoration: BoxDecoration(
              //color: Colors.red,
              border:
                  Border.all(color: AppColors.buttonBorderColor, width: 2.0),
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.red,
                  Colors.redAccent,
                ],
              ),
            ), */
            decoration: BoxDecoration(
              // color: Colors.yellow,
              gradient: RadialGradient(
                colors: [
                  Colors.red,
                  Colors.redAccent.shade200,
                ],
                radius: 0.5,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                // for (int i = 1; i <= 2; i++)
                BoxShadow(
                  color: Colors.red.withOpacity(_animationController.value),
                  spreadRadius: _animation.value * 5,
                )
              ],
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}
