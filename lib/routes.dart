import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/screens/auth_screens/recover_account.dart';
import 'package:pokerapp/screens/auth_screens/registration_new.dart';
import 'package:pokerapp/screens/club_screen/announcements_view.dart';
import 'package:pokerapp/screens/club_screen/bookmarked_hands.dart';
import 'package:pokerapp/screens/club_screen/botscripts.dart';
import 'package:pokerapp/screens/club_screen/member_credit_history.dart';
import 'package:pokerapp/screens/club_screen/club_main_screen.dart';
import 'package:pokerapp/screens/club_screen/club_member_detailed_view.dart';
import 'package:pokerapp/screens/club_screen/club_members_view.dart';
import 'package:pokerapp/screens/club_screen/club_settings.dart';
import 'package:pokerapp/screens/club_screen/club_stats_screen.dart';
import 'package:pokerapp/screens/game_screens/game_history_details_view/hand_stats_view.dart';
import 'package:pokerapp/screens/game_screens/game_history_details_view/stack_details_view.dart';
import 'package:pokerapp/screens/game_screens/new_game_settings/choose_game_new.dart';
import 'package:pokerapp/screens/main_screens/profile_page_view/system_announcements.dart';
import 'package:pokerapp/screens/profile_screens/card_selector_screen.dart';
import 'package:pokerapp/screens/profile_screens/customize_view.dart';
import 'package:pokerapp/screens/profile_screens/help_screen.dart';
import 'package:pokerapp/screens/profile_screens/performance_view.dart';
import 'package:pokerapp/screens/profile_screens/privacy_policy.dart';
import 'package:pokerapp/screens/profile_screens/table_selector.dart';
import 'package:pokerapp/services/app/appinfo_service.dart';
import 'package:pokerapp/services/game_play/customization_service.dart';
import 'package:provider/provider.dart';

import 'package:pokerapp/screens/screens.dart';

import 'package:pokerapp/models/club_homepage_model.dart';
import 'package:pokerapp/models/club_members_model.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/hand_history_model.dart';
import 'package:pokerapp/models/rewards_model.dart';

class Routes {
  Routes._();

  //SplashScreen
  static const String initial = '/';
  // LoginScreen
  static const String login = '/login';
  // RegistrationScreen
  static const String registration = '/registration';
// Restore account
  static const String restore_account = "/restore_account";
  // MainScreen
  static const String main = '/main';
  // Theme selection
  static const String customize = "/customize";

  // Theme selection
  static const String game_screen_customize = "/game_customize";

  //System announcements
  static const String system_announcements = "/system_announcements";

  // GamePlayScreen
  static const String game_play = '/game_play';
  // NewGameSettings
  static const String new_game_settings = '/new_game_settings';
  //GameHistoryView
  static const String game_history = '/game_history';
  //ClubMembersView
  static const String club_members_view = '/club_members_view';
  // MessagesPageView
  static const String message_page = '/message_page';
  // ClubMembers
  static const String club_members = '/club_members';
  // ClubMembers
  static const String club_settings = '/club_settings';
  //ClubHostMessaging
  static const String club_host_messagng = '/club_host_messagng';
  // RewardsListScreen  -- provider, arguments
  static const String rewards_list_screen = '/rewards_list_screen';
  // ClubMembersDetailsView  -- provider, arguments
  static const String club_member_detail_view = '/club_member_detail_view';
  // ClubMembersCreditDetailsView  -- provider, arguments
  static const String club_member_credit_detail_view =
      '/club_member_credit_detail_view';
  // HandHistoryListView  -- provider, arguments
  static const String hand_history_list = '/hand_history_list';
  // HighHandLogView
  static const String high_hand_log = '/high_hand_log';
  //  TableResultScreen
  static const String table_result = '/table_result';
  // GameHistoryDetailView
  static const String game_history_detail_view = '/game_history_detail_view';
  // HandLogView
  static const String hand_log_view = '/hand_log_view';
  // RewardsList
  static const String rewards_list = '/rewards_list';
  // ActionTimeSelect
  static const String action_time_select = '/action_time_select';
  // GameTypeSelect
  static const String game_type_select = '/game_type_select';
  // BlindsSelect
  static const String blind_select = '/blind_select';
  // BuyInRangesSelect
  static const String buy_in_range_select = '/buy_in_range_select';
  // MaxPlayerSelect
  static const String max_player_select = '/max_player_select';
  // ClubTipsSelect
  static const String club_tips_select = '/club_tips_select';
  // ClubsPageView
  static const String club_pages = '/club_pages';
  // ClubMainScreen
  static const String club_main = '/club_main';
  // ClubMainScreen
  static const String pointsLineChart = '/points_line_chart';
  //ChatScreen
  static const String chatScreen = '/chatScreen';
  // Bookmarks Screen
  static const String bookmarked_hands = '/bookmarked_hands';
  // BotScripts screen
  static const String bot_scripts = '/bot_scripts';
  // Hand Statistics screen
  static const String hand_statistics = "/hand_statistics";

