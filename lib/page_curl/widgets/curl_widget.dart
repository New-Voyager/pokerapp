import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/page_curl/clippers/curl_background_clipper.dart';
import 'package:pokerapp/page_curl/clippers/curl_backside_clipper.dart';
import 'package:pokerapp/page_curl/models/touch_event.dart';
import 'dart:math' as math;

import 'package:pokerapp/page_curl/models/vector_2d.dart';
import 'package:pokerapp/page_curl/painters/curl_shadow_painter.dart';

class CurlWidget extends StatefulWidget {
  final Widget frontWidget;
  final Widget backWidget;
  final Size size;
  final bool vertical;

  CurlWidget({
    @required this.frontWidget,
    @required this.backWidget,
    @required this.size,
    @required this.vertical,
  });

  @override
  _CurlWidgetState createState() => _CurlWidgetState();
}

class _CurlWidgetState extends State<CurlWidget> {
  bool get isVertical => widget.vertical;

  /* variables that controls drag and updates */

  /* px / draw call */
  int mCurlSpeed = 60;

  /* The initial offset for x and y axis movements */
  int mInitialEdgeOffset;

  /* Maximum radius a page can be flipped, by default it's the width of the view */
  double mFlipRadius;

  /* pointer used to move */
  Vector2D mMovement;

  /* starting point */
  Vector2D mStart;

  /* finger position */
  Vector2D mFinger;

  /* paint curl edge */
  Paint curlEdgePaint;

  /* vector points used to define current clipping paths */
  Vector2D mA, mB, mC, mD, mE, mF, mOldF, mOrigin;

  /* vectors that are corners of the entire polygon */
  Vector2D mM, mN, mO, mP;

  /* ff false no draw call has been done */
  bool bViewDrawn;

  /* if TRUE we are currently auto-flipping */
  bool bFlipping;

  /* tRUE if the user moves the pages */
  bool bUserMoves = false;

  /* used to control touch input blocking */
  bool bBlockTouchInput = false;

  /* enable input after the next draw event */
  bool bEnableInputAfterDraw = false;

  double abs(double value) {
    if (value < 0) return value * -1;
    return value;
  }

  Vector2D capMovement(Vector2D point, bool bMaintainMoveDir) {
    // make sure we never ever move too much
    if (point.distance(mOrigin) > mFlipRadius) {
      if (bMaintainMoveDir) {
        // maintain the direction
        point = mOrigin.sum(point.sub(mOrigin).normalize().mult(mFlipRadius));
      } else {
        // change direction
        if (point.x > (mOrigin.x + mFlipRadius))
          point.x = (mOrigin.x + mFlipRadius);
        else if (point.x < (mOrigin.x - mFlipRadius))
          point.x = (mOrigin.x - mFlipRadius);
        point.y = math.sin(math.acos(abs(point.x - mOrigin.x) / mFlipRadius)) *
            mFlipRadius;
      }
    }
    return point;
  }

  void doPageCurl() {
    int width = getWidth().toInt();
    int height = getHeight().toInt();

    // F will follow the finger, we add a small displacement
    // So that we can see the edge
    mF.x = mMovement.x + 0.1;
    mF.y = height - mMovement.y + 0.1;

    // A->E: Hypotenuse
    // A->F: Adjacent
    // E->F: Opposite

    // Get diffs
    double deltaX = mF.x;
    double deltaY = height - mF.y;

    double bh = math.sqrt(deltaX * deltaX + deltaY * deltaY) / 2;
    double tangAlpha = deltaY / deltaX;
    double alpha = math.atan(deltaY / deltaX);
    double _cos = math.cos(alpha);
    double _sin = math.sin(alpha);

    mA.x = 0;
    mA.y = height - (bh / _sin);

    mD.x = math.min((bh / _cos), getWidth());
    // bound mD.y
    mD.y = height.toDouble();

    mA.y = math.min(mA.y, getHeight());
    if (mA.y == getHeight()) {
      mOldF.x = mF.x;
      mOldF.y = mF.y;
    }

    // Get W
    mE.x = mD.x;
    mE.y = mD.y;

    // bouding corrections
    if (mD.x > width) {
      mD.y = height + tangAlpha * mD.x;
      mE.x = 0;
      mE.y = height + math.tan(2 * alpha) * mD.x;

      // modify mD to create newmD by cleaning y value
      // Vector2D newmD = Vector2D(0, mD.y);
      // double l = height - newmD.y;
      // mE.x = -math.sqrt(abs(math.pow(l, 2) - math.pow((newmD.y - mE.y), 2)));
    }
    log('::Curl:: bh: $bh alpha: $alpha sin: $_sin cos: $_cos mA: $mA mE: $mE mF: $mF mMovement: $mMovement width: $width height: $height mOldF: $mOldF');
  }

