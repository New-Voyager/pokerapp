import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as fdp;
import 'package:pokerapp/main_helper.dart';
import 'package:pokerapp/models/game_history_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_assets.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/routes.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/game_screens/game_history_view/game_history_item_new.dart';
import 'package:pokerapp/screens/game_screens/widgets/back_button.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:provider/provider.dart';

class GameHistoryView extends StatefulWidget {
  final String clubCode;
  GameHistoryView(this.clubCode);

  @override
  _GameHistoryViewState createState() => _GameHistoryViewState();
}

class _GameHistoryViewState extends State<GameHistoryView>
    with RouteAwareAnalytics {
  String get routeName => Routes.game_history;

  final ValueNotifier<bool> _filterAppliedVn = ValueNotifier<bool>(false);
  int _selectedMonthAsFilter = -1;
  bool showFilterButton = false;
  AppTextScreen _appScreenText;

  bool _loadingData = true;

  List<GameHistoryModel> _prevGames;

  _fetchData() async {
    _prevGames = await ClubInteriorService.getGameHistory(widget.clubCode);
    _loadingData = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _appScreenText = getAppTextScreen("gameHistoryView");
    // method call
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchData();
    });
  }

  Widget gameHistoryItem(BuildContext context, int index) {
    final item = this._prevGames[index];
    return GestureDetector(
        onTap: () {
          GameHistoryDetailModel model =
              GameHistoryDetailModel(item.gameCode, true);
          Navigator.pushNamed(
            context,
            Routes.game_history_detail_view,
            arguments: {'model': model, 'clubCode': widget.clubCode},
          );
        },
        child: GameHistoryItemNew(game: _prevGames[index]));
  }

  Widget body(AppTheme theme) {
    if (_loadingData) {
      return Center(
        child: Text(
          _appScreenText['noGamesPlayed'],
          style: AppDecorators.getCenterTextTextstyle(appTheme: theme),
        ),
      );
    }

    // build game history list
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: gameHistoryItem,
      itemCount: _prevGames.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10.0),
    );
  }

  Widget _buildMonthDatePicker({
    @required final DateTime selectedDate,
    @required final DateTime firstAllowedDate,
    @required final DateTime lastAllowedDate,
    @required final ValueChanged<DateTime> onNewSelected,
    @required final AppTheme theme,
  }) {
    // add some colors to default settings
    fdp.DatePickerStyles styles = fdp.DatePickerStyles(
      selectedSingleDateDecoration: BoxDecoration(
        color: theme.accentColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
    );

    final fdp.DatePickerLayoutSettings layoutSettings =
        fdp.DatePickerLayoutSettings(
      scrollPhysics: BouncingScrollPhysics(),
      maxDayPickerRowCount: 4,
      contentPadding: EdgeInsets.all(2.0),
      monthPickerPortraitWidth: 250.0,
    );

    final selectedDateNotifier = ValueNotifier<DateTime>(selectedDate);

    return Align(
      alignment: Alignment.center,
      child: ValueListenableBuilder(
        valueListenable: selectedDateNotifier,
        builder: (_, selectedDate, __) => fdp.MonthPicker.single(
          selectedDate: selectedDate,
          onChanged: (newDate) {
            selectedDateNotifier.value = newDate;
            onNewSelected(newDate);
          },
          firstDate: firstAllowedDate,
          lastDate: lastAllowedDate,
          datePickerLayoutSettings: layoutSettings,
          datePickerStyles: styles,
        ),
      ),
    );
  }

  void _showMonthPickerDialog({
    @required final AppTheme theme,
  }) async {
    DateTime pickedDate;

    final currentDate = DateTime.now();

    final needToFilter = await showPrompt(
      context,
      "Filter",
      "Month Picker",
      positiveButtonText: "Apply",
      child: _buildMonthDatePicker(
        theme: theme,
        selectedDate: currentDate,
        firstAllowedDate: currentDate.subtract(Duration(days: 365)),
        lastAllowedDate: currentDate,
        onNewSelected: (DateTime dateTime) {
          pickedDate = dateTime;
        },
      ),
    );

    if (pickedDate == null || !needToFilter) return;

    // else, call api and refresh
    _selectedMonthAsFilter = pickedDate.month;

    // TODO: may be show loading indicator
    // TODO: call api and populate _prevGames array
    _filterAppliedVn.value = true;

    log('selected month is $_selectedMonthAsFilter');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            theme: theme,
            titleText: _appScreenText['gameHistory'],
            subTitleText: "${_appScreenText['clubCode']}: ${widget.clubCode}",
            context: context,
            actionsList: [
              // button to show filter
              Visibility(
                visible: showFilterButton,
                child: Center(
                  child: ValueListenableBuilder(
                      valueListenable: _filterAppliedVn,
                      builder: (_, isFilterApplied, __) => isFilterApplied
                          ? CircleImageButton(
                              theme: theme,
                              svgAsset: AppAssets.filterRemove,
                              onTap: () {
                                _filterAppliedVn.value = false;
                              },
                            )
                          : CircleImageButton(
                              theme: theme,
                              svgAsset: AppAssets.filter,
                              onTap: () {
                                _showMonthPickerDialog(theme: theme);
                              },
                            )),
                ),
              ),
            ],
          ),
          body: _prevGames == null
              ? Center(
                  child: CircularProgressWidget(),
                )
              : SafeArea(
                  child: body(theme),
                ),
        ),
      ),
    );
  }
}
