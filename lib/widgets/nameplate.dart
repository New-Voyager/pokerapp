import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_drawing/path_drawing.dart';

class Nameplate extends StatelessWidget {
  final int remainingTime;
  final int totalTime;
  final String svg;
  final String progressPath;
  final Size size;
  final Size progressRatio;

  Nameplate.fromSvgString({
    Key key,
    @required this.remainingTime,
    @required this.totalTime,
    @required this.svg,
    @required this.progressPath,
    @required this.size,
    @required this.progressRatio,
  }) : super(key: key) {
    assert(svg != null &&
        size != null &&
        remainingTime != null &&
        totalTime != null);
  }

// 1463 500
  @override
  Widget build(BuildContext context) {
    final path = parseSvgPathData(progressPath);
    log('Path view box boundary: ${path.getBounds()}');
    Widget progressWidget = Container();
    if (totalTime != 0) {
      progressWidget = SizedBox(
        width: size.width,
        height: size.height,
        child: FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          clipBehavior: Clip.hardEdge,
          child: SizedBox.fromSize(
            size: Size(size.width, size.height),
            child: PlateWidget(
              progressPath,
              remainingTime,
              totalTime,
              progressRatio,
              animate: true,
              showProgress: true,
            ),
          ),
        ),
      );
    }
    return Container(
      width: size.width,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // svg
          SvgPicture.string(
            svg,
            width: size.width,
            height: size.height,
          ),
          progressWidget,
        ],
      ),
    );
  }
}

class FilledPathPainter extends CustomPainter {
  FilledPathPainter({
    @required this.path,
    @required this.color,
    @required this.fillColor,
    @required this.percent,
    @required this.progressPath,
    @required this.progressRatio,
  });

  final Path path;
  final Path progressPath;
  final Color color;
  final double percent;
  final Color fillColor;
  final Size progressRatio;
  Matrix4 matrix4;

  @override
  bool shouldRepaint(FilledPathPainter oldDelegate) =>
      oldDelegate.path != path || oldDelegate.color != color;

  /// Scales a [Canvas] to a given [viewBox] based on the [desiredSize]
  /// of the widget.
  void scaleCanvasToViewBox(
    Canvas canvas,
    Size desiredSize,
    Rect viewBox,
  ) {
    if (desiredSize != viewBox.size) {
      final double scale = math.min(
        desiredSize.width / viewBox.width,
        desiredSize.height / viewBox.height,
      );
      final Size scaledHalfViewBoxSize = viewBox.size * scale / 2.0;
      final Size halfDesiredSize = desiredSize / 2.0;
      final Offset shift = Offset(
        halfDesiredSize.width - scaledHalfViewBoxSize.width,
        halfDesiredSize.height - scaledHalfViewBoxSize.height,
      );
      canvas.translate(shift.dx, shift.dy);
      canvas.scale(scale, scale);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect pathBounds = path.getBounds();
    final transformedPath = path;
    Size viewBoxSize = Size(
        size.width * progressRatio.width, size.height * progressRatio.height);

    // print(
    //     'Path bounds: $pathBounds, viewBoxSize: $viewBoxSize Canvas Size: $size');

    double aspectRat = pathBounds.width / pathBounds.height;

    print(aspectRat);

    scaleCanvasToViewBox(
      canvas,
      viewBoxSize,
      pathBounds,
    );

    canvas.drawPath(
        transformedPath,
        Paint()
          ..color = fillColor
          ..style = PaintingStyle.fill
          ..strokeWidth = 5);

    canvas.drawPath(
        transformedPath,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5);

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
      final timerPathTrans = progressPath;
      canvas.drawPath(
          timerPathTrans,
          Paint()
            ..color = Colors.red
            ..style = PaintingStyle.stroke
            ..strokeWidth = 20);
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
  final Size progressRatio;
  //final Path path;
  final String progressPath;

  PlateWidget(
    this.progressPath,
    this.currentProgress,
    this.total,
    this.progressRatio, {
    this.animate = false,
    this.showProgress = false,
  });

  @override
  _PlateWidgetState createState() {
    return _PlateWidgetState();
  }
}

class _PlateWidgetState extends State<PlateWidget>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  Path path;

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
    this.path = parseSvgPathData(widget.progressPath);

    if (widget.total != 0) {
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
  }

  @override
  Widget build(BuildContext context) {
    var path = parseSvgPathData(widget.progressPath);

    Color borderColor = Colors.green;
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
      progressLength += percent;
      progressPath =
          trimPath(path, progressLength, origin: PathTrimOrigin.begin);
    }

    // print('i am here: $percent, $progressLength, ${progressPath.getBounds()}');

    return Container(
      child: CustomPaint(
        painter: FilledPathPainter(
          path: path,
          progressPath: progressPath,
          progressRatio: widget.progressRatio,
          color: borderColor,
          percent: percent,
          fillColor: Colors.transparent,
          // var roundedPath =
          //     'M 20 0 h 200 a 20 20 0 0 1 20 20 v 200 a 20 20 0 0 1 -20 20 h -200 a 20 20 0 0 1 -20 -20 v -200 a 20 20 0 0 1 20 -20 z';
        ),
      ),
    );
  }
}

