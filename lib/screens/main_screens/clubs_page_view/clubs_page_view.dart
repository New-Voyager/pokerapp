import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_colors.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/screens/club_screen/club_main_screen.dart';
import 'package:pokerapp/screens/main_screens/clubs_page_view/widgets/club_item.dart';
import 'package:pokerapp/screens/main_screens/clubs_page_view/widgets/create_club_bottom_sheet.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/round_raised_button.dart';
import 'package:pokerapp/widgets/round_text_field.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
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

  void _deleteClub(ClubModel club, BuildContext ctx) async {
    // update the club with new details
    bool status = await ClubsService.deleteClub(club.clubCode);

    if (status) {
      Alerts.showSnackBar(ctx, 'Delete successfully');
      return _fetchClubs();
    }

    Alerts.showSnackBar(ctx, 'Could not delete');
  }

  void _editClub(ClubModel club, BuildContext ctx) async {
    /* the bottom sheet returns
    * 'name'
    * 'description'
    * keys, which are used by the API to create a new club */

    Map<String, String> clubDetails = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => CreateClubBottomSheet(
        name: club.clubName,
        description: '',
      ),
    );

    if (clubDetails == null) return;

    // these are the new club name and description
    String clubName = clubDetails['name'];
    String clubDescription = clubDetails['description'];

    // update the club with new details
    bool status = await ClubsService.updateClub(
      club.clubCode,
      clubName,
      clubDescription,
    );

    if (status) {
      Alerts.showSnackBar(ctx, 'Update successful');
      return _fetchClubs();
    }

    return Alerts.showSnackBar(ctx, 'Could not update');
  }

  void _showClubOptions(ClubModel club, BuildContext ctx) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(15.0),
          color: AppColors.cardBackgroundColor,
          width: MediaQuery.of(context).size.width * 0.60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              /* delete club  */
              RoundRaisedButton(
                radius: 5.0,
                color: AppColors.contentColor,
                buttonText: 'Delete Club',
                onButtonTap: () {
                  Navigator.pop(context);
                  _deleteClub(club, ctx);
                },
              ),
              SizedBox(height: 10.0),
              RoundRaisedButton(
                radius: 5.0,
                color: AppColors.contentColor,
                buttonText: 'Edit Club',
                onButtonTap: () {
                  Navigator.pop(context);
                  _editClub(club, ctx);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createClub(BuildContext ctx) async {
    /* show a bottom sheet asking for club information */

    /* the bottom sheet returns
    * 'name'
    * 'description'
    * keys, which are used by the API to create a new club */
    Map<String, String> clubDetails = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => CreateClubBottomSheet(),
    );

    /* user has cancelled the club creation process */
    if (clubDetails == null) return;

    String clubName = clubDetails['name'];
    String clubDescription = clubDetails['description'];

    _toggleLoading();

    /* create a club using the clubDetails */
    bool status = await ClubsService.createClub(
      clubName,
      clubDescription,
    );

    _toggleLoading();

    /* finally, show a status message and fetch all the clubs (if required) */
    if (status) {
      Alerts.showSnackBar(ctx, 'Created new club');
      _fetchClubs();
    } else
      Alerts.showSnackBar(ctx, 'Something went wrong');
  }

  void _fetchClubs() async {
    _toggleLoading();

    _clubs = await ClubsService.getMyClubs();

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
        fontSize: 30.0,
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
                    CustomTextButton(
                      text: '+ Create Club',
                      onTap: () => _createClub(ctx),
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
                                                c?.hostName
                                                    ?.toLowerCase()
                                                    ?.contains(query) ??
                                                false ||
                                                    c.clubName
                                                        .toLowerCase()
                                                        .contains(query))
                                            .toList();
                                      }

                                      /*
                                      * An animated switcher is used to smooth
                                      * the transition between the "Nothing Found" widget
                                      * and the ListView containing club items widget
                                      * */

                                      return AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        reverseDuration:
                                            const Duration(milliseconds: 200),
                                        child: query.isNotEmpty &&
                                                _filteredClubs.isEmpty

                                            /* if filtered result is empty */

                                            ? Center(
                                                child: Text(
                                                  'Nothing Found',
                                                  style: AppStyles
                                                      .clubItemInfoTextStyle
                                                      .copyWith(
                                                    fontSize: 30.0,
                                                  ),
                                                ),
                                              )

                                            /* list the club items, if present */

                                            : ListView.separated(
                                                physics:
                                                    const BouncingScrollPhysics(),
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
                                                            Provider<ClubModel>(
                                                          create: (_) => club,
                                                          child:
                                                              ClubMainScreen(),
                                                        ),
                                                      ),
                                                    ),
                                                    onLongPress: () =>
                                                        _showClubOptions(
                                                      club,
                                                      ctx,
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
                                              ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
