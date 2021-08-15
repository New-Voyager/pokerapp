import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/resources/new/app_strings_new.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/round_color_button.dart';
import 'package:provider/provider.dart';

class CreateClubBottomSheet extends StatefulWidget {
  final String name;
  final String description;

  // name and description needs to be passed, when the club details needed to be edited
  CreateClubBottomSheet({
    this.name,
    this.description,
  });

  @override
  _CreateClubBottomSheetState createState() => _CreateClubBottomSheetState();
}

class _CreateClubBottomSheetState extends State<CreateClubBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, String> clubDetails = {};
  AppTextScreen _appScreenText;

  @override
  void initState() {
    _appScreenText = getAppTextScreen("createClubBottomSheet");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final separator20 = SizedBox(height: 20.0);
    final separator5 = SizedBox(height: 10.0);

    return Consumer<AppTheme>(
      builder: (_, theme, __) => Container(
          decoration: AppDecorators.bgRadialGradient(theme),
          height: MediaQuery.of(context).size.height - 200,
          /*  padding: EdgeInsets.only(
           // bottom: MediaQuery.of(context).viewInsets.bottom,
          ), */
          // color: AppColorsNew.cardBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _appScreenText['CREATECLUB'],
                      style: AppDecorators.getHeadLine3Style(theme: theme),
                    ),
                    RoundedColorButton(
                      text: _appScreenText['CREATE'],
                      textColor: theme.primaryColor,
                      backgroundColor: theme.accentColor,
                      onTapFunction: () {
                        if (!_formKey.currentState.validate()) return;
                        _formKey.currentState.save();
                        Navigator.pop(context, clubDetails);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 8.0,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ),
                  decoration: AppDecorators.tileDecorationWithoutBorder(theme),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          separator20,
                          /* club name */
                          Text(
                            _appScreenText['NAME'],
                            style:
                                AppDecorators.getSubtitle3Style(theme: theme),
                          ),
                          separator5,
                          CardFormTextField(
                            theme: theme,
                            elevation: 0.0,
                            hintText: _appScreenText['NAME'],
                            validator: (String val) => val.trim().isEmpty
                                ? _appScreenText['YOUMUSSTPROVIDEANAME']
                                : null,
                            onSaved: (String val) =>
                                clubDetails['name'] = val.trim(),
                          ),
                          separator20,

                          /* club description */
                          Text(
                            AppStringsNew.labelDescriptionText,
                            style:
                                AppDecorators.getSubtitle3Style(theme: theme),
                          ),
                          separator5,
                          CardFormTextField(
                            theme: theme,
                            elevation: 0.0,
                            hintText: _appScreenText['DESCRIPTION'],
                            validator: (String val) => val.trim().isEmpty
                                ? _appScreenText['YOUMUSTPROVIDEDESCRIPTION']
                                : null,
                            maxLines: 5,
                            onSaved: (String val) =>
                                clubDetails['description'] = val.trim(),
                          ),
                          separator20,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
