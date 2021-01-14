import 'package:flutter/material.dart';
import 'package:pokerapp/enums/hand_actions.dart';
import 'package:pokerapp/models/hand_log_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/utils/card_helper.dart';
import 'package:pokerapp/widgets/card_view.dart';

class HandStageView extends StatelessWidget {
  final HandStageModel _handStageModel;

  HandStageView(this._handStageModel);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            _handStageModel.stageName +
                ": " +
                _handStageModel.potAmount.toString(),
            style: const TextStyle(
              fontFamily: AppAssets.fontFamilyLato,
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Visibility(
          visible: (_handStageModel.stageCards != null &&
              _handStageModel.stageCards.length > 0),
          child: Container(
            margin: EdgeInsets.only(left: 10, top: 5, bottom: 10, right: 10),
            alignment: Alignment.centerLeft,
            child: (_handStageModel.stageCards.length > 1
                ? CommunityCardWidget(
                    _handStageModel.stageCards,
                    true,
                  )
                : _handStageModel.stageCards.length != 0
                    ? CardView(
                        card: CardHelper.getCard(_handStageModel.stageCards[0]),
                      )
                    : Container()),
          ),
        ),
        Card(
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
          color: AppColors.cardBackgroundColor,
          child: Container(
            margin: EdgeInsets.all(10),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _handStageModel.stageActions.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _handStageModel.stageActions[index].name ?? "Player",
                        style: const TextStyle(
                          fontFamily: AppAssets.fontFamilyLato,
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        handActionsToString(
                            _handStageModel.stageActions[index].action),
                        style: const TextStyle(
                          fontFamily: AppAssets.fontFamilyLato,
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _handStageModel.stageActions[index].amount.toString(),
                        style: const TextStyle(
                          fontFamily: AppAssets.fontFamilyLato,
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
