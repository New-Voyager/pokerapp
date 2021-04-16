import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:tuple/tuple.dart';

class BetWidget extends StatefulWidget {
  final double rangeMin;
  final double rangeMax;
  final double divisions;
  final List<Tuple2<String, String>> otherBets;
  //final Function onSubmitCallBack;

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
    //this.onSubmitCallBack,
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
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    //val = widget.rangeMax / widget.rangeMin;
    val = (widget.rangeMax - widget.rangeMin) / 2;
    _controller = TextEditingController(text: "${val.toStringAsFixed(0)}");
  }

  @override
  Widget build(BuildContext context) {
    log('val: $val min: ${widget.rangeMin} max: ${widget.rangeMax}');
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height / 3,
      width: width,
      color: Colors.black12, //.withOpacity(0.65),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Transform.translate(offset: Offset(0, -100),
            //   child:  SvgPicture.asset(
            //     "assets/images/game/green bet.svg",
            //     fit: BoxFit.contain,
            //   ),
            // ),
            Container(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: height / 5,
                      width: width / 2,
                      child: sleekSlider(),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 64,
                        // height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.appAccentColor,),
                          
                        ),
                        child: TextField(
                          textAlign: TextAlign.center,
                          readOnly: true,
                          controller: _controller,
                          decoration: InputDecoration(
                            filled: false,
                            fillColor: Colors.transparent,
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.yellow,
                            fontWeight: FontWeight.w600,
                          ),
                          onTap: () async {
                            final res = await showDialog(
                              context: context,
                              builder: (context) {
                                TextEditingController _localCtrl =
                                    TextEditingController(
                                        text: _controller.text);
                                return AlertDialog(
                                  content: TextField(
                                    controller: _localCtrl,
                                    autofocus: true,
                                    /*  onChanged: (value) {
                                      _controller.text = value;
                                    }, */
                                    keyboardType: TextInputType.number,
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => Navigator.of(context)
                                          .pop(_localCtrl.text),
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (res != null && res.toString().isNotEmpty) {
                              setState(() {
                                val = double.parse(res.toString());
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        //onTap: widget.onSubmitCallBack(val),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            //color: Colors.red,
                            border: Border.all(color: Colors.white, width: 1.0),
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.red,
                                Colors.redAccent,
                              ],
                            ),
                            color: Colors.amber,
                          ),
                          child: Text(
                            "BET",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              alignment: Alignment.center,
              width: width / 1.5,
              height: 64,
              child: betAmountList(),
            )
          ],
        ),
      ),
    );
  }

  Widget sleekSlider() {
    final slider = SleekCircularSlider(
      onChange: (value) => _controller.text = value.toStringAsFixed(0),
      min: widget.rangeMin,
      max: widget.rangeMax,
      initialValue: val,
      appearance: CircularSliderAppearance(
        size: 350,
        startAngle: 120,
        angleRange: 300,
        animationEnabled: false,
        infoProperties: InfoProperties(
          /*   bottomLabelText: 'kg',
            bottomLabelStyle: TextStyle(fontSize: 25, color: Colors.yellow), */
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
            trackColor: AppColors.lightGrayColor,
            dotColor: AppColors.appAccentColor,
            // progressBarColor: Colors.indigo,
            progressBarColors: [
              Colors.indigo.shade900,
              Colors.indigo.shade600,
              Colors.indigo.shade400,
            ]),
        customWidths: CustomSliderWidths(
          trackWidth: 8,
          progressBarWidth: 16,
          handlerSize: 10,
        ),
      ),
    );
    return slider;
  }

  Widget betAmountList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final Tuple2<String, String> currentTuple = widget.otherBets[index];
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(children: [
            Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(vertical: 4),
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
                  )),
              child: Text(
                "${currentTuple.item1}",
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
            Text(
              "${currentTuple.item2}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ]),
          SizedBox(width: 10),
        ]);
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
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
