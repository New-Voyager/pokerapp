import 'package:flutter/material.dart';
import 'package:pokerapp/models/search_club_model.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';

import '../../../../resources/app_assets.dart';
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

  @override
  Widget build(BuildContext context) {
    final separator10 = SizedBox(height: 10.0);
    final separator8 = SizedBox(height: 8.0);
    final separator15 = SizedBox(height: 15.0);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        color: Color(0xff686565),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                      style: const TextStyle(
                        fontFamily: AppAssets.fontFamilyLato,
                        fontSize: 20,
                        color: Color(0xff1601ff),
                      ),
                    ),
                  ),
                  separator8,
                  Text(
                    "Search Club",
                    style: const TextStyle(
                      fontFamily: AppAssets.fontFamilyLato,
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 20.0,
              ),
              color: Color(0xff474747),
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
                          onSaved: (String val) => searchClubCode = val.trim(),
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

                        searchClub = await ClubInteriorService.searchClubHelper(
                          searchClubCode,
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        child: Icon(
                          Icons.search,
                          color: Color(0xffff8b03),
                          size: 50,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            separator10,
            Container(
              padding: EdgeInsets.all(20),
              color: Color(0xff474747),
              width: MediaQuery.of(context).size.width,
              child: searchClub == null
                  ? searchClubCode == null
                      ? Container()
                      : Text(
                          "A Club found for the code '$searchClubCode' ",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "A Club found for the code '$searchClubCode' ",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        separator10,
                        Text(
                          "Name: ${searchClub.name}",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        separator10,
                        Text(
                          "Host: ${searchClub.ownerName}",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        separator15,
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xffc4c4c4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "Join",
                              style: TextStyle(
                                color: Color(0xff0079e7),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}
