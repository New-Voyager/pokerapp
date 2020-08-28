import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/text_button.dart';

class CreateClubBottomSheet extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> clubDetails = {};

  @override
  Widget build(BuildContext context) {
    final separator20 = SizedBox(height: 20.0);
    final separator5 = SizedBox(height: 10.0);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 20.0,
      ),
      color: Color(0xff313235),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            /* club name */

            Text(
              'Club Name',
              style: AppStyles.credentialsTextStyle,
            ),
            separator5,
            CardFormTextField(
              elevation: 0.0,
              color: Color(0xff313235),
              hintText: 'Name',
              validator: (String val) =>
                  val.trim().isEmpty ? 'You must provide a name' : null,
              onSaved: (String val) => clubDetails['name'] = val.trim(),
            ),
            separator20,

            /* club description */
            Text(
              'Club Description',
              style: AppStyles.credentialsTextStyle,
            ),
            separator5,
            CardFormTextField(
              elevation: 0.0,
              color: Color(0xff313235),
              hintText: 'Description',
              validator: (String val) =>
                  val.trim().isEmpty ? 'You must provide a description' : null,
              onSaved: (String val) => clubDetails['description'] = val.trim(),
            ),
            separator20,
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                text: 'Create',
                onTap: () {
                  if (!_formKey.currentState.validate()) return;
                  _formKey.currentState.save();
                  Navigator.pop(context, clubDetails);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
