import 'package:flutter/material.dart';
import 'package:pokerapp/models/ui/app_text.dart';
import 'package:pokerapp/models/ui/app_theme.dart';
import 'package:pokerapp/resources/app_text_styles.dart';
import 'package:pokerapp/resources/new/app_assets_new.dart';
import 'package:pokerapp/resources/new/app_styles_new.dart';
import 'package:pokerapp/utils/adaptive_sizer.dart';

class AppNameAndLogoWidget extends StatelessWidget {
  final AppTheme _appTheme;
  AppNameAndLogoWidget(this._appTheme, this._appScreenText);
  AppTextScreen _appScreenText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Text(
            _appScreenText['POCKERCLUBAPP'],
            textAlign: TextAlign.center,
            style: AppTextStyles.H1.copyWith(
              color: _appTheme.accentColor,
            ),
          ),
        ),
        Text(
          this._appScreenText['SUBTITLE'],
          textAlign: TextAlign.center,
          style: AppTextStyles.T3.copyWith(
            color: _appTheme.supportingColorWithDark(0.50),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          child: Image.asset(
            AppAssetsNew.pathGameTypeChipImage,
            height: 100.ph,
            width: 100.pw,
          ),
        ),
      ],
    );
  }
}