String namePlateStr1 = '''
<?xml version="1.0" encoding="UTF-8" standalone="no"?> <!-- Created with Vectornator for iOS (http://vectornator.io/) --><!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg height="100%" style="fill-rule:nonzero;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.w3.org/2000/svg" xml:space="preserve" width="100%" xmlns:vectornator="http://vectornator.io" version="1.1" viewBox="0 0 370 130">
<metadata>
<vectornator:setting key="DimensionsVisible" value="1"/>
<vectornator:setting key="PencilOnly" value="0"/>
<vectornator:setting key="SnapToPoints" value="0"/>
<vectornator:setting key="OutlineMode" value="0"/>
<vectornator:setting key="CMYKEnabledKey" value="0"/>
<vectornator:setting key="RulersVisible" value="1"/>
<vectornator:setting key="SnapToEdges" value="0"/>
<vectornator:setting key="GuidesVisible" value="1"/>
<vectornator:setting key="DisplayWhiteBackground" value="0"/>
<vectornator:setting key="doHistoryDisabled" value="0"/>
<vectornator:setting key="SnapToGuides" value="1"/>
<vectornator:setting key="TimeLapseWatermarkDisabled" value="0"/>
<vectornator:setting key="Units" value="Points"/>
<vectornator:setting key="DynamicGuides" value="0"/>
<vectornator:setting key="IsolateActiveLayer" value="0"/>
<vectornator:setting key="SnapToGrid" value="0"/>
</metadata>
<defs/>
<g id="Untitled" vectornator:layerName="Untitled">
<path d="M353.4+126.9L17.2+126.9C9.99995+126.9+4.19995+121.1+4.19995+113.9L4.19995+16.2C4.19995+8.99995+9.99995+3.19995+17.2+3.19995C122.3+3.19995+227.3+3.19995+332.4+3.19995C335.1+3.19995+337.8+3.19995+340.5+3.19995C344.8+3.19995+349.1+3.19995+353.4+3.19995C360.6+3.19995+366.4+8.99995+366.4+16.2C366.4+19.8+366.4+23.3+366.4+26.9L366.4+37.5999C366.4+37.6999+366.4+89.2+366.4+113.9C366.4+121.1+360.6+126.9+353.4+126.9Z" opacity="1" fill="#363636"/>
<path name="progress" stroke="#c0c0c0" stroke-width="3" d="M353.4+126.9L17.2+126.9C9.99995+126.9+4.19995+121.1+4.19995+113.9L4.19995+16.2C4.19995+8.99995+9.99995+3.19995+17.2+3.19995C122.3+3.19995+227.3+3.19995+332.4+3.19995C335.1+3.19995+337.8+3.19995+340.5+3.19995C344.8+3.19995+349.1+3.19995+353.4+3.19995C360.6+3.19995+366.4+8.99995+366.4+16.2C366.4+19.8+366.4+23.3+366.4+26.9L366.4+37.5999C366.4+37.6999+366.4+89.2+366.4+113.9C366.4+121.1+360.6+126.9+353.4+126.9Z" fill="none" stroke-linecap="butt" opacity="1" stroke-linejoin="miter"/>
<path d="M13.371+28.2862C13.2622+52.3936+13.2622+76.501+13.1533+100.608C14.4596+101.144+18.3783+102.751+21.4263+107.573C24.0388+111.859+24.4743+116.278+24.5832+118.02C131.371+117.886+238.159+117.752+344.947+117.618C345.056+116.546+345.382+111.189+349.083+107.171C352.676+103.287+356.703+103.287+357.683+103.287C357.683+78.376+357.574+53.4649+357.574+28.5539C355.506+27.4824+352.676+25.6074+349.845+22.527C346.471+18.777+344.402+14.8931+343.205+12.2145C237.397+12.0806+131.698+12.0806+25.8895+11.9467C25.6718+13.8217+24.9098+17.8396+22.1884+21.7236C18.9227+26.679+14.786+27.8844+13.371+28.2862Z" opacity="1" fill="#363636"/>
</g>
</svg>
''';
String namePlateStr = '''
<?xml version="1.0" encoding="UTF-8" standalone="no"?> <!-- Created with Vectornator for iOS (http://vectornator.io/) --><!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg height="100%" style="fill-rule:nonzero;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.w3.org/2000/svg" xml:space="preserve" width="100%" xmlns:vectornator="http://vectornator.io" version="1.1" viewBox="2 2 400 240">
<metadata>
<vectornator:setting key="DimensionsVisible" value="1"/>
<vectornator:setting key="PencilOnly" value="0"/>
<vectornator:setting key="SnapToPoints" value="0"/>
<vectornator:setting key="OutlineMode" value="0"/>
<vectornator:setting key="CMYKEnabledKey" value="0"/>
<vectornator:setting key="RulersVisible" value="1"/>
<vectornator:setting key="SnapToEdges" value="0"/>
<vectornator:setting key="GuidesVisible" value="1"/>
<vectornator:setting key="DisplayWhiteBackground" value="0"/>
<vectornator:setting key="doHistoryDisabled" value="0"/>
<vectornator:setting key="SnapToGuides" value="0"/>
<vectornator:setting key="TimeLapseWatermarkDisabled" value="0"/>
<vectornator:setting key="Units" value="Points"/>
<vectornator:setting key="DynamicGuides" value="0"/>
<vectornator:setting key="IsolateActiveLayer" value="0"/>
<vectornator:setting key="SnapToGrid" value="0"/>
</metadata>
<defs/>
<g id="Untitled" vectornator:layerName="Untitled">
<path stroke="#fff" stroke-width="10" d="M387.643+242L16.3568+242C8.4053+242+2+230.747+2+216.778L2+27.2224C2+13.253+8.4053+2+16.3568+2C132.425+2+248.383+2+364.452+2C367.433+2+370.415+2+373.397+2C378.146+2+382.895+2+387.643+2C395.595+2+402+13.253+402+27.2224C402+34.207+402+40.9977+402+47.9823L402+68.742C402+68.936+402+168.855+402+216.778C402+230.747+395.595+242+387.643+242Z" fill="none" stroke-linecap="butt" opacity="1" stroke-linejoin="miter"/>
</g>
</svg>

''';
String progressPathStr =
    '''M387.643+242L16.3568+242C8.4053+242+2+230.747+2+216.778L2+27.2224C2+13.253+8.4053+2+16.3568+2C132.425+2+248.383+2+364.452+2C367.433+2+370.415+2+373.397+2C378.146+2+382.895+2+387.643+2C395.595+2+402+13.253+402+27.2224C402+34.207+402+40.9977+402+47.9823L402+68.742C402+68.936+402+168.855+402+216.778C402+230.747+395.595+242+387.643+242Z''';
