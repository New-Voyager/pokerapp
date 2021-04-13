import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuple/tuple.dart';

class BetWidget extends StatefulWidget {
  final double rangeMin;
  final double rangeMax;
  final double divisions;
  final List<Tuple2<String, String>> otherBets;

  BetWidget({
    this.rangeMin = 50.0,
    this.rangeMax = 200.0,
    this.divisions = 10,
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
    val = widget.rangeMax / widget.rangeMin;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 250,
      alignment: Alignment.center,
      color: Colors.grey.withOpacity(0.65),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 48,
                width: 48,
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
                      Navigator.of(context, rootNavigator: true).pop(val);
                    },
                    child: Container(
                      margin: EdgeInsets.all(4),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  label: "${val.toStringAsFixed(0)}",
                  semanticFormatterCallback: (value) {
                    return "${val.toStringAsFixed(0)}";
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
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    );
  }
}
