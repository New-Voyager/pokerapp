import 'package:flutter/material.dart';
import 'package:pokerapp/models/search_club_model.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import '../../../../resources/app_colors.dart';
import '../../../../resources/app_colors.dart';
import '../../../../resources/app_styles.dart';
import '../../../../services/app/club_interior_service.dart';

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

  @override
  Widget build(BuildContext context) {
    final separator10 = SizedBox(height: 10.0);
    final separator8 = SizedBox(height: 8.0);
    final separator15 = SizedBox(height: 15.0);

    return Container(
      height: MediaQuery.of(context).size.height - 100,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        color: AppColors.cardBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Done",
                        style: AppStyles.subTitleTextStyle,
                      ),
                    ),
                    separator8,
                    Text(
                      "Search Club",
                      style: AppStyles.titleTextStyle,
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 20.0,
                ),
                color: AppColors.chatMeColor,
                child: Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          child: CardFormTextField(
                            elevation: 0.0,
                            radius: 7,
                            color: Color(0xff888383),
                            hintText: 'Enter club code',
                            validator: (String val) => val.trim().isEmpty
                                ? 'You must provide a club code'
                                : null,
                            onSaved: (String val) =>
                                searchClubCode = val.trim(),
                            hintColor: Colors.white,
                          ),
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Icon(
                            Icons.search,
                            size: 35,
                            color: AppColors.appAccentColor,
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
                      child: CircularProgressIndicator(),
                    )
                  : searchClubCode == null
                      ? Container()
                      : Container(
                          padding: EdgeInsets.all(20),
                          color: AppColors.chatMeColor,
                          width: MediaQuery.of(context).size.width,
                          child: searchClub == null
                              ? Text(
                                  "A Club not found for the code '$searchClubCode' ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )
                              : Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      "A Club found for the code '$searchClubCode' ",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    separator10,
                                    Text(
                                      "Name: ${searchClub.name}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    separator10,
                                    Text(
                                      "Host: ${searchClub.ownerName}",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                    separator15,
                                    Center(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 10),
                                        decoration: BoxDecoration(
                                          color:
                                              AppColors.buttonBackGroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          "Join",
                                          style: AppStyles.subTitleTextStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        )
            ],
          ),
        ),
      ),
    );
  }
}
