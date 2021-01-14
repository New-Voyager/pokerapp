import 'package:flutter/material.dart';
import 'package:pokerapp/resources/app_styles.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/custom_text_button.dart';

import '../../../../resources/app_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    final separator20 = SizedBox(height: 20.0);
    final separator5 = SizedBox(height: 10.0);

    return Container(
        height: MediaQuery.of(context).size.height - 200,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
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
                    Text(
                      "Create Club",
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
                color: Color(0xff313235),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CustomTextButton(
                          text: 'Create',
                          onTap: () {
                            if (!_formKey.currentState.validate()) return;
                            _formKey.currentState.save();
                            Navigator.pop(context, clubDetails);
                          },
                        ),
                      ),
                      separator20,
                      /* club name */
                      Text(
                        'Name',
                        style: AppStyles.credentialsTextStyle,
                      ),
                      separator5,
                      CardFormTextField(
                        elevation: 0.0,
                        color: AppColors.cardBackgroundColor,
                        hintText: 'Name',
                        validator: (String val) => val.trim().isEmpty
                            ? 'You must provide a name'
                            : null,
                        onSaved: (String val) =>
                            clubDetails['name'] = val.trim(),
                      ),
                      separator20,

                      /* club description */
                      Text(
                        'Description',
                        style: AppStyles.credentialsTextStyle,
                      ),
                      separator5,
                      CardFormTextField(
                        elevation: 0.0,
                        color: AppColors.cardBackgroundColor,
                        hintText: 'Description',
                        validator: (String val) => val.trim().isEmpty
                            ? 'You must provide a description'
                            : null,
                        onSaved: (String val) =>
                            clubDetails['description'] = val.trim(),
                      ),
                      separator20,

                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
