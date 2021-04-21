import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_colors.dart';

class GlowButton extends StatefulWidget {
  final String text;
  GlowButton(this.text);

  @override
  _GlowButtonState createState() => _GlowButtonState();
}

class _GlowButtonState extends State<GlowButton> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  Container getContainer() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.buttonBorderColor, width: 2.0),
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Colors.red,
              Colors.redAccent,
            ],
          ),
          color: Colors.blueAccent, //Color.fromARGB(255, 27, 28, 30),
          boxShadow: [
            BoxShadow(
                color: Colors.blue, //Color.fromARGB(130, 237, 125, 58),
                blurRadius: _animation.value,
                spreadRadius: _animation.value)
          ]),
      child: Text(
        "BET",
        style: TextStyle(fontSize: 12, color: Colors.white),
      ),
    );
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 15.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getContainer();
  }
}
