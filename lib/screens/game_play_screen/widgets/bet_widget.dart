import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:tuple/tuple.dart';

class BetWidget extends StatefulWidget {
  final double rangeMin;
  final double rangeMax;
  final double divisions;
  final List<Tuple2<String, String>> otherBets;

  BetWidget({
    this.rangeMin = 2.0,
    this.rangeMax = 400.0,
    this.divisions = 10,
    this.otherBets = const [
      Tuple2("All In", "400"),
      Tuple2("10BB", "50"),
      Tuple2("5BB", "20"),
      Tuple2("3BB", "12"),
      /*  Tuple2("10BB", "50"),
      Tuple2("5BB", "20"),
      Tuple2("3BB", "12"), */
    ],
    /* this.otherBets = [
      Tuple2<String,String>('asdf', '10'),
      Tuple2<String,String>('adsf', '30'),
    ], */
  });

  @override
  _BetWidgetState createState() => _BetWidgetState();
}

class _BetWidgetState extends State<BetWidget> {
  double val;

  @override
  void initState() {
    super.initState();
    //val = widget.rangeMax / widget.rangeMin;
    val = widget.rangeMin;
  }

  @override
  Widget build(BuildContext context) {
    log('val: $val min: ${widget.rangeMin} max: ${widget.rangeMax}');
    return Container(
      height: 250,
      width: 250,
      color: Colors.black12, //.withOpacity(0.65),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
              // Transform.translate(offset: Offset(0, -100),
              //   child:  SvgPicture.asset(
              //     "assets/images/game/green bet.svg",
              //     fit: BoxFit.contain,
              //   ),
              // ),
              Container(
                width: 120,
                height: 120,
                child: 
                Transform.translate(
                  offset: Offset(0, 30),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                          height: 120,
                          width: 120,
                          child: sleekSlider(),
                        )),
                        Align(
                          alignment: Alignment.center,
                          child: 
                          Text(
                              '100',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            )
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: 
                            Transform.translate(offset: Offset(2, 0),
                            child:
                            Stack(
                              alignment: Alignment.center,
                              children: 
                                  [
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      margin: EdgeInsets.symmetric(vertical: 4),
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        //color: Colors.red,
                                        border: Border.all(color: Colors.white, width: 1.0),
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                                Colors.red,
                                                Colors.red,
                                            ],
                                        )                      
                                      ),
                                    ),
                                    Text(
                                        "Bet",
                                        style: TextStyle(fontSize: 10, color: Colors.white),
                                      ),
                                  ],
                              ),
                            )
                            ),           
                    ]
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  height: 100,
                  width: 100,
                  alignment: Alignment.center,
                  child: betAmountList(),
                )
        ],
      ),
    );
  }

  Widget sleekSlider() {
    final slider = SleekCircularSlider(
        min: 2,
        max: 400.0,
        initialValue: val,
        appearance: CircularSliderAppearance(
            size:279,
            startAngle: 120,
            angleRange: 300,
            animationEnabled: false,
            infoProperties: InfoProperties(
              bottomLabelText: 'kg',
              bottomLabelStyle: TextStyle(
                fontSize: 25,
              ),
              mainLabelStyle: TextStyle(
                fontSize: 0,
                color: Colors.white70,
              ),
              modifier: (double value) {
                final roundedValue = value.ceil().toInt().toString();
                // log('val: $roundedValue');
                // val = double.parse(roundedValue);
                return '$roundedValue ';
              },
            ),
            customColors: CustomSliderColors(
              hideShadow: true,
              trackColor: Colors.greenAccent,
              dotColor: Colors.white,
              progressBarColor: Colors.indigo,
            ),
            customWidths: CustomSliderWidths(
              trackWidth: 10,
              progressBarWidth: 20,
              handlerSize: 8,
            )
        ),
        onChangeEnd: (double weight){
          return weight;
        },
      );
    return slider;
  }

  Widget betAmountList() {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final Tuple2<String, String> currentTuple = widget.otherBets[index];
          return 
          Row (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: 
                          [
                            Container(
                              padding: EdgeInsets.all(4),
                              margin: EdgeInsets.symmetric(vertical: 4),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                //color: Colors.red,
                                border: Border.all(color: Colors.white, width: 1.0),
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  // begin: Alignment.topRight,
                                  // end: Alignment.bottomLeft,
                                  colors: [
                                        Colors.indigo,
                                        Colors.cyan,
                                    ],
                                )                      
                              ),
                            ),
                            Text(
                                "${currentTuple.item1}",
                                style: TextStyle(fontSize: 10, color: Colors.white),
                              ),
                          ],
                      ),
                    Text(
                        "${currentTuple.item2}",
                        style: TextStyle(fontSize: 10, color: Colors.white, ),
                      ),
                  ]
              ),
              SizedBox(width: 40),
            ]
          );
        },
        itemCount: widget.otherBets.length,
      );    
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}