import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/models/game/new_game_provider.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/screens/club_screen/club_banner_view/club_banner_view.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/club_games_page_view.dart';
import 'package:pokerapp/screens/club_screen/games_page_view/new_game_settings/new_game_settings.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:provider/provider.dart';

import 'club_action_buttons_view/club_action_buttons_view.dart';

class ClubMainScreen extends StatefulWidget {
  @override
  _ClubMainScreenState createState() => _ClubMainScreenState();
}

class _ClubMainScreenState extends State<ClubMainScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<Widget> _buildActions(String clubCode) => [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: CustomTextButton(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewGameSettings(
                  clubCode: clubCode,
                ),
              ),
            ),
            text: '+ Create Game',
          ),
        ),
      ];

  Widget _buildOutstandingBalanceWidget(ClubModel clubModel) => Container(
        margin: EdgeInsets.all(8.0),
        child: Card(
          color: AppColors.cardBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.all(20.0),
                child: Text(
                  "Outstanding Chips Balance",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                    fontFamily: AppAssets.fontFamilyLato,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20.0),
                child: Text(
                  clubModel.balance ?? '100',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    // todo: change color as per balance value
                    color: clubModel.balance == null
                        ? AppColors.positiveColor
                        : double.parse(clubModel.balance) > 0
                            ? AppColors.positiveColor
                            : double.parse(clubModel.balance) == 0
                                ? Colors.white
                                : AppColors.negativeColor,
                    fontSize: 14.0,
                    fontFamily: AppAssets.fontFamilyLato,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          elevation: 5.5,
        ),
      );

  @override
  Widget build(BuildContext context) => Consumer<ClubModel>(
        builder: (_, ClubModel clubModel, __) => Scaffold(
          backgroundColor: AppColors.screenBackgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: _buildActions(clubModel.clubCode),
            elevation: 0.0,
            backgroundColor: AppColors.screenBackgroundColor,
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClubBannerView(
                    clubModel: clubModel,
                  ),
                  _buildOutstandingBalanceWidget(clubModel),
                  ClubGamesPageView(),
                  ClubActionButtonsView()
                ],
              ),
            ),
          ),
        ),
      );
}
