import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/club_screen/club_main_screen.dart';
import 'package:pokerapp/screens/main_screens/clubs_page_view/widgets/club_item.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/widgets/round_text_field.dart';
import 'package:pokerapp/widgets/text_button.dart';
import 'package:provider/provider.dart';

class ClubsPageView extends StatefulWidget {
  @override
  _ClubsPageViewState createState() => _ClubsPageViewState();
}

class _ClubsPageViewState extends State<ClubsPageView> {
  bool _showLoading = false;

  List<ClubModel> _clubs;
  List<ClubModel> _filteredClubs = List<ClubModel>();

  void _toggleLoading() {
    if (mounted)
      setState(() {
        _showLoading = !_showLoading;
      });
  }

  void _fetchClubs() async {
    _toggleLoading();

    _clubs = await ClubsService.getMyClubs();

    log(_clubs.toString());

    _toggleLoading();
  }

  @override
  void initState() {
    super.initState();

    _fetchClubs();
  }

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

    return ListenableProvider<ValueNotifier<String>>(
      create: (_) => ValueNotifier<String>(''),
      child: Builder(
        builder: (ctx) => Scaffold(
          backgroundColor: AppColors.screenBackgroundColor,
          body: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: AppDimensions.kMainPaddingHorizontal,
              right: AppDimensions.kMainPaddingHorizontal,
            ),
            child: Column(
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

                _showLoading
                    ? Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : _clubs.isEmpty
                        ? Expanded(
                            child: Center(
                              child: Text(
                                'No Clubs',
                                style: AppStyles.clubItemInfoTextStyle.copyWith(
                                  fontSize: 30.0,
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 15.0),
                                  child: RoundTextField(
                                    hintText: 'Search',
                                    iconData: Icons.search,
                                    onChanged: (query) =>
                                        Provider.of<ValueNotifier<String>>(
                                      ctx,
                                      listen: false,
                                    ).value = query,
                                  ),
                                ),
                                Expanded(
                                  child: Consumer<ValueNotifier<String>>(
                                    builder: (_, valueNotifier, __) {
                                      String query = valueNotifier.value
                                          .trim()
                                          .toLowerCase();

                                      if (query.isNotEmpty) {
                                        _filteredClubs.clear();
                                        _filteredClubs = _clubs
                                            .where((c) =>
                                                c.hostName
                                                    .toLowerCase()
                                                    .contains(query) ||
                                                c.clubName
                                                    .toLowerCase()
                                                    .contains(query))
                                            .toList();
                                      }

                                      return ListView.separated(
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        padding: const EdgeInsets.only(
                                          bottom: 15.0,
                                        ),
                                        itemBuilder: (_, index) {
                                          var club = query.isNotEmpty
                                              ? _filteredClubs[index]
                                              : _clubs[index];
                                          return InkWell(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ClubMainScreen(),
                                              ),
                                            ),
                                            child: ClubItem(
                                              club: club,
                                            ),
                                          );
                                        },
                                        separatorBuilder: (_, __) =>
                                            SizedBox(height: 10.0),
                                        itemCount: query.isNotEmpty
                                            ? _filteredClubs.length
                                            : _clubs.length,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                /*
                * list of clubs
                * */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
