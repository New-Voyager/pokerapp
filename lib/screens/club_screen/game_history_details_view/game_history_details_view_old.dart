import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokerapp/models/game_play_models/ui/card_object.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_constants.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/screens/game_play_screen/card_views/visible_card_view.dart';
import 'package:pokerapp/services/app/game_service.dart';

class GameHistoryDetailsViewOld extends StatefulWidget {
  final String gameCode;
  final bool isOwner;
  GameHistoryDetailsViewOld(this.gameCode, this.isOwner);

  @override
  _GameHistoryDetailsViewOld createState() =>
      _GameHistoryDetailsViewOld(gameCode, isOwner);
}

class _GameHistoryDetailsViewOld extends State<GameHistoryDetailsViewOld> {
  bool _isOwner = false;
  bool _showLoading = false;
  String _gameCode;
  //GameHistoryDetailModel _gameDetail;

  _toggleLoading() => setState(() {
        _showLoading = !_showLoading;
      });

  _fetchData() async {
    _toggleLoading();
    //_gameDetail = await GameService.getGameHistoryDetail(_gameCode);
    _toggleLoading();
  }

  _GameHistoryDetailsViewOld(this._gameCode, this._isOwner);

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackgroundColor,
        title: Text("Game History"),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            getUpperCard(),
            seprator,
            getLowerCard(),
          ],
        ),
      ),
    );
  }

  final seprator = SizedBox(
    height: 10.0,
  );

  getCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        VisibleCardView(
            card: CardObject(
                suit: AppConstants.redHeart, label: "B", color: Colors.red)),
        VisibleCardView(
            card: CardObject(
                suit: AppConstants.redHeart, label: "9", color: Colors.red)),
        VisibleCardView(
            card: CardObject(
                suit: AppConstants.blackSpade,
                label: "A",
                color: Colors.black)),
        VisibleCardView(
            card: CardObject(
                suit: AppConstants.blackSpade,
                label: "J",
                color: Colors.black)),
        VisibleCardView(
            card: CardObject(
                suit: AppConstants.blackSpade,
                label: "J",
                color: Colors.black)),
      ],
    );
  }

  Widget getLowerCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff313235),
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.cardRadius),
          ),
        ),
        child: Column(
          children: [
            ListTile(
                leading: CircleAvatar(
                  child: SvgPicture.asset('assets/images/casino.svg',
                      color: Colors.white),
                  backgroundColor: Color(0xfffe5b31),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    seprator,
                    Text(
                      "High Hand Winners",
                      style: TextStyle(color: Colors.white),
                    ),
                    seprator,
                    Text(
                      "Reward: 100",
                      style: TextStyle(color: Color(0xff848484)),
                    ),
                    seprator,
                    Text(
                      "Aditya C",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    seprator,
                    Row(
                      children: [
                        Flexible(
                          flex: 6,
                          child: getCards(),
                        ),
                        Flexible(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Game Code: ABCDEF",
                                  style: TextStyle(
                                      color: Color(0xff848484), fontSize: 12.0),
                                  overflow: TextOverflow.clip,
                                ),
                                Text(
                                  "#Hand:212",
                                  style: TextStyle(
                                      color: Color(0xff848484), fontSize: 12.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    seprator,
                    Text(
                      "Paul",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    seprator,
                    Row(
                      children: [
                        Flexible(
                          flex: 6,
                          child: getCards(),
                        ),
                        Flexible(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Game Code: XXYYZY",
                                  style: TextStyle(
                                      color: Color(0xff848484), fontSize: 12.0),
                                  overflow: TextOverflow.clip,
                                ),
                                Text(
                                  "#Hand:214",
                                  style: TextStyle(
                                      color: Color(0xff848484), fontSize: 12.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    seprator,
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(left: 70.0),
              child: Divider(
                color: Color(0xff707070),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                child: SvgPicture.asset('assets/images/casino.svg',
                    color: Colors.white),
                backgroundColor: Color(0xff319ffe),
              ),
              title: Text(
                "Hand History",
                style: TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {}),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70.0),
              child: Divider(
                color: Color(0xff707070),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                child: SvgPicture.asset('assets/images/casino.svg',
                    color: Colors.white),
                backgroundColor: Color(0xffef9712),
              ),
              title: Text(
                "Table Record",
                style: TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {}),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 70.0),
              child: Divider(
                color: Color(0xff707070),
              ),
            ),
            ListTile(
              leading: CircleAvatar(
                child: SvgPicture.asset('assets/images/casino.svg',
                    color: Colors.white),
                backgroundColor: Color(0xff0fc915),
              ),
              title: Text(
                "High Hand Log",
                style: TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget getUpperCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 250.0,
        decoration: BoxDecoration(
          color: Color(0xff313235),
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.cardRadius),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 10.0,
              decoration: BoxDecoration(
                color: Color(0xffef9712),
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(AppDimensions.cardRadius),
                ),
              ),
            ),
            Flexible(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "NLH 1 / 2",
                      style: TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                    seprator,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Ended at 12/10 12:30 PM",
                            style: TextStyle(
                              color: Color(0xff848484),
                              // fontWeight: FontWeight.bold,
                              // fontSize: 20.0,
                            )),
                        Text("Started by Al Pacino",
                            style: TextStyle(
                              color: Color(0xff848484),
                              // fontWeight: FontWeight.bold,
                              // fontSize: 20.0,
                            )),
                      ],
                    ),
                    seprator,
                    Text("Run Time: 12:30",
                        style: TextStyle(
                          color: Color(0xff848484),
                          // fontWeight: FontWeight.bold,
                          // fontSize: 20.0,
                        )),
                    seprator,
                    Text("Session Time: 5:34",
                        style: TextStyle(
                          color: Color(0xff848484),
                          // fontWeight: FontWeight.bold,
                          // fontSize: 20.0,
                        )),
                    seprator,
                    Text("#Hands: 223",
                        style: TextStyle(
                          color: Color(0xff848484),
                          // fontWeight: FontWeight.bold,
                          // fontSize: 20.0,
                        )),
                    seprator,
                    Text("#Hands Played: 124",
                        style: TextStyle(
                          color: Color(0xff848484),
                          // fontWeight: FontWeight.bold,
                          // fontSize: 20.0,
                        )),
                    seprator,
                    Text("#Hands Won: 13",
                        style: TextStyle(
                          color: Color(0xff848484),
                          // fontWeight: FontWeight.bold,
                          // fontSize: 20.0,
                        )),
                    seprator,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Big Win: 125",
                            style: TextStyle(
                              color: Color(0xff848484),
                              // fontWeight: FontWeight.bold,
                              // fontSize: 20.0,
                            )),
                        Text("Hand #85",
                            style: TextStyle(
                              color: Color(0xff848484),
                              // fontWeight: FontWeight.bold,
                              // fontSize: 20.0,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
