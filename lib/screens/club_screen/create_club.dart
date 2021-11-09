import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/exceptions/exceptions.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/screens/main_screens/clubs_page_view/widgets/create_club_bottom_sheet.dart';
import 'package:pokerapp/services/app/club_interior_service.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/dialogs.dart';

class CreateClubDialog {
  static Future<String> prompt(
      {@required BuildContext context,
      @required AppTextScreen appScreenText}) async {
    String name;
    String description;
    final Map<String, String> clubDetails = {};

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    final ret = await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        final theme = AppTheme.getTheme(context);
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.61,
                  margin: EdgeInsets.all(16),
                  padding:
                      EdgeInsets.only(bottom: 24, top: 8, right: 8, left: 8),
                  decoration: AppDecorators.bgRadialGradient(theme).copyWith(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.accentColor, width: 3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              appScreenText['createClub'],
                              style:
                                  AppDecorators.getHeadLine3Style(theme: theme),
                            ),
                            RoundRectButton(
                              text: appScreenText['create'],
                              onTap: () async {
                                if (!_formKey.currentState.validate()) {
                                  return;
                                }
                                _formKey.currentState.save();

                                // create the club now
                                log('name: $name description: $description');
                                /* create a club using the clubDetails */
                                String clubCode;
                                try {
                                  clubCode = await ClubsService.createClub(
                                    clubDetails['name'],
                                    clubDetails['description'],
                                  );
                                } on GQLException catch (e) {
                                  await showErrorDialog(
                                      context, 'Error', gqlErrorText(e));
                                  return null;
                                } catch (e) {
                                  await showErrorDialog(
                                      context, 'Error', errorText('GENERIC'));
                                  return null;
                                } finally {}

                                Navigator.pop(context, clubCode);
                              },
                              theme: theme,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 8.0,
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: 8.0,
                          ),
                          decoration:
                              AppDecorators.tileDecorationWithoutBorder(theme),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 10.ph),
                                  /* club name */
                                  Text(
                                    appScreenText['name'],
                                    style: AppDecorators.getSubtitleStyle(
                                        theme: theme),
                                  ),
                                  SizedBox(height: 5.ph),
                                  CardFormTextField(
                                    theme: theme,
                                    elevation: 0.0,
                                    hintText: appScreenText['nameHint'],
                                    validator: (String val) =>
                                        val.trim().isEmpty
                                            ? appScreenText['provideClubName']
                                            : null,
                                    onSaved: (String val) =>
                                        clubDetails['name'] = val.trim(),
                                  ),
                                  SizedBox(height: 5.ph),
                                  Text(
                                    appScreenText['description'],
                                    style: AppDecorators.getSubtitleStyle(
                                        theme: theme),
                                  ),
                                  SizedBox(height: 5.ph),
                                  CardFormTextField(
                                    theme: theme,
                                    elevation: 0.0,
                                    hintText: appScreenText['descriptionHint'],
                                    validator: (String val) => val
                                            .trim()
                                            .isEmpty
                                        ? appScreenText['provideDescription']
                                        : null,
                                    maxLines: 5,
                                    onSaved: (String val) =>
                                        clubDetails['description'] = val.trim(),
                                  ),
                                  SizedBox(height: 20.ph),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        );
      },
    );

    return ret;
  }
}
