import 'package:flutter/material.dart';

class JumpingTextWidget extends StatefulWidget {
  final String text;
  final Color color;
  final double jumpHeight;

  JumpingTextWidget({
    @required this.text,
    this.color = Colors.white,
    this.jumpHeight = 10,
  });

  @override
  _JumpingTextWidgetState createState() => _JumpingTextWidgetState();
}

class _JumpingTextWidgetState extends State<JumpingTextWidget> {
  Offset startOffset;
  Offset endOffset;

  @override
  void initState() {
    super.initState();

    startOffset = Offset.zero;
    endOffset = Offset(0, -widget.jumpHeight);
  }

  void onEnd() {
    // swap the start and end offset
    setState(() {
      Offset tmp = startOffset;
      startOffset = endOffset;
      endOffset = tmp;
    });
  }

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<Offset>(
        curve: Curves.easeInOut,
        onEnd: onEnd,
        duration: const Duration(milliseconds: 900),
        tween: Tween(begin: startOffset, end: endOffset),
        builder: (_, offset, child) => Transform.translate(
          offset: offset,
          child: child,
        ),
        child: Column(
          children: [
            // arrow
            Icon(Icons.keyboard_arrow_up, color: widget.color),

            // text
            Text(
              widget.text,
              style: TextStyle(color: widget.color),
            ),
          ],
        ),
      );
}