  double getWidth() => widget.size.width;

  double getHeight() => widget.size.height;

  void resetClipEdge() {
    // set base movement
    mMovement.x = mInitialEdgeOffset.toDouble();
    mMovement.y = mInitialEdgeOffset.toDouble();
    mStart = Vector2D(0,0);

    mA = Vector2D(0, 0);
    mB = Vector2D(getWidth(), getHeight());
    mC = Vector2D(getWidth(), 0);
    mD = Vector2D(0, 0);
    mE = Vector2D(0, 0);
    mF = Vector2D(0, 0);
    mOldF = Vector2D(0, 0);

    // The movement origin point
    mOrigin = Vector2D(getWidth(), 0);
  }

  void resetMovement() {
    if (!bFlipping) return;

    // No input when flipping
    bBlockTouchInput = true;

    double curlSpeed = mCurlSpeed.toDouble();
    curlSpeed *= -1;

    mMovement.x += curlSpeed;
    mMovement = capMovement(mMovement, false);

    resetClipEdge();
    doPageCurl();

    bUserMoves = false;
    bBlockTouchInput = false;
    bFlipping = false;
    bEnableInputAfterDraw = true;

    setState(() {});
  }

  void handleTouchInput(TouchEvent touchEvent) {
    if (bBlockTouchInput) return;

    if (touchEvent.getEvent() != TouchEventType.END) {
      // get finger position if NOT TouchEventType.END
      mFinger.x = touchEvent.getX();
      mFinger.y = touchEvent.getY();
    }

    switch (touchEvent.getEvent()) {
      case TouchEventType.END:
        bUserMoves = false;
        bFlipping = true;
        resetMovement();
        break;

      case TouchEventType.START:
        //mFinger.round();
        mStart.x = mFinger.x;
        mStart.y = mFinger.y;
        break;

      case TouchEventType.MOVE:
        bUserMoves = true;

        Vector2D offset = Vector2D(0, 0);
        offset.x = (mStart.x - mFinger.x).abs();
        offset.y = (mStart.y - mFinger.y).abs();
        mMovement = Vector2D.fromVector(offset);

        mMovement = capMovement(mMovement, true);

        // make sure the y value get's locked at a nice level
        if (mMovement.y <= 1) mMovement.y = 1;

        // if this is a problem, don't round it
        mMovement.round();
        doPageCurl();

        mA.round();
        mE.round();
        mF.round();
        log('::Curl:: mFinger: $mFinger mStart: $mStart mMovement: $mMovement offset: $offset mA: $mA mE: $mE mF: $mF');

        setState(() {});
        break;
    }
  }

