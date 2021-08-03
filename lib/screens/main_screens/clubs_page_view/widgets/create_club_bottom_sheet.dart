import 'package:flutter/material.dart';
import 'package:pokerapp/resources/new/app_colors_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/widgets/card_form_text_field.dart';
import 'package:pokerapp/widgets/round_color_button.dart';

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
        decoration: AppStylesNew.BgGreenRadialGradient,
        height: MediaQuery.of(context).size.height - 200,
        /*  padding: EdgeInsets.only(
         // bottom: MediaQuery.of(context).viewInsets.bottom,
        ), */
        // color: AppColors.cardBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Create Club",
                    style: AppStylesNew.clubTitleTextStyle,
                  ),
                  RoundedColorButton(
                    text: 'Create',
                    backgroundColor: AppColorsNew.yellowAccentColor,
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
                decoration: AppStylesNew.actionRowDecoration,
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
                          'Name',
                          style: AppStylesNew.labelTextStyle,
                        ),
                        separator5,
                        CardFormTextField(
                          elevation: 0.0,
                          color: AppColorsNew.newFieldBgColor,
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
                          style: AppStylesNew.labelTextStyle,
                        ),
                        separator5,
                        CardFormTextField(
                          elevation: 0.0,
                          color: AppColorsNew.newFieldBgColor,
                          hintText: 'Description',
                          validator: (String val) => val.trim().isEmpty
                              ? 'You must provide a description'
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
        ));
  }
}
