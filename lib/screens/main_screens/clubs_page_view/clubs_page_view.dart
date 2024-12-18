import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_overlay/onboarding_overlay.dart';
import 'package:pokerapp/exceptions/exceptions.dart';
import 'package:pokerapp/main.dart';
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/club_model.dart';
import 'package:pokerapp/models/pending_approvals.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/app_dimensions.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/club_screen/create_club.dart';
import 'package:pokerapp/screens/main_screens/clubs_page_view/widgets/club_item.dart';
import 'package:pokerapp/screens/main_screens/clubs_page_view/widgets/create_club_bottom_sheet.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/services/onboarding.dart';
import 'package:pokerapp/services/test/mock_data.dart';
import 'package:pokerapp/utils/alerts.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/textfields.dart';
import 'package:pokerapp/widgets/texts.dart';
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
  final GlobalKey<OnboardingState> onboardingKey = GlobalKey<OnboardingState>();

  List<ClubModel> _clubs;
  AppTextScreen _appScreenText;
  final TextEditingController _messageController = TextEditingController();

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

  Future<String> showInvitationCodeCheckDialog() {
    final appTheme = context.read<AppTheme>();
    final invitationCodeVn = ValueNotifier<String>("");

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        backgroundColor: appTheme.fillInColor,
        title: Text(
          _appScreenText['invitationCode'],
          style: AppDecorators.getSubtitle2Style(theme: appTheme),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CardFormTextField(
              theme: appTheme,
              hintText: _appScreenText['enterInvitationCode'],
              onChanged: (val) {
                invitationCodeVn.value = val;
              },
              keyboardType: TextInputType.name,
            ),
          ],
        ),
        actions: [
          RoundRectButton(
            text: _appScreenText['validateInvitationCode'],
            onTap: () async {
              bool isInvitationCodeValid = true;
              // TODO: CHECK FOR VALIDITY OF INVITATION CODE

              // if invitation code is invalid, return NULL
              Navigator.pop<String>(
                context,
                isInvitationCodeValid ? invitationCodeVn.value : null,
              );
            },
            theme: appTheme,
          ),
        ],
      ),
    );
  }

  void _createClub(BuildContext ctx) async {
    // final appScreenText = getAppTextScreen("createClubBottomSheet");
    String invitationCode = '';
    bool getInvitationCode = false;

    if (getInvitationCode) {
      // invitation code dialog
      invitationCode = await showInvitationCodeCheckDialog();

      // if invitation code is null, then either the dialog was closed, or validation failed
      if (invitationCode == null) {
        invitationCode = '';
      }
    }

    // if we come here, we have a valid invitation code, in the variable [invitationCode]

    // create club dialog
    String clubCode = await CreateClubDialog.prompt(
      context: ctx,
      invitationCode: invitationCode,
      appScreenText: getAppTextScreen("createClubBottomSheet"),
    );

    if (clubCode != null) {
      /* finally, show a status message and fetch all the clubs (if required) */
      Alerts.showNotification(
          titleText: _appScreenText['club'],
          subTitleText: '${_appScreenText['createdClub']}',
          duration: Duration(seconds: 2));
      final natsClient = Provider.of<Nats>(context, listen: false);
      _toggleLoading();
      natsClient.subscribeClubMessages(clubCode);
      _fetchClubs(withLoading: true);
      _toggleLoading();
    }
  }

  void _createClub2(BuildContext ctx) async {
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

    /* create a club using the clubDetails */
    String clubCode;
    try {
      clubCode = await ClubsService.createClub(
        clubName,
        clubDescription,
      );
    } on GQLException catch (e) {
      await showErrorDialog(context, 'Error', gqlErrorText(e));
      return;
    } catch (e) {
      await showErrorDialog(context, 'Error', errorText('GENERIC'));
      return;
    } finally {}
    _toggleLoading();
    /* finally, show a status message and fetch all the clubs (if required) */
    if (clubCode != null) {
      Alerts.showNotification(
          titleText: _appScreenText['club'],
          subTitleText: '${_appScreenText['createdClub']}: $clubName',
          duration: Duration(seconds: 2));
      final natsClient = Provider.of<Nats>(context, listen: false);
      natsClient.subscribeClubMessages(clubCode);
      _fetchClubs(withLoading: true);
    } else {
      Alerts.showSnackBar(ctx, _appScreenText['unknownError']);
    }
    _toggleLoading();
  }

  Future<void> _fillClubs({bool withLoading = false}) async {
    //var appState = Provider.of<AppState>(context, listen: false);

    if (appState != null && appState.mockScreens) {
      _clubs = await MockData.getClubs();
    } else {
      _clubs = await appState.cacheService.getMyClubs(update: withLoading);
      //_clubs = await ClubsService.getMyClubs();
    }

    if (mounted) setState(() {});
  }

  void _fetchClubs({
    bool withLoading = true,
  }) async {
    log('fetching clubs');
    if (!withLoading) return _fillClubs();

    _toggleLoading();

    await _fillClubs(withLoading: withLoading);
    _toggleLoading();
  }

  Timer _refreshTimer;

  void listener() {
    if (mounted) {
      _fetchClubs(withLoading: false);
      final natsClient = Provider.of<Nats>(context, listen: false);
      for (final club in _clubs) {
        log('club: ${club.clubName} status: ${club.memberStatus}');
        if (!appState.mockScreens &&
            natsClient != null &&
            natsClient.clientSub != null) {
          natsClient.subscribeClubMessages(club.clubCode);
        }
      }
    }
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

    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      if (appState.currentIndex != 1) {
        return;
      }
      final OnboardingState onboarding = onboardingKey.currentState;
      if (onboarding != null) {
        onboarding.show();
      }
    });
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

  List<FocusNode> focusNodes = List<FocusNode>.generate(
    2,
    (int i) => FocusNode(),
    growable: false,
  );
  Map<int, OnboardingType> onboardOptions = {};

  List<OnboardingStep> getOnboardingSteps(AppTheme appTheme) {
    List<OnboardingStep> steps = [];

    bool onboardSearchButton = OnboardingService.showSearchClubButton;
    bool onboardCreateButton = OnboardingService.showCreateClubButton;
    if (onboardSearchButton) {
      onboardOptions[steps.length] = OnboardingType.SEARCH_CLUB_BUTTON;
      steps.add(OnboardingStep(
        focusNode: focusNodes[0],
        title: 'Search Club',
        bodyText: "Tap here to search a club using club code",
        titleTextColor: Colors.white,
        labelBoxPadding: const EdgeInsets.all(16.0),
        labelBoxDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: appTheme.fillInColor,
          border: Border.all(
            color: appTheme.secondaryColor,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
        arrowPosition: ArrowPosition.top,
        hasArrow: true,
        hasLabelBox: true,
        fullscreen: true,
      ));
    }

    if (onboardCreateButton) {
      onboardOptions[steps.length] = OnboardingType.CREATE_CLUB_BUTTON;
      steps.add(
        OnboardingStep(
          focusNode: focusNodes[1],
          title: "Create Club",
          bodyText: "Tap here to create a new club",
          titleTextColor: Colors.white,
          labelBoxPadding: const EdgeInsets.all(16.0),
          labelBoxDecoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            color: appTheme.fillInColor,
            border: Border.all(
              color: appTheme.secondaryColor,
              width: 1.0,
              style: BorderStyle.solid,
            ),
          ),
          arrowPosition: ArrowPosition.top,
          hasArrow: true,
          hasLabelBox: true,
          fullscreen: true,
        ),
      );
    }
    return steps;
  }

  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    log('Language code: ${locale.languageCode}');
    return Consumer<AppTheme>(builder: (_, theme, __) {
      Widget mainView = buildMainView(theme);
      List<OnboardingStep> steps = []; //getOnboardingSteps(theme);
      if (steps.length == 0) {
        return mainView;
      }

      // Future.delayed(Duration(milliseconds: 500), () {
      //   if (appState.currentIndex != 1) {
      //     return;
      //   }
      //   final OnboardingState onboarding = onboardingKey.currentState;
      //   if (onboarding != null) {
      //     onboarding.show();
      //   }
      // });

      return Onboarding(
          key: onboardingKey,
          autoSizeTexts: true,
          steps: steps,
          onChanged: (int index) {
            log('Onboarding: index: $index, type: ${onboardOptions[index]}');
            if (onboardOptions[index] == OnboardingType.SEARCH_CLUB_BUTTON) {
              OnboardingService.showSearchClubButton = false;
            } else if (onboardOptions[index] ==
                OnboardingType.CREATE_CLUB_BUTTON) {
              OnboardingService.showCreateClubButton = false;
            }
          },
          child: mainView);
    });
  }

  Widget buildMainView(AppTheme theme) {
    return WillPopScope(
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
                      CircleImageButton(
                          theme: theme,
                          icon: Icons.search,
                          onTap: () async {
                            // Alerts.showDailog(
                            //   context: context,
                            //   child: BugsFeaturesWidget(),
                            // );
                            await showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (ctx) => SearchClubBottomSheet(),
                            );
                            _fetchClubs(withLoading: true);
                          }),

                      // RoundRectButton(
                      //   text: _appScreenText['searchClub'],
                      //   onTap: () async {
                      //     await showModalBottomSheet(
                      //       context: context,
                      //       backgroundColor: Colors.transparent,
                      //       isScrollControlled: true,
                      //       builder: (ctx) => SearchClubBottomSheet(),
                      //     );
                      //     _fetchClubs(withLoading: true);
                      //     // Map<String, dynamic> attribs;
                      //     // try {
                      //     //   ScreenAttributes.buildList();
                      //     //   Size size = Size(390.0, 865.0);
                      //     //   attribs = ScreenAttributes.getScreenAttribs('iPhone Something', 1.0, size);
                      //     //   log('attribs length: ${attribs.length}');
                      //     // } catch(err) {
                      //     //   log('Error: ${err.toString()}');
                      //     // }
                      //   },
                      //   focusNode: focusNodes[0],
                      //   theme: theme,
                      // ),
                      HeadingWidget(heading: _appScreenText['clubs']),
                      // RoundRectButton(
                      //   text: '+ ${_appScreenText['createClub']}',
                      //   onTap: () => _createClub(ctx),
                      //   theme: theme,
                      //   focusNode: focusNodes[1],
                      // ),
                      CircleImageButton(
                          theme: theme,
                          icon: Icons.add,
                          onTap: () {
                            // Alerts.showDailog(
                            //   context: context,
                            //   child: BugsFeaturesWidget(),
                            // );
                            _createClub(ctx);
                          }),

                      // CircleImageButton(
                      //     theme: theme,
                      //     icon: Icons.help_rounded,
                      //     onTap: () {
                      //       // Alerts.showDailog(
                      //       //   context: context,
                      //       //   child: BugsFeaturesWidget(),
                      //       // );
                      //       showErrorDialog(context, 'Help',
                      //           "Host: Host a Poker game and invite your friends to join.\n\nJoin: Join your friend's game with the game code.\n\nTap on Clubs tab to create your friends' club.",
                      //           info: true);
                      //     }),
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
                              child: ClubsHelpText(theme),
                              // Center(
                              //   child: Text(
                              //     _appScreenText['noClubs'],
                              //     style: AppDecorators.getAccentTextStyle(
                              //         theme: theme),
                              //   ),
                              // ),
                            )
                          : Expanded(
                              child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.only(
                                  bottom: 15.0,
                                ),
                                itemBuilder: (_, index) {
                                  if (index == 0) {
                                    return Center(
                                      child: Text(
                                          'Tap a club to go to club screen'),
                                    );
                                  }
                                  var club = _clubs[index - 1];
                                  return InkWell(
                                    onTap: () {
                                      log('Opening club ${club.clubCode}');
                                      this.openClub(context, club);
                                    },
                                    // onLongPress: () => _showClubOptions(
                                    //   club,
                                    //   ctx,
                                    //   theme,
                                    // ),
                                    child: Container(
                                      decoration:
                                          AppDecorators.getGameItemDecoration(
                                              theme: theme),
                                      child: Stack(
                                        children: [
                                          ColorFiltered(
                                            colorFilter: ColorFilter.mode(
                                                theme.gameListShadeColor,
                                                BlendMode.srcATop),
                                            child: Image(
                                              image: AssetImage(
                                                AppAssetsNew
                                                    .pathLiveGameItemBackground,
                                              ),
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                          ClubItem(
                                            club: club,
                                            theme: theme,
                                            appScreenText: _appScreenText,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 16.0),
                                itemCount: _clubs.length + 1,
                              ),
                            ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ClubsHelpText extends StatelessWidget {
  final AppTheme theme;

  ClubsHelpText(this.theme);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 50),
          Row(
            children: [
              Text('Tap'),
              SizedBox(width: 10),
              CircleImageButton(theme: theme, icon: Icons.add, onTap: () {}),
              SizedBox(width: 10),
              Text('to create a club'),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: [
              Text('Tap'),
              SizedBox(width: 10),
              CircleImageButton(theme: theme, icon: Icons.search, onTap: () {}),
              SizedBox(width: 10),
              Text('to search an existing club'),
            ],
          )
        ],
      ),
    );
  }
}