  // Club Statistics screen
  static const String club_statistics = "/club_statistics";

  // player profile statistics
  static const String player_statistics = "/player_statistics";
  // announcements
  static const String announcements = "/announcements";
  // help
  static const String help = "/help";

// gamescreen table view.
  static const String select_table = "/select_table";
  // gamescreen holecard view.
  static const String select_cards = "/select_card";

  // gamescreen holecard view.
  static const String privacy_policy = "/privacy_policy";

  // gamescreen holecard view.
  static const String terms_conditions = "/terms_conditions";
  // gamescreen holecard view.
  static const String attributions = "/attributions";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: SplashScreen(),
        );

      // case login:
      //   return _getPageRoute(
      //     routeName: settings.name,
      //     viewToShow: LoginScreen(),
      //   );

      case registration:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: RegistrationScreenNew(),
        );

      case restore_account:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: RestoreAccountScreen(),
        );

      case main:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: MainScreen(),
        );

      case game_play:
        String gameCode;
        bool botGame = false;
        if (settings.arguments is String) {
          gameCode = settings.arguments as String;
        } else {
          dynamic args = settings.arguments as dynamic;
          gameCode = args['gameCode'] as String;
          botGame = args['botGame'] ?? false;
        }
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: GamePlayScreen(
            gameCode: gameCode,
            botGame: botGame,
          ),
        );

      case new_game_settings:
        var clubCode = settings.arguments as String;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: ChooseGameNew(clubCode: clubCode),
        );

      case game_history:
        var clubCode = settings.arguments as String;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: GameHistoryView(clubCode),
        );

      case club_members_view:
        var clubHomePageModel = settings.arguments as ClubHomePageModel;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: ClubMembersView(clubHomePageModel),
        );

      case message_page:
        var clubCode = settings.arguments as String;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: MessagesPageView(
            clubCode: clubCode,
          ),
        );

      case club_members:
        var clubCode = settings.arguments as String;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: ClubMembers(
            clubCode: clubCode,
          ),
        );

      case club_settings:
        var clubHomePageModel = settings.arguments as ClubHomePageModel;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: ClubSettingsScreen(
            clubModel: clubHomePageModel,
          ),
        );

      case club_host_messagng:
        var args = settings.arguments as dynamic;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: ClubHostMessaging(
            clubCode: args['clubCode'],
            player: args['player'],
            name: args['name'],
          ),
        );

      case rewards_list_screen:
        var clubCode = settings.arguments as String;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: ChangeNotifierProvider(
            create: (_) => RewardsModelProvider(clubCode),
            child: RewardsListScreen(),
          ),
        );

      case club_member_detail_view:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        String clubCode = args["clubCode"];
        String playerId = args["playerId"];
        bool isCurrentOwner = args["currentOwner"] as bool;
        final ClubMemberModel member = args["member"];
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: ChangeNotifierProvider<ClubMemberModel>(
            create: (_) => member,
            builder: (BuildContext context, _) => Consumer<ClubMemberModel>(
              builder: (_, ClubMemberModel data, __) =>
                  ClubMembersDetailsView(clubCode, playerId, isCurrentOwner),
            ),
          ),
        );

      case club_member_credit_detail_view:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        String clubCode = args["clubCode"];
        String playerId = args["playerId"];
        bool owner = args['owner'];

        return _getPageRoute(
          routeName: settings.name,
          viewToShow: ClubActivityCreditScreen(clubCode, playerId, owner),
        );

      case hand_history_list:
        var args = settings.arguments as dynamic;
        var model = args['model'] as HandHistoryListModel;
        var clubCode = args['clubCode'];
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: ChangeNotifierProvider<HandHistoryListModel>(
            create: (_) => model,
            builder: (BuildContext context, _) =>
                Consumer<HandHistoryListModel>(
              builder: (_, HandHistoryListModel data, __) =>
                  HandHistoryListView(
                data,
                clubCode,
              ),
            ),
          ),
        );

      case high_hand_log:
        var args = settings.arguments as dynamic;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: HighHandLogView(
            args['gameCode'],
            clubCode: args['clubCode'],
          ),
        );

      case table_result:
        var args = settings.arguments as dynamic;
        var gameCode = args["gameCode"];
        var showTips = args["showTips"] ?? false;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: TableResultScreen(gameCode: gameCode, showTips: showTips),
        );

      case game_history_detail_view:
        var args = settings.arguments as dynamic;
        var model = args['model'] as GameHistoryDetailModel;
        var clubCode = args['clubCode'];
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: ChangeNotifierProvider<GameHistoryDetailModel>(
            create: (_) => model,
            builder: (BuildContext context, _) =>
                Consumer<GameHistoryDetailModel>(
              builder: (_, GameHistoryDetailModel data, __) =>
                  GameHistoryDetailView(data, clubCode),
            ),
          ),
        );

      case hand_log_view:
        var args = settings.arguments as dynamic;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: HandLogView(
            args['gameCode'],
            args['handNum'],
            clubCode: args['clubCode'],
          ),
        );
      case customize:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: CustomizeScreen(),
        );
      case game_screen_customize:
        var gameCode = 'CUSTOMIZE';
        var customizeService = CustomizationService();
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: GamePlayScreen(
            gameCode: gameCode,
            customizationService: customizeService,
          ),
        );

      case system_announcements:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: SystemAnnouncements(),
        );
      case club_main:
        var clubCode = settings.arguments as String;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: ClubMainScreenNew(clubCode: clubCode),
        );

      case club_pages:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: ClubsPageView(),
        );

      case pointsLineChart:
        var args = settings.arguments as GameHistoryDetailModel;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: PointsLineChart(
            gameCode: args.gameCode,
          ),
        );

      case hand_statistics:
        var args = settings.arguments as GameHistoryDetailModel;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: HandStatsView(
            gameHistoryModel: args,
          ),
        );

      case club_statistics:
        var args = settings.arguments as String;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: ClubStatsScreen(
            clubCode: args,
          ),
        );

      case chatScreen:
        var args = settings.arguments as dynamic;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: ChatScreen(
            clubCode: args['clubCode'],
            player: args['player'],
            name: args['name'],
          ),
        );

      case bookmarked_hands:
        var args = settings.arguments as dynamic;
        log("ARGS : ${args.toString()}");
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: BookmarkedHands(
            clubCode: args.toString(),
          ),
        );

      case bot_scripts:
        var args = settings.arguments as dynamic;

        return _getPageRoute(
          routeName: settings.name,
          viewToShow: BotScriptsScreen(
            clubModel: args,
          ),
        );

      case player_statistics:
        var playerUuid = settings.arguments as String;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: PerformanceView(
            playerUuid: playerUuid,
          ),
        );
      case announcements:
        var clubModel = settings.arguments as ClubHomePageModel;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: AnnouncementsView(
            clubModel: clubModel,
          ),
        );

      case help:
        var versionCode = settings.arguments as String;
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: HelpScreen(
            version: versionCode,
          ),
        );

      case select_table:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: TableSelectorScreen(),
        );

      case select_cards:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: CardSelectorScreen(),
        );
      case privacy_policy:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: PrivacyPolicyScreen(
            title: "Privacy Policy",
            text: appInfo.privacyPolicy,
          ),
        );
      case terms_conditions:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: PrivacyPolicyScreen(
            title: "Terms and Conditions",
            text: appInfo.toc,
          ),
        );
      case attributions:
        return _getPageRoute(
          routeName: settings.name,
          viewToShow: PrivacyPolicyScreen(
            title: "Attributions",
            text: appInfo.attributions,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static PageRoute _getPageRoute({String routeName, Widget viewToShow}) {
    return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (_) => viewToShow,
    );
  }
}
