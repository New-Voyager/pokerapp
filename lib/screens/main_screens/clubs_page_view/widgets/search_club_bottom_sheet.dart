import 'package:flutter/material.dart';
import 'package:pokerapp/models/search_club_model.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/screens/chat_screen/widgets/no_message.dart';
import 'package:pokerapp/screens/club_screen/widgets/roud_icon_button.dart';
import 'package:pokerapp/screens/game_screens/widgets/new_button_widget.dart';
import 'package:pokerapp/services/nats/nats.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:pokerapp/widgets/round_raised_button.dart';
import 'package:pokerapp/widgets/rounded_accent_button.dart';
import 'package:provider/provider.dart';
import '../../../../resources/app_colors.dart';
import '../../../../resources/app_styles.dart';
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

    return Container(
      decoration: AppStylesNew.BgGreenRadialGradient,
      height: MediaQuery.of(context).size.height * 0.8,
      child: Stack(
        children: [
          Positioned(
            top: 8,
            left: 8,
            child: RoundIconButton(
              icon: Icons.close_rounded,
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
                  // IconButton(
                  //   color: AppColorsNew.newGreenButtonColor,
                  //   icon: Icon(
                  //     Icons.close_rounded,
                  //   ),
                  //   onPressed: () => Navigator.of(context).pop(),
                  // ),
                  //   RoundedAccentButton(
                  //     text: "Done",
                  //     onTapFunction: () => Navigator.of(context).pop(),
                  //   ),
                  // ],
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       GestureDetector(
                  //         onTap: () {
                  //           Navigator.pop(context);
                  //         },
                  //         child: Text(
                  //           "Done",
                  //           style: AppStyles.subTitleTextStyle,
                  //         ),
                  //       ),
                  //       separator15,
                  //       Text(
                  //         "Search Club",
                  //         style: AppStyles.titleTextStyle,
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Row(
                        children: [
                          Expanded(
                            child: CardFormTextField(
                              elevation: 0.0,
                              radius: 7,
                              color: AppColorsNew.actionRowBgColor,
                              hintText: 'Enter club code',
                              validator: (String val) => val.trim().isEmpty
                                  ? 'You must provide a club code'
                                  : null,
                              onSaved: (String val) =>
                                  searchClubCode = val.trim(),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
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
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: Icon(
                                Icons.search,
                                size: 35,
                                color: AppColorsNew.newGreenButtonColor,
                              ),
                            ),
                          )
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
                                color: AppColorsNew.actionRowBgColor,
                              ),
                              child: searchClub == null
                                  ? Text(
                                      "No clubs found for the code '$searchClubCode' ",
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "A club is found",
                                        ),
                                        separator10,
                                        Text(
                                          "Name: ${searchClub.name}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.dp),
                                        ),
                                        separator10,
                                        Text(
                                          "Host: ${searchClub.ownerName}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.dp),
                                        ),
                                        separator15,
                                        Center(
                                          child: RoundedColorButton(
                                            onTapFunction: () =>
                                                onJoin(context),
                                            text: "Join",
                                            backgroundColor:
                                                AppColorsNew.yellowAccentColor,
                                          ),
                                        ),
                                        /* GestureDetector(
                                          onTap: () => onJoin(context),
                                          child: Center(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 30, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                    .buttonBackGroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                "Join",
                                                style:
                                                    AppStyles.subTitleTextStyle,
                                              ),
                                            ),
                                          ),
                                        ),
                                       */
                                      ],
                                    ),
                            )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
