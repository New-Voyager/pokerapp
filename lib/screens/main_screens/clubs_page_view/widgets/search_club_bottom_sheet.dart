import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:pokerapp/models/search_club_model.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/app_text_styles.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/widgets/dialogs.dart';
import 'package:pokerapp/widgets/textfields.dart';
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
  TextEditingController _messageController = TextEditingController();
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

  Widget _buildTextFormField({
    TextInputType keyboardType,
    @required TextEditingController controller,
    @required void validator(String _),
    @required String hintText,
    @required void onInfoIconPress(),
    @required String labelText,
    @required AppTheme appTheme,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        /* border */
        border: AppDecorators.getBorderStyle(
          radius: 32.0,
          color: appTheme.primaryColorWithDark(),
        ),
        errorBorder: AppDecorators.getBorderStyle(
          radius: 32.0,
          color: appTheme.negativeOrErrorColor,
        ),
        focusedBorder: AppDecorators.getBorderStyle(
          radius: 32.0,
          color: appTheme.accentColorWithDark(),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.info,
            color: appTheme.supportingColorWithDark(0.50),
          ),
          onPressed: onInfoIconPress,
        ),

        /* hint & label texts */
        hintText: hintText,
        hintStyle: AppTextStyles.T3.copyWith(
          color: appTheme.supportingColorWithDark(0.60),
        ),
        labelText: labelText,
        labelStyle: AppTextStyles.T0.copyWith(
          color: appTheme.accentColor,
        ),

        /* other */
        contentPadding: EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        fillColor: appTheme.fillInColor,
        alignLabelWithHint: true,
      ),
    );
  }

  void onJoin(BuildContext context) async {
    // note must not be empty
    String text = _messageController.text.trim();
    if (text.isEmpty) {
      showErrorDialog(context, 'Error', 'Note must be specified');

      return;
    }

    await ClubInteriorService.joinClub(searchClubCode, text);
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
              child: CircleImageButton(
                icon: Icons.close_rounded,
                theme: theme,
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              margin: EdgeInsets.only(top: 48),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
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
                                hintText: _appScreenText['enterClubCode'],
                                validator: (String val) => val.trim().isEmpty
                                    ? _appScreenText['provideClubCode']
                                    : null,
                                onSaved: (String val) =>
                                    searchClubCode = val.trim(),
                              ),
                            ),
                            SizedBox(
                              width: 10.pw,
                            ),
                            CircleImageButton(
                              icon: Icons.search,
                              theme: theme,
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
                                        "${_appScreenText['noClubsFound']} '$searchClubCode' ",
                                        style: AppDecorators.getHeadLine4Style(
                                            theme: theme),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${_appScreenText['clubFound']}",
                                            style:
                                                AppDecorators.getSubtitle3Style(
                                                    theme: theme),
                                          ),
                                          separator10,
                                          Text(
                                            "${_appScreenText['name']}: ${searchClub.name}",
                                            style:
                                                AppDecorators.getHeadLine4Style(
                                                    theme: theme),
                                          ),
                                          separator10,
                                          Text(
                                            "${_appScreenText['host']}: ${searchClub.ownerName}",
                                            style:
                                                AppDecorators.getHeadLine4Style(
                                                    theme: theme),
                                          ),
                                          separator15,
                                          _buildTextFormField(
                                            appTheme: theme,
                                            labelText: 'Note',
                                            keyboardType: TextInputType.name,
                                            controller: _messageController,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Note must not be empty';
                                              }
                                              if (value.length > 50) {
                                                return 'Note must be less than 50 characters';
                                              }
                                              return null;
                                            },
                                            hintText: 'Enter note to club host',
                                            onInfoIconPress: () {
                                              toast(
                                                'Note is required',
                                                duration: Duration(seconds: 3),
                                              );
                                            },
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
