import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/hand_log_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_log_header_view.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_stage_view.dart';
import 'package:pokerapp/screens/club_screen/hand_log_views/hand_winners_view.dart';
import 'package:pokerapp/services/app/hand_service.dart';

class HandLogView extends StatefulWidget {
  HandLogModel _handLogModel;
  bool isAppbarWithHandNumber;
  HandLogView(this._handLogModel, {this.isAppbarWithHandNumber = false});

  @override
  State<StatefulWidget> createState() => _HandLogViewState(_handLogModel);
}

class _HandLogViewState extends State<HandLogView> {
  HandLogModel _handLogModel;
  bool _isLoading = true;
  var handLogjson;

  _HandLogViewState(this._handLogModel);

  initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    await HandService.getHandLog(_handLogModel);
    _isLoading = false;
    setState(() {
      // update ui
    });
  }

  loadJsonData() async {
    // String data = await DefaultAssetBundle.of(context)
    //     .loadString("assets/sample-data/handlog.json");
    // final jsonResult = json.decode(data);
    //
    setState(() {
      //_handLogModel = HandLogModel.fromJson(jsonResult);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: widget.isAppbarWithHandNumber
          ? PreferredSize(
              preferredSize: Size(0, 0),
              child: Container(),
            )
          : AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 14,
                  color: AppColors.appAccentColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              titleSpacing: 0,
              elevation: 0.0,
              backgroundColor: AppColors.screenBackgroundColor,
              title: Text(
                "Hand History",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColors.appAccentColor,
                  fontSize: 14.0,
                  fontFamily: AppAssets.fontFamilyLato,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
      body: this._isLoading == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                    alignment: widget.isAppbarWithHandNumber
                        ? Alignment.topCenter
                        : Alignment.topLeft,
                    child: Text(
                      widget.isAppbarWithHandNumber
                          ? "Last Hand Log"
                          : "Hand Log",
                      style: const TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  HandLogHeaderView(_handLogModel),
                  Container(
                    margin:
                        EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Winners",
                      style: const TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Container(
                    child: HandWinnersView(_handLogModel),
                  ),
                  Container(
                    child: HandStageView(_handLogModel.preFlopActions),
                  ),
                  Container(
                    child: HandStageView(_handLogModel.flopActions),
                  ),
                  Container(
                    child: HandStageView(_handLogModel.turnActions),
                  ),
                  Container(
                    child: HandStageView(_handLogModel.riverActions),
                  ),
                ],
              ),
            ),
    );
  }
}
