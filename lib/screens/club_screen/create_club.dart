import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pokerapp/exceptions/exceptions.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_decorators.dart';
import 'package:pokerapp/services/app/clubs_service.dart';
import 'package:pokerapp/widgets/buttons.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/dialogs.dart';

class CreateClubDialog {
  static Future<String> prompt({
    @required BuildContext context,
    @required AppTextScreen appScreenText,
    String invitationCode = '',
  }) async {
    String name;
    String description;
    final Map<String, String> clubDetails = {};

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    final ret = await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        final theme = AppTheme.getTheme(context);
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: Container(
              padding: EdgeInsets.only(bottom: 24, top: 8, right: 8, left: 8),
              decoration: AppDecorators.bgRadialGradient(theme).copyWith(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.accentColor, width: 3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          appScreenText['createClub'],
                          style: AppDecorators.getHeadLine3Style(theme: theme),
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
                  Visibility(
                    visible: invitationCode != null && !invitationCode.isEmpty,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Row(children: [
                          Text(
                            "Invitation Code: ",
                            style:
                                AppDecorators.getHeadLine5Style(theme: theme),
                          ),
                          Text(
                            invitationCode,
                            style: AppDecorators.getHeadLine5Style(theme: theme)
                                .copyWith(color: theme.accentColor),
                          ),
                        ])),
                  ),
                  Flexible(
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
                        child: Container(
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
                                  validator: (String val) => val.trim().isEmpty
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
                                  validator: (String val) => val.trim().isEmpty
                                      ? appScreenText['provideDescription']
                                      : null,
                                  maxLines: 5,
                                  maxLength: 500,
                                  showCharacterCounter: true,
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
                  ),
                ],
              )),
        );
      },
    );

    return ret;
  }
}