  void init() {
    // init main variables
    mM = Vector2D(0, 0);
    mN = Vector2D(0, getHeight());
    mO = Vector2D(getWidth(), getHeight());
    mP = Vector2D(getWidth(), 0);

    mMovement = Vector2D(0, 0);
    mFinger = Vector2D(0, 0);
    //mOldMovement = Vector2D(0, 0);

    // create the edge paint
    curlEdgePaint = Paint();
    curlEdgePaint.isAntiAlias = true;
    curlEdgePaint.color = Colors.white;
    curlEdgePaint.style = PaintingStyle.fill;

    // mUpdateRate = 1;
    mInitialEdgeOffset = 0;

    // other initializations
    mFlipRadius = getWidth();

    resetClipEdge();
    doPageCurl();
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Widget boundingBox({Widget child}) => SizedBox(
        width: getWidth(),
        height: getHeight(),
        child: child,
      );

  double getAngle() {
    double displaceInX = mA.x - mF.x;
    if (displaceInX == 149.99998333333335) displaceInX = 0;

    double displaceInY = getHeight() - mF.y;
    if (displaceInY < 0) displaceInY = 0;

    double angle = math.atan(displaceInY / displaceInX);
    if (angle.isNaN) angle = 0.0;

    if (angle < 0) angle = angle + math.pi;

    return angle;
  }

  Offset getOffset() {
    double xOffset = mF.x;
    double yOffset = -abs(getHeight() - mF.y);

    return Offset(xOffset, yOffset);
  }

  void onDragCallback(final details) {
    if (details is DragStartDetails) {
      handleTouchInput(TouchEvent(TouchEventType.START, details.localPosition));
    }

    if (details is DragEndDetails) {
      handleTouchInput(TouchEvent(TouchEventType.END, null));
    }

    if (details is DragUpdateDetails) {
      handleTouchInput(TouchEvent(TouchEventType.MOVE, details.localPosition));
    }
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = 12.0;
    final width = 15.0;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      /* drag start */
      onVerticalDragStart: isVertical ? onDragCallback : null,
      onHorizontalDragStart: isVertical ? null : onDragCallback,

      /* drag end */
      onVerticalDragEnd: isVertical ? onDragCallback : null,
      onHorizontalDragEnd: isVertical ? null : onDragCallback,

      /* drag update */
      onVerticalDragUpdate: isVertical ? onDragCallback : null,
      onHorizontalDragUpdate: isVertical ? null : onDragCallback,

      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // foreground image + custom painter for shadow
          !this.bUserMoves ?
          widget.frontWidget
          :
          boundingBox(
            child: ClipPath(
              clipper: CurlBackgroundClipper(
                mA: mA,
                //mD: mD,
                mE: mE,
                mF: mF,
                mM: mM,
                mN: mN,
                mP: mP,
                shouldClip: this.bUserMoves,
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  widget.frontWidget,
                  // CustomPaint(
                  //   painter: CurlShadowPainter(mA: mA, mD: mD, mE: mE, mF: mF),
                  // ),
                ],
              ),
            ),
          ),

          // // back side - widget

          // boundingBox(
          //   child: ClipPath(
          //     clipper: CurlBackSideClipper(mA: mA, /*mD: mD,*/ mE: mE, mF: mF),
          //     clipBehavior: Clip.antiAlias,
          //     child: Transform.translate(
          //       offset: getOffset(),
          //       child: Transform.rotate(
          //         alignment: Alignment.bottomLeft,
          //         angle: getAngle(),
          //         child: widget.backWidget,
          //       ),
          //     ),
          //   ),
          // ),

          Positioned(
              top: mA.y,
              left: mA.x,
              child: Container(
                width: width,
                height: width,
                decoration:
                    BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                child: Center(child: Text('A', style: TextStyle(fontSize: fontSize)))
              )),
          // Positioned(
          //     top: mB.y,
          //     left: mB.x,
          //     child: Container(
          //       width: width,
          //       height: width,
          //       decoration:
          //           BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          //           child: Center(child: Text('B', style: TextStyle(fontSize: fontSize)))
          //     )),
          // Positioned(
          //     top: mC.y,
          //     left: mC.x,
          //     child: Container(
          //       width: width,
          //       height: width,
          //       decoration:
          //           BoxDecoration(color: Colors.cyan, shape: BoxShape.circle),
          //           child: Center(child: Text('C', style: TextStyle(fontSize: fontSize)))
          //     )),
          Positioned(
              top: mD.y,
              left: mD.x,
              child: Container(
                width: width*2,
                height: width*2,
                decoration:
                    BoxDecoration(color: Colors.indigo, shape: BoxShape.circle),
                    child: Center(child: Text('D', style: TextStyle(fontSize: fontSize)))
              )),
          Positioned(
              top: mE.y,
              left: mE.x,
              child: Container(
                width: width,
                height: width,
                decoration:
                    BoxDecoration(color: Colors.pink, shape: BoxShape.circle),
                    child: Center(child: Text('E', style: TextStyle(fontSize: fontSize)))
              )),
          Positioned(
              top: mF.y,
              left: mF.x,
              child: Container(
                width: width,
                height: width,
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: Center(child: Text('F', style: TextStyle(fontSize: fontSize, color: Colors.black)))
              )),
          Positioned(
              top: mM.y,
              left: mM.x,
              child: Container(
                width: width,
                height: width,
                decoration:
                    BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
                    child: Center(child: Text('M', style: TextStyle(fontSize: fontSize, color: Colors.black)))
              )),              
          Positioned(
              top: mN.y,
              left: mN.x,
              child: Container(
                width: width,
                height: width,
                decoration:
                    BoxDecoration(color: Colors.green[900], shape: BoxShape.circle),
                    child: Center(child: Text('N', style: TextStyle(fontSize: fontSize, color: Colors.black)))
              )),              
          Positioned(
              top: mP.y,
              left: mP.x,
              child: Container(
                width: width,
                height: width,
                decoration:
                    BoxDecoration(color: Colors.yellow[900], shape: BoxShape.circle),
                    child: Center(child: Text('P', style: TextStyle(fontSize: fontSize, color: Colors.black)))
              )),     
            Positioned(
              top: mOrigin.y,
              left: mOrigin.x,
              child: Container(
                width: width*2,
                height: width*2,
                decoration:
                    BoxDecoration(color: Colors.white30, shape: BoxShape.circle),
                    child: Center(child: Text('O', style: TextStyle(fontSize: fontSize, color: Colors.black)))
              )),                        

        ],
      ),
    );
  }
}
