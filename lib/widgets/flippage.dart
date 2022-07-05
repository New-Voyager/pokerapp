import 'dart:math';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showFrontSide;
  bool _flipXAxis;

  @override
  void initState() {
    super.initState();
    _showFrontSide = true;
    _flipXAxis = true;
    Future.delayed(Duration(milliseconds: 50), () {
      _showFrontSide = false;
      setState(() {});
      // _changeRotationAxis();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.widget.title),
          centerTitle: true,
          actions: [
            IconButton(
              icon: RotatedBox(
                child: Icon(Icons.flip),
                quarterTurns: _flipXAxis ? 0 : 1,
              ),
              onPressed: _changeRotationAxis,
            ),
          ],
        ),
        body: FlipCard()
        // body: DefaultTextStyle(
        //   style: TextStyle(color: Colors.white),
        //   textAlign: TextAlign.center,
        //   child: Center(
        //     child: Container(
        //       constraints: BoxConstraints.tight(Size.square(200.0)),
        //       child: _buildFlipAnimation(),
        //     ),
        //   ),
        // ),
        );
  }

  void _changeRotationAxis() {
    setState(() {
      _flipXAxis = true;
      //!_flipXAxis;
    });
  }

  void _switchCard() {
    setState(() {
      _showFrontSide = !_showFrontSide;
    });
  }

  Widget _buildFlipAnimation() {
    developer.log('CommunityCard: flipp _showFrontSide: $_showFrontSide');
    return GestureDetector(
      onTap: _switchCard,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 250),
        transitionBuilder: __transitionBuilder,
        layoutBuilder: (widget, list) => Stack(children: [widget, ...list]),
        child: _showFrontSide ? _buildFront() : _buildRear(),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeOut.flipped,
      ),
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != widget.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: _flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
              : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          child: widget,
          alignment: Alignment.center,
        );
      },
    );
  }

  Widget _buildFront() {
    return __buildLayout(
      key: ValueKey(true),
      backgroundColor: Colors.blue,
      faceName: "Front",
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
          child: FlutterLogo(),
        ),
      ),
    );
  }

  Widget _buildRear() {
    return __buildLayout(
      key: ValueKey(false),
      backgroundColor: Colors.blue.shade700,
      faceName: "Rear",
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
          child:
              Center(child: Text("Flutter", style: TextStyle(fontSize: 50.0))),
        ),
      ),
    );
  }

  Widget __buildLayout(
      {Key key, Widget child, String faceName, Color backgroundColor}) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.0),
        color: backgroundColor,
      ),
      child: Center(
        child: Text(faceName.substring(0, 1), style: TextStyle(fontSize: 80.0)),
      ),
    );
    // return Container(
    //   key: key,
    //   decoration: BoxDecoration(
    //     color: backgroundColor,
    //     borderRadius: BorderRadius.circular(12.0),
    //   ),
    //   child: Stack(
    //     fit: StackFit.expand,
    //     children: [
    //       child,
    //       Positioned(
    //         bottom: 8.0,
    //         right: 8.0,
    //         child: Text(faceName),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class FlipCard extends StatefulWidget {
  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool _showFrontSide;
  bool _flipXAxis;

  @override
  void initState() {
    super.initState();
    _showFrontSide = true;
    _flipXAxis = true;
    Future.delayed(Duration(milliseconds: 50), () {
      _showFrontSide = false;
      setState(() {});
      // _changeRotationAxis();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.tight(Size.square(200.0)),
      child: _buildFlipAnimation(),
    );
  }

  void _changeRotationAxis() {
    setState(() {
      _flipXAxis = true;
      //!_flipXAxis;
    });
  }

  void _switchCard() {
    setState(() {
      _showFrontSide = !_showFrontSide;
    });
  }

  Widget _buildFlipAnimation() {
    developer.log('CommunityCard: flipp _showFrontSide: $_showFrontSide');
    return GestureDetector(
      onTap: _switchCard,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 250),
        transitionBuilder: __transitionBuilder,
        layoutBuilder: (widget, list) => Stack(children: [widget, ...list]),
        child: _showFrontSide ? _buildFront() : _buildRear(),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeOut.flipped,
      ),
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != widget.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: _flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
              : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          child: widget,
          alignment: Alignment.center,
        );
      },
    );
  }

  Widget _buildFront() {
    return __buildLayout(
      key: ValueKey(true),
      backgroundColor: Colors.blue,
      faceName: "Front",
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
          child: FlutterLogo(),
        ),
      ),
    );
  }

  Widget _buildRear() {
    return __buildLayout(
      key: ValueKey(false),
      backgroundColor: Colors.blue.shade700,
      faceName: "Rear",
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
          child:
              Center(child: Text("Flutter", style: TextStyle(fontSize: 50.0))),
        ),
      ),
    );
  }

  Widget __buildLayout(
      {Key key, Widget child, String faceName, Color backgroundColor}) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.0),
        color: backgroundColor,
      ),
      child: Center(
        child: Text(faceName.substring(0, 1), style: TextStyle(fontSize: 80.0)),
      ),
    );
    // return Container(
    //   key: key,
    //   decoration: BoxDecoration(
    //     color: backgroundColor,
    //     borderRadius: BorderRadius.circular(12.0),
    //   ),
    //   child: Stack(
    //     fit: StackFit.expand,
    //     children: [
    //       child,
    //       Positioned(
    //         bottom: 8.0,
    //         right: 8.0,
    //         child: Text(faceName),
    //       ),
    //     ],
    //   ),
    // );
  }
}
