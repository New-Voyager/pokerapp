import 'package:flutter/material.dart';
import 'package:pokerapp/models/search_club_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:provider/provider.dart';
import '../../../../services/app/club_interior_service.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class SearchClubBottomSheet extends StatefulWidget {
  SearchClubBottomSheet();

  @override
  _SearchClubBottomSheetState createState() => _SearchClubBottomSheetState();
}

class _SearchClubBottomSheetState extends State<SearchClubBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String searchClubCode;
  SearchClub searchClub;
  bool _showLoading = false;
  AppTextScreen _appScreenText;

  @override
  void initState() {
    _appScreenText = getAppTextScreen("searchClubBottomSheet");
    super.initState();
  }

  void _toggleLoading() {
    if (mounted)
      setState(() {
        _showLoading = !_showLoading;
      });
  }

  void onJoin(BuildContext context) async {
    await ClubInteriorService.joinClub(searchClubCode);
    final natsClient = Provider.of<Nats>(context, listen: false);
    natsClient.subscribeClubMessages(searchClubCode);

    // close this popup
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final separator10 = SizedBox(height: 10.0);
    final separator15 = SizedBox(height: 15.0);

    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
        decoration: AppDecorators.bgRadialGradient(theme),
        height: MediaQuery.of(context).size.height * 0.8,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -10.pw,
              right: 4.pw,
              child: RoundIconButton(
                icon: Icons.close_rounded,
                iconColor: Colors.red,
                bgColor: Colors.black,
                borderColor: Colors.red,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              margin: EdgeInsets.only(top: 48),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Row(
                          children: [
                            Expanded(
                              child: CardFormTextField(
                                theme: theme,
                                elevation: 0.0,
                                radius: 7,
                                hintText: _appScreenText['ENTERCLUBCODE'],
                                validator: (String val) => val.trim().isEmpty
                                    ? _appScreenText['YOUMUSTPROVIDEACLUBCODE']
                                    : null,
                                onSaved: (String val) =>
                                    searchClubCode = val.trim(),
                              ),
                            ),
                            SizedBox(
                              width: 10.pw,
                            ),
                            RoundIconButton(
                              icon: Icons.search,
                              borderColor: theme.accentColor,
                              onTap: () async {
                                if (!_formKey.currentState.validate()) return;
                                _formKey.currentState.save();
                                _toggleLoading();

                                searchClub =
                                    await ClubInteriorService.searchClubHelper(
                                  searchClubCode,
                                );
                                _toggleLoading();
                              },
                            )
                            // GestureDetector(
                            //   onTap: () async {
                            //     if (!_formKey.currentState.validate()) return;
                            //     _formKey.currentState.save();
                            //     _toggleLoading();

                            //     searchClub =
                            //         await ClubInteriorService.searchClubHelper(
                            //       searchClubCode,
                            //     );
                            //     _toggleLoading();
                            //   },
                            //   child: Container(
                            //     padding: EdgeInsets.symmetric(
                            //         horizontal: 5, vertical: 5),
                            //     child: Icon(
                            //       Icons.search,
                            //       size: 35,
                            //       color: theme.secondaryColor,
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                    separator10,
                    _showLoading
                        ? Center(
                            child: CircularProgressWidget(),
                          )
                        : searchClubCode == null
                            ? Container()
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 8),
                                padding: EdgeInsets.all(20),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: theme.fillInColor,
                                ),
                                child: searchClub == null
                                    ? Text(
                                        "${_appScreenText['NOCLUBSFOUNDFORTHECODE']} '$searchClubCode' ",
                                        style: AppDecorators.getHeadLine4Style(
                                            theme: theme),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${_appScreenText['ACLUBISFOUND']}",
                                            style:
                                                AppDecorators.getSubtitle3Style(
                                                    theme: theme),
                                          ),
                                          separator10,
                                          Text(
                                            "${_appScreenText['NAME']}: ${searchClub.name}",
                                            style:
                                                AppDecorators.getHeadLine4Style(
                                                    theme: theme),
                                          ),
                                          separator10,
                                          Text(
                                            "${_appScreenText['HOST']}: ${searchClub.ownerName}",
                                            style:
                                                AppDecorators.getHeadLine4Style(
                                                    theme: theme),
                                          ),
                                          separator15,
                                          Center(
                                            child: RoundRectButton(
                                              onTap: () => onJoin(context),
                                              text: "${_appScreenText['JOIN']}",
                                              theme: theme,
                                            ),
                                          ),
                                        ],
                                      ),
                              )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
