import 'package:flutter/material.dart';
import 'package:pokerapp/mock_data/mock_club_data.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/screens/main_screens/clubs_page_view/widgets/club_item.dart';
import 'package:pokerapp/widgets/round_text_field.dart';
import 'package:pokerapp/widgets/text_button.dart';

class ClubsScreen extends StatefulWidget {
  @override
  _ClubsScreenState createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen> {
  static final _totalClubs = 17;

  var _clubs = MockClubData.get(_totalClubs);

  Text _getTitleTextWidget(title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: AppAssets.fontFamilyLato,
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final separator = SizedBox(height: 14.0);

    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: AppDimensions.kMainPaddingHorizontal,
          right: AppDimensions.kMainPaddingHorizontal,
        ),
        children: <Widget>[
          /*
          * title and create club button
          * */
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _getTitleTextWidget('Clubs'),
              TextButton(
                text: '+ Create Club',
                onTap: () {
                  // todo create new club
                },
              ),
            ],
          ),
          separator,

          /*
          * search box
          * */

          RoundTextField(
            hintText: 'Search',
            iconData: Icons.search,
          ),
          separator,

          /*
          * list of clubs
          * */

          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            shrinkWrap: true,
            itemBuilder: (_, index) {
              var club = _clubs[index];
              return ClubItem(
                club: club,
              );
            },
            separatorBuilder: (_, __) => SizedBox(height: 10.0),
            itemCount: _totalClubs,
          ),
        ],
      ),
    );
  }
}
