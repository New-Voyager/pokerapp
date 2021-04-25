import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:pokerapp/resources/app_colors.dart';

class FilledPathPainter extends CustomPainter {
  FilledPathPainter({
    @required this.path,
    @required this.color,
    @required this.percent,
    @required this.progressPath,
  });

  final Path path;
  final Path progressPath;
  final Color color;
  final double percent;
  Matrix4 matrix4;

  @override
  bool shouldRepaint(FilledPathPainter oldDelegate) =>
      oldDelegate.path != path || oldDelegate.color != color;

  @override
  void paint(Canvas canvas, Size size) {
    // log('size:$size');
    final Rect pathBounds = path.getBounds();
    if (matrix4 == null) {
      matrix4 = Matrix4.identity();
      matrix4.scale(
          size.width / pathBounds.width, size.height / pathBounds.height);
    }

    final transformedPath = path.transform(matrix4.storage);

    canvas.drawPath(
        transformedPath,
        Paint()
          ..color = Color(0XFF494444)
          ..style = PaintingStyle.fill
          ..strokeWidth = 2);

    canvas.drawPath(
        transformedPath,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);

    Color progressColor = Colors.transparent;

    if (progressPath != null && percent > 0.0) {
      if (this.percent <= 0.50) {
        progressColor = Colors.greenAccent;
      } else if (this.percent <= 0.75) {
        progressColor = Colors.yellow;
      } else {
        progressColor = Colors.red;
      }

      // log('timerPath is not null');
      final timerPathTrans = progressPath.transform(matrix4.storage);
      canvas.drawPath(
          timerPathTrans,
          Paint()
            ..color = progressColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);
    }
  }

  @override
  bool hitTest(Offset position) => path.contains(position);
}

class PlateWidget extends StatefulWidget {
  final int currentProgress;
  final int total;
  final bool animate;
  final bool showProgress;
  PlateWidget(this.currentProgress, this.total,
      {this.animate = false, this.showProgress = false});

  @override
  _PlateWidgetState createState() {
    return _PlateWidgetState();
  }
}

class _PlateWidgetState extends State<PlateWidget>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  @override
  void dispose() {
    super.dispose();
    if (_animationController != null) {
      _animationController.dispose();
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.animate) {
      if (_animationController == null) {
        _animationController = AnimationController(
            vsync: this, duration: Duration(seconds: widget.total));
        if (widget.total != 0) {
          _animation = Tween(
                  begin: widget.currentProgress.toDouble(),
                  end: widget.total.toDouble())
              .animate(_animationController);
          _animation.addListener(() {
            setState(() {});
          });
          _animationController.forward();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // log('building nameplate: showProgress: ${widget.showProgress} currentProgress: ${widget.currentProgress} total: ${widget.total}');
    var path = parseSvgPathData('M 0,0 L100,0 L 100,100 L 0,100 L 0,0Z');
    var roundedPath =
        'M0,0 h200 a20,20 0 0 1 20,20 v200 a20,20 0 0 1 -20,20 h-200 a20,20 0 0 1 -20,-20 v-200 a20,20 0 0 1 20,-20 z';
    path = parseSvgPathData(roundedPath);

    Color borderColor = AppColors.plateBorderColor;
    double percent = 0.0;
    double progressLength = 0.0;
    Path progressPath;
    if (widget.animate) {
      if (_animation != null) {
        percent = _animation.value / widget.total.toDouble();
        progressLength = 1.0 - percent;
        progressPath =
            trimPath(path, progressLength, origin: PathTrimOrigin.end);
      }
    } else if (widget.showProgress) {
      percent = widget.currentProgress.toDouble() / widget.total.toDouble();
      progressLength = 1.0 - percent;
      progressPath = trimPath(path, progressLength, origin: PathTrimOrigin.end);
    }

    return CustomPaint(
      painter: FilledPathPainter(
        path: path,
        progressPath: progressPath,
        color: borderColor,
        percent: percent,
      ),
    );
  }
}
