import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuple/tuple.dart';

class BetWidget extends StatefulWidget {
  final rangeMin;
  final rangeMax;
  double divisions = 10;
  final List<Tuple2<String, String>> otherBets;

  BetWidget({
    this.rangeMin = 50.0,
    this.rangeMax = 200.0,
    this.divisions,
    this.otherBets = const [
      Tuple2("AllIn", "435"),
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
    val = 100;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            height: 200,
            width: 250,
            alignment: Alignment.center,
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 64,
                      width: 64,
                      child: SvgPicture.asset(
                        "assets/images/game/green bet.svg",
                        fit: BoxFit.contain,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16),
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(color: Colors.lime),
                          child: Text(
                            "${val.toStringAsFixed(0)}",
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print("PUSH Pressed");
                          },
                          child: Container(
                            margin: EdgeInsets.all(4),
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Push",
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RotatedBox(
                      quarterTurns: 3,
                      child: Slider.adaptive(
                        max: widget.rangeMax,
                        min: widget.rangeMin,
                        inactiveColor: Colors.red.shade100,
                        activeColor: Colors.red.shade300,
                        onChanged: (value) {
                          print("NEW VAL:$value");
                          setState(() {
                            val = value;
                          });
                        },
                        label: "$val",
                        semanticFormatterCallback: (value) {
                          return "$value";
                        },
                        value: val,
                        divisions: 10,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      height: 300,
                      width: 100,
                      alignment: Alignment.center,
                      //color: Colors.red,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final Tuple2<String, String> currentTuple =
                              widget.otherBets[index];
                          return Container(
                            padding: EdgeInsets.all(2),
                            margin: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            color: Colors.grey.shade300,
                            child: Column(
                              children: [
                                Text(
                                  "${currentTuple.item1}",
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                Text(
                                  "${currentTuple.item2}",
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: widget.otherBets.length,
                        scrollDirection: Axis.vertical,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
