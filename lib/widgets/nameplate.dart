import 'dart:developer';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:pokerapp/models/game_play_models/provider_models/seat.dart';

class Nameplate extends StatelessWidget {
  final int remainingTime;
  final int totalTime;
  final String svg;
  final String progressPath;
  final Size size;
  final Size progressRatio;
  final double scale;
  final Seat seat;

  Nameplate.fromSvgString({
    Key key,
    @required this.remainingTime,
    @required this.totalTime,
    @required this.svg,
    @required this.progressPath,
    @required this.size,
    @required this.progressRatio,
    @required this.seat,
    this.scale = 1.0,
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
    // log('Path view box boundary: ${path.getBounds()}');
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
    String svg = this.svg;
    if (seat != null &&
        seat.player != null &&
        (seat.player.playerFolded || !seat.player.inhand)) {
      svg = svg.replaceAll("#D7D3C6", "#808080");
    }
    log('svg: $svg');

    return Transform.scale(
        scale: this.scale,
        child: Container(
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
        ));
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
    // final Rect pathBounds = path.getBounds();
    final Rect pathBounds = Rect.fromLTRB(0, 0, 400, 240);
    final transformedPath = path;
    Size viewBoxSize = Size(
        size.width * progressRatio.width, size.height * progressRatio.height);

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
      if (this.percent < 0.50) {
        // progressColor = Colors.green[800];
        progressColor = Colors.yellow;
      } else if (this.percent >= 0.50) {
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

String namePlateOldStr = '''
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

String progressPathOldStr =
    "M201.203+3.0174C260.603+3.5174+320.003+3.9174+379.403+4.4174C383.203+4.4174+386.903+5.7174+389.703+8.1174C389.703+8.1174+389.703+8.1174+389.803+8.2174C390.103+8.4174+390.303+8.7174+390.603+8.9174C394.303+12.4174+396.203+17.4174+396.203+22.4174C396.403+86.5174+396.603+150.617+396.803+214.617C396.803+219.717+395.303+224.817+392.303+229.017L392.203+229.117L392.103+229.217C388.803+233.717+383.503+236.317+377.903+236.317C259.903+236.317+142.003+236.217+24.0027+236.217C18.5027+236.217+13.2027+233.717+10.0028+229.217L9.90275+229.117C5.70275+223.217+5.40275+217.017+5.40275+214.717C5.40275+151.617+5.40275+88.4174+5.40275+25.3174C5.40275+20.9174+6.50275+16.5174+8.80275+12.6174C9.50275+11.4174+10.3028+10.3174+11.3027+9.1174L11.4027+9.0174C14.8027+5.1174+19.9027+3.0174+25.0027+3.0174L201.203+3.0174Z";

String namePlateStrCurved = """
<svg width="400" height="240" viewBox="0 0 400 240" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M34.8 81.7C35.1 77.6 35.3 73.5 35.6 69.3C35.9 64.7 36.2 60.1 36.5 55.5C45.6 55.5 54.7 55.4 63.8 55.4C64.1 52.1 64.9 46.7 67.8 40.8C71.6 33.1 76.7 28.8 78.1 27.7C83.9 23 89.7 21.2 93 20.4C111.2 20 129.5 19.7 147.7 19.3C152.5 15.5 160 10.4 170.2 6.7C173.2 5.6 184.7 1.6 200.2 1.8C216.7 2 229.1 6.7 234.5 9.1C243.2 12.9 249.8 17.5 254.2 21.1C263.2 21.2 272.3 21.2 281.3 21.3C290.7 21.3 300.1 21.4 309.4 21.4C312.2 21.9 322.9 24.3 330.6 34.4C336.3 41.9 337.3 49.7 337.5 53C347.7 53.1 357.9 53.1 368.1 53.2C368.1 58.5 368.1 63.9 368 69.4C367.9 73.9 367.8 78.3 367.6 82.6C371.2 84.1 376.7 86.8 382.1 91.7C383.9 93.3 387.4 96.5 390.5 101.6C392.4 104.7 396.5 111.4 396.4 120.6C396.4 131.1 391 138.4 388.6 141.6C381.4 151.3 371.9 155.2 367.8 156.6C367.5 165.3 367.2 174 367 182.7C358 182.6 349 182.5 339.9 182.3C339.8 186.1 338.9 195.4 332.6 204.7C326.6 213.6 318.8 217.8 315.3 219.4C293.9 219.4 272.4 219.3 251 219.3C245.9 223.3 226.4 237.9 197.9 236.9C172.7 236 155.7 223.4 150.2 219C130.8 219.1 111.3 219.2 91.9 219.3C88.6 218.5 78.2 215.7 70.2 205.8C63.5 197.5 62.2 188.8 61.8 185.2C52.7 185.2 43.6 185.2 34.5 185.2C34.3 179.9 34.2 174.6 34.1 169.2C34 164.5 34 159.9 34 155.4C30 153.5 26.7 151.5 24.3 149.7C19.6 146.3 16.6 143.1 15.8 142.2C14.2 140.5 12.4 138.5 10.6 135.5C9.7 134 7.8 130.5 6.7 125.9C4.5 116.4 7.4 108.4 8.4 105.8C11.6 97.3 17.1 92.4 19.4 90.4C25.5 85.1 31.3 82.8 34.8 81.7Z" fill="#d6d3c6"/>
<path d="M45.3 90.5C45.8 82.5 46.3 74.4 46.7 66.4C56 66.4 65.4 66.3 74.7 66.3C74.4 64.1 74.3 61.5 74.4 58.6C74.5 56.1 74.8 53.8 75.2 51.8C75.7 49.4 77.1 44.1 81.7 39.1C86.5 33.9 92.1 32 94.4 31.4C113.4 31 132.4 30.6 151.4 30.2C155.3 26.8 161.3 22.4 169.4 18.8C173.7 16.9 185.1 12.4 200.4 12.6C204.5 12.7 220 13.2 236.6 22.5C242.6 25.9 247.2 29.5 250.3 32.2C269.7 32.3 289 32.3 308.4 32.4C310.9 33 316.6 34.7 321 39.8C321.6 40.5 323.5 42.7 324.9 46.2C325.5 47.6 326.7 50.7 326.7 54.6C326.7 55.2 326.6 56.2 326.5 58C326.3 60.4 326.1 62.4 326 63.8C336.4 63.9 346.7 64 357.1 64.1C357 72.9 356.8 81.7 356.7 90.4C360.7 91.4 367.7 93.6 374.4 99.4C378 102.5 380.6 105.8 382.2 108.5C383.4 110.4 385.9 115 385.7 121.2C385.5 126.8 383 130.6 381.3 133.3C380.2 135 377.2 139.5 371.4 143.2C365.7 146.8 360.2 147.8 357.2 148.1C357 156 356.8 164 356.6 171.9C347.3 171.8 337.9 171.7 328.6 171.6C328.9 173.3 329.1 175.7 329.1 178.6C329.1 182.5 329 189.5 325 196.7C321.2 203.3 315.8 206.9 312.7 208.6C290.9 208.5 269 208.5 247.2 208.4C243.2 212 226.6 225.8 201.5 226C175.3 226.2 158.1 211.5 154.3 208.1C133.9 208.2 113.5 208.2 93.1 208.3C90.5 207.6 83.4 205.1 78 198C70.4 187.8 72.7 176.1 73.1 174.3C63.9 174.4 54.6 174.5 45.4 174.5C45.2 165.6 45.1 156.6 44.9 147.7C41.2 146.7 34.8 144.6 28.7 139.2C24.7 135.7 17.5 129.5 16.9 119.6C16.1 107.9 24.9 100 26.5 98.5C34 91.6 42.6 90.7 45.3 90.5Z" fill="#171817"/>
</svg>
""";

String progressPathCurvedStr =
    "M198.7 7.2C212.9 7.1 223.6 10.6 228.2 12.3C239.3 16.4 247.3 22.2 252.3 26.5C271.1 26.6 289.9 26.6 308.7 26.7C311.3 27.2 316.1 28.5 320.9 32.2C325.3 35.6 327.6 39.4 328.6 41.1C332.5 48.3 332.2 55.2 331.9 58.1C342.1 58.2 352.3 58.3 362.5 58.4C362.4 67.6 362.2 76.9 362.1 86.1C366.5 87.5 375.1 91 382.2 99.5C385.3 103.2 390.4 109.3 390.9 118.5C391.5 129.7 384.7 137.7 382.4 140.3C375.1 148.9 365.8 151.4 362.4 152.2C362.1 160.5 361.9 168.7 361.6 177C352.5 176.9 343.4 176.9 334.3 176.8C334.6 180.1 335.1 190.1 328.9 200.1C323.9 208.2 317.1 212.1 314 213.7C292.4 213.7 270.7 213.7 249.1 213.7C244.4 217.6 227.3 231 201.7 231.3C174.7 231.6 156.7 217.2 152.2 213.4C132.3 213.5 112.5 213.5 92.6 213.6C89.7 212.9 81.3 210.4 74.7 202.4C66.9 192.9 67 182.2 67.1 179.6C58 179.6 49 179.6 39.9 179.6C39.7 170.2 39.6 160.9 39.4 151.5C36 150.3 31 148.1 25.9 143.9C21.6 140.4 13.1 133.5 11.6 122C10.3 112.4 14.6 105 16.2 102.4C23.9 89.8 37.3 86.6 40.1 86C40.6 77.7 41.2 69.3 41.7 61C50.8 61 60 60.9 69.1 60.9C69 58.4 68.5 44.3 79.2 34C84.5 28.9 90.4 26.7 93.8 25.8C112.4 25.4 131 25 149.7 24.7C154.3 20.9 161.8 15.6 172.1 11.9C174.7 10.8 184.9 7.3 198.7 7.2Z";

String namePlateStr = '''
<svg width="1500" height="500" viewBox="0 0 1500 500" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path
        d="M1413.4 500.2H86.7C38.8 500.2 0 461.4 0 413.5V86.9C0 39 38.8 0.199997 86.7 0.199997H1413.4C1461.3 0.199997 1500.1 39 1500.1 86.9V413.5C1500 461.4 1461.2 500.2 1413.4 500.2Z"
        fill="#D8D3C6" />
    <path
        d="M1402.3 486H98.6C52.7 486 15.4 448.8 15.4 402.8V99.1C15.4 53.2 52.6 15.9 98.6 15.9H1402.3C1448.2 15.9 1485.5 53.1 1485.5 99.1V402.8C1485.5 448.7 1448.2 486 1402.3 486Z"
        fill="#171817" />
</svg>
''';

String progressPathStr =
    "M749.9 7.39999C969.7 7.39999 1189.4 7.39999 1409.2 7.39999C1422.3 8.59999 1447.5 12.8 1467 31.5C1486.4 50.2 1492.6 74.1 1492.6 88.2C1492.6 196.8 1492.6 305.5 1492.6 414.1C1492 421.3 1489.2 445.3 1469.2 466C1445.6 490.4 1415.3 492.2 1409.1 492.4C970.4 492.4 531.7 492.4 92.9 492.4C87.2 492.3 53.7 491.2 29.1 464.1C10.2 443.2 8.00001 419.5 7.60001 412.1C7.60001 303.5 7.60001 194.9 7.60001 86.3C7.50001 72.8 14 49.9 33 31.6C51.3 13.9 74.6 9.09999 87.3 7.49999C308.2 7.49999 529 7.39999 749.9 7.39999Z";
