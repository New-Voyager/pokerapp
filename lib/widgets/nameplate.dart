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
              animate: false,
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

    // canvas.drawPath(
    //     transformedPath,
    //     Paint()
    //       ..color = fillColor
    //       ..style = PaintingStyle.fill
    //       ..strokeWidth = 3);

    // canvas.drawPath(
    //     transformedPath,
    //     Paint()
    //       ..color = color
    //       ..style = PaintingStyle.stroke
    //       ..strokeWidth = 3);

    Color progressColor = Colors.transparent;

    if (progressPath != null && percent > 0.0) {
      if (this.percent <= 0.50) {
        progressColor = Colors.green[800];
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
            ..color = progressColor
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
      percent =
          1 - (widget.currentProgress.toDouble() / widget.total.toDouble());
      progressLength += percent;
      progressPath =
          trimPath(path, progressLength, origin: PathTrimOrigin.begin);
    }

    // log('Nameplate: percent: $percent total: ${widget.total} progress: ${widget.currentProgress}');
    // print('Nameplate: i am here: $percent, $progressLength, ${progressPath.getBounds()}');

    return Container(
      child: CustomPaint(
        painter: FilledPathPainter(
          path: path,
          progressPath: progressPath,
          progressRatio: widget.progressRatio,
          color: Colors.transparent,
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
String namePlateStr2 = '''
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
String progressPathStr1 =
    '''M387.643+242L16.3568+242C8.4053+242+2+230.747+2+216.778L2+27.2224C2+13.253+8.4053+2+16.3568+2C132.425+2+248.383+2+364.452+2C367.433+2+370.415+2+373.397+2C378.146+2+382.895+2+387.643+2C395.595+2+402+13.253+402+27.2224C402+34.207+402+40.9977+402+47.9823L402+68.742C402+68.936+402+168.855+402+216.778C402+230.747+395.595+242+387.643+242Z''';

String namePlateStr3 = '''
<?xml version="1.0" encoding="UTF-8" standalone="no"?> <!-- Created with Vectornator for iOS (http://vectornator.io/) --><!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg height="100%" style="fill-rule:nonzero;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.w3.org/2000/svg" xml:space="preserve" width="100%" xmlns:vectornator="http://vectornator.io" version="1.1" viewBox="0 0 400 240">
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
<path d="M382.1+236L18.7001+236C10.9001+236+4.6001+225.1+4.6001+211.6L4.6001+28.4C4.6001+14.9+10.9001+4+18.7001+4C42.5001+4+200+4+200+4C200+4+253.1+4+359.4+4C368.2+4+368.2+4+368.2+4C372.8+4+377.5+4+382.1+4C389.9+4+396.2+14.9+396.2+28.4C396.2+35.2+396.2+41.7+396.2+48.5L396.2+68.6C396.2+68.8+396.2+165.4+396.2+211.7C396.2+225.1+389.9+236+382.1+236Z" opacity="1" fill="#051809"/>
<path d="M29.4326+217.197C32.7463+217.197+35.4326+214.511+35.4326+211.197C35.4326+207.883+32.7463+205.197+29.4326+205.197C26.1189+205.197+23.4326+207.883+23.4326+211.197C23.4326+214.511+26.1189+217.197+29.4326+217.197Z" opacity="1" fill="#c0c0c0"/>
<path d="M28.6139+32.2415C31.9277+32.2415+34.614+29.5552+34.614+26.2415C34.614+22.9278+31.9277+20.2415+28.6139+20.2415C25.3003+20.2415+22.614+22.9278+22.614+26.2415C22.614+29.5552+25.3003+32.2415+28.6139+32.2415Z" opacity="1" fill="#c0c0c0"/>
<path d="M371.199+35.4031C374.513+35.4031+377.199+32.7168+377.199+29.4031C377.199+26.0894+374.513+23.4031+371.199+23.4031C367.885+23.4031+365.199+26.0894+365.199+29.4031C365.199+32.7168+367.885+35.4031+371.199+35.4031Z" opacity="1" fill="#c0c0c0"/>
<path d="M371.959+216.658C375.273+216.658+377.959+213.788+377.959+210.474C377.959+207.16+375.273+204.658+371.959+204.658C368.645+204.658+365.959+207.345+365.959+210.658C365.959+213.972+368.645+216.658+371.959+216.658Z" opacity="1" fill="#c0c0c0"/>
<path stroke="#010101" stroke-width="5" d="M200.334+2.31091C139.634+2.31091+79.034+2.31091+18.334+2.31091C16.234+3.31091+13.034+5.11091+10.134+8.41091C5.63401+13.6109+4.53401+19.3109+4.23401+21.7109C4.33401+84.8109+4.33401+148.011+4.43401+211.111C4.13401+213.211+3.63401+219.811+7.53401+226.511C10.534+231.711+14.734+234.411+16.734+235.511C138.934+235.511+261.134+235.611+383.334+235.611C385.234+234.611+390.134+231.911+393.234+226.011C395.334+222.011+395.734+218.311+395.734+216.211C395.634+151.311+395.534+86.4109+395.434+21.5109C395.334+19.7109+394.934+15.5109+392.034+11.3109C388.634+6.41091+384.034+4.41091+382.434+3.81091C321.734+3.21091+261.034+2.81091+200.334+2.31091Z" fill="none" stroke-linecap="butt" opacity="1" stroke-linejoin="miter"/>
</g>
</svg>
''';

String progressPathStr3 =
    "M200.1 2.59998C259.5 3.09998 318.9 3.49998 378.3 3.99998C382.1 3.99998 385.8 5.29998 388.6 7.69998C388.6 7.69998 388.6 7.69998 388.7 7.79998C389 7.99998 389.2 8.29998 389.5 8.49998C393.2 12 395.1 17 395.1 22C395.3 86.1 395.5 150.2 395.7 214.2C395.7 219.3 394.2 224.4 391.2 228.6L391.1 228.7L391 228.8C387.7 233.3 382.4 235.9 376.8 235.9C258.8 235.9 140.9 235.8 22.9 235.8C17.4 235.8 12.1 233.3 8.90005 228.8L8.80005 228.7C4.60005 222.8 4.30005 216.6 4.30005 214.3C4.30005 151.2 4.30005 88 4.30005 24.9C4.30005 20.5 5.40005 16.1 7.70005 12.2C8.40005 11 9.20005 9.89998 10.2 8.69998L10.3 8.59998C13.7 4.69998 18.8 2.59998 23.9 2.59998H200.1Z";

String namePlateStr = '''
<?xml version="1.0" encoding="UTF-8" standalone="no"?> <!-- Created with Vectornator for iOS (http://vectornator.io/) --><!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg height="100%" style="fill-rule:nonzero;clip-rule:evenodd;stroke-linecap:round;stroke-linejoin:round;" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns="http://www.w3.org/2000/svg" xml:space="preserve" width="100%" xmlns:vectornator="http://vectornator.io" version="1.1" viewBox="0 0 400 240">
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
<path d="M382.1+236L18.7001+236C10.9001+236+4.6001+225.1+4.6001+211.6L4.6001+28.4C4.6001+14.9+10.9001+4+18.7001+4C42.5001+4+200+4+200+4C200+4+253.1+4+359.4+4C368.2+4+368.2+4+368.2+4C372.8+4+377.5+4+382.1+4C389.9+4+396.2+14.9+396.2+28.4C396.2+35.2+396.2+41.7+396.2+48.5L396.2+68.6C396.2+68.8+396.2+165.4+396.2+211.7C396.2+225.1+389.9+236+382.1+236Z" opacity="1" fill="#171817"/>
<path stroke="#d6d3c6" stroke-width="5" d="M201.203+3.0174C260.603+3.5174+320.003+3.9174+379.403+4.4174C383.203+4.4174+386.903+5.7174+389.703+8.1174C389.703+8.1174+389.703+8.1174+389.803+8.2174C390.103+8.4174+390.303+8.7174+390.603+8.9174C394.303+12.4174+396.203+17.4174+396.203+22.4174C396.403+86.5174+396.603+150.617+396.803+214.617C396.803+219.717+395.303+224.817+392.303+229.017L392.203+229.117L392.103+229.217C388.803+233.717+383.503+236.317+377.903+236.317C259.903+236.317+142.003+236.217+24.0027+236.217C18.5027+236.217+13.2027+233.717+10.0028+229.217L9.90275+229.117C5.70275+223.217+5.40275+217.017+5.40275+214.717C5.40275+151.617+5.40275+88.4174+5.40275+25.3174C5.40275+20.9174+6.50275+16.5174+8.80275+12.6174C9.50275+11.4174+10.3028+10.3174+11.3027+9.1174L11.4027+9.0174C14.8027+5.1174+19.9027+3.0174+25.0027+3.0174L201.203+3.0174Z" fill="none" stroke-linecap="butt" opacity="1" stroke-linejoin="miter"/>
</g>
</svg>
''';

String progressPathStr =
    "M201.203+3.0174C260.603+3.5174+320.003+3.9174+379.403+4.4174C383.203+4.4174+386.903+5.7174+389.703+8.1174C389.703+8.1174+389.703+8.1174+389.803+8.2174C390.103+8.4174+390.303+8.7174+390.603+8.9174C394.303+12.4174+396.203+17.4174+396.203+22.4174C396.403+86.5174+396.603+150.617+396.803+214.617C396.803+219.717+395.303+224.817+392.303+229.017L392.203+229.117L392.103+229.217C388.803+233.717+383.503+236.317+377.903+236.317C259.903+236.317+142.003+236.217+24.0027+236.217C18.5027+236.217+13.2027+233.717+10.0028+229.217L9.90275+229.117C5.70275+223.217+5.40275+217.017+5.40275+214.717C5.40275+151.617+5.40275+88.4174+5.40275+25.3174C5.40275+20.9174+6.50275+16.5174+8.80275+12.6174C9.50275+11.4174+10.3028+10.3174+11.3027+9.1174L11.4027+9.0174C14.8027+5.1174+19.9027+3.0174+25.0027+3.0174L201.203+3.0174Z";