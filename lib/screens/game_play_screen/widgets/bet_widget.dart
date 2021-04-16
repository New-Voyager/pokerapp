import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/provider_models/player_action.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class BetWidget extends StatefulWidget {
  final Function onSubmitCallBack;
  final PlayerAction action;
  BetWidget({
    @required this.action,
    this.onSubmitCallBack,
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
    // always start with min
    val = widget.action.minRaiseAmount.toDouble();
    _controller = TextEditingController(text: "${val.toStringAsFixed(0)}");
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    //log('val: $val min: ${widget.rangeMin} max: ${widget.rangeMax}');
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
                          border: Border.all(color: AppColors.buttonBorderColor, width: 2.0),
                          shape: BoxShape.circle,                          
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
                          style: AppStyles.betChipsText,
                          onTap: () async {
                            final res = await showDialog(
                              context: context,
                              builder: (context) {
                                TextEditingController _localCtrl =
                                    TextEditingController(text: _controller.text);
                                return AlertDialog(
                                  content: TextField(
                                    controller: _localCtrl,
                                    autofocus: true,
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
                        onTap: () {
                          log('BET hit $val');
                          if (widget.onSubmitCallBack != null) {
                            widget.onSubmitCallBack(val);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            //color: Colors.red,
                            border: Border.all(color: AppColors.buttonBorderColor, width: 2.0),
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.red,
                                Colors.redAccent,
                              ],
                            ),
                            //color: Colors.amber,
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
    log('min: ${widget.action.minRaiseAmount} max: ${widget.action.maxRaiseAmount} val: $val');

    final slider = SleekCircularSlider(
      onChange: (value) {
        _controller.text = value.toStringAsFixed(0);
        val = double.parse(_controller.text);
      },
      min: widget.action.minRaiseAmount.toDouble(),
      max: widget.action.maxRaiseAmount.toDouble(),
      initialValue: val,
      appearance: CircularSliderAppearance(
        size: 350,
        startAngle: 145,
        angleRange: 245,
        animationEnabled: false,
        infoProperties: InfoProperties(
          mainLabelStyle: TextStyle(
            fontSize: 0,
            color: Colors.white70,
          ),
          modifier: (double value) {
            final roundedValue = value.ceil().toInt().toString();
            return '$roundedValue ';
          },
        ),

        customColors: CustomSliderColors(
            hideShadow: false,
            trackColor: AppColors.lightGrayColor,
            dotColor: AppColors.buttonBorderColor,
            progressBarColors: [
              Colors.red,
              Colors.yellow,
              Colors.green,
            ],            
          ),
        customWidths: CustomSliderWidths(
          trackWidth: 16,
          progressBarWidth: 16,
          handlerSize: 16,
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
        final option = widget.action.options[index];
        return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(children: [
            InkWell(
              onTap: () {
                log('option: ${option.amount} pressed');
                val = option.amount.toDouble();
                setState(() {
                  
                });
              },
              child: Container(
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
                  "${option.text}",
                  style: TextStyle(fontSize: 10, color: Colors.white),
                ),
              ),
            ),
            Text(
              "${option.amount.toInt().toString()}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ]),
          SizedBox(width: 10),
        ]);
      },
      itemCount: widget.action.options.length,
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
