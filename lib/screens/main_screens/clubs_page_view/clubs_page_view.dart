import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/main_screens/clubs_page_view/widgets/club_item.dart';
import 'package:pokerapp/screens/main_screens/clubs_page_view/widgets/create_club_bottom_sheet.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/heading_widget.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:pokerapp/widgets/round_raised_button.dart';
import 'package:provider/provider.dart';

import 'widgets/search_club_bottom_sheet.dart';

class ClubsPageView extends StatefulWidget {
  @override
  _ClubsPageViewState createState() => _ClubsPageViewState();
}

class _ClubsPageViewState extends State<ClubsPageView>
    with RouteAware, RouteAwareAnalytics {
  @override
  String get routeName => Routes.club_pages;
  bool _showLoading = false;

  List<ClubModel> _clubs;
  AppTextScreen _appScreenText;

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
      Alerts.showSnackBar(ctx, _appScreenText['UPADATESUCCESSFUL']);
      return _fetchClubs();
    }

    return Alerts.showSnackBar(ctx, _appScreenText['COULDNOTUPDATE']);
  }

  void _showClubOptions(
      ClubModel club, BuildContext ctx, AppTheme theme) async {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: EdgeInsets.all(15.0),
          color: theme.fillInColor,
          width: MediaQuery.of(context).size.width * 0.60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              /* delete club  */
              RoundRaisedButton(
                radius: 5.0,
                color: theme.accentColor,
                buttonText: _appScreenText['DELETECLUB'],
                onButtonTap: () {
                  Navigator.pop(context);
                  _deleteClub(club, ctx);
                },
              ),
              SizedBox(height: 10.0),
              RoundRaisedButton(
                radius: 5.0,
                color: theme.accentColor,
                buttonText: _appScreenText['EDITCLUB'],
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
    String clubCode = await ClubsService.createClub(
      clubName,
      clubDescription,
    );

    _toggleLoading();

    /* finally, show a status message and fetch all the clubs (if required) */
    if (clubCode != null) {
      Alerts.showNotification(
          titleText: _appScreenText['CLUB'],
          subTitleText: '${_appScreenText['CREATEDCLUB']}: $clubName',
          duration: Duration(seconds: 2));
      final natsClient = Provider.of<Nats>(context, listen: false);
      natsClient.subscribeClubMessages(clubCode);
      _fetchClubs();
    } else
      Alerts.showSnackBar(ctx, _appScreenText['SOMETHINGWENTWRONG']);
  }

  Future<void> _fillClubs() async {
    _clubs = await ClubsService.getMyClubs();
    for (final club in _clubs) {
      log('club: ${club.clubName} status: ${club.memberStatus}');
    }
    if (mounted) setState(() {});
  }

  void _fetchClubs({
    bool withLoading = true,
  }) async {
    log('fetching clubs');
    if (!withLoading) return _fillClubs();

    _toggleLoading();

    await _fillClubs();
    _toggleLoading();
  }

  Timer _refreshTimer;

  void listener() {
    _fetchClubs(withLoading: false);
  }

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("clubsPageView");

    /* fetch the clubs initially */
    _fetchClubs();

    /* add listener for updateing when needed */
    context.read<ClubsUpdateState>().addListener(listener);

    // TEMP SOLUTION FOR REFRESHING
    /* set a timer to run every X second */
    // _refreshTimer = Timer.periodic(
    //   const Duration(seconds: 5),
    //   (_) => _fetchClubs(withLoading: false),
    // );
  }

  void refreshClubScreen() {
    log('refresh club screen');
    context.read<ClubsUpdateState>().notify();
  }

  void openClub(BuildContext context, ClubModel club) async {
    if (club.memberStatus == 'ACTIVE') {
      Navigator.pushNamed(
        context,
        Routes.club_main,
        arguments: club.clubCode,
      );
    }
  }

  @override
  void didPopNext() {
    super.didPopNext();
    refreshClubScreen();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) => WillPopScope(
        onWillPop: () async {
          context.read<ClubsUpdateState>().removeListener(listener);
          routeObserver.unsubscribe(this);
          return true;
        },
        child: Builder(
          builder: (ctx) => Container(
            decoration: AppDecorators.bgRadialGradient(theme),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: AppDimensions.kMainPaddingHorizontal,
                  right: AppDimensions.kMainPaddingHorizontal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    /*
                    * title
                    * */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RoundedColorButton(
                          backgroundColor: theme.accentColor,
                          textColor: theme.primaryColorWithDark(),
                          text: _appScreenText['SEARCH'],
                          onTapFunction: () async {
                            await showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (ctx) => SearchClubBottomSheet(),
                            );
                            _fetchClubs();
                          },
                        ),
                        HeadingWidget(heading: AppStringsNew.clubsTitle),
                        RoundedColorButton(
                          backgroundColor: theme.accentColor,
                          textColor: theme.primaryColorWithDark(),
                          text: '+ ${_appScreenText['CREATE']}',
                          onTapFunction: () => _createClub(ctx),
                        ),
                      ],
                    ),

                    // _getTitleTextWidget('Clubs'),

                    // const SizedBox(height: 30),
                    /*
                    * create and search box
                    * */
                    // const SizedBox(height: 10),
                    (_showLoading || (_clubs == null))
                        ? Expanded(
                            child: Center(
                              child: CircularProgressWidget(),
                            ),
                          )
                        : _clubs.isEmpty
                            ? Expanded(
                                child: Center(
                                  child: Text(
                                    _appScreenText['NOCLUBS'],
                                    style: AppDecorators.getAccentTextStyle(
                                        theme: theme),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.only(
                                    bottom: 15.0,
                                  ),
                                  itemBuilder: (_, index) {
                                    var club = _clubs[index];
                                    return InkWell(
                                      onTap: () => this.openClub(context, club),
                                      onLongPress: () => _showClubOptions(
                                        club,
                                        ctx,
                                        theme,
                                      ),
                                      child: Container(
                                        decoration:
                                            AppDecorators.getGameItemDecoration(
                                                theme: theme),
                                        child: ClubItem(
                                          club: club,
                                          theme: theme,
                                          appScreenText: _appScreenText,
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 16.0),
                                  itemCount: _clubs.length,
                                ),
                              ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
